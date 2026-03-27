# Distressed Asset Recovery Stress Engine

This repository is organized as a modular quant workflow for **distressed bond recovery stress testing** and signal generation.

## Executive Summary

The model evaluates a bond portfolio under five stress scenarios and produces scenario-level and asset-level outputs:

- **Stochastic recovery simulation** using **Beta** and **Power Law** distributions to capture non-normal, tail-heavy recovery behavior.
- **Z-Score diagnostics** to identify assets with materially weak recovery outcomes relative to the scenario cross-section.
- **Ruin Threshold logic** to classify potential invalidation events where recovery falls below scenario-specific survival levels.
- **Sell/Hold signals** to support risk triage.

### Methodology

1. **Load inputs (`scripts/01_load_data.R`)**
   - Reads CSV/RDS/RData files from `/data` when provided.
   - Uses deterministic synthetic defaults when `/data` is empty.

2. **Run analysis (`scripts/02_analysis.R`)**
   - Generates stressed recoveries by scenario:
     - Beta distribution for baseline and liquidity-driven conditions.
     - Power law tails for jump-risk regimes.
   - Applies scenario shocks:
     - price gap-down,
     - currency devaluation,
     - scenario ruin thresholds.
   - Computes:
     - `z_score = scale(stressed_recovery)`
     - `ruin_flag = stressed_recovery <= ruin_threshold`
     - `signal ∈ {Sell, Hold}`

3. **Visualize (`scripts/03_visualize.R`)**
   - Produces stacked SELL/HOLD scenario chart with `ggplot2`.

4. **Orchestrate (`run_all.R`)**
   - Executes all modules in sequence.

## Repository Structure

```text
/data
  .gitkeep
/scripts
  01_load_data.R
  02_analysis.R
  03_visualize.R
README.md
run_all.R
```

## Five Stress Scenarios

- **Baseline**: Normal market functioning.
- **Liquidity Crunch**: High volatility and lower recoveries.
- **Jurisdictional Freeze**: Recovery collapses toward ruin threshold immediately.
- **Counterparty Default**: Gap-down driven valuation shock.
- **Hyper-Inflationary**: FX devaluation impairs real bond value.

## Run

```bash
Rscript run_all.R
```

If `ggplot2` is installed, the signal chart is saved to:

```text
output/sell_hold_signals.png
```
