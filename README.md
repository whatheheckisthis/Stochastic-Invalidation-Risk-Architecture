# Stochastic Invalidation & Risk Architecture (SIRA)

Distressed bond recovery, stress testing, and signal generation across five adverse market scenarios.

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
z_score   = scale(stressed_recovery)
ruin_flag = stressed_recovery <= ruin_threshold
signal    ∈ {SELL, HOLD}
```

>*Beta distributions model recovery rates bounded between 0 and 1 with shape parameters tuned to scenario severity — appropriate where loss given default follows a unimodal, mean-reverting pattern. Power law tails are applied under jump-risk regimes where extreme outcomes are structurally more probable than a normal or Beta distribution would predict.*

**3. Orchestrate (`run_all.R`)**

Executes all modules in sequence. Visualization written to `output/sell_hold_signals.png` via ggplot2.

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
├── run_all.R                    # Orchestration entry point
├── data/
│   └── .gitkeep                 # Drop CSV/RDS/RData here; synthetic defaults used if empty
├── scripts/
│   ├── 01_load_data.R
│   ├── 02_analysis.R
│   └── 03_visualize.R
└── output/
    └── sell_hold_signals.png    # Generated on run
```
```bash
Rscript run_all.R
```
> Requires R and ggplot2. No external data sources, live feeds, or network connectivity are required at runtime — the engine is designed to produce valid output in fully air-gapped or degraded environments. Where live or externally sourced data is available, it can be substituted via `/data` in place of the synthetic defaults. No additional dependencies beyond base R and ggplot2 are introduced.

---

## Non-goals

- **NG-001:** Not a live risk system — outputs are stochastic simulations against synthetic 
  or operator-supplied data; no MtM or real-time feed integration.
  - *Exception:* External data may be substituted via `/data`; synthetic fallback activates 
    only on empty input.

- **NG-002:** Not an OMS or EMS — SELL/HOLD signals are pre-trade analytical indicators, 
  not executable order instructions.
  - *Exception:* Signals may inform execution where the operator has accepted analytical 
    risk and applied independent instrument-level validation (ILV).

- **NG-003:** Not a full credit model — scenarios model directional LGD/PD stress behaviour; 
  no substitute for instrument-level credit analysis or IRB model validation.

- **NG-004:** Not a compliance attestation — ruin threshold and Z-score logic expresses 
  analytical intent; no certified conformance to SR 11-7, FRTB, or equivalent MRM frameworks.

- **NG-005:** Not environment-agnostic — reproducibility guaranteed within declared runtime 
  (R + ggplot2)OOS configurations require operator validation and a documented deviation log.

> Runtime boundary declaration — not a hardening claim or certified assurance posture. Not 
> affiliated with or endorsed by CC, Basel II/III, BCBS 239, FRTB, ISO 27001/27005, 
> E8 ML3/ML4, SOC 2, or SR 11-7.
> This describes a runtime boundary, not a hardening claim or certified assurance posture. 
> It is not affiliated with or endorsed by Common Criteria, Basel II/III, BCBS 239, FRTB, 
> ISO 27001, ISO 27005, Essential Eight ML3/ML4, SOC 2, SR 11-7, or any equivalent 
> evaluation framework.
