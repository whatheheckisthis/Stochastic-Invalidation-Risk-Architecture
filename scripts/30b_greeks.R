# ============================================================================
# Script Name : 30b_greeks.R
# Purpose     : Greeks engine + delta-gamma-vega scenario P&L attribution.
# ============================================================================

run_greeks_engine <- function(core_results_df, dcf_results_df, spread_stress_output, vol_surface_df) {
  cat(sprintf("%s%s[30b/36] greeks -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  q <- as.numeric(CFG$options$dividend_yield)
  tol <- as.numeric(CFG$options$convergence_tolerance)

  rec_cfg <- CFG$options$recovery_put
  kick_cfg <- CFG$options$kicker_call
  floor_cfg <- CFG$options$annuity_floor

  scenario_df <- spread_stress_output$scenario_df
  erosion_by_scenario <- aggregate(value_erosion_pct ~ scenario, data = dcf_results_df, FUN = mean)
  merged <- merge(vol_surface_df, erosion_by_scenario, by = "scenario", all.x = TRUE, sort = FALSE)
  merged <- merge(merged, scenario_df[, c("scenario", "net_income_after_defaults")], by = "scenario", all.x = TRUE, sort = FALSE)
  merged$value_erosion_pct[is.na(merged$value_erosion_pct)] <- 0

  deployed_capital <- as.numeric(CFG$credit$deployed_capital)

  compute_row <- function(option_name, sc, S_base, S_stressed, K, r, T, sigma_base, sigma_scenario, option_side) {
    base <- bsm_price_greeks(S = S_base, K = K, r = r, sigma = sigma_base, T = T, q = q,
                             context = paste0(option_name, "_", gsub(" ", "_", sc), "_base"))
    stress <- bsm_price_greeks(S = S_stressed, K = K, r = r, sigma = sigma_scenario, T = T, q = q,
                               context = paste0(option_name, "_", gsub(" ", "_", sc), "_stress"))

    if (option_side == "put") {
      delta <- stress$delta_put
      price_base <- base$put_price
      price_stressed <- stress$put_price
      rho <- stress$rho_put
    } else {
      delta <- stress$delta_call
      price_base <- base$call_price
      price_stressed <- stress$call_price
      rho <- stress$rho_call
    }

    dS <- S_stressed - S_base
    dSigma <- sigma_scenario - sigma_base
    delta_pnl <- delta * dS
    gamma_pnl <- 0.5 * stress$gamma * dS^2
    vega_pnl <- stress$vega * dSigma

    data.frame(
      option_name = option_name,
      scenario = sc,
      side = option_side,
      price_base = price_base,
      price_stressed = price_stressed,
      delta = delta,
      gamma = stress$gamma,
      vega = stress$vega,
      theta_call = stress$theta_call,
      rho = rho,
      positive_theta_flag = isTRUE(stress$positive_theta_flag),
      delta_pnl = delta_pnl,
      gamma_pnl = gamma_pnl,
      vega_pnl = vega_pnl,
      total_pnl = delta_pnl + gamma_pnl + vega_pnl,
      convergence_tolerance = tol,
      stringsAsFactors = FALSE
    )
  }

  rows <- lapply(seq_len(nrow(merged)), function(i) {
    sc <- merged$scenario[i]

    S_rec_base <- as.numeric(rec_cfg$firm_value)
    S_rec_stressed <- max(1e-6, S_rec_base * as.numeric(mean(core_results_df$stressed_recovery[core_results_df$scenario == sc], na.rm = TRUE)))
    rec <- compute_row(
      option_name = "recovery_put", sc = sc,
      S_base = S_rec_base, S_stressed = S_rec_stressed,
      K = as.numeric(rec_cfg$debt_face_value), r = as.numeric(rec_cfg$risk_free_rate),
      T = as.numeric(rec_cfg$resolution_horizon), sigma_base = as.numeric(rec_cfg$firm_volatility),
      sigma_scenario = as.numeric(merged$firm_sigma[i]), option_side = "put"
    )

    S_kick_base <- as.numeric(kick_cfg$equity_value_entry)
    S_kick_stressed <- max(1e-6, S_kick_base * (1 - as.numeric(merged$value_erosion_pct[i])))
    kick <- compute_row(
      option_name = "kicker_call", sc = sc,
      S_base = S_kick_base, S_stressed = S_kick_stressed,
      K = as.numeric(kick_cfg$strike_price), r = as.numeric(kick_cfg$risk_free_rate),
      T = as.numeric(kick_cfg$hold_period_years), sigma_base = as.numeric(kick_cfg$equity_volatility),
      sigma_scenario = as.numeric(merged$equity_sigma[i]), option_side = "call"
    )

    S_floor_base <- as.numeric(floor_cfg$portfolio_return_current)
    S_floor_stressed <- max(1e-6, as.numeric(merged$net_income_after_defaults[i]) / deployed_capital)
    floor <- compute_row(
      option_name = "annuity_floor", sc = sc,
      S_base = S_floor_base, S_stressed = S_floor_stressed,
      K = as.numeric(floor_cfg$floor_rate), r = as.numeric(floor_cfg$risk_free_rate),
      T = as.numeric(floor_cfg$duration_years), sigma_base = as.numeric(floor_cfg$return_volatility),
      sigma_scenario = as.numeric(merged$portfolio_sigma[i]), option_side = "put"
    )

    rbind(rec, kick, floor)
  })

  out_df <- do.call(rbind, rows)
  cat(sprintf("%s%s[30b/36] greeks -- complete -- rows=%d positive_theta=%d%s\n",
              NEON$bold, NEON$cyan, nrow(out_df), sum(out_df$positive_theta_flag, na.rm = TRUE), NEON$reset))
  out_df
}
