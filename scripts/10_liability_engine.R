# ============================================================================
# Script Name : 10_liability_engine.R
# Purpose     : Liability stack calculations for annuity obligations.
# ============================================================================

run_liability_engine <- function(scenario_name = "Baseline") {
  cfg <- CFG$liability

  annuity_pool_size <- as.numeric(cfg$annuity_pool_size)
  payout_rate <- as.numeric(cfg$payout_rate)
  duration_years <- as.numeric(cfg$duration_years)
  insurer_solvency_buffer <- as.numeric(cfg$insurer_solvency_buffer)

  inflation_multiplier <- 1
  if (identical(scenario_name, "Hyper-Inflationary")) {
    sens <- cfg$inflation_sensitivity
    if (is.logical(sens)) {
      inflation_multiplier <- if (isTRUE(sens)) 1.25 else 1.0
    } else {
      sens_chr <- tolower(as.character(sens))
      if (sens_chr %in% c("indexed", "true", "yes")) {
        inflation_multiplier <- 1.25
      } else if (sens_chr %in% c("fixed", "false", "no")) {
        inflation_multiplier <- 1.0
      } else {
        inflation_multiplier <- max(1, as.numeric(sens))
      }
    }
  }

  annual_obligation <- annuity_pool_size * payout_rate * inflation_multiplier
  discount_rate <- max(0.0001, payout_rate)
  present_value_obligations <- annual_obligation * ((1 - (1 + discount_rate)^(-duration_years)) / discount_rate)

  available_capital <- annuity_pool_size
  regulatory_minimum <- annuity_pool_size * insurer_solvency_buffer
  solvency_headroom <- available_capital - present_value_obligations - regulatory_minimum

  status <- if (solvency_headroom < 0) "BREACH" else "SOLVENT"

  list(
    annual_obligation = annual_obligation,
    present_value_obligations = present_value_obligations,
    solvency_headroom = solvency_headroom,
    inflation_multiplier = inflation_multiplier,
    status = status
  )
}
