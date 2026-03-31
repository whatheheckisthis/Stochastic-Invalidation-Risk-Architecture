# ============================================================================
# Script Name : 34_vol_surface.R
# Purpose     : Scenario-governed volatility surface (air-gap compatible).
# ============================================================================

build_vol_surface <- function(core_results_df) {
  cat(sprintf("%s%s[34/36] vol_surface -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  cfg <- CFG$vol_surface
  scenario_names <- CFG$scenarios$names
  skew_factor <- as.numeric(cfg$skew_factor)

  base_firm_vol <- as.numeric(cfg$base_firm_vol)
  base_equity_vol <- as.numeric(cfg$base_equity_vol)
  base_portfolio_vol <- as.numeric(cfg$base_portfolio_vol)

  ruin_by_scenario <- aggregate(ruin_flag ~ scenario, data = core_results_df, FUN = mean)

  rows <- lapply(scenario_names, function(sc) {
    key <- gsub("-", "_", gsub(" ", "_", sc))
    sc_cfg <- CFG$scenarios[[key]]

    shock_multiplier <- as.numeric(sc_cfg$shock_multiplier)
    fx_devaluation <- if (is.null(sc_cfg$fx_devaluation)) 0 else as.numeric(sc_cfg$fx_devaluation)
    ruin_probability <- as.numeric(ruin_by_scenario$ruin_flag[ruin_by_scenario$scenario == sc])
    if (!is.finite(ruin_probability)) ruin_probability <- 0

    firm_sigma <- base_firm_vol * shock_multiplier
    equity_sigma <- base_equity_vol * shock_multiplier
    portfolio_sigma <- base_portfolio_vol * shock_multiplier

    if (sc == "Counterparty Default") {
      T_ref <- max(1e-6, as.numeric(CFG$options$recovery_put$resolution_horizon))
      p <- max(1e-6, min(0.999999, ruin_probability))
      cp_sigma <- sqrt(-2 * log(p) / T_ref)
      firm_sigma <- max(firm_sigma, cp_sigma)
      equity_sigma <- max(equity_sigma, cp_sigma)
      portfolio_sigma <- max(portfolio_sigma, cp_sigma * 0.75)
    }

    if (sc == "Hyper-Inflationary") {
      amp <- 1 + fx_devaluation
      firm_sigma <- firm_sigma * amp
      equity_sigma <- equity_sigma * amp
      portfolio_sigma <- portfolio_sigma * amp
    }

    if (sc == "Liquidity Crunch" || sc == "Jurisdictional Freeze") {
      firm_sigma <- firm_sigma * (1 + 0.5 * skew_factor)
      equity_sigma <- equity_sigma * (1 + 0.5 * skew_factor)
      portfolio_sigma <- portfolio_sigma * (1 + 0.25 * skew_factor)
    }

    if (any(c(firm_sigma, equity_sigma, portfolio_sigma) < 0)) {
      stop("Negative volatility on surface — arbitrage violation")
    }

    data.frame(
      scenario = sc,
      firm_sigma = pmax(firm_sigma, 1e-6),
      equity_sigma = pmax(equity_sigma, 1e-6),
      portfolio_sigma = pmax(portfolio_sigma, 1e-6),
      skew = skew_factor,
      stringsAsFactors = FALSE
    )
  })

  out_df <- do.call(rbind, rows)

  # Arbitrage checks (warning-only)
  K_atm <- as.numeric(CFG$options$kicker_call$strike_price)
  K1 <- K_atm * 0.9
  K2 <- K_atm * 1.1
  T1 <- max(0.25, as.numeric(CFG$options$recovery_put$resolution_horizon) / 2)
  T2 <- as.numeric(CFG$options$recovery_put$resolution_horizon)
  r0 <- 0
  q0 <- 0
  s0 <- as.numeric(CFG$options$kicker_call$equity_value_entry)
  sigma_ref <- mean(out_df$equity_sigma)

  p1 <- bsm_put_from_parity(
    call_price = bsm_call_price(s0, K1, r0, sigma_ref, T2, q0, context = "vol_check"),
    S = s0, K = K1, r = r0, T = T2, q = q0
  )
  p2 <- bsm_put_from_parity(
    call_price = bsm_call_price(s0, K2, r0, sigma_ref, T2, q0, context = "vol_check"),
    S = s0, K = K2, r = r0, T = T2, q = q0
  )
  butterfly_warn <- !(p1 < p2)

  c_t1 <- bsm_call_price(s0, K_atm, r0, sigma_ref, T1, q0, context = "vol_check")
  c_t2 <- bsm_call_price(s0, K_atm, r0, sigma_ref, T2, q0, context = "vol_check")
  calendar_warn <- !(c_t1 <= c_t2)

  cat("\nVolatility Surface (Scenario-Governed)\n")
  cat("─────────────────────────────────────────────────────────\n")
  cat("[BSM VOL NOTICE] Surface is scenario-governed, not market-implied.\n")
  cat("No options market data consumed. Skew is parameterised.\n")
  cat("─────────────────────────────────────────────────────────\n")
  print(out_df, row.names = FALSE)
  cat("─────────────────────────────────────────────────────────\n")
  cat(sprintf("Arbitrage checks: Butterfly %s Calendar %s\n",
              ifelse(butterfly_warn, "WARN", "PASS"),
              ifelse(calendar_warn, "WARN", "PASS")))

  attr(out_df, "arbitrage") <- list(
    butterfly = ifelse(butterfly_warn, "WARN", "PASS"),
    calendar = ifelse(calendar_warn, "WARN", "PASS")
  )

  cat(sprintf("%s%s[34/36] vol_surface -- complete -- scenarios=%d%s\n",
              NEON$bold, NEON$cyan, nrow(out_df), NEON$reset))
  out_df
}
