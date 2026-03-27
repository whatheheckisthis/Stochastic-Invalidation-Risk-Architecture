# ============================================================================
# Script Name : 02_analysis.R
# Purpose     : Compute SELL/HOLD signals from distressed bond prices.
# Author      : Codex Assistant
# Created     : 2026-03-27
# R Version   : 3.6+
# ============================================================================

run_analysis <- function(price_data) {
  if (length(price_data) < 2) {
    stop("At least two price observations are required for analysis.")
  }

  returns <- diff(price_data)
  threshold <- stats::quantile(returns, probs = 0.10, na.rm = TRUE)

  signal_vector <- ifelse(returns <= threshold, "SELL", "HOLD")

  signal_counts <- table(factor(signal_vector, levels = c("SELL", "HOLD")))

  summary_df <- data.frame(
    metric = c("observations", "sell_count", "hold_count", "sell_ratio"),
    value = c(
      length(price_data),
      as.integer(signal_counts["SELL"]),
      as.integer(signal_counts["HOLD"]),
      round(as.integer(signal_counts["SELL"]) / length(signal_vector), 4)
    ),
    stringsAsFactors = FALSE
  )

  list(
    prices = price_data,
    returns = returns,
    threshold = as.numeric(threshold),
    signals = signal_vector,
    signal_counts = signal_counts,
    summary = summary_df
  )
}
