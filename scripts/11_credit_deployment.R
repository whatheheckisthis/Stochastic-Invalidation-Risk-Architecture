# ============================================================================
# Script Name : 11_credit_deployment.R
# Purpose     : Credit deployment and spread capture calculations.
# ============================================================================

run_credit_deployment <- function(annual_obligation, stressed_recovery = NULL) {
  cfg <- CFG$credit

  deployed_capital <- as.numeric(cfg$deployed_capital)
  gross_yield <- as.numeric(cfg$gross_yield)
  fee_income <- as.numeric(cfg$fee_income)
  equity_kicker_value <- as.numeric(cfg$equity_kicker_value)
  illiquidity_premium <- as.numeric(cfg$illiquidity_premium)
  default_rate_assumption <- as.numeric(cfg$default_rate_assumption)

  gross_income <- (deployed_capital * (gross_yield + illiquidity_premium)) + fee_income + equity_kicker_value

  lgd_proxy <- if (is.null(stressed_recovery)) {
    1
  } else {
    pmin(1, pmax(0, 1 - as.numeric(stressed_recovery)))
  }

  expected_loss <- deployed_capital * default_rate_assumption * lgd_proxy
  net_income_after_defaults <- gross_income - expected_loss
  spread_captured <- net_income_after_defaults - as.numeric(annual_obligation)

  watch_threshold <- as.numeric(CFG$signals$watch_spread_threshold)
  spread_ratio <- spread_captured / deployed_capital
  spread_signal <- ifelse(
    spread_captured < 0,
    "SPREAD_NEGATIVE",
    ifelse(spread_ratio < watch_threshold, "SPREAD_COMPRESSED", "SPREAD_POSITIVE")
  )

  list(
    gross_income = gross_income,
    net_income_after_defaults = net_income_after_defaults,
    spread_captured = spread_captured,
    expected_loss = expected_loss,
    lgd_proxy = lgd_proxy,
    spread_signal = spread_signal
  )
}
