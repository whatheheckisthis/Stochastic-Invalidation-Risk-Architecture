# ============================================================================
# Script Name : stochastic_invalidation_base_r.R
# Purpose     : Discrete-time stochastic simulation of a distressed debt price
#               path with explicit invalidation (ruin) monitoring.
# Author      : Codex Assistant
# Created     : 2026-03-27
# R Version   : 3.6+
# Notes       : Base R only. Step-by-step loop for auditability.
# ============================================================================

# -----------------------------
# 1) INITIALIZATION
# -----------------------------
set.seed(123)

time_horizon <- 1000L
starting_value <- 1.00
ruin_threshold <- 0.40

# Length is 1001 to store S0 through S1000.
price_path <- numeric(time_horizon + 1L)
price_path[1] <- starting_value

ruin_day <- NA_integer_
terminal_value <- starting_value

# -----------------------------
# 2) STOCHASTIC SIMULATION
# 3) INVALIDATION CHECK
# -----------------------------
for (time_index in 2:(time_horizon + 1L)) {
  epsilon_t <- rnorm(1, mean = 0, sd = 0.02)
  price_path[time_index] <- price_path[time_index - 1L] + epsilon_t

  if (price_path[time_index] < ruin_threshold) {
    ruin_day <- time_index - 1L
    terminal_value <- price_path[time_index]
    break
  }
}

if (is.na(ruin_day)) {
  ruin_day <- time_horizon
  terminal_value <- price_path[time_horizon + 1L]
}

# -----------------------------
# 4) CLINICAL REPORT OUTPUT
# -----------------------------
cat(sprintf("Terminal day: %d\n", ruin_day))
cat(sprintf("Final calculated value: %.6f\n", terminal_value))
