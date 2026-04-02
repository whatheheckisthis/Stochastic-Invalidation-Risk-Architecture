# SIRA — Model Assumptions Registry

> **License:** Apache License 2.0 — derived material use
> permitted under license terms. See `LICENSE` and `NOTICE`
> at repository root.
>
> **Academic use:** This material must not be used to underpin
> coursework content or submitted as original work in any
> assessed academic context. It is a practitioner artefact,
> not peer-reviewed literature. Trace all analytical claims
> to their cited primary sources. See [`DISCLAIMER.md`](DISCLAIMER.md)
> for full terms.


> Governance artefact. Companion to `notebooks/sira_scenarios.ipynb`.
> Produced as a delivery artefact of the SIRA assurance programme.
> All formulae and criteria derive from the wider SIRA architecture.
> This document does not define the model — it annotates it.

---

## How to read this document

Each section corresponds to a notebook cell group and a set of
scripts in the SIRA engine. For each analytical component the
following are declared:

- **Criteria** — the decision rule or classification boundary
- **Units** — the unit of measurement for all inputs and outputs
- **Working formula** — the expression as implemented in R
- **Derivation** — the source in the wider SIRA architecture
- **Assumption** — what is taken as given and its governance boundary
- **Known limitation** — what the model does not capture and why

---

## 1. Stochastic Recovery Layer (Cells 05–09)

### 1.1 Beta distribution — Baseline, Liquidity Crunch, Jurisdictional Freeze

**Criteria**
Recovery outcome classified as SELL if:
`stressed_recovery <= ruin_threshold` OR
`z_score(stressed_recovery) <= -|sell_zscore_threshold|`
Otherwise HOLD.

**Units**
- `stressed_recovery`: dimensionless fraction [0.001, 0.995]
- `ruin_threshold`: dimensionless fraction, scenario-specific
- `z_score`: standard deviations from scenario cross-section mean

**Working formula**

```text
raw        ~ Beta(shape1, shape2)
conditioned = raw * recovery_anchor + (1 - recovery_anchor) * raw
stressed   = clip(conditioned * shock_multiplier, 0.001, 0.995)
z_score    = (stressed - mean(stressed)) / sd(stressed)
ruin_flag  = stressed <= ruin_threshold
signal     = if (ruin_flag | z_score <= -|threshold|) SELL else HOLD
```

**Derivation**
`scripts/02_analysis.R` | `docs/CREDIT_RISK_LAYER.md §1.2`

**Assumption**
Recovery is a bounded fractional outcome. Beta distribution provides
bounded [0,1] support and accommodates unimodal/skewed shapes
appropriate for mean-reverting recovery regimes.
`recovery_anchor` is portfolio-level — instrument-level variation
is not modelled at the scenario layer.

**Known limitation**
SIRA operates at scenario level with cross-scenario standardisation
by `asset_id`. It does not model covenant hierarchy, collateral
liquidation path, legal waterfall timing, or sponsor support
optionality. Instrument-level analysis is the primary source for
obligor-specific adjudication. (`CREDIT_RISK_LAYER.md §1.4`)

---

### 1.2 Power Law distribution — Counterparty Default, Hyper-Inflationary

**Criteria**
Same SELL/HOLD logic as Beta. Power Law applied where tail
realizations dominate loss behaviour.

**Units**
Same as §1.1. `exponent` is dimensionless (shape parameter).

**Working formula**

```text
u          ~ Uniform(0, 1)
raw        = (1 - u)^(-1/exponent)          # inverse-transform sampling
normalised = 1 / raw                         # map to (0,1) recovery fraction
stressed   = clip(normalised * shock_multiplier * (1 - fx_devaluation),
                  0.001, 0.995)
```

**Derivation**
`scripts/02_analysis.R` | `docs/CREDIT_RISK_LAYER.md §4.2`

**Assumption**
Power Law appropriate where jump discontinuities and macro
dislocations justify extreme-value-oriented tail emphasis.
Exponent governance is operator-defined — calibration to
empirical workout data is an operator validation responsibility.

**Known limitation**
SIRA does not model time-to-resolution path dependency.
Static per-run scenario shocks are applied — duration-driven
deterioration and cure dynamics are not endogenised.
(`CREDIT_RISK_LAYER.md §3.4`)

