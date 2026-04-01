# SIRA Notebook — Model Risk Reviewer Checklist

> Structured checklist for formal model risk review of the
> SIRA notebook package. Each item maps to a document,
> a notebook cell, and an evidence artefact.
> Work through this checklist in order.
> Items marked [OPERATOR] require evidence outside the repository.

---

## Section 1 — Scope and boundary

| # | Criterion | Where to verify | Evidence artefact |
|---|---|---|---|
| 1.1 | Model scope is declared and non-goals are explicit | `README.md NG-001 to NG-021` | Non-goals register |
| 1.2 | Notebook is read-only — does not write to `output/` | `SIRA_METHODOLOGY.md` §What SIRA is | Cell 12 session metadata |
| 1.3 | Notebook is not a replacement for `run_all.R` | `SIRA_READER_GUIDE.md` | `README.md NG` section |
| 1.4 | Model owner is designated | `RISK_COMMITTEE.md §6.1` | [OPERATOR] |
| 1.5 | Model inventory classification is assigned | `RISK_COMMITTEE.md §4.1` | [OPERATOR] |

---

## Section 2 — Distribution rationale

| # | Criterion | Where to verify | Evidence artefact |
|---|---|---|---|
| 2.1 | Beta distribution justified for mean-reverting regimes | `SIRA_ASSUMPTIONS.md §1.1` | `CREDIT_RISK_LAYER.md §4.1` |
| 2.2 | Power Law justified for jump-risk regimes | `SIRA_ASSUMPTIONS.md §1.2` | `CREDIT_RISK_LAYER.md §4.2` |
| 2.3 | Gaussian ruled out on structural grounds | `SIRA_RNORM_RATIONALE.md` | Cell 08 log-scale chart |
| 2.4 | Gaussian reference draw is comparison only, not signal input | `SIRA_RNORM_RATIONALE.md` | Cell 04 annotation |
| 2.5 | Empirical calibration basis for shape parameters | `RISK_COMMITTEE.md §2.3` | [OPERATOR] validation memo |
| 2.6 | Boundary condition handling (near-zero recovery) | `SIRA_ASSUMPTIONS.md §1.1` | `RISK_COMMITTEE.md §2.4` |

---

## Section 3 — Signal logic

| # | Criterion | Where to verify | Evidence artefact |
|---|---|---|---|
| 3.1 | SELL/HOLD derivation is rule-based, not inferred | `SIRA_ASSUMPTIONS.md §1.1` | Cell 04 `compute_signals()` |
| 3.2 | WATCH exclusion from core engine is documented | `SIRA_METHODOLOGY.md` §Why the signal is binary | `README.md NG-002` |
| 3.3 | WATCH validity in spread layer is justified | `SIRA_METHODOLOGY.md` §Why the signal is binary | `README.md NG-002` |
| 3.4 | Ruin threshold derivation is governed | `RISK_COMMITTEE.md §3.2` | [OPERATOR] threshold standard |
| 3.5 | Z-score threshold calibration is governed | `RISK_COMMITTEE.md §3.3` | [OPERATOR] calibration window |
| 3.6 | False positive/negative posture is defined | `RISK_COMMITTEE.md §3.4` | [OPERATOR] error targets |

---

## Section 4 — Capital stack

| # | Criterion | Where to verify | Evidence artefact |
|---|---|---|---|
| 4.1 | Liability engine is not actuarial valuation | `SIRA_ASSUMPTIONS.md §2.1` | `README.md NG-008` |
| 4.2 | LGD proxy construction is correctly attributed | `SIRA_ASSUMPTIONS.md §2.2` | `CREDIT_RISK_LAYER.md §1.1` |
| 4.3 | Spread signal graduated response path exists | `SIRA_METHODOLOGY.md` §Why the capital stack layer exists | `RISK_COMMITTEE.md` |
| 4.4 | Annuity type classification governs obligation structure | `SIRA_ASSUMPTIONS.md §2.1` | `config/sira.toml [annuity]` |

---

## Section 5 — Valuation layer

