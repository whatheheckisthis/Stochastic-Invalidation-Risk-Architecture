# CREDIT RISK LAYER — SIRA TECHNICAL REFERENCE

## 1) LGD/PD Framing

### 1.1 Recovery as LGD proxy without IRB equivalence
SIRA models recovery outcomes at scenario level and derives directional loss stress via the complement relation `LGD_proxy = 1 - stressed_recovery`. This construction is analytical stress instrumentation, not an IRB capital model. The implementation boundary is explicit: scenario-conditioned stochastic recovery and rule-based signal triage (`SELL`/`HOLD`), with no claim of IRB substitution.

### 1.2 Beta shape parameters and implied stress severity
For Beta scenarios, SIRA consumes `CFG$scenarios.<scenario>$shape1` and `CFG$scenarios.<scenario>$shape2`, then conditions the draw using portfolio `recovery_anchor`. The resulting parameterization shifts mass concentration and skewness of recovery draws; lower effective mass toward the upper bound and higher mass toward the lower bound imply higher LGD stress severity and, by extension, a stronger implied PD/LGD stress posture for the scenario. Parameter governance therefore directly controls stress severity expression.

### 1.3 Bounded [0,1] recovery for direct lending positions
Direct lending recovery is structurally a bounded fractional outcome. SIRA enforces bounded support through distribution choice and hard clipping to `(0.001, 0.995)`, preserving interpretability of recoveries as economically feasible fractions rather than unconstrained mark-to-market residuals. This is appropriate for recovery-centric stress in distressed private credit and bond workout contexts where terminal economic realization is the decision variable.

### 1.4 Limits of scenario-level LGD stress vs instrument-level analysis
SIRA operates at scenario level with cross-scenario standardization by `asset_id`. It does not model covenant package hierarchy, collateral liquidation path, legal waterfall timing, sponsor support optionality, or facility-specific restructuring terms. Instrument-level credit analysis remains the primary source for obligor-specific adjudication; SIRA contributes directional stress signal context.

## 2) IRB Model Validation Awareness

### 2.1 Position in an IRB stack
SIRA is not a PD estimation engine, downturn LGD estimator, EAD model, nor regulatory capital computation layer. It complements an IRB stack as a scenario stress overlay for portfolio triage and committee interrogation of adverse recovery sensitivity. Its outputs can inform IRB stress scenario design only when calibration provenance, data lineage, and validation standards are satisfied under the institution's MRM framework.

### 2.2 SR 11-7 posture: inventory, validation scope, ongoing monitoring
Under SR 11-7 framing, SIRA should be classified as a scenario-based analytical model with decision-support impact. Required inventory attributes include intended use, user population, input lineage mode (`live`/`synthetic`), key parameters (`shape1`, `shape2`, `exponent`, `ruin_threshold`, `sell_zscore_threshold`), and control owner. Validation scope should cover conceptual soundness (distribution rationale), process verification (code/runtime controls), and outcome analysis (signal stability and error posture). Ongoing monitoring should track parameter drift, signal-rate drift, and synthetic-mode invocation frequency.

### 2.3 Preconditions for ancillary IRB use
A validation function would require: (i) empirical fit evidence for distribution choices by stress regime; (ii) parameter calibration protocol with approval evidence; (iii) sensitivity and stability analysis across key thresholds; (iv) performance diagnostics against realized workout outcomes where available; (v) documented governance for synthetic-mode restrictions; and (vi) complete audit trail from `config/sira.toml` version to run artifact output.

## 3) Distressed Bond Recovery Behaviour

### 3.1 Why normal distributions are structurally inappropriate
Distressed recovery outcomes are bounded, asymmetric, and tail-sensitive. Gaussian assumptions impose unbounded support and symmetric tail behaviour that mis-specify downside concentration and truncation at economic bounds. SIRA’s bounded Beta regime and heavy-tail Power Law regime are aligned to these structural properties.

### 3.2 Bimodality in distressed debt and Beta tuning
Distressed recoveries frequently exhibit high-mass low-recovery and moderate/high-recovery clusters driven by binary workout paths (disorderly impairment versus structured resolution). Beta parameter tuning via `shape1`/`shape2` controls skew and concentration and can approximate this bimodal tendency at scenario aggregation level when combined with heterogeneous `recovery_anchor` inputs across assets.

