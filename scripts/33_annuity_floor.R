# ============================================================================
# Script Name : 33_annuity_floor.R
# Purpose     : Indexed annuity floor put analytics and solvency adjustment.
# ============================================================================

run_annuity_floor_engine <- function(spread_stress_output, vol_surface_df) {
  cat(sprintf("%s%s[33/34] annuity_floor -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  annuity_type <- tolower(as.character(CFG$annuity$type))
  scenario_df <- spread_stress_output$scenario_df
  annuity_pool_size <- as.numeric(CFG$liability$annuity_pool_size)

  if (annuity_type != "indexed") {
    out <- transform(
      scenario_df[, c("scenario", "solvency_headroom")],
      put_price_base = 0,
      put_price_stressed = 0,
      floor_liability_base = 0,
      floor_liability_stressed = 0,
      solvency_headroom_adjusted = solvency_headroom,
      floor_signal = "COVERED"
    )
    return(out[, c("scenario", "put_price_base", "put_price_stressed", "floor_liability_base",
                   "floor_liability_stressed", "solvency_headroom_adjusted", "floor_signal")])
  }

  cfg <- CFG$options$annuity_floor
  S_base <- as.numeric(cfg$portfolio_return_current)
  K <- as.numeric(cfg$floor_rate)
  r <- as.numeric(cfg$risk_free_rate)
  sigma_base <- as.numeric(cfg$return_volatility)
  T <- as.numeric(cfg$duration_years)

  base_greeks <- bsm_price_greeks(S = S_base, K = K, r = r, sigma = sigma_base, T = T, context = "annuity_floor_base")

  merged <- merge(scenario_df[, c("scenario", "net_income_after_defaults", "solvency_headroom")],
                  vol_surface_df[, c("scenario", "portfolio_sigma")],
                  by = "scenario", all.x = TRUE, sort = FALSE)

  deployed_capital <- as.numeric(CFG$credit$deployed_capital)

  rows <- lapply(seq_len(nrow(merged)), function(i) {
    sc <- merged$scenario[i]
    S_stressed <- as.numeric(merged$net_income_after_defaults[i]) / deployed_capital
    K_stressed <- K
    if (sc == "Hyper-Inflationary") {
      K_stressed <- K * as.numeric(CFG$liability$inflation_sensitivity)
    }

    greeks <- bsm_price_greeks(
      S = pmax(S_stressed, 1e-6),
      K = K_stressed,
      r = r,
      sigma = as.numeric(merged$portfolio_sigma[i]),
      T = T,
      context = sprintf("annuity_floor_%s", gsub(" ", "_", sc))
    )

    floor_liability_stressed <- greeks$put_price * annuity_pool_size
    solvency_headroom_adjusted <- as.numeric(merged$solvency_headroom[i]) - floor_liability_stressed

    floor_signal <- if (solvency_headroom_adjusted < 0) {
      "BREACH"
    } else if (solvency_headroom_adjusted < (0.05 * annuity_pool_size)) {
      "WATCH"
    } else {
      "COVERED"
    }

    data.frame(
      scenario = sc,
      put_price_base = base_greeks$put_price,
      put_price_stressed = greeks$put_price,
      floor_liability_base = base_greeks$put_price * annuity_pool_size,
      floor_liability_stressed = floor_liability_stressed,
      solvency_headroom_adjusted = solvency_headroom_adjusted,
      floor_signal = floor_signal,
      stringsAsFactors = FALSE
    )
  })

  out_df <- do.call(rbind, rows)
  cat(sprintf("%s%s[33/34] annuity_floor -- complete -- breach=%d%s\n",
              NEON$bold,
              NEON$cyan,
              sum(out_df$floor_signal == "BREACH", na.rm = TRUE),
              NEON$reset))
  out_df
}
