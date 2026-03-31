# ============================================================================
# Script Name : 36_delta_hedge.R
# Purpose     : Discrete delta-hedging replication error simulation by scenario.
# ============================================================================

run_delta_hedge_engine <- function(greeks_df) {
  cat(sprintf("%s%s[36/36] delta_hedge -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  steps <- as.integer(CFG$options$hedge_steps)
  tol <- as.numeric(CFG$options$hedge_tolerance)
  q <- as.numeric(CFG$options$dividend_yield)

  rec_cfg <- CFG$options$recovery_put
  kick_cfg <- CFG$options$kicker_call
  floor_cfg <- CFG$options$annuity_floor

  get_terms <- function(option_name) {
    if (option_name == "recovery_put") return(list(S = as.numeric(rec_cfg$firm_value), K = as.numeric(rec_cfg$debt_face_value), r = as.numeric(rec_cfg$risk_free_rate), T = as.numeric(rec_cfg$resolution_horizon), sigma = as.numeric(rec_cfg$firm_volatility)))
    if (option_name == "kicker_call") return(list(S = as.numeric(kick_cfg$equity_value_entry), K = as.numeric(kick_cfg$strike_price), r = as.numeric(kick_cfg$risk_free_rate), T = as.numeric(kick_cfg$hold_period_years), sigma = as.numeric(kick_cfg$equity_volatility)))
    list(S = as.numeric(floor_cfg$portfolio_return_current), K = as.numeric(floor_cfg$floor_rate), r = as.numeric(floor_cfg$risk_free_rate), T = as.numeric(floor_cfg$duration_years), sigma = as.numeric(floor_cfg$return_volatility))
  }

  rows <- lapply(seq_len(nrow(greeks_df)), function(i) {
    g <- greeks_df[i, ]
    terms <- get_terms(as.character(g$option_name))

    S_base <- terms$S
    S_stress <- S_base + as.numeric(g$delta_pnl / ifelse(abs(g$delta) < 1e-6, 1, g$delta))
    sigma_imp <- terms$sigma
    sigma_scn <- sigma_imp + as.numeric(g$vega_pnl / ifelse(abs(g$vega) < 1e-6, 1, g$vega))

    dt <- terms$T / steps
    pnl <- 0
    for (j in seq_len(steps)) {
      w <- j / steps
      S_t <- max(1e-6, S_base + w * (S_stress - S_base))
      T_t <- max(1e-6, terms$T - (j - 1) * dt)
      greeks_t <- bsm_price_greeks(S = S_t, K = terms$K, r = terms$r, sigma = max(1e-6, sigma_scn), T = T_t, q = q,
                                   context = paste0("hedge_", g$option_name, "_", g$scenario))
      dollar_gamma <- (S_t^2 / 2) * greeks_t$gamma
      vol_spread <- sigma_imp^2 - sigma_scn^2
      pnl <- pnl + dollar_gamma * vol_spread * dt
    }

    signal <- if (pnl > tol) {
      "HEDGE_GAIN"
    } else if (pnl < -tol) {
      "HEDGE_LOSS"
    } else {
      "HEDGE_NEUTRAL"
    }

    data.frame(
      option_name = as.character(g$option_name),
      scenario = as.character(g$scenario),
      hedge_replication_error = pnl,
      hedge_signal = signal,
      stringsAsFactors = FALSE
    )
  })

  out_df <- do.call(rbind, rows)
  cat(sprintf("%s%s[36/36] delta_hedge -- complete -- losses=%d%s\n",
              NEON$bold, NEON$cyan, sum(out_df$hedge_signal == "HEDGE_LOSS", na.rm = TRUE), NEON$reset))
  out_df
}
