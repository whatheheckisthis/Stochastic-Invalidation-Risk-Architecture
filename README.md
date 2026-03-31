# Stochastic Invalidation & Risk Architecture (SIRA)

Distressed bond recovery, stress testing, and signal generation
across five adverse market scenarios — with a full capital stack,
valuation intelligence, and options pricing layer.

[![Focus](https://img.shields.io/badge/Focus-Quant%20Risk%20Modelling-0A66C2?style=flat-square)](#)
[![Approach](https://img.shields.io/badge/Approach-Auditability%20by%20Design-2E7D32?style=flat-square)](#)
[![Runtime](https://img.shields.io/badge/Runtime-R%20%2B%20ggplot2-276DC3?style=flat-square)](#)
[![Config](https://img.shields.io/badge/Config-TOML%20Declared--Intent-8B5CF6?style=flat-square)](#)
[![Env](https://img.shields.io/badge/Env-Air--Gapped%20Compatible-333333?style=flat-square)](#)

---

## Executive Summary

SIRA evaluates a distressed bond and direct lending portfolio across
five adverse scenarios and produces scenario-level and asset-level
outputs across four integrated layers:

**Core stress engine**
- Stochastic recovery simulation using Beta and Power Law
  distributions to capture non-normal, tail-heavy recovery behaviour.
- Z-score diagnostics to identify assets with materially weak
  recovery outcomes relative to the scenario cross-section.
- Ruin threshold logic to classify invalidation events where recovery
  falls below scenario-specific survival levels.
- SELL/HOLD signals to support risk triage.

**Capital stack layer**
- Annuity liability engine modelling obligation structure under stress.
- Credit deployment engine computing net spread against obligations.
- Spread stress aggregator emitting SOLVENT/WATCH/BREACH per scenario.

**Valuation and deal intelligence layer**
- Stress-conditioned DCF, M&A screening, accretion/dilution,
  LBO viability, and IRR attribution — each consuming in-session
  scenario outputs from the core engine.

**Options intelligence layer**
- Black-Scholes pricing derived from Itô's Lemma and replicating
  portfolio argument (Haugh, Columbia IEOR E4706).
- Recovery put, equity kicker call, and annuity floor put — each
  stress-conditioned against the scenario vol surface.
- Full Greeks engine with delta-gamma-vega P&L attribution.
- Delta-hedge replication error simulation per scenario.

All operator-configurable parameters are declared in
`config/sira.toml` — the single source of truth for scenario
definitions, distribution parameters, signal thresholds, capital
stack parameters, and options inputs. No analytical script contains
hardcoded values. The runtime surface is fully terminal-native with
structured stdout emission.

---

## Methodology

### 1. Preflight (`scripts/00_env_check.R`)

Confirms minimum R version, ggplot2 and RcppTOML availability, TOML
parseability, output directory writability, and data manifest
integrity before any analytical work begins. SHA-256 hash validation
is applied to all active manifest entries; live-mode files halt on
hash mismatch. Halts with a labelled non-zero exit on any failed
check.

### 2. Load Configuration (`scripts/00_config.R`)

Parses `config/sira.toml` via RcppTOML and exposes a single named
list `CFG` to the runtime environment. Initialises the `NEON` colour
palette, gated on `isatty(stdout())`.

### 3. Load Inputs (`scripts/01_load_data.R`)

Consumes `data/manifest/data_manifest.toml` and loads only active
governed files for the preflight-selected `data_mode` (`live` or
`synthetic`). Live/synthetic segregation is enforced at folder level
with lineage reference captured in run metadata. Synthetic mode emits
an explicit disclosure notice to stdout.

### 4. Run Analysis (`scripts/02_analysis.R`)

Generates stressed recoveries per scenario from parameters declared
in `CFG$scenarios`:

- Beta distribution for baseline and liquidity-driven conditions —
  appropriate where LGD follows a bounded, mean-reverting pattern
  with shape parameters tuned to scenario severity.
- Power Law tails for jump-risk regimes — applied where extreme
  outcomes are structurally more probable than Beta or normal
  distributions predict.

Iterates scenarios dynamically from `CFG$scenarios$names` — no
hardcoded scenario list. Applies scenario shocks then computes:
```
z_score    = scale(stressed_recovery)
ruin_flag  = stressed_recovery <= ruin_threshold
signal    ∈ {SELL, HOLD}
LGD_proxy  = 1 - stressed_recovery
```

### 5. Visualise and Emit (`scripts/03_visualize.R`)

Writes `output/sell_hold_signals.png` via ggplot2. Emits a
terminal-native fixed-width summary table showing per-scenario
SELL/HOLD counts and mean recovery.

### 6. Capital Stack (`scripts/10–13`)
```
10_liability_engine.R   → annuity obligation PV and solvency headroom
11_credit_deployment.R  → gross yield, net income, spread captured
12_spread_stress.R      → SOLVENT/WATCH/BREACH per scenario
13_capital_stack_viz.R  → terminal summary + capital_stack_spread.png
```

Spread engine model:
```
gross_income              = deployed_capital × gross_yield + fees
net_income_after_defaults = gross_income − scenario LGD stress
spread_captured           = net_income − annual_obligation
```

Solvency headroom is further adjusted by the annuity floor put
price from the options layer before final spread signal emission.

### 7. Valuation and Deal Intelligence (`scripts/20–25`)
```
20_dcf.R          → stress-conditioned PV and impairment signal
21_ma.R           → ACQUIRE/REVIEW/PASS acquisition screen
22_accretion.R    → spread delta under stressed pro-forma yield
23_lbo.R          → DSCR, stressed IRR, leverage viability signal
24_irr.R          → IRR attribution: coupon, fee, kicker, recovery
25_deal_summary.R → unified committee table, worst-case, dominant risk
```

DCF stressed case:
```
PV_stressed = Σ(coupon / (1+r_stressed)^t)
            + (stressed_recovery × face_value) / (1+r_stressed)^T
```

IRR attribution decomposition:
```
coupon_contribution   = PV(coupons)  / initial_investment
fee_contribution      = fee_income   / initial_investment
kicker_contribution   = call_price_stressed / initial_investment
recovery_contribution = terminal_recovery   / initial_investment
```

### 8. Options Intelligence Layer (`scripts/30–36`)

Grounded in Haugh (2016), Columbia IEOR E4706.

**BSM derivation basis**

Stock price follows geometric Brownian motion:
```
dSt = µSt dt + σSt dWt
```

Under risk-neutral measure Q (drift µ eliminated):
```
dSt = rSt dt + σSt dWtQ
```

Black-Scholes PDE:
```
rS(∂C/∂S) + (∂C/∂t) + (½)σ²S²(∂²C/∂S²) − rC = 0
```

Closed-form solution with continuous dividend yield q:
```
d1 = (log(S/K) + (r − q + σ²/2)(T−t)) / (σ√(T−t))
d2 = d1 − σ√(T−t)
C  = exp(−q(T−t)) × S × Φ(d1) − exp(−r(T−t)) × K × Φ(d2)
P  = C − exp(−qT) × S + exp(−rT) × K   [put-call parity]
```

The elimination of µ from the PDE is a governance feature in
SIRA's context: firm value drift is unobservable and
scenario-dependent. Risk-neutral pricing removes it by construction.

**Greeks (Haugh Section 3)**
```
Δ_call = exp(−qT) × Φ(d1)
Δ_put  = Δ_call − exp(−qT)
Γ      = exp(−qT) × φ(d1) / (S × σ × √T)
ν      = exp(−qT) × S × √T × φ(d1)
θ_call = −(exp(−qT) × S × φ(d1) × σ)/(2√T)
         + q × exp(−qT) × S × Φ(d1)
         − r × K × exp(−rT) × Φ(d2)
ρ_call = K × T × exp(−rT) × Φ(d2)
```

P&L attribution per scenario (Taylor approximation):
```
P&L ≈ Δ×ΔS + (Γ/2)×ΔS² + ν×Δσ
```

**Instrument mapping**

| Instrument | Option type | Underlying | Strike |
|---|---|---|---|
| Distressed bond recovery | Put on firm value | Firm asset value V | Debt face value D |
| Equity kicker | Call on company equity | Equity value at entry | Warrant strike K |
| Indexed annuity floor | Put on portfolio return | Net portfolio yield | Floor rate |

**Leverage effect (Merton/Haugh)**

As stressed recovery declines, firm equity vol rises:
```
σ_equity ≈ (V/E) × σ_firm
```

This creates a documented stress amplification mechanism:
lower recovery → higher implied vol → higher put price →
larger solvency headroom erosion. Named and governed in
RISK_COMMITTEE.md.

**Volatility surface**

Scenario-governed, not market-calibrated. Skew implemented
via parameterised adjustment:
```
σ(K) = σ_base + skew_factor × (ATM_K − K) / ATM_K
```

Arbitrage constraints enforced per Haugh Section 2:
butterfly and calendar spread checks emitted to preflight log.

**Delta-hedge replication error (Haugh eq. 24)**
```
P&L = Σ (St²/2 × Γt × (σ²_implied − σ²_scenario) × Δt)
```

Positive P&L → scenario vol below implied → hedge gain.
Negative P&L → scenario vol above implied → solvency erosion.
Signal: HEDGE_GAIN / HEDGE_NEUTRAL / HEDGE_LOSS per scenario.

### 9. Orchestration (`run_all.R`)

Full pipeline execution order:
```
00_env_check → 00_config → 01_load_data → 02_analysis →
03_visualize → 10_liability_engine → 11_credit_deployment →
12_spread_stress → 13_capital_stack_viz → 20_dcf → 21_ma →
22_accretion → 23_lbo → 24_irr → 25_deal_summary →
30_bs_core → 30b_greeks → 34_vol_surface → 31_recovery_put →
32_kicker_call → 33_annuity_floor → 36_delta_hedge →
35_options_summary → 25_deal_summary [final pass]
```

Terminal harness emits header, per-stage progress, wall-clock
elapsed time, and exit status. Mid-pipeline failures halt with
labelled error output — no silent partial runs.

---

## Five Stress Scenarios

| Scenario | Stress mechanism | Distribution | Vol multiplier |
|---|---|---|---|
| Baseline | Normal market functioning | Beta | 1.00× |
| Liquidity Crunch | Elevated vol, compressed recoveries | Beta | shock_multiplier |
| Jurisdictional Freeze | Recovery collapses toward ruin threshold | Beta | shock_multiplier |
| Counterparty Default | Gap-down valuation shock | Power Law | exponent-implied |
| Hyper-Inflationary | FX devaluation impairs real bond value | Power Law | fx_devaluation |

All scenario parameters — shape, exponent, ruin threshold, shock
multiplier, FX devaluation, vol multiplier — declared in
`config/sira.toml`. No scenario definition exists outside the TOML.

---

## Repository Structure
```text
.
├── README.md
├── run_all.R
├── config/
│   └── sira.toml
├── data/
│   ├── README.md
│   ├── live/                        # Controlled staging — never committed
│   ├── synthetic/                   # Canonical governed datasets
│   ├── manifest/                    # data_manifest.toml + schema
│   └── lineage/                     # Per-file lineage records
├── scripts/
│   ├── 00_env_check.R
│   ├── 00_config.R
│   ├── 01_load_data.R
│   ├── 02_analysis.R
│   ├── 03_visualize.R
│   ├── 10_liability_engine.R
│   ├── 11_credit_deployment.R
│   ├── 12_spread_stress.R
│   ├── 13_capital_stack_viz.R
│   ├── 20_dcf.R
│   ├── 21_ma.R
│   ├── 22_accretion.R
│   ├── 23_lbo.R
│   ├── 24_irr.R
│   ├── 25_deal_summary.R
│   ├── 30_bs_core.R
│   ├── 30b_greeks.R
│   ├── 31_recovery_put.R
│   ├── 32_kicker_call.R
│   ├── 33_annuity_floor.R
│   ├── 34_vol_surface.R
│   ├── 35_options_summary.R
│   └── 36_delta_hedge.R
├── docs/
│   ├── CREDIT_RISK_LAYER.md
│   ├── RISK_COMMITTEE.md
│   ├── DEFENSE_APPENDIX.md
│   └── COMPLIANCE_CROSSWALK.csv
└── output/
    ├── sell_hold_signals.png
    ├── capital_stack_spread.png
    └── capital_stack_metadata.rds
```
```bash
Rscript run_all.R
```

> Requires R (>= 4.0.0), ggplot2, and RcppTOML. All BSM
> computation uses base R stats (pnorm, dnorm, qnorm, uniroot).
> No external data sources, live feeds, or network connectivity
> required at runtime. In air-gapped deployments, RcppTOML must
> be available from a local mirror or vendored package store.

---

## Governance Artefacts

| Artefact | Purpose |
|---|---|
| `docs/CREDIT_RISK_LAYER.md` | LGD/PD framing, IRB boundary, distribution rationale, committee preparation |
| `docs/RISK_COMMITTEE.md` | Pre-structured challenge register across model scope, signal integrity, model risk, and operational controls |
| `docs/DEFENSE_APPENDIX.md` | Epsilon and sigma as co-primary defense objects; controls matrix mapped to ISM, SOC 2, E8 ML4 |
| `docs/COMPLIANCE_CROSSWALK.csv` | Component-level coverage assessment across SR 11-7, FRTB, Basel III IRB, BCBS 239, SOC 2, E8 ML4, ISM |
| `data/manifest/data_manifest.toml` | Controlled input registry with SHA-256, lineage references, and approval fields |

----

# Non-Goals Register

> Runtime boundary declaration only. Not a hardening claim or certified assurance posture.
> Not affiliated with or endorsed by Common Criteria, Basel II/III, BCBS 239, FRTB, ISO 27001,
> ISO 27005, Essential Eight ML3/ML4, SOC 2, SR 11-7, or any equivalent evaluation framework.

---

## Analytical boundaries — NG-001 to NG-006

| ID | Boundary | Detail | Exception |
|---|---|---|---|
| NG-001 | Not a live risk system | Outputs are stochastic simulations against synthetic or operator-supplied data. No MtM or real-time feed integration. | External data may be substituted via `CFG$data$path`; synthetic fallback activates only on empty input. |
| NG-002 | Not an OMS or EMS | SELL/HOLD are pre-trade analytical indicators, not executable order instructions. A three-state signal set (SELL/WATCH/HOLD) was evaluated during development; WATCH excluded from core engine as the two-state set is sufficient for declared analytical scope. WATCH is valid in the spread stress layer (SOLVENT/WATCH/BREACH) where the graduated response path justifies the third state. | Signals may inform execution where the operator has accepted analytical risk and applied independent instrument-level validation (ILV). |
| NG-003 | Not a full credit model | Scenarios model directional LGD/PD stress behaviour only. No substitute for instrument-level credit analysis or IRB model validation. | — |
| NG-004 | Not a compliance attestation | Ruin threshold and z-score logic expresses analytical intent. No certified conformance to SR 11-7, FRTB, or equivalent MRM frameworks. | — |
| NG-005 | Not environment-agnostic | Reproducibility guaranteed within declared runtime (R + ggplot2 + RcppTOML). Out-of-spec configurations require operator validation and a documented deviation log. | — |
| NG-006 | Not a hardened terminal application | Terminal colour output adapts to execution context and is absent in non-interactive or piped runs. | — |

---

## Capital stack boundaries — NG-007 to NG-009

| ID | Boundary | Detail |
|---|---|---|
| NG-007 | Not a regulatory capital model for insurers | Capital stack extension is a stress coverage analytic. Must not be interpreted as an insurer capital adequacy certification engine. |
| NG-008 | Not a replacement for actuarial liability valuation | Liability engine outputs are parameterised stress approximations and require independent actuarial governance. |
| NG-009 | Not a live portfolio management system | SOLVENT/WATCH/BREACH signals are governance prompts, not automated allocation, hedging, or execution instructions. |

---

## Data governance boundaries — NG-010 to NG-012

| ID | Boundary | Detail |
|---|---|---|
| NG-010 | `data/live/` is not a data lake | Controlled staging folder only. Not a managed repository. |
| NG-011 | Manifest governs in-repo ingestion only | Does not replace enterprise data governance authorities. |
| NG-012 | SHA-256 confirms integrity, not provenance | Hash checks confirm integrity at ingestion and do not constitute provenance certification. |

---

## Valuation boundaries — NG-013 to NG-015

| ID | Boundary | Detail |
|---|---|---|
| NG-013 | IRR outputs are not audited return attestations | Analytical attribution outputs only. |
| NG-014 | DCF outputs are not mark-to-market valuations | Stress-conditioned analytical values only. Not audited fair value estimates. |
| NG-015 | M&A and accretion signals are not investment advice | Scenario-conditioned screening outputs. Do not constitute transaction recommendations. |

---

## Options and BSM boundaries — NG-016 to NG-021

| ID | Boundary | Detail |
|---|---|---|
| NG-016 | BSM replication assumes continuous liquid trading | Private credit is illiquid and not continuously tradeable. Delta-hedge replication error output is analytical stress evidence only. |
| NG-017 | Vol surface is scenario-governed, not market-calibrated | σ(K,T) is parameterised, not implied from traded option prices. No options market data consumed. |
| NG-018 | Merton linkage is explanatory framing only | Firm value V is operator-declared. Full traded-equity iterative calibration is not implemented. |
| NG-019 | Greeks are BSM/GBM Greeks only | Computed under constant volatility and log-normal assumptions. Stochastic-volatility Greeks (Heston, SABR) not implemented. Sticky-delta dynamics not modelled. |
| NG-020 | Risk-neutral pricing removes physical drift µ | SIRA does not estimate equity risk premia or physical-measure return expectations. |
| NG-021 | Positive theta flags are diagnostic only | Do not constitute hedging recommendations. |