| # | Criterion | Where to verify | Evidence artefact |
|---|---|---|---|
| 5.1 | DCF outputs are not MtM valuations | `SIRA_ASSUMPTIONS.md §3.1` | `README.md NG-014` |
| 5.2 | IRR outputs are not audited return attestations | `SIRA_ASSUMPTIONS.md §3.2` | `README.md NG-013` |
| 5.3 | M&A signals are not investment advice | `README.md NG-015` | Non-goals register |
| 5.4 | Exit EV proxy (DCF stressed) is documented | `SIRA_ASSUMPTIONS.md §3.2` | Cell 17 |
| 5.5 | DSCR minimum and IRR floor governance | `RISK_COMMITTEE.md` | [OPERATOR] threshold approval |

---

## Section 6 — Black-Scholes options layer

| # | Criterion | Where to verify | Evidence artefact |
|---|---|---|---|
| 6.1 | BSM limitation notice is emitted at runtime | `SIRA_ASSUMPTIONS.md §4.1` | Cell 18 output |
| 6.2 | Put-call parity derivation used (not separate put formula) | `SIRA_ASSUMPTIONS.md §4.1` | Cell 18 `bsm_put()` |
| 6.3 | Firm value V is operator-declared, not market-calibrated | `SIRA_ASSUMPTIONS.md §4.1` | `README.md NG-018` |
| 6.4 | Vol surface is scenario-governed, not market-implied | `SIRA_ASSUMPTIONS.md §4.1` | `README.md NG-017` |
| 6.5 | Merton linkage is explanatory framing only | `SIRA_METHODOLOGY.md` §Why BSM is included | `README.md NG-018` |
| 6.6 | BSM/SIRA convergence diagnostic is interpreted correctly | `SIRA_ASSUMPTIONS.md §4.1` | Cell 18 convergence column |
| 6.7 | Leverage effect amplification mechanism is documented | `SIRA_METHODOLOGY.md` §Why BSM is included | Cell 18 annotation |
| 6.8 | Greeks are BSM/GBM only — stochastic vol not implemented | `SIRA_ASSUMPTIONS.md §4.1` | `README.md NG-019` |
| 6.9 | Counterparty Default sigma derivation is annotated | `SIRA_ASSUMPTIONS.md §4.1` | Cell 18 `sigma_cd_implied` |

---

## Section 7 — Reproducibility and runtime

| # | Criterion | Where to verify | Evidence artefact |
|---|---|---|---|
| 7.1 | Seed is declared and sourced from CFG | `SIRA_ASSUMPTIONS.md §5` | Cell 02 |
| 7.2 | Path resolver finds correct config | `SIRA_PATH_RESOLVER.md` | Cell 12 config source log |
| 7.3 | No hardcoded scenario values in notebook | `SIRA_ASSUMPTIONS.md §5` | All cells use CFG |
| 7.4 | Session metadata records seed, timestamp, packages | Cell 12 | Cell 12 output |
| 7.5 | Re-run from Cell 02 produces identical outputs | `SIRA_PATH_RESOLVER.md` | Determinism by construction |
| 7.6 | Notebook does not write to `output/` | Cell 12 declaration | Cell 12 output |

---

## Section 8 — Operator action items

Items marked [OPERATOR] above require evidence that cannot be
produced by the repository. The following must be completed
before a formal model risk review can be closed:

| # | Item | Reference |
|---|---|---|
| O1 | Designate model owner | `RISK_COMMITTEE.md §6.1` |
| O2 | Assign model inventory classification | `RISK_COMMITTEE.md §4.1` |
| O3 | Provide empirical calibration basis for shape parameters | `RISK_COMMITTEE.md §2.3` |
| O4 | Define ruin threshold derivation standard | `RISK_COMMITTEE.md §3.2` |
| O5 | Define z-score threshold calibration window | `RISK_COMMITTEE.md §3.3` |
| O6 | Establish false positive/negative error targets | `RISK_COMMITTEE.md §3.4` |
| O7 | Approve DSCR minimum and IRR floor | valuation governance |
| O8 | Confirm firm value V declaration and governance | `README.md NG-018` |
| O9 | Define audit log retention schedule | `SIRA_PATH_RESOLVER.md` |
| O10 | Back-test design approval | `RISK_COMMITTEE.md §4.2` |

---

## Sign-off record

| Reviewer | Role | Date | Scope |
|---|---|---|---|
| | | | |
| | | | |

> This checklist is a navigation instrument, not a sign-off authority.
> Formal model risk sign-off is governed by the operator's MRM framework.
