# CREDIT RISK LAYER

## 1.0 Overview

The SIRA credit risk layer is the analytical core that converts portfolio exposures and scenario definitions into risk outcomes that can be interpreted as action signals. In implementation terms, the layer starts with normalized asset-level attributes from upstream loading logic (for example `asset_id`, `price`, `recovery_anchor`, region, rating, and sector fields), then executes a deterministic simulation pass across configured scenario names, and finally emits scenario-conditioned signal outcomes such as `SELL` or `HOLD` for each asset-scenario pair. This design is intentionally modular: the core scenario engine in `02_analysis.R` performs recovery simulation and first-order signalling, while valuation and return modules (`20_dcf.R`, `24_irr.R`, and `23_lbo.R`) translate the same stress outcomes into DCF impairment, IRR quality tiers, and leveraged buyout viability states. Together, these modules form a coherent analytical stack rather than independent calculators.

At a system level, the credit layer is not a static scorecard. It is a path from assumptions to outcomes:

- input portfolio anchors and scenario configuration,
- distribution-driven recovery generation,
- stress transforms and scenario-specific shock operators,
- thresholding and standardization for action signals,
- downstream valuation overlays that preserve scenario identity.

The layer therefore acts as the “decision preparation” stage of SIRA. It does not itself execute trades, allocate capital, or evaluate governance quality. Instead, it provides structured analytic outputs that can be consumed by later human or programmatic decision stages.

## 2.0 Analytical Design Principles

### 2.1 Deterministic core + stochastic overlay

SIRA combines deterministic orchestration with stochastic simulation. The deterministic core is visible in the explicit function pipeline, fixed schema expectations, ordered scenario execution, and reproducibility controls (`set.seed` sourced from runtime config in `02_analysis.R`). For a given portfolio snapshot and configuration bundle, the process topology remains constant. This deterministic spine ensures auditability and repeat-run comparability.

On top of this, the layer applies stochastic mechanisms where uncertainty matters most:

- random draws from a Beta distribution when recovery behavior is bounded but variable,
- random draws transformed by a Power Law process for heavy-tail regimes,
- random Gaussian perturbations in the standalone stochastic invalidation script (`stochastic_invalidation_base_r.R`) to simulate discrete-time deterioration toward ruin.

This split is central to the architecture: orchestration is deterministic; loss realization pathways are stochastic.

### 2.2 Scenario-based modelling

The architecture is scenario-native, not scenario-retrofitted. `02_analysis.R` iterates over configured scenario names and materializes a rowset for each `(asset, scenario)` combination. Scenario identity is retained throughout the process and passed downstream into DCF, IRR, and LBO engines. In practical terms, this means all major outputs are scenario-indexed, enabling comparison of outcome distributions under different stress narratives (e.g., counterparty failure versus inflation shock).

Scenario-conditioned mechanics are not only parameter substitutions; they include structural interventions in the recovery path. For example:

- Counterparty default applies additional degradation tied to market price proximity.
- Hyper-inflation applies an FX devaluation multiplier.
- Jurisdictional freeze imposes threshold-proximal collapse behavior.

These are architecture-level operators, not cosmetic tags.

### 2.3 No real-time dependency

The layer is intentionally batch-oriented and configuration-driven. It does not require streaming prices, event buses, or low-latency state synchronization. Inputs are loaded, analyzed, and emitted as reproducible artifacts. This removes runtime coupling to live feeds and keeps the model interpretable and testable. It also bounds operational complexity: risk analytics can run in controlled windows, with known seeds and controlled scenario sets.

The tradeoff is explicit: while robust for stress testing and policy simulation, the layer is not intended for sub-second adaptation to intraday microstructure changes.

## 3.0 Core Modelling Components

### 3.1 Beta Distribution (Recovery modelling)

The Beta branch is used in `generate_recovery` when a scenario configuration specifies `distribution == "beta"`. The script parameterizes Beta shapes as functions of scenario shape constants and asset-level `recovery_anchor`:

- `shape1 = cfg$shape1 * anchor + 0.5`
- `shape2 = cfg$shape2 * (1 - anchor) + 0.5`

This formulation accomplishes three things structurally:

1. It binds the distribution center to each asset’s anchor recovery expectation.
2. It allows scenario stress to reshape dispersion and skew via `shape1/shape2` controls.
3. It prevents degenerate shape values by adding a floor offset.

After random draw, recoveries are clamped into `[0.001, 0.995]`, ensuring downstream math remains numerically stable and avoiding pathological zeros/ones in valuation formulas.

Interpretively, Beta modelling captures recoveries that are naturally bounded between zero and one and whose uncertainty is asymmetric across assets and scenarios.

### 3.2 Power Law (Tail risk)

For scenarios configured as `powerlaw`, the engine samples from a transformed uniform process:

- tail component: `(runif(n)^(-1/exponent)) - 1`
- mapped recovery: `1 / (1 + tail)`

