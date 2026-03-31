# ============================================================================
# Script Name : 31_recovery_put.R
# Purpose     : Implicit recovery put analytics for distressed bond recovery.
# ============================================================================

run_recovery_put_engine <- function(core_results_df, vol_surface_df) {
  cat(sprintf("%s%s[31/34] recovery_put -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  cfg <- CFG$options$recovery_put
  tol <- as.numeric(CFG$options$convergence_tolerance)

  S <- as.numeric(cfg$firm_value)
  K <- as.numeric(cfg$debt_face_value)
  r <- as.numeric(cfg$risk_free_rate)
  sigma_base <- as.numeric(cfg$firm_volatility)
  T <- as.numeric(cfg$resolution_horizon)

  base_greeks <- bsm_price_greeks(S = S, K = K, r = r, sigma = sigma_base, T = T, context = "recovery_put_base")

  merged <- merge(
    core_results_df[, c("asset_id", "scenario", "stressed_recovery")],
    vol_surface_df[, c("scenario", "firm_sigma")],
    by = "scenario",
    all.x = TRUE,
    sort = FALSE
  )

  merged$firm_sigma[is.na(merged$firm_sigma)] <- sigma_base

  merged$scenario_sigma <- mapply(function(sc, sigma_in, stressed_recovery) {
    if (sc == "Counterparty Default") {
      severity <- pmax(0, 1 - as.numeric(stressed_recovery))
      return(pmax(1e-6, sigma_in * (1 + severity)))
    }
    sigma_in
  }, merged$scenario, merged$firm_sigma, merged$stressed_recovery)

  stress_res <- lapply(seq_len(nrow(merged)), function(i) {
    greeks <- bsm_price_greeks(
      S = S,
      K = K,
      r = r,
      sigma = as.numeric(merged$scenario_sigma[i]),
      T = T,
      context = sprintf("recovery_put_%s", gsub(" ", "_", merged$scenario[i]))
    )

    implied_recovery <- pmax(S - K, 0) / K
    convergence_signal <- ifelse(abs(implied_recovery - as.numeric(merged$stressed_recovery[i])) <= tol,
                                 "CONVERGENT", "DIVERGENT")

    data.frame(
      asset_id = merged$asset_id[i],
      scenario = merged$scenario[i],
      put_price_base = base_greeks$put_price,
      put_price_stressed = greeks$put_price,
      implied_recovery_bsm = implied_recovery,
      sira_stressed_recovery = as.numeric(merged$stressed_recovery[i]),
      convergence_signal = convergence_signal,
      delta_put = greeks$delta_put,
      vega = greeks$vega,
      stringsAsFactors = FALSE
    )
  })

  out_df <- do.call(rbind, stress_res)
  cat(sprintf("%s%s[31/34] recovery_put -- complete -- divergent=%d%s\n",
              NEON$bold,
              NEON$cyan,
              sum(out_df$convergence_signal == "DIVERGENT", na.rm = TRUE),
              NEON$reset))
  out_df
}
