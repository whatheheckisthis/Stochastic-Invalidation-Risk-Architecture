# Project Title: Stochastic Invalidation & Risk Architecture

## Problem Statement
In high-stakes finance, waiting for API data during a crisis is a fatal flaw. This model prioritizes **local data integrity** and **internal stochastic parameters** so the risk engine can execute even when live market feeds fail.

## Methodology
- **Tooling**
  - Implemented in **R** as a centralized "Plug and Play" function: `black_box_risk_engine()`.
  - Uses base R statistics for core computations and `ggplot2` (optional) for visualization.
- **Fail-safe data design**
  - If external data is unavailable, the engine auto-generates synthetic local portfolio data via `generate_synthetic_portfolio()`.
  - This ensures a 100% runnable analysis path without API dependency.
- **Institutional logic**
  - Applies a **Z-Score distance-from-mean** on scenario recovery values.
  - Triggers **High Risk** when `z_score < -2` or when invalidation is reached.

## Black Box Engine Deliverables
### 1) Centralized Engine
`black_box_risk_engine(portfolio = NULL, scenario_weights = ..., seed = 42)`

### 2) Five Distinct Stress Scenarios
1. **Baseline**: Standard market behavior with mild noise.
2. **Rate Shock**: 200–300 bps interest rate jump.
3. **Liquidity Trap**: Exit horizon extended to 180–450 days.
4. **Variance Error**: Recovery mispricing error band of 15–20%.
5. **Black Swan**: Combined systemic stress (rates + liquidity + tail-loss).

### 3) Statistical Output
For each scenario, the engine automatically computes:
- **Mean Recovery**
- **Standard Deviation (σ) of Recovery**
- **Invalidation Ratio**
- **Ruin Ratio** (recovery below institutional range 1.0)
- **Weighted Risk/Stress Score**

## Key Results
The model identifies **Ruin Thresholds** where mean recovery can drop below the institutional range (`1.0`), and isolates invalidation events where cost of capital exceeds projected recovery. This produces a direct **Sell/Hold** signal basis for fund managers.

## Sigma Team Q&A (Self-Check)
1. **Why use Standard Deviation?**
   - To measure volatility/dispersion of recovery rates.
2. **How did you handle the fetching issue?**
   - By hard-coding synthetic data structures so the model runs regardless of connectivity.
3. **What is the invalidation point?**
   - The numerical threshold where `cost_of_capital > projected_recovery`.

## Example Usage (R)
```r
source("black_box_risk_engine.R")

engine_result <- black_box_risk_engine(seed = 2026)
print_institutional_summary(engine_result)

# Optional plot when ggplot2 is installed
if (!is.null(engine_result$plot)) {
  print(engine_result$plot)
}
```
