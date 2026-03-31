# ============================================================================
# Script Name : 31_recovery_put.R
# Purpose     : Recovery put engine with Merton/Haugh leverage-effect feedback.
# ============================================================================

run_recovery_put_engine <- function(core_results_df, vol_surface_df) {
  cat(sprintf("%s%s[31/36] recovery_put -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  cfg <- CFG$options$recovery_put
  tol <- as.numeric(CFG$options$convergence_tolerance)
  q <- as.numeric(CFG$options$dividend_yield)

  V_base <- as.numeric(cfg$firm_value)
  D <- as.numeric(cfg$debt_face_value)
  r <- as.numeric(cfg$risk_free_rate)
  sigma_base <- as.numeric(cfg$firm_volatility)
  T <- as.numeric(cfg$resolution_horizon)

  E_base <- as.numeric(CFG$options$kicker_call$equity_value_entry)

  merged <- merge(
    aggregate(stressed_recovery ~ scenario, core_results_df, mean),
    vol_surface_df[, c("scenario", "firm_sigma", "equity_sigma")],
    by = "scenario", all.x = TRUE, sort = FALSE
  )

  rows <- lapply(seq_len(nrow(merged)), function(i) {
    sc <- merged$scenario[i]
    rec <- as.numeric(merged$stressed_recovery[i])
    V_stressed <- max(1e-6, D * rec)
    E_stressed <- max(1e-6, E_base * rec)

    sigma_stressed <- as.numeric(merged$firm_sigma[i])
    sigma_equity_stressed <- as.numeric(merged$equity_sigma[i])
    sigma_leverage_adjusted <- max(1e-6, sigma_equity_stressed * (E_stressed / V_stressed))

    p_base <- bsm_price_greeks(S = V_base, K = D, r = r, sigma = sigma_base, T = T, q = q,
                               context = paste0("recovery_put_", gsub(" ", "_", sc), "_base"))$put_price
    p_stressed <- bsm_price_greeks(S = V_stressed, K = D, r = r, sigma = sigma_stressed, T = T, q = q,
                                   context = paste0("recovery_put_", gsub(" ", "_", sc), "_stressed"))$put_price
    p_lev <- bsm_price_greeks(S = V_stressed, K = D, r = r, sigma = sigma_leverage_adjusted, T = T, q = q,
                              context = paste0("recovery_put_", gsub(" ", "_", sc), "_leverage"))$put_price

    implied_base <- pmax(0, pmin(1, 1 - (p_base / D)))
    implied_stress <- pmax(0, pmin(1, 1 - (p_stressed / D)))
    implied_lev <- pmax(0, pmin(1, 1 - (p_lev / D)))

    conv_base <- abs(implied_base - rec) <= tol
    conv_stress <- abs(implied_stress - rec) <= tol
    conv_lev <- abs(implied_lev - rec) <= tol

    convergence_surface <- if (conv_base && conv_stress && conv_lev) {
      "HIGH_CONFIDENCE"
    } else if (conv_base && !(conv_stress && conv_lev)) {
      "VOL_SENSITIVE"
    } else {
      "MODEL_REVIEW_REQUIRED"
    }

    data.frame(
      scenario = sc,
      put_price_base = p_base,
      put_price_stressed = p_stressed,
      put_price_leverage_adjusted = p_lev,
      sigma_base = sigma_base,
      sigma_stressed = sigma_stressed,
      sigma_leverage_adjusted = sigma_leverage_adjusted,
      implied_recovery_base = implied_base,
      implied_recovery_stressed = implied_stress,
      implied_recovery_leverage_adjusted = implied_lev,
      sira_stressed_recovery = rec,
      convergence_surface = convergence_surface,
      stringsAsFactors = FALSE
    )
  })

  out_df <- do.call(rbind, rows)
  cat(sprintf("%s%s[31/36] recovery_put -- complete -- high_confidence=%d review_required=%d%s\n",
              NEON$bold,
              NEON$cyan,
              sum(out_df$convergence_surface == "HIGH_CONFIDENCE", na.rm = TRUE),
              sum(out_df$convergence_surface == "MODEL_REVIEW_REQUIRED", na.rm = TRUE),
              NEON$reset))
  out_df
}
