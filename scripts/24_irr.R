# ============================================================================
# Script Name : 24_irr.R
# Purpose     : IRR attribution engine with stressed recovery overlay.
# ============================================================================

run_irr_engine <- function(core_results_df, kicker_results_df = NULL) {
  cat(sprintf("%s%s[24/25] irr_engine -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  if (!is.data.frame(core_results_df) || nrow(core_results_df) == 0) {
    stop("[ERROR] IRR engine requires core_results_df.")
  }

  cfg <- CFG$irr
  initial_investment <- as.numeric(cfg$initial_investment)
  coupon_cashflows <- as.numeric(unlist(cfg$coupon_cashflows))
  fee_income <- as.numeric(cfg$fee_income)
  equity_kicker_realised <- as.numeric(cfg$equity_kicker_realised)
  terminal_recovery <- as.numeric(cfg$terminal_recovery)
  target_irr <- as.numeric(cfg$target_irr)
  floor_irr <- as.numeric(cfg$floor_irr)

  if (length(coupon_cashflows) == 0) {
    stop("[ERROR] irr.coupon_cashflows must contain at least one value.")
  }

  build_cashflows <- function(terminal_value) {
    period_cf <- coupon_cashflows
    period_cf[1] <- period_cf[1] + fee_income + equity_kicker_realised
    period_cf[length(period_cf)] <- period_cf[length(period_cf)] + terminal_value
    c(-initial_investment, period_cf)
  }

  solve_irr <- function(cashflows) {
    npv_fn <- function(r) {
      sum(cashflows / ((1 + r) ^ (0:(length(cashflows) - 1))))
    }

    low <- -0.999
    high <- 10
    f_low <- npv_fn(low)
    f_high <- npv_fn(high)
    if (is.na(f_low) || is.na(f_high) || f_low * f_high > 0) {
      return(NA_real_)
    }

    uniroot(npv_fn, lower = low, upper = high)$root
  }

  base_cashflows <- build_cashflows(terminal_recovery)
  irr_base <- solve_irr(base_cashflows)

  coupon_contribution <- sum(coupon_cashflows) / initial_investment
  fee_contribution <- fee_income / initial_investment
  kicker_contribution <- equity_kicker_realised / initial_investment
  recovery_contribution <- terminal_recovery / initial_investment

  scenario_names <- unique(core_results_df$scenario)
  scenario_rows <- lapply(scenario_names, function(sc) {
    stressed_recovery_ratio <- mean(core_results_df$stressed_recovery[core_results_df$scenario == sc], na.rm = TRUE)
    stressed_terminal <- initial_investment * stressed_recovery_ratio

    scenario_kicker <- equity_kicker_realised
    if (!is.null(kicker_results_df) && is.data.frame(kicker_results_df)) {
      sc_row <- kicker_results_df[kicker_results_df$scenario == sc, , drop = FALSE]
      if (nrow(sc_row) > 0 && is.finite(as.numeric(sc_row$call_price_stressed[1]))) {
        scenario_kicker <- as.numeric(sc_row$call_price_stressed[1])
      }
    }

    stressed_cashflows <- coupon_cashflows
    stressed_cashflows[1] <- stressed_cashflows[1] + fee_income + scenario_kicker
    stressed_cashflows[length(stressed_cashflows)] <- stressed_cashflows[length(stressed_cashflows)] + stressed_terminal
    irr_stressed <- solve_irr(c(-initial_investment, stressed_cashflows))

    irr_signal <- if (!is.na(irr_stressed) && irr_stressed >= target_irr) {
      "STRONG"
    } else if (!is.na(irr_stressed) && irr_stressed >= floor_irr) {
      "ACCEPTABLE"
    } else {
      "IMPAIRED"
    }

    data.frame(
      scenario = sc,
      irr_base = irr_base,
      irr_stressed = irr_stressed,
      coupon_contribution = coupon_contribution,
      fee_contribution = fee_contribution,
      kicker_contribution = scenario_kicker / initial_investment,
      recovery_contribution = recovery_contribution,
      recovery_contribution_stressed = stressed_terminal / initial_investment,
      irr_signal = irr_signal,
      stringsAsFactors = FALSE
    )
  })

  out_df <- do.call(rbind, scenario_rows)
  out_df <- out_df[order(out_df$scenario), ]

  cat(sprintf("%s%s[24/25] irr_engine -- complete -- strong=%d acceptable=%d impaired=%d%s\n",
              NEON$bold,
              NEON$cyan,
              sum(out_df$irr_signal == "STRONG", na.rm = TRUE),
              sum(out_df$irr_signal == "ACCEPTABLE", na.rm = TRUE),
              sum(out_df$irr_signal == "IMPAIRED", na.rm = TRUE),
              NEON$reset))

  out_df
}