This introduces heavy-tail behavior in adverse realizations. Relative to Beta-mode recoveries, the power-law branch more readily generates extreme drawdowns, which is critical for evaluating fragility under rare-but-severe conditions. As with Beta, outputs are clipped to `[0.001, 0.995]` to stabilize integrations in later modules.

Architecturally, the presence of both Beta and Power Law models lets SIRA represent two different uncertainty geometries:

- bounded, shape-controlled dispersion (Beta), and
- fat-tail stress asymmetry (Power Law).

The scenario engine can therefore switch distribution families without rewriting downstream valuation logic.

### 3.3 Scenario Engine

The scenario engine in `02_analysis.R` is the routing kernel of the credit layer. Its responsibilities include:

- loading scenario names from configuration,
- resolving per-scenario parameter bundles,
- invoking distribution-specific recovery generation,
- applying scenario-specific stress transforms,
- assembling standardized scenario frames with metadata and thresholds.

Three notable stress operators are embedded:

1. **Counterparty Default adjustment**: stressed recovery is further scaled by `pmax(0.08, price/100)`, linking market price deterioration to default severity.
2. **Hyper-Inflationary adjustment**: stressed recovery is multiplied by `(1 - fx_devaluation)`, introducing macro FX impairment.
3. **Jurisdictional Freeze adjustment**: stressed recovery is capped at a synthetic collapse boundary near the ruin threshold (`threshold + abs(N(0, 0.02))`).

Each scenario frame includes both pre-shock (`base_recovery`) and post-shock (`stressed_recovery`) values, plus `ruin_threshold`, ensuring traceability from stochastic draw to decision boundary.

## 4.0 Stochastic Invalidation Layer

### 4.1 Purpose

The stochastic invalidation layer models the process by which an exposure state transitions from distressed-but-viable to invalidated (ruin). In the main analysis engine, this appears as threshold logic (`ruin_flag` when stressed recovery falls below scenario threshold). In the standalone base-R reference (`stochastic_invalidation_base_r.R`), invalidation is represented as a first-passage process where a simulated price path breaches a ruin barrier.

This dual form is deliberate:

- cross-sectional invalidation for portfolio-wide scenario snapshots, and
- temporal invalidation for path-dependent deterioration analysis.

### 4.2 Tail shock modelling

Tail shocks are represented in two non-exclusive ways:

1. **Distributional tails** via Power Law recovery generation in `02_analysis.R`.
2. **Random walk excursions** via Gaussian shock increments in `stochastic_invalidation_base_r.R`.

In the base script, each time step adds `epsilon_t ~ N(0, 0.02)` to the prior value. Ruin occurs on first breach below `ruin_threshold = 0.40`. This implementation highlights a key architectural concept: invalidation is not merely “low value”; it is a barrier event with timing (`ruin_day`) and terminal state (`terminal_value`).

### 4.3 Control breakdown simulation

Without introducing governance overlays, the architecture still models control breakdown analytically through scenario operators that force structural degradation:

- jurisdictional freeze caps recovery near collapse thresholds,
- counterparty default ties outcomes to distressed pricing,
- hyper-inflation enforces macro devaluation loss.

These operators effectively encode breakdown regimes where baseline assumptions fail. The output is not a compliance judgment; it is a quantified shift in recovery, valuation, and return viability under breakdown conditions.

## 5.0 Signal Generation

### 5.1 SELL / HOLD logic

Primary action signalling in `02_analysis.R` is computed from two inputs:

- **hard boundary condition**: `ruin_flag = stressed_recovery <= ruin_threshold`,
- **relative stress condition**: standardized stress score per asset (`z_score` across its scenario outcomes).

A scenario row is labelled `SELL` if either condition is true:

- ruin threshold breach, or
- z-score below configured sell threshold (`CFG$signals$sell_zscore_threshold`).

Otherwise it is `HOLD`. This makes the signal engine hybrid:

- absolute risk floor (ruin), and
- comparative deterioration filter (z-score).

### 5.2 Ruin thresholds

Ruin thresholds are scenario-configured parameters embedded into each output row. Their architecture role is pivotal because they anchor invalidation semantics to scenario context rather than to a single global constant. This allows one scenario to represent strict fragility (higher threshold) while another tolerates deeper drawdown before invalidation.

In downstream modules, ruin behavior also propagates indirectly. Lower stressed recovery reduces DCF terminal value, can depress IRR into `IMPAIRED`, and can degrade LBO stressed IRR below viability thresholds.

### 5.3 Scenario aggregation

The analytical stack aggregates by scenario at different layers:

- `02_analysis.R`: asset-scenario row outputs with scenario-specific signals,
- `20_dcf.R`: scenario-specific impairment classification (`IMPAIRED` or `STABLE`),
- `24_irr.R`: scenario-level return quality (`STRONG`, `ACCEPTABLE`, `IMPAIRED`),
- `23_lbo.R`: scenario-level sponsor viability (`VIABLE`, `MARGINAL`, `IMPAIRED`).

