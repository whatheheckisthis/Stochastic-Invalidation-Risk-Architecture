# SIRA

## Stochastic Invalidation & Risk Architecture
### A Black Box Recovery Probability Engine

## Primary documents
Read these first:
- [docs/ETHOS.md](docs/ETHOS.md) — architectural philosophy and stack rationale.
- [docs/DELIVERY.md](docs/DELIVERY.md) — engagement model, delivery artefacts, GRC control mappings, and SDLC gating controls matrix.

Everything else in this repository is the operational substrate that supports those documents.

## Top-level assets
- [black_box_risk_engine.R](black_box_risk_engine.R)
- [STOCHASTIC_INVALIDATION_RISK_ARCHITECTURE.md](STOCHASTIC_INVALIDATION_RISK_ARCHITECTURE.md)
- [LICENSE](LICENSE)

---

## Motivation
This project is framed around **Marginal Propensity to Invest (MPI)** as a decision lens for distressed asset recovery and risk posture design.

- **Definition:** MPI describes the incremental change in investment resulting from a change in expected return, confidence, or available capital under uncertainty.
- **Calculation (working form):**
  - `MPI = ΔInvestment / ΔExpected_Income` (macro framing), and
  - scenario-adjusted variants for recovery models where expected income is replaced by risk-adjusted return signals.
- **Economic impact:**
  - Higher MPI can accelerate capital deployment into recovery pathways.
  - Lower MPI can indicate tightening liquidity preference, elevated perceived risk, or control uncertainty.
  - In this repository, MPI-oriented framing is used to connect recovery probability outputs with governance and control decisions.

---

## Project purpose
SIRA is documented as an **Intent-to-Auditable-Trust-Object (IATO)** workflow so each material change is traceable across:
1. Intent.
2. Control mapping.
3. SDLC gating.
4. Verification evidence.
5. Provenance.

---

## Control mapping (summary)
| Component | Risk | Control expectation | Evidence |
|---|---|---|---|
| `getDataPoint` | Data interpretation drift | Deterministic extraction and formatting | Unit tests + sample runtime output |
| `getRatio` | Divide-by-zero / denominator edge failure | Explicit boundary behavior | Unit tests for edge cases |
| `main` flow | Silent pipeline drift | Repeatable request-transform-output sequence | Client run + regression outputs |
| Delivery workflow | Untraceable change | Commit-scoped rationale and review metadata | Git history + PR record |

For full mappings and gates, use [docs/DELIVERY.md](docs/DELIVERY.md).

---

## SDLC gating (summary)
| Gate | Stage | Required outcome |
|---|---|---|
| G1 | Plan | Intent, scope, and non-goals defined |
| G2 | Design | Threat model and control mapping defined |
| G3 | Build | Diff aligns with declared scope |
| G4 | Verify | Tests executed and outcomes captured |
| G5 | Release | Provenance and residual risk recorded |
| G6 | Operate | Runbook commands validated |

Detailed criteria and evidence requirements are maintained in [docs/DELIVERY.md](docs/DELIVERY.md).

---

## Repository structure
```text
.
├── README.md
├── docs/
│   ├── ETHOS.md
│   ├── DELIVERY.md
│   ├── ARCHITECTURE.md
│   ├── WORKER_COMPAT.md
│   └── cyber-risk-controls.md
├── JPMC-tech-task-1-py3/
├── JPMC-tech-task-2-py3/
├── JPMC-tech-task-3-py3/
├── black_box_risk_engine.R
└── STOCHASTIC_INVALIDATION_RISK_ARCHITECTURE.md
```

---

## Runbook (terminal-first)
Commands:

```bash
python JPMC-tech-task-1-py3/server3.py
python JPMC-tech-task-1-py3/client3.py
python JPMC-tech-task-1-py3/client_test.py
curl 'http://localhost:8080/query?id=1'
```

Dependency remediation:

```bash
pip install python-dateutil
```

---

## Cross references
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — system invariants and design rationale.
- [docs/WORKER_COMPAT.md](docs/WORKER_COMPAT.md) — audit and implementation narrative.
- [docs/cyber-risk-controls.md](docs/cyber-risk-controls.md) — Essential Eight control coverage.

---

## Non-Goals
- **NG-001:** Not a replacement for a full organisational SDLC or security programme.
- **NG-002:** Not a runtime hardening guarantee across all environments.
- **NG-003:** Not formal verification of third-party or external system behaviour.
- **NG-004:** Not automatic compliance attestation — organisation-specific controls and evidence are required.
- **NG-005:** Not affiliated with or endorsed by Common Criteria.

