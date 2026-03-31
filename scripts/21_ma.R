# ============================================================================
# Script Name : 21_ma.R
# Purpose     : M&A screening engine for distressed credit book acquisition.
# ============================================================================

run_ma_engine <- function(dcf_results_df) {
  cat(sprintf("%s%s[21/25] ma_engine -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  if (!is.data.frame(dcf_results_df) || nrow(dcf_results_df) == 0) {
    stop("[ERROR] M&A engine requires DCF output.")
  }

  cfg <- CFG$ma
  ask_price <- as.numeric(cfg$ask_price)
  book_face_value <- as.numeric(cfg$book_face_value)
  synergy_yield_uplift <- as.numeric(cfg$synergy_yield_uplift)
  integration_cost <- as.numeric(cfg$integration_cost)
  minimum_discount_to_par <- as.numeric(cfg$minimum_discount_to_par)

  scenario_names <- unique(dcf_results_df$scenario)
  discount_to_par <- (book_face_value - ask_price) / book_face_value

  scenario_rows <- lapply(scenario_names, function(sc) {
    implied_portfolio_value <- sum(dcf_results_df$dcf_stressed_value[dcf_results_df$scenario == sc], na.rm = TRUE)
    adjusted_value <- implied_portfolio_value + synergy_yield_uplift - integration_cost

    acquire_cond <- adjusted_value > ask_price && discount_to_par >= minimum_discount_to_par

    within_ask_band <- abs(adjusted_value - ask_price) / max(abs(ask_price), 1) <= 0.05
    within_discount_band <- abs(discount_to_par - minimum_discount_to_par) / max(abs(minimum_discount_to_par), 1e-9) <= 0.05

    signal <- if (acquire_cond) {
      "ACQUIRE"
    } else if (within_ask_band || within_discount_band) {
      "REVIEW"
    } else {
      "PASS"
    }

    data.frame(
      scenario = sc,
      implied_portfolio_value = implied_portfolio_value,
      discount_to_par = discount_to_par,
      adjusted_value = adjusted_value,
      ma_signal = signal,
      stringsAsFactors = FALSE
    )
  })

  out_df <- do.call(rbind, scenario_rows)
  out_df <- out_df[order(out_df$scenario), ]

  cat(sprintf("%s%s[21/25] ma_engine -- complete -- acquire=%d review=%d pass=%d%s\n",
              NEON$bold,
              NEON$cyan,
              sum(out_df$ma_signal == "ACQUIRE", na.rm = TRUE),
              sum(out_df$ma_signal == "REVIEW", na.rm = TRUE),
              sum(out_df$ma_signal == "PASS", na.rm = TRUE),
              NEON$reset))

  out_df
}
