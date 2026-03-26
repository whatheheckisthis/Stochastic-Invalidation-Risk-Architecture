# SIRA — Stochastic Invalidation & Risk Architecture

A black box recovery probability engine for distressed asset portfolios under extreme market stress.

---

## What this is

SIRA simulates asset recovery distributions across five stress scenarios using internal synthetic data structures — no API calls, no live feeds, no external dependencies that can fail during a crisis. The engine runs in any environment, including fully air-gapped or degraded connectivity conditions.

The core deliverable is `black_box_risk_engine.R`: a single plug-and-play function (`black_box_engine()`) that accepts a portfolio and a scenario definition, runs 10,000 Monte Carlo draws per asset, and returns mean net recovery, standard deviation, Z-score distance from the invalidation threshold, a weighted Risk/Stress Score, and a SELL/WATCH/HOLD signal per asset.

---

## Repository structure

```text
.
├── README.md
├── black_box_risk_engine.R              # Core engine — plug-and-play entry point
├── STOCHASTIC_INVALIDATION_RISK_ARCHITECTURE.md  # Case study write-up
├── docs/
│   ├── ETHOS.md                         # Architectural philosophy and stack rationale
│   ├── DELIVERY.md                      # Engagement model, GRC mappings, SDLC gates
│   ├── ARCHITECTURE.md                  # System invariants and design rationale
│   ├── WORKER_COMPAT.md                 # Audit and implementation narrative
│   └── cyber-risk-controls.md           # Essential Eight control coverage
├── JPMC-tech-task-1-py3/
├── JPMC-tech-task-2-py3/
└── JPMC-tech-task-3-py3/
```

---

## Engine overview

**Scenarios modelled:**

| ID | Scenario | Rate Shock | Horizon Mult | Vol Mult | Recovery Haircut |
|----|----------|-----------|--------------|----------|-----------------|
| S1 | Baseline | — | 1.0× | 1.0× | — |
| S2 | Rate Shock | +200 bps | 1.15× | 1.3× | −7% |
| S3 | Liquidity Trap | +100 bps | 1.8× | 1.2× | −10% |
| S4 | Variance Error | +50 bps | 1.1× | 1.9× | −5% |
| S5 | Black Swan | +350 bps | 2.2× | 2.5× | −22% |

**Key outputs per asset per scenario:**
- `mean_net_rec` — mean net recovery after carry cost
- `sd_net_rec` — standard deviation of net recovery distribution
- `z_score_floor` — Z-score distance from the invalidation threshold (net recovery = 0)
- `risk_score` — weighted stress score: higher = further below invalidation
- `signal` — `SELL` (ruin threshold breached) / `WATCH` / `HOLD`

**Invalidation logic:**

```
Net Recovery    = Gross Recovery − (CoC × Exit Horizon / 365)
Invalidation Pt = Net Recovery < 0  →  SELL signal
Z-Score         = (mean_net_rec − 0) / sd_net_rec
Risk/Stress Score = max(0, −Z × 100) + (vol_mult − 1) × 25
```

---

## Running the engine

```bash
Rscript black_box_risk_engine.R
```

Produces terminal output (portfolio summary, Black Swan scenario detail) and three ggplot2 charts:
- `output_mean_recovery.png` — mean net recovery by asset and scenario
- `output_risk_scores.png` — Risk/Stress Score distributions by scenario
- `output_sigma_bands.png` — per-asset recovery density plots with invalidation threshold

Dependencies: R, ggplot2. No external data sources required.

---

## Python tasks (JPMC)

```bash
python JPMC-tech-task-1-py3/server3.py
python JPMC-tech-task-1-py3/client3.py
python JPMC-tech-task-1-py3/client_test.py
curl 'http://localhost:8080/query?id=1'
```

Dependency:

```bash
pip install python-dateutil
```

---

## Control mapping

| Component | Risk | Control expectation | Evidence |
|-----------|------|---------------------|----------|
| `black_box_engine()` | Scenario parameter drift | Deterministic scenario definitions, hard-coded internal data | Reproducible output via `set.seed(42)` |
| `simulate_recovery()` | Boundary violations | Recovery draws bounded [0, 1] | Unit tests + runtime output |
| `portfolio_summary()` | Silent pipeline drift | Repeatable transform-output sequence | Regression outputs across all 5 scenarios |
| Delivery workflow | Untraceable change | Commit-scoped rationale | Git history + PR record |

Full GRC mappings and SDLC gate criteria: [docs/DELIVERY.md](docs/DELIVERY.md).

---

## SDLC gates

| Gate | Stage | Required outcome |
|------|-------|-----------------|
| G1 | Plan | Intent, scope, and non-goals defined |
| G2 | Design | Threat model and control mapping defined |
| G3 | Build | Diff aligns with declared scope |
| G4 | Verify | Tests executed and outcomes captured |
| G5 | Release | Provenance and residual risk recorded |
| G6 | Operate | Runbook commands validated |

---

## Non-goals

- NG-001: Not a replacement for a full organisational SDLC or security programme.
- NG-002: Not a runtime hardening guarantee across all environments.
- NG-003: Not formal verification of third-party or external system behaviour.
- NG-004: Not automatic compliance attestation — organisation-specific controls and evidence required.
- NG-005: Not affiliated with or endorsed by Common Criteria.

---

## Further reading

- [docs/ETHOS.md](docs/ETHOS.md) — architectural philosophy and stack rationale
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — system invariants and design rationale
- [docs/cyber-risk-controls.md](docs/cyber-risk-controls.md) — Essential Eight control coverage
- [STOCHASTIC_INVALIDATION_RISK_ARCHITECTURE.md](STOCHASTIC_INVALIDATION_RISK_ARCHITECTURE.md) — full case study
