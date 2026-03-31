# Defense Appendix — Epsilon-Centric Controls Matrix

>This appendix restructures the model defense posture around a single governing variable epsilon, treating it not as an implementation detail but as the primary object of control, audit, and committee challenge. Rather than presenting a general narrative of model soundness, the framework anchors every control objective, compliance mapping, and evidence requirement to epsilon's specific role in path perturbation, threshold-cross timing, and decision volatility under stress.

## Purpose

`epsilon` is treated as the central pillar of model defensibility because it governs path perturbation behavior, near-threshold instability, and decision volatility under stress. The appendix is therefore structured as a **Controls Matrix** that maps epsilon-relevant control intent to audit/compliance lenses.

This follows the same intent-to-auditable pattern used in the IATO series (Intent-to-Auditable-Trust-Object indexing):
- Define control IDs and objectives first.
- Map each control to implementation/security management intent (ISM).
- Cross-map to SOC 2 criteria and internal maturity target (`E8 ML4`).
- Use the matrix as the anchor for evidence packs, committee defense, and assurance reporting.

## Epsilon as the Primary Defense Object

In this project, `epsilon_t` is the per-step stochastic shock in the invalidation simulation (`scripts/stochastic_invalidation_base_r.R`).

Why is epsilon the primary defense object:
- It directly affects threshold-cross timing and ruin incidence.
- It is the highest-leverage source of local stochastic instability.
- It can create false confidence if not governed with calibration, traceability, and evidence retention controls.
- It is where the committee challenge converges: “How robust is the decision if perturbations are slightly different?”

## Secondary Defense Object: Spread Engine and Liability Stack

The capital stack extension introduces a second governed defense object: **liability coverage spread integrity**. While epsilon governs asset-level stochastic perturbation risk, the spread engine governs whether private credit income remains sufficient to cover annuity obligations under stress.

Defense focus for the spread object:
- Liability assumptions are centralized in `[liability]` TOML controls (`payout_rate`, `duration_years`, `inflation_sensitivity`, `insurer_solvency_buffer`).
- Credit income assumptions are centralized in `[credit]` TOML controls and stress-adjusted with scenario-level LGD proxies.
- Cross-scenario outputs are normalized to `SOLVENT/WATCH/BREACH`, providing auditable escalation states.
- Headroom breaches are first-class events in metadata artifacts and terminal summaries.

## Controls Matrix 
This matrix is the authoritative reference set for the appendix. Detailed control procedures, test scripts, and owner attestations are to be defined in the Controls Framework artifact set.

| Control ID | Objective | ISM | SOC 2 | E8 ML4 |
|---|---|---|---|---|
| CTRL-AUD-01 | Immutable audit logging | Event logging | CC6, CC7 | ML4 |
| CTRL-AUD-02 | Change traceability | Change management | CC8 | ML4 |
| CTRL-AUD-03 | Evidence retention | Records management | CC2, CC3 | ML4 |
| CTRL-OBS-01 | Service telemetry | Monitoring | CC7 | ML4 |
| CTRL-OBS-02 | Alert fidelity | Incident detection | CC7 | ML4 |
| CTRL-OBS-03 | Time synchronisation | Time source security | CC7 | ML3 |
| CTRL-CON-01 | Continuous control validation | Assessment cadence | CC4, CC5 | ML4 |
| CTRL-CON-02 | Vulnerability management | Vuln management | CC7 | ML4 |
| CTRL-CON-03 | Supply-chain monitoring | Software provenance | CC6, CC7 | ML4 |
| CTRL-GOV-01 | Segregation of duties | Privileged access | CC6 | ML4 |
| CTRL-GOV-02 | Exception governance | Risk acceptance | CC3 | ML4 |
| CTRL-GOV-03 | Assurance reporting | Governance oversight | CC2 | ML4 |
| CTRL-LIA-01 | Liability assumption ownership and approval traceability | Governance and risk ownership | CC3, CC8 | ML4 |
| CTRL-LIA-02 | Liability assumption change review cadence | Change management | CC8 | ML4 |
| CTRL-LIA-03 | Breach escalation governance (SOLVENT/WATCH/BREACH) | Incident and exception governance | CC7, CC3 | ML4 |

## Epsilon Control Interpretation Layer

The matrix above is interpreted for epsilon-specific assurance as follows:

### A) Auditability Controls
- **CTRL-AUD-01 / CTRL-AUD-02 / CTRL-AUD-03** ensure every epsilon-impacting run is attributable to a specific config, seed, parameter state, and runtime environment.
- Defense claim: epsilon behavior is not only simulated; it is reproducibly auditable.

### B) Observability Controls
- **CTRL-OBS-01 / CTRL-OBS-02 / CTRL-OBS-03** ensure epsilon drift, anomaly spikes, and timing inconsistencies are detectable with operational fidelity.
- Defense claim: threshold instability is monitored, not discovered post hoc.

### C) Continuous Assurance Controls
- **CTRL-CON-01 / CTRL-CON-02 / CTRL-CON-03** ensure epsilon-related behavior is continuously validated and that dependencies affecting stochastic integrity are governed.
- Defense claim: epsilon integrity is maintained across change cycles, not only at release time.

### D) Governance Controls
- **CTRL-GOV-01 / CTRL-GOV-02 / CTRL-GOV-03** ensure authority boundaries, exception pathways, and board/committee assurance reporting are explicit.
- Defense claim: epsilon calibration and override are governed decisions with accountable ownership.