---

### 1.3 Normal (Gaussian) reference — all scenarios

**Purpose**
Structural comparison only. Quantifies Gaussian mis-specification
relative to SIRA distributions. Not used in signal logic.

**Criteria**
Not applicable — reference draw only.

**Units**
Same as §1.1.

**Working formula**

```text
nr ~ Normal(mean(stressed_recovery), sd(stressed_recovery))
nr = clip(nr, 0.001, 0.995)
```

**Derivation**
`docs/CREDIT_RISK_LAYER.md §3.1`

**Assumption**
Equivalent mean and SD to SIRA draw. This is the weakest possible
Gaussian comparison — a calibrated Gaussian would perform worse
on tail properties, not better.

**Known limitation**
The comparison is qualitative. No formal KS test or tail index
comparison is implemented in the notebook. Formal distribution
testing is an operator validation responsibility.

---

## 2. Capital Stack Layer (Cells 13–15)

### 2.1 Liability engine

**Criteria**
`solvency_headroom > 0` → SOLVENT
`solvency_headroom <= 0` → BREACH

**Units**
- All monetary values: operator-declared currency (CFG)
- `payout_rate`: dimensionless fraction per annum
- `duration_years`: integer years

**Working formula**

```text
annual_obligation = annuity_pool_size * payout_rate
pv_obligations    = annual_obligation * sum(1/(1+r)^t, t=1..duration_years)
solvency_headroom = pool*(1 - insurer_solvency_buffer) - pv_obligations
```

**Derivation**
`scripts/10_liability_engine.R`

**Assumption**
Flat coupon discounting. Discount rate proxied by `gross_yield`.
Actuarial liability valuation is out of scope — this is a
parameterised stress approximation. (`NG-008`)

**Known limitation**
Annuity type (fixed/variable/indexed) affects obligation structure.
Indexed annuity floor liability is captured in the BSM layer
(Cell 18) as a put option, not in the liability engine directly.

---

### 2.2 Credit deployment and spread stress

**Criteria**
`spread > 0 AND headroom > 0` → SOLVENT
`spread > 0 AND headroom <= 0` → WATCH
`spread <= 0` → BREACH

**Units**
Same currency as §2.1.

**Working formula**

```text
LGD_proxy     = 1 - mean(stressed_recovery)   # scenario-level
expected_loss = deployed_capital * LGD_proxy * default_rate_assumption
net_income    = (deployed_capital * gross_yield + fee_income + equity_kicker_value) - expected_loss
spread        = net_income - annual_obligation
```

**Derivation**
`scripts/11_credit_deployment.R` | `scripts/12_spread_stress.R`
`docs/CREDIT_RISK_LAYER.md §1.1` (LGD proxy construction)

**Assumption**
LGD proxy is scenario-level, not instrument-level.
`default_rate_assumption` is a base case point estimate —
no PD distribution is modelled at this layer.

---

## 3. Valuation Layer (Cells 16–17)

### 3.1 DCF stress

**Criteria**
`erosion > impairment_threshold` → IMPAIRED
Otherwise STABLE.
`erosion = (dcf_base - dcf_stressed) / dcf_base`

**Units**
- Face value, coupon, PV: operator-declared currency
- `coupon_rate`, `discount_rate_*`: dimensionless fraction per annum
- `term_years`: integer years
- `erosion`: dimensionless fraction

**Working formula**

```text
dcf_base     = sum(coupon/(1+r_base)^t, t=1..T)
               + (face * recovery_anchor)/(1+r_base)^T
dcf_stressed = sum(coupon/(1+r_stressed)^t, t=1..T)
               + (face * mean_stressed_recovery)/(1+r_stressed)^T
erosion      = (dcf_base - dcf_stressed) / dcf_base
```

**Derivation**
`scripts/20_dcf.R`

**Assumption**
Flat coupon structure. Single discount rate per stress state.
Not a mark-to-market valuation — stress-conditioned analytical
value only. (`NG-014`)

---

### 3.2 LBO / IRR

**Criteria**
`DSCR >= min_dscr AND IRR_stressed >= min_irr` → VIABLE
`DSCR >= min_dscr AND IRR_stressed < min_irr` → MARGINAL
`DSCR < min_dscr` → IMPAIRED

