# Stochastic Invalidation & Risk Architecture (SIRA)

Distressed bond recovery, stress testing, and signal generation across five adverse market scenarios.

[![Focus](https://img.shields.io/badge/Focus-Quant%20Risk%20Modelling-0A66C2?style=flat-square)](#)
[![Approach](https://img.shields.io/badge/Approach-Auditability%20by%20Design-2E7D32?style=flat-square)](#)
[![Runtime](https://img.shields.io/badge/Runtime-R%20%2B%20ggplot2-276DC3?style=flat-square)](#)
[![Config](https://img.shields.io/badge/Config-TOML%20Declared--Intent-8B5CF6?style=flat-square)](#)
[![Env](https://img.shields.io/badge/Env-Air--Gapped%20Compatible-333333?style=flat-square)](#)

---

## Executive summary

The engine evaluates a bond portfolio under five stress scenarios and produces scenario-level and asset-level outputs:

- **Stochastic recovery simulation** using Beta and Power Law distributions to capture non-normal, tail-heavy recovery behaviour.
- **Z-score diagnostics** to identify assets with materially weak recovery outcomes relative to the scenario cross-section.
- **Ruin threshold logic** to classify invalidation events where recovery falls below scenario-specific survival levels.
- **SELL/HOLD signals** to support risk triage.

All operator-configurable parameters are declared in `config/sira.toml` — the single source of truth for scenario definitions, distribution parameters, signal thresholds, and output dimensions. No analytical script contains hardcoded values. The runtime surface is fully terminal-native with structured stdout emission; terminal colour output adapts to the execution context.

---

## Methodology

**1. Preflight (`scripts/00_env_check.R`)**

Confirms minimum R version, ggplot2 availability, TOML parseability, and output directory writability before any analytical work begins. Halts with a labelled non-zero exit on any failed check.

**2. Load configuration (`scripts/00_config.R`)**

Parses `config/sira.toml` via `RcppTOML` and exposes a single named list `CFG` to the runtime environment. Initialises the `NEON` colour palette, gated on `isatty(stdout())` — clean undecorated output in non-interactive or piped contexts.

**3. Load inputs (`scripts/01_load_data.R`)**

Reads CSV, RDS, or RData files from the path declared in `CFG$data$path` when provided. Falls back to deterministic synthetic defaults when the directory is empty — seed set from `CFG$runtime$seed`. The engine produces valid output in either case.

**4. Run analysis (`scripts/02_analysis.R`)**

Generates stressed recoveries per scenario from parameters declared in `CFG$scenarios`:

- Beta distribution for baseline and liquidity-driven conditions.
- Power law tails for jump-risk regimes.

Iterates scenarios dynamically from `CFG$scenarios$names` — no hardcoded scenario list. Applies scenario shocks — price gap-down, currency devaluation, scenario-specific ruin thresholds — then computes:

```
z_score   = scale(stressed_recovery)
ruin_flag = stressed_recovery <= ruin_threshold
signal    ∈ {SELL, HOLD}
```

>*Beta distributions model recovery rates bounded between 0 and 1 with shape parameters tuned to scenario severity — appropriate where loss given default follows a unimodal, mean-reverting pattern. Power law tails are applied under jump-risk regimes where extreme outcomes are structurally more probable than a normal or Beta distribution would predict.*

**5. Visualise and emit (`scripts/03_visualize.R`)**

Consumes the results dataframe and writes `output/sell_hold_signals.png` via ggplot2 using dimensions and DPI from `CFG$output`. Emits a terminal-native fixed-width summary table to stdout showing per-scenario SELL/HOLD counts and mean recovery.

**6. Orchestrate (`run_all.R`)**

Sources all scripts in sequence with a terminal harness: header block on start, per-stage progress, footer block with wall-clock elapsed time and exit status. Traps mid-pipeline failures and emits labelled error output before halting — no silent partial runs.

---

## Five stress scenarios

| Scenario | Stress mechanism | Distribution |
|----------|-----------------|--------------|
| Baseline | Normal market functioning | Beta |
| Liquidity Crunch | Elevated volatility, compressed recoveries | Beta |
| Jurisdictional Freeze | Recovery collapses toward ruin threshold | Beta |
| Counterparty Default | Gap-down valuation shock | Power Law |
| Hyper-Inflationary | FX devaluation impairs real bond value | Power Law |

All scenario parameters — shape, exponent, ruin threshold, shock multiplier, FX devaluation — are declared in `config/sira.toml` and consumed at runtime. No scenario definition exists outside the TOML.

---

## Repository structure

```text
.
├── README.md
├── run_all.R                    # Orchestration entry point
├── config/
│   └── sira.toml                # Canonical operator configuration — declared-intent register
├── data/
│   └── .gitkeep                 # Drop CSV/RDS/RData here; synthetic defaults used if empty
├── scripts/
│   ├── 00_env_check.R           # Preflight: R version, packages, paths
│   ├── 00_config.R              # TOML loader; exposes CFG and NEON globals
│   ├── 01_load_data.R
│   ├── 02_analysis.R
│   ├── 03_visualize.R
│   ├── 10_liability_engine.R
│   ├── 11_credit_deployment.R
│   ├── 12_spread_stress.R
│   └── 13_capital_stack_viz.R
└── output/
    ├── sell_hold_signals.png    # Generated on run
    ├── capital_stack_spread.png # Generated on run
    └── capital_stack_metadata.rds
```

```bash
Rscript run_all.R
```

> Requires R (>= 4.0.0), ggplot2, and RcppTOML. No external data sources, live feeds, or network connectivity are required at runtime — the engine is designed to produce valid output in fully air-gapped or degraded environments. Where live or externally sourced data is available, it can be substituted via the path declared in `config/sira.toml`. RcppTOML is the only dependency introduced beyond base R and ggplot2; it must be installable from a local mirror or vendored package in air-gapped deployments.

---

## Non-goals

- **NG-001:** Not a live risk system — outputs are stochastic simulations against synthetic
  or operator-supplied data; no MtM or real-time feed integration.
  - *Exception:* External data may be substituted via the path declared in `CFG$data$path`;
    synthetic fallback activates only on empty input.

- **NG-002:** Not an OMS or EMS — SELL/HOLD signals are pre-trade analytical indicators,
  not executable order instructions. A three-state signal set (SELL/WATCH/HOLD) was evaluated
  during development; WATCH was excluded from this implementation as the two-state set is
  sufficient for the declared analytical scope.
  - *Exception:* Signals may inform execution where the operator has accepted analytical
    risk and applied independent instrument-level validation (ILV).

- **NG-003:** Not a full credit model — scenarios model directional LGD/PD stress behaviour;
  no substitute for instrument-level credit analysis or IRB model validation.

- **NG-004:** Not a compliance attestation — ruin threshold and Z-score logic expresses
  analytical intent; no certified conformance to SR 11-7, FRTB, or equivalent MRM frameworks.

- **NG-005:** Not environment-agnostic — reproducibility guaranteed within declared runtime
  (R + ggplot2 + RcppTOML); OOS configurations require operator validation and a documented
  deviation log.

- **NG-006:** Not a hardened terminal application — terminal colour output is a UX consideration;
  it adapts to the execution context and is absent in non-interactive or piped runs. No terminal
  UI framework or ncurses dependency is introduced.

- **NG-007:** Not a regulatory capital model for insurers — the capital stack extension is a stress
  coverage analytic and must not be interpreted as an insurer capital adequacy certification engine.

- **NG-008:** Not a replacement for actuarial liability valuation — liability engine outputs are
  parameterized stress approximations and require independent actuarial governance.

- **NG-009:** Not a live portfolio management system — spread signals (`SOLVENT/WATCH/BREACH`) are
  governance prompts, not automated allocation, hedging, or execution instructions.

> This describes a runtime boundary, not a hardening claim or certified assurance posture.
> Not affiliated with or endorsed by Common Criteria, Basel II/III, BCBS 239, FRTB,
> ISO 27001, ISO 27005, Essential Eight ML3/ML4, SOC 2, SR 11-7, or any equivalent
> evaluation framework.
