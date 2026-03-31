# ============================================================================
# Script Name : 23_lbo.R
# Purpose     : LBO viability engine under stress.
# ============================================================================

run_lbo_engine <- function(dcf_results_df) {
  cat(sprintf("%s%s[23/25] lbo_engine -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  if (!is.data.frame(dcf_results_df) || nrow(dcf_results_df) == 0) {
    stop("[ERROR] LBO engine requires DCF output.")
  }

  cfg <- CFG$lbo
  equity_contribution <- as.numeric(cfg$equity_contribution)
  debt_amount <- as.numeric(cfg$debt_amount)
  debt_cost <- as.numeric(cfg$debt_cost)
  hold_period_years <- as.numeric(cfg$hold_period_years)
  exit_multiple <- as.numeric(cfg$exit_multiple)
  ebitda_proxy <- as.numeric(cfg$ebitda_proxy)
  min_dscr <- as.numeric(cfg$min_dscr)
  min_irr_threshold <- as.numeric(cfg$min_irr_threshold)

  dscr <- ebitda_proxy / (debt_amount * debt_cost)
  entry_leverage <- debt_amount / (equity_contribution + debt_amount)

  exit_ev_base <- ebitda_proxy * exit_multiple
  equity_return_base <- exit_ev_base - debt_amount
  irr_base <- (equity_return_base / equity_contribution)^(1 / hold_period_years) - 1

  scenario_names <- unique(dcf_results_df$scenario)
  scenario_rows <- lapply(scenario_names, function(sc) {
    exit_ev_stressed <- sum(dcf_results_df$dcf_stressed_value[dcf_results_df$scenario == sc], na.rm = TRUE)
    equity_return_stressed <- exit_ev_stressed - debt_amount

    irr_stressed <- if (equity_return_stressed <= 0 || equity_contribution <= 0) {
      -1
    } else {
      (equity_return_stressed / equity_contribution)^(1 / hold_period_years) - 1
    }

    signal <- if (dscr < min_dscr) {
      "IMPAIRED"
    } else if (irr_stressed >= min_irr_threshold) {
      "VIABLE"
    } else {
      "MARGINAL"
    }

    data.frame(
      scenario = sc,
      dscr = dscr,
      entry_leverage = entry_leverage,
      irr_base = irr_base,
      irr_stressed = irr_stressed,
      lbo_signal = signal,
      stringsAsFactors = FALSE
    )
  })

  out_df <- do.call(rbind, scenario_rows)
  out_df <- out_df[order(out_df$scenario), ]

  cat(sprintf("%s%s[23/25] lbo_engine -- complete -- viable=%d marginal=%d impaired=%d%s\n",
              NEON$bold,
              NEON$cyan,
              sum(out_df$lbo_signal == "VIABLE", na.rm = TRUE),
              sum(out_df$lbo_signal == "MARGINAL", na.rm = TRUE),
              sum(out_df$lbo_signal == "IMPAIRED", na.rm = TRUE),
              NEON$reset))

  out_df
}