**Units**
- DSCR: dimensionless ratio
- IRR: dimensionless fraction per annum
- `equity_contribution`, `debt_amount`: operator-declared currency

**Working formula**

```text
DSCR           = ebitda_proxy / (debt_amount * debt_cost)
entry_leverage = debt_amount / (equity + debt_amount)
exit_ev        = dcf_stressed            # DCF stressed value as proxy
equity_return  = exit_ev - debt_amount
IRR_stressed   = (equity_return/equity_contribution)^(1/hold) - 1
```

IRR attribution:

```text
coupon_contrib   = PV(coupons) / initial_investment
fee_contrib      = fee_income / initial_investment
kicker_contrib   = equity_kicker_value / initial_investment
recovery_contrib = (exit_ev - debt) / initial_investment
```

**Derivation**
`scripts/23_lbo.R` | `scripts/24_irr.R`

**Assumption**
Exit EV proxied by DCF stressed value. Hold period matches
LBO declaration in CFG. IRR attribution uses stressed IRR
as the discount rate — base IRR is not computed separately
in the notebook (available in run_all.R pipeline).

---

## 4. Black-Scholes Options Layer (Cells 18–19)

### 4.1 Recovery put

**Criteria**
`|BSM_implied_recovery - SIRA_stressed_recovery| <= convergence_tolerance` → CONVERGENT
Otherwise DIVERGENT.

Divergence is diagnostic, not a model failure. BSM assumes
log-normal firm value and continuous trading. SIRA assumes
bounded recovery with scenario shocks. Divergence quantifies
the structural gap between the two frameworks.

**Units**
- `S` (firm value), `K` (debt face value): operator-declared currency
- `sigma`: dimensionless vol per annum (sqrt(year))
- `T`: years to resolution horizon
- `r`: risk-free rate per annum
- Put price: same currency as S, K
- Greeks: delta (dimensionless), vega (currency/vol unit),
  gamma (1/currency)

**Working formula**

```text
d1  = (log(S/K) + (r + sigma^2/2)T) / (sigma*sqrt(T))
d2  = d1 - sigma*sqrt(T)
Put = K*exp(-r*T)*pnorm(-d2) - S*pnorm(-d1)    # put-call parity
delta_put = pnorm(d1) - 1
vega      = S * sqrt(T) * dnorm(d1)
gamma     = dnorm(d1) / (S * sigma * sqrt(T))
```

P&L attribution (Taylor approximation, Haugh §3):

```text
P&L ≈ delta*delta_S + (gamma/2)*delta_S^2 + vega*delta_sigma
```

Leverage effect (Haugh eq.17):

```text
sigma_equity_stressed ~ (V_stressed / E_stressed) * sigma_firm
```

**Derivation**
`scripts/30_bs_core.R` | `scripts/30b_greeks.R` | `scripts/31_recovery_put.R`
Haugh (2016), Columbia IEOR E4706 — BlackScholes.pdf

**Assumption**
- Firm value V is operator-declared, not estimated from equity
  market prices via iterative Merton calibration. (`NG-018`)
- Volatility surface is scenario-governed, not market-calibrated.
  (`NG-017`)
- BSM assumes continuous trading in a liquid market. Private
  credit is illiquid — put price is analytical stress evidence,
  not a market price. (`NG-016`)
- Greeks are BSM/GBM Greeks under constant vol and log-normal
  assumptions. Stochastic-vol Greeks not implemented. (`NG-019`)
- Risk-neutral pricing removes physical drift mu. SIRA does not
  estimate equity risk premia. (`NG-020`)

**Known limitation**
Counterparty Default sigma is derived from scenario ruin probability
via `sigma = sqrt(-2*log(p)/T)`. This is an analytical approximation
— it is not an implied vol from traded options. Operator validation
memo required to justify against empirical data. (`COMPLIANCE_CROSSWALK.csv`)

---

## 5. Portability and runtime assumptions

| Assumption | Mitigation |
|---|---|
| Notebook runs from `notebooks/` subdirectory | `resolve_toml_path()` in Cell 01 tries 4 strategies; halts with named failure modes |
| `SIRA_TOML_PATH` env var not set | Resolver falls back to relative path strategies before halting |
| IRkernel installed in R environment | Cell 00 halts with install instructions if packages missing |
| `xmllint` available (subprocess XSD fallback) | `apt-get install -y libxml2-utils`; documented in quickstart |
| CFG keys exist as expected | Missing keys produce R `NULL` — downstream `ifelse(!is.null(...))` guards handle gracefully |

