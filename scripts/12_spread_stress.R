# ============================================================================
# Script Name : 12_spread_stress.R
# Purpose     : Aggregate spread stress signals across configured scenarios.
# ============================================================================

run_spread_stress <- function(core_results_df, annuity_floor_df = NULL) {
  scenario_names <- CFG$scenarios$names

  scenario_rows <- lapply(scenario_names, function(sc) {
    rec <- mean(core_results_df$stressed_recovery[core_results_df$scenario == sc], na.rm = TRUE)

    liability <- run_liability_engine(scenario_name = sc)
    credit <- run_credit_deployment(
      annual_obligation = liability$annual_obligation,
      stressed_recovery = rec
    )

    floor_adjustment <- 0
    floor_signal <- "COVERED"
    adjusted_headroom <- liability$solvency_headroom
    if (!is.null(annuity_floor_df) && is.data.frame(annuity_floor_df)) {
      floor_row <- annuity_floor_df[annuity_floor_df$scenario == sc, , drop = FALSE]
      if (nrow(floor_row) > 0) {
        floor_adjustment <- as.numeric(floor_row$floor_liability_stressed[1])
        adjusted_headroom <- as.numeric(floor_row$solvency_headroom_adjusted[1])
        floor_signal <- as.character(floor_row$floor_signal[1])
      }
    }

    signal <- if (credit$spread_signal == "SPREAD_NEGATIVE" || adjusted_headroom < 0 || floor_signal == "BREACH") {
      "BREACH"
    } else if (credit$spread_signal == "SPREAD_COMPRESSED" || adjusted_headroom < (0.05 * as.numeric(CFG$liability$annuity_pool_size)) || floor_signal == "WATCH") {
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
      solvency_headroom = adjusted_headroom,
      solvency_headroom_unadjusted = liability$solvency_headroom,
      floor_liability_stressed = floor_adjustment,
      liability_status = liability$status,
      spread_signal = credit$spread_signal,
      floor_signal = floor_signal,
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
