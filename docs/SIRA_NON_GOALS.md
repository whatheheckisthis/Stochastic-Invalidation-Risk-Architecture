# SIRA Non-Goals Register

> Runtime boundary declaration only. Not a hardening claim
> or certified assurance posture. Not affiliated with or
> endorsed by Common Criteria, Basel II/III, BCBS 239,
> FRTB, ISO 27001, ISO 27005, Essential Eight ML3/ML4,
> SOC 2, SR 11-7, or any equivalent evaluation framework.

> **Canonical location:** This file is the authoritative
> Non-Goals Register for the SIRA programme. All other
> files in this repository that reference non-goals link
> to this document. Do not reproduce register entries
> inline elsewhere — update this file and link to it.

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

---

## Evidence and validation boundaries — NG-022 to NG-024

| ID | Boundary | Detail |
|---|---|---|
| NG-022 | Executed model outputs not present | The engine is governed at the architecture and documentation layer prior to live data ingestion. No committed run artefact constitutes a production output. See [`docs/SIRA_EVIDENCE_GAP_REGISTER.md`](_superseded/SIRA_EVIDENCE_GAP_REGISTER.md) EG-001. |
| NG-023 | Distribution parameters not empirically calibrated | Beta and Power Law parameters are structurally justified but not fitted to empirical workout data in this repository. Calibration is an operator action item contingent on historical workout data. See [`docs/SIRA_EVIDENCE_GAP_REGISTER.md`](_superseded/SIRA_EVIDENCE_GAP_REGISTER.md) EG-002. |
| NG-024 | No backtesting evidence present | Signal logic has not been evaluated against historical recovery outcomes. Backtesting is an operator action item contingent on a labelled historical dataset. See [`docs/SIRA_EVIDENCE_GAP_REGISTER.md`](_superseded/SIRA_EVIDENCE_GAP_REGISTER.md) EG-003. |

---

> Runtime boundary declaration only. Not a hardening
> claim or certified assurance posture. Not affiliated
> with or endorsed by Common Criteria, Basel II/III,
> BCBS 239, FRTB, ISO 27001, ISO 27005, Essential Eight
> ML3/ML4, SOC 2, SR 11-7, or any equivalent evaluation
> framework. Evidence and validation boundaries
> (NG-022 to NG-024) are governed in
> [`docs/SIRA_EVIDENCE_GAP_REGISTER.md`](_superseded/SIRA_EVIDENCE_GAP_REGISTER.md).

---

**Boundary Clarification:** This defines system boundaries, not behaviour.