---

## 6. Duplication register

| Pattern | Location | Rationale |
|---|---|---|
| `rnorm` reference generation | Cells 05–09, Cell 10 | Consolidated into `draw_rnorm_reference()` in Cell 04. Interactive clarity: each scenario cell is self-contained for committee step-through. Deliberate, not careless. |
| `scenarios_all` list traversal | Cells 10, 11, 14, 16, 17, 18, 20 | Shared object passed forward. Pattern is consistent — each layer adds columns to the scenario index. |
| `strrep("─", n)` separators | Multiple cells | Terminal emission format mirrors `scripts/03_visualize.R`. Consistency is intentional. |

---

## 7. Non-goals for this notebook

Consistent with `README.md` non-goals register:

- Not a replacement for `run_all.R` — the pipeline is the governed
  execution path. This notebook is an inspection surface only.
- Not a governed output producer — does not write to `output/`
  or commit any artefact.
- Not a live data surface — consumes the same data as the pipeline,
  governed by the manifest.
- Not an IRB capital model — BSM and LGD outputs are analytical
  stress instrumentation. (`NG-003`, `NG-004`)
- Not a market pricing engine — BSM put prices are not market
  prices for illiquid instruments. (`NG-016`)

---

## References

- [`docs/CREDIT_RISK_LAYER.md`](../docs/CREDIT_RISK_LAYER.md) — LGD/PD framing and distribution rationale
- [`docs/RISK_COMMITTEE.md`](../docs/RISK_COMMITTEE.md) — pre-structured committee challenge register
- [`docs/DEFENSE_APPENDIX.md`](../docs/DEFENSE_APPENDIX.md) — epsilon and sigma as co-primary defense objects
- [`docs/COMPLIANCE_CROSSWALK.csv`](../docs/COMPLIANCE_CROSSWALK.csv) — component-level coverage assessment
- Haugh (2016). *The Black-Scholes Model.* Columbia IEOR E4706.
- `README.md` — non-goals register (NG-001 to NG-021)

## Operator action items

1. Run cells in strict order 00–20. Cell 14 depends on
   `ANNUAL_OBLIGATION` from Cell 13. Cell 16 passes `DCF_BY_SCENARIO`
   to Cell 17. Cell 18 consumes `scenarios_all` from Cell 05–09.
   Out-of-order execution will produce object-not-found errors.
2. Populate all CFG sections required by the new cells before
   running the notebook:
   `[liability]`, `[credit]`, `[dcf]`, `[lbo]`, `[options]`,
   `[vol_surface]` must all be present in sira.toml.
3. Install dplyr for `case_when` in Cell 14:
   `install.packages("dplyr")`
   Add to Cell 00 required_packages vector.
4. Set `SIRA_TOML_PATH` if running from a non-standard directory:
   `Sys.setenv(SIRA_TOML_PATH = "/absolute/path/to/config/sira.toml")`
   Run before Cell 01.
5. Do not commit notebook output to version control.
   Install nbstripout: `pip install nbstripout && nbstripout --install`

---

### Why structured this way

The path resolver is the most operationally important addition. Four
strategies in priority order — subdirectory relative, root relative,
environment variable, upward walk — cover every realistic launch
context including CI pipelines and air-gapped deployments. The error
message when all four fail names each strategy explicitly so the
operator knows exactly what was tried and how to fix it. That is a
governance-quality error, not a stack trace.

The `draw_rnorm_reference()` consolidation in Cell 04 retains the
inline annotation explaining why the Gaussian draw exists. The
annotation is the governance record — it prevents a future reviewer
from treating the pattern as a mistake and removing it, which would
silently remove the structural mis-specification evidence from every
scenario chart.

The assumptions registry is structured to match the compliance
crosswalk schema: criteria, units, formula, derivation, assumption,
known limitation. A model risk reviewer who has already read the
crosswalk can navigate the assumptions document without a new
orientation. The duplication register in §6 is included specifically
to answer reviewer questions about repeated patterns before they are
raised.