### 3.3 Jurisdictional variation and calibration of Jurisdictional Freeze
Jurisdictional legal process heterogeneity changes expected resolution recoveries. In SIRA, the Jurisdictional Freeze scenario uses Beta sampling plus tighter shocking and threshold proximity logic (`ruin_threshold`, `shock_multiplier`, and proximity collapse mechanism). Calibration should map legal enforceability and resolution friction to these parameter fields rather than to ad hoc overrides.

### 3.4 Time-to-resolution linkage and static-scenario adequacy
Recovery is path-dependent on resolution horizon. SIRA applies static per-run scenario shocks and does not include dynamic time-evolution states. It captures directional severity under specified scenarios but does not endogenize duration-driven deterioration or cure dynamics. Time-to-resolution effects must be incorporated externally when decisions require temporal credit trajectory modelling.

## 4) Beta vs Power Law Selection

### 4.1 Formal justification for Beta in mean-reverting recovery regimes
Beta is defined on bounded support and accommodates a broad family of unimodal/skewed shapes. For regimes where recoveries fluctuate within constrained legal/economic ranges and revert around scenario-conditioned central tendencies, Beta provides coherent stress sampling with explicit shape control through `shape1` and `shape2`.

### 4.2 Formal justification for Power Law in jump-risk regimes
Power Law construction is appropriate where tail realizations dominate loss behaviour and extreme low-recovery events are materially more probable than thin-tail assumptions imply. SIRA applies this regime to Counterparty Default and Hyper-Inflationary scenarios, where jump discontinuities and macro dislocations justify extreme-value-oriented tail emphasis via `exponent` and scenario shock multipliers.

### 4.3 Parameter sensitivity surface and material signal transition zones
Material signal transitions occur near decision boundaries defined by `CFG$scenarios.<scenario>$ruin_threshold` and `CFG$signals$sell_zscore_threshold`.
- In Beta regimes, incremental changes to `shape1`/`shape2` alter lower-tail density and can sharply increase SELL incidence when stressed recoveries cluster near threshold.
- In Power Law regimes, modest exponent shifts alter tail thickness and propagate non-linearly into ruin-flag frequency.
- `shock_multiplier` and `fx_devaluation` act as first-order severity amplifiers and can move large portions of the distribution across SELL trigger surfaces.

### 4.4 Boundary-condition failure modes and engine handling
Known failure modes include invalid parameter domains, excessive concentration near lower support, and decision instability when outcomes sit on threshold boundaries. Engine handling currently includes bounded clipping of recoveries and deterministic reproducibility via runtime seed; it does not include explicit parameter-domain rejection rules in preflight. Controlled parameter validation at config ingest is therefore a governance requirement for production-grade assurance.

## 5) What a Risk Committee Asks (Presenter Preparation)

### 5.1 Framing scope limitation without weakening utility
State the model boundary as a control: SIRA is a scenario stress and signal triage layer that increases adverse-case visibility and comparability across assets. It is intentionally not an execution engine, not a capital model, and not a replacement for instrument-level credit adjudication.

### 5.2 Back-testing question when synthetic data was used in development
Answer directly: development continuity used deterministic synthetic fallback (`CFG$runtime$seed`) to guarantee reproducible execution. Validation readiness requires phased replacement with governed historical workout data and explicit synthetic/live mode segregation in evidence packs.

### 5.3 Positioning SELL/HOLD relative to credit discretion
Define SELL/HOLD as pre-trade risk escalation flags. Final action authority remains within existing credit governance and portfolio management discretion, with override and exception handling governed outside the engine.

### 5.4 Responding to IRB equivalence challenges
Use categorical separation: SIRA provides stress-conditioned recovery diagnostics and does not produce IRB-compliant PD/LGD/EAD capital outputs. Its valid role is ancillary stress intelligence that can inform scenario design, not replace validated IRB components.

### 5.5 Presenting the non-goals register as rigour evidence
Present non-goals as boundary control instrumentation. The register prevents category error, constrains misuse, improves model inventory classification quality, and increases auditability by making excluded claims explicit at design time.