This multi-module aggregation creates a composite view where one scenario may be recoverable in accounting value terms but unacceptable in return or leverage terms, enabling richer interpretation than a single binary output.

## 6.0 Analytical Flow Diagram (MANDATORY)

```text
[Input Config]
     ↓
[Scenario Engine]
     ↓
[Beta + Power Law Models]
     ↓
[Stress Outputs]
     ↓
[Signal Engine]
```

Expanded interpretation:

1. **Input Config**: portfolio anchors, scenario parameters, runtime seed, and thresholds.
2. **Scenario Engine**: loops scenarios, applies distribution and scenario-specific transforms.
3. **Beta + Power Law Models**: generates bounded versus heavy-tail recovery draws.
4. **Stress Outputs**: materializes stressed recovery, threshold comparisons, and metadata.
5. **Signal Engine**: maps outcomes to SELL/HOLD; hands stress state to DCF/IRR/LBO overlays.

## 7.0 Component Table (MANDATORY)

| Module | Function | Input | Output |
|---|---|---|---|
| `scripts/02_analysis.R` | Core scenario risk engine and SELL/HOLD signal generation | Normalized portfolio (`asset_id`, `price`, `recovery_anchor`, metadata), scenario config, runtime seed, sell z-threshold | Asset-scenario table with `base_recovery`, `stressed_recovery`, `ruin_flag`, `z_score`, `signal`, `audit_id` |
| `scripts/stochastic_invalidation_base_r.R` | Discrete-time invalidation path simulator | Time horizon, starting value, ruin threshold, Gaussian shock process | `ruin_day`, `terminal_value`, simulated path state |
| `scripts/20_dcf.R` | Stress-conditioned DCF valuation and impairment classifier | Core stressed recoveries + portfolio anchors + DCF assumptions | `dcf_base_value`, `dcf_stressed_value`, `value_erosion_pct`, `IMPAIRED/STABLE` signal |
| `scripts/24_irr.R` | IRR attribution and scenario return quality | Core stressed recoveries, IRR cash flow config, optional kicker results | Scenario-level `irr_base`, `irr_stressed`, contribution splits, `irr_signal` tier |
| `scripts/23_lbo.R` | LBO viability under stressed exit values | Scenario DCF outputs + leverage assumptions | `dscr`, leverage, stressed IRR, `lbo_signal` (`VIABLE/MARGINAL/IMPAIRED`) |

## 8.0 Assumptions

1. **Synthetic fallback assumptions**
   - The architecture is compatible with synthetic portfolio inputs where live market data is unavailable.
   - Scenario stress and recovery anchors can be configured without direct real-time feeds.
   - Scenario outputs remain useful for comparative stress ranking even under synthetic data conditions.

2. **Deterministic seeds**
   - Reproducibility is enforced through explicit seeding (`set.seed`) in the core analysis.
   - Given identical input tables and config, stochastic draws are replayable.
   - This enables controlled regression tests and explainable variance attribution.

3. **Model-bound recovery domain**
   - Recoveries are constrained to `(0,1)` via clamping.
   - This assumption supports numerical stability across valuation engines.

4. **Configuration integrity**
   - Scenario names and mapping keys are assumed consistent with config naming transforms.
   - Missing stressed discount mappings in DCF are treated as hard errors, not soft defaults (unless configured default exists).

## 9.0 Limitations

1. **Not IRB**
   - The layer is an internal analytical architecture for stress analytics and signal generation.
   - It is not an Internal Ratings-Based regulatory capital framework implementation.
   - It does not claim regulatory capital calibration, supervisory parameter alignment, or bank-grade PD/LGD/EAD compliance packaging.

2. **Not real-time**
   - The process is batch and scenario-run oriented.
   - It is not designed as a live, tick-driven credit monitor.

3. **Model abstraction constraints**
   - Recovery simulation is stylized and depends on scenario assumptions rather than calibrated structural credit models.
   - Power-law and Beta choices capture distribution shape, but not full causal micro-foundations.

4. **Cross-module simplifications**
   - DCF, IRR, and LBO overlays use shared stress states but simplify many deal-specific legal and structural terms.
   - Signals are decision aids and should be interpreted as analytical outputs, not executable directives.

## 10.0 Document Index

- **Core analysis engine**: `scripts/02_analysis.R`
  - Scenario loop, stochastic recovery generation, stress transforms, ruin logic, SELL/HOLD signal.
- **Stochastic invalidation reference**: `scripts/stochastic_invalidation_base_r.R`
  - Pathwise ruin simulation and first-breach reporting.
- **DCF module**: `scripts/20_dcf.R`
  - Stress-implied valuation erosion and impairment state.
- **IRR module**: `scripts/24_irr.R`
  - Cash flow attribution and scenario IRR tiering.
- **LBO module**: `scripts/23_lbo.R`
  - Leverage viability classification under stressed exits.

This index anchors the credit risk layer to executable scripts, ensuring the analytical architecture remains implementation-derived rather than conceptual-only.