### E) Liability Governance Controls
- **CTRL-LIA-01 / CTRL-LIA-02** ensure payout-rate and solvency assumptions are operator-owned, reviewed, and approval-traceable.
- **CTRL-LIA-03** ensures solvency headroom deterioration and breach states trigger governed response pathways.
- Defense claim: spread coverage decisions remain controlled and challengeable under stress, not discretionary.

## Required Framework Follow-Through

To operationalize this appendix as a true control framework, the following artifacts must be defined next:
1. Control owner and approver per Control ID.
2. Control test procedure and evidence frequency per Control ID.
3. Epsilon calibration standard (range policy, breach criteria, exception workflow).
4. Evidence index linking each control to generated artifacts (logs, run metadata, config diffs, sign-offs).
5. Quarterly assurance pack template for committee review.

## Canonical References

- Epsilon implementation locus: `scripts/stochastic_invalidation_base_r.R`
- Technical model framing and IRB boundary: `docs/CREDIT_RISK_LAYER.md`
- Committee challenge framing and governance gaps: `docs/RISK_COMMITTEE.md`

## Data Governance Controls Addendum

| Control ID | Objective | ISM | SOC 2 | BCBS 239 | E8 ML4 |
|---|---|---|---|---|---|
| CTRL-DAT-01 | Manifest-based input registry for governed file activation and mode control | Integrity and configuration verification | CC6, CC7 | Principle 2 | ML4 |
| CTRL-DAT-02 | SHA-256 hash verification at preflight ingestion gate | Integrity verification controls | CC6, CC7 | Principle 3, Principle 6 | ML4 |
| CTRL-DAT-03 | Lineage record per governed dataset | Records integrity and traceability | CC6, CC7 | Principle 3 | ML4 |
| CTRL-DAT-04 | Live/synthetic segregation at folder level with git policy enforcement | Data handling segregation | CC6 | Principle 2 | ML4 |

## Non-goals Register Addendum (Data Architecture)

- `data/live/` is not a data lake or managed repository.
- Manifest governance does not replace institutional enterprise data governance.
- SHA-256 verification confirms file integrity at ingestion time and is not provenance certification.

## Valuation Layer Controls Addendum

| Control ID | Objective | ISM | SOC 2 | SR 11-7 | E8 ML4 |
|---|---|---|---|---|---|
| CTRL-VAL-01 | DCF stress parameterisation governance | Integrity and configuration verification | CC8 | Outcomes Analysis | ML4 |
| CTRL-VAL-02 | M&A threshold approval and override governance | Risk ownership and exception handling | CC3, CC8 | Model Boundary and Challenge | ML4 |
| CTRL-VAL-03 | LBO leverage and DSCR floor controls | Stress and resilience controls | CC7 | Ongoing Monitoring | ML4 |
| CTRL-VAL-04 | IRR target/floor change governance | Change control and monitoring | CC8 | Ongoing Monitoring | ML4 |

### Valuation Control Interpretation

- **CTRL-VAL-01** ensures DCF discount/recovery stress parameters are owner-approved and evidence-backed before run activation.
- **CTRL-VAL-02** ensures acquisition decisions are bounded by committee-ratified thresholds with explicit override accountability.
- **CTRL-VAL-03** ensures leverage amplification controls remain challengeable through DSCR and stressed IRR guardrails.
- **CTRL-VAL-04** ensures IRR floor/target adjustments are governed changes with monitoring continuity.

## Non-goals Register Addendum (Valuation Intelligence)

- Not a live trading or execution system.
- Not a regulatory capital model.
- Not a substitute for instrument-level credit underwriting.
- Not an actuarial valuation engine.
- IRR output is analytical attribution and not an audited return statement.

## Sigma as Co-Primary Defense Object

Per Black-Scholes sensitivity structure, sigma is co-primary with epsilon because vega transmits volatility governance directly into option valuation and stress P&L attribution. In SIRA, CTRL-OPT-02 (vol surface consistency) is therefore a first-order control objective rather than a secondary modeling detail.

## Options Controls Matrix Addendum

| Control ID | Objective | ISM | SOC 2 | SR 11-7 / FRTB | E8 ML4 |
|---|---|---|---|---|---|
| CTRL-OPT-06 | Leverage effect feedback documentation | Governance and risk ownership | CC3 | Conceptual Soundness | ML4 |
| CTRL-OPT-07 | Arbitrage constraint monitoring on vol surface | Integrity verification controls | CC7 | Ongoing Monitoring | ML4 |
| CTRL-OPT-08 | Delta-hedge replication error monitoring | Continuous assurance controls | CC7 | Model Validation | ML4 |
| CTRL-OPT-09 | Positive theta flag governance | Exception governance | CC3 | Ongoing Monitoring | ML4 |

## Non-goals Register Addendum (Options and BSM Layer)

- BSM replication argument assumes continuous trading; private credit is illiquid, so delta-hedging output is analytical stress evidence only.
- Vol surface is not calibrated to market option prices; `sigma(K,T)` is scenario-governed.
- Merton connection is analytical framing only; SIRA does not solve full structural calibration from traded equity.
- Greeks are closed-form BSM Greeks under GBM assumptions and do not model stochastic volatility surface dynamics.
- Risk-neutral pricing eliminates `mu`; SIRA does not model physical-measure equity risk premium expectations.
