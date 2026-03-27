# ============================================================================
# Script Name : stochastic_invalidation_base_r.R
# Purpose     : Simulate distressed bond price dynamics and enforce a
#               stochastic invalidation rule (ruin event) using Base R only.
# Author      : Codex Assistant
# Created     : 2026-03-27
# R Version   : 3.6+
# Notes       : No external packages are used. Logic is intentionally explicit
#               for line-by-line professional audit.
# ============================================================================

# -----------------------------
# 1) INITIALIZE
# -----------------------------
set.seed(123)

number_of_days <- 1000L
initial_price <- 1.0
ruin_threshold <- 0.40

bond_path <- numeric(number_of_days)
bond_path[1] <- initial_price

ruin_day <- NA_integer_

# -----------------------------
# 2) SIMULATE + 3) INVALIDATE
# -----------------------------
for (day_index in 2:number_of_days) {
  step_change <- rnorm(1, mean = 0, sd = 0.02)
  bond_path[day_index] <- bond_path[day_index - 1] + step_change

  if (bond_path[day_index] < ruin_threshold) {
    ruin_day <- day_index

    if (day_index < number_of_days) {
      bond_path[(day_index + 1):number_of_days] <- 0
    }

    break
  }
}

# -----------------------------
# 4) PLOT
# -----------------------------
plot(
  x = seq_len(number_of_days),
  y = bond_path,
  type = "l",
  lwd = 2,
  col = "navy",
  xlab = "Day",
  ylab = "Bond Price",
  main = "Stochastic Invalidation Path (Base R)",
  ylim = c(0, max(1.1, bond_path, na.rm = TRUE))
)

abline(h = ruin_threshold, col = "red", lty = 2)

if (!is.na(ruin_day)) {
  abline(v = ruin_day, col = "darkred", lty = 3)
}
