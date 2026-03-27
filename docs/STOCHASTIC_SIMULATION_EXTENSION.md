# Discrete-Time Stochastic Simulation Specification (Base R)

This extension defines the model in strict, auditable terms and mirrors the exact implementation constraints.

## 1. Initialization

- **Time Horizon (`T`)**: `1000` discrete intervals (days).
- **Starting Value (`S0`)**: `1.00` (Par).
- **Data Structure**: numeric vector of length `1001` to store `S0` and `S1..S1000`.
- **Reproducibility**: fixed random seed (`set.seed(123)`).

## 2. Stochastic Simulation (Arithmetic Random Walk)

The path follows:

\[
S_t = S_{t-1} + \epsilon_t
\]

with:

\[
\epsilon_t \sim N(\mu=0, \sigma=0.02)
\]

Implementation requirements:
- use an explicit `for` loop over each day,
- generate shocks with `rnorm(1, mean = 0, sd = 0.02)`.

## 3. Invalidation (Ruin Threshold)

- **Threshold**: `0.40`.
- **Rule**: if `S_t < 0.40`, terminate immediately.
- **Capture at breach**:
  - exact breach index `t`,
  - terminal value `S_t`.
- **No-breach case**: if all values stay `>= 0.40`, complete all 1000 steps and keep full vector through `S1000`.

## 4. Technical Constraints

- **Environment:** Base R (Version 3.6+).
- **Prohibited:** External libraries (e.g., `tidyverse`, `ggplot2`, `data.table`), vectorized optimizations that bypass step-by-step auditing, or "Side-Door" helper functions.
- **Output:** A clinical report consisting of:
  - `Terminal day`
  - `Final calculated value`

### Clinical Report Format (Required)

```text
Terminal day: <integer day index>
Final calculated value: <numeric value>
```


---

## Raw Script Blocks (Requested)

### 02_Simulation (Base R)

```r
for (time_index in 2:(time_horizon + 1L)) {
  epsilon_t <- rnorm(1, mean = 0, sd = 0.02)
  price_path[time_index] <- price_path[time_index - 1L] + epsilon_t

  # 03_Invalidation handled inline below for strict stepwise auditing
  if (price_path[time_index] < ruin_threshold) {
    ruin_day <- time_index - 1L
    terminal_value <- price_path[time_index]
    break
  }
}
```

### 03_Invalidation (Standalone Logic View)

```r
if (price_path[time_index] < ruin_threshold) {
  ruin_day <- time_index - 1L
  terminal_value <- price_path[time_index]
  break
}
```

---

## ASCII Walkthrough

```text
[Start]
   |
   v
Set seed, T=1000, S0=1.00, threshold=0.40
Create price_path of length 1001 and set price_path[1]=S0
   |
   v
for t = 1..1000:
   draw epsilon_t ~ N(0, 0.02)
   compute S_t = S_{t-1} + epsilon_t
   |
   +--> if S_t < 0.40 ?
           | Yes -> record breach day t and S_t, stop immediately
           | No  -> continue

After loop:
- if never breached, terminal day = 1000 and terminal value = S_1000
- output clinical report:
    Terminal day
    Final calculated value
```
