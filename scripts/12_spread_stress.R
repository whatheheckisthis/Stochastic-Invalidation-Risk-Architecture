# ============================================================================
# Script Name : 12_spread_stress.R
# Purpose     : Aggregate spread stress signals across configured scenarios.
# ============================================================================

run_spread_stress <- function(core_results_df) {
  scenario_names <- CFG$scenarios$names

  scenario_rows <- lapply(scenario_names, function(sc) {
    rec <- mean(core_results_df$stressed_recovery[core_results_df$scenario == sc], na.rm = TRUE)

    liability <- run_liability_engine(scenario_name = sc)
    credit <- run_credit_deployment(
      annual_obligation = liability$annual_obligation,
      stressed_recovery = rec
    )

    signal <- if (credit$spread_signal == "SPREAD_NEGATIVE" || liability$solvency_headroom < 0) {
      "BREACH"
    } else if (credit$spread_signal == "SPREAD_COMPRESSED" || liability$solvency_headroom < (0.05 * as.numeric(CFG$liability$annuity_pool_size))) {
      "WATCH"
    } else {
      "SOLVENT"
    }

    data.frame(
      scenario = sc,
      stressed_recovery = rec,
      annual_obligation = liability$annual_obligation,
      gross_income = credit$gross_income,
      net_income_after_defaults = credit$net_income_after_defaults,
      spread_captured = credit$spread_captured,
      spread_ratio = credit$spread_captured / as.numeric(CFG$credit$deployed_capital),
      solvency_headroom = liability$solvency_headroom,
      liability_status = liability$status,
      spread_signal = credit$spread_signal,
      capital_stack_signal = signal,
      stringsAsFactors = FALSE
    )
  })

  scenario_df <- do.call(rbind, scenario_rows)
  worst_idx <- which.min(scenario_df$spread_captured)

  list(
    scenario_df = scenario_df,
    worst_case = scenario_df$scenario[worst_idx],
    signal_counts = as.data.frame(table(scenario_df$capital_stack_signal), stringsAsFactors = FALSE),
    headroom_summary = as.list(stats::quantile(scenario_df$solvency_headroom, probs = c(0, 0.25, 0.5, 0.75, 1), names = TRUE))
  )
}
