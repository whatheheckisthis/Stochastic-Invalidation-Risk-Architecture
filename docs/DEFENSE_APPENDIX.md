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
