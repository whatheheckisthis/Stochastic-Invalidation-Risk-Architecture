# Distressed Asset Recovery Stress Engine

Modular quant workflow for distressed bond recovery stress testing and signal generation across five adverse market scenarios.

[![Focus](https://img.shields.io/badge/Focus-Quant%20Risk%20Modelling-0A66C2?style=flat-square)](#)
[![Approach](https://img.shields.io/badge/Approach-Auditability%20by%20Design-2E7D32?style=flat-square)](#)
[![Runtime](https://img.shields.io/badge/Runtime-R%20%2B%20ggplot2-276DC3?style=flat-square)](#)
[![Env](https://img.shields.io/badge/Env-Air--Gapped%20Compatible-333333?style=flat-square)](#)
---

## Executive summary

The engine evaluates a bond portfolio under five stress scenarios and produces scenario-level and asset-level outputs:

- **Stochastic recovery simulation** using Beta and Power Law distributions to capture non-normal, tail-heavy recovery behaviour.
- **Z-score diagnostics** to identify assets with materially weak recovery outcomes relative to the scenario cross-section.
- **Ruin threshold logic** to classify invalidation events where recovery falls below scenario-specific survival levels.
- **SELL/HOLD signals** to support risk triage.

---

## Methodology

**1. Load inputs (`scripts/01_load_data.R`)**

Reads CSV, RDS, or RData files from `/data` when provided. Falls back to deterministic synthetic defaults when `/data` is empty — the engine produces valid output in either case.

**2. Run analysis (`scripts/02_analysis.R`)**

Generates stressed recoveries per scenario:

- Beta distribution for baseline and liquidity-driven conditions.
- Power law tails for jump-risk regimes.

Applies scenario shocks — price gap-down, currency devaluation, scenario-specific ruin thresholds — then computes:

```
z_score  = scale(stressed_recovery)
ruin_flag = stressed_recovery <= ruin_threshold
signal   ∈ {SELL, HOLD}
```

**3. Visualize (`scripts/03_visualize.R`)**

Produces a stacked SELL/HOLD scenario chart via ggplot2.

**4. Orchestrate (`run_all.R`)**

Executes all modules in sequence.

---

## Five stress scenarios

| Scenario | Stress mechanism |
|----------|-----------------|
| Baseline | Normal market functioning |
| Liquidity Crunch | Elevated volatility, compressed recoveries |
| Jurisdictional Freeze | Recovery collapses toward ruin threshold |
| Counterparty Default | Gap-down valuation shock |
| Hyper-Inflationary | FX devaluation impairs real bond value |

---

## Repository structure

```text
.
├── README.md
├── run_all.R                  # Orchestration entry point
├── data/
│   └── .gitkeep               # Drop CSV/RDS/RData here; synthetic defaults used if empty
├── scripts/
│   ├── 01_load_data.R
│   ├── 02_analysis.R
│   └── 03_visualize.R
└── output/
    └── sell_hold_signals.png  # Generated on run
```

---

## Run

```bash
Rscript run_all.R
```

Output written to:

```text
output/sell_hold_signals.png
```

Requires ggplot2. No external data sources or live feeds required.

---

## Non-goals

- **NG-001:** Not a live risk system — recovery outputs are stochastic simulations against synthetic or user-supplied data, not real-time market valuations.
- **NG-002:** Not a trading system — SELL/HOLD signals are analytical indicators for risk triage, not executable instructions.
- **NG-003:** Not a full credit model — scenarios capture directional stress behaviour; they do not substitute for instrument-level credit analysis.
- **NG-004:** Not compliance attestation — the ruin threshold and Z-score logic documents analytical intent, not certified regulatory conformance.
- **NG-005:** Not environment-agnostic — reproducibility is guaranteed within the declared runtime (R + ggplot2); behaviour under untested configurations is out of scope.
