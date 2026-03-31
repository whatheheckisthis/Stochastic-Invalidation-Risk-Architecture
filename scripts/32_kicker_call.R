# ============================================================================
# Script Name : 32_kicker_call.R
# Purpose     : Equity kicker call option analytics and IRR enrichment.
# ============================================================================

run_kicker_call_engine <- function(dcf_results_df, vol_surface_df) {
  cat(sprintf("%s%s[32/34] kicker_call -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  cfg <- CFG$options$kicker_call
  credit_type <- tolower(as.character(CFG$credit_type$type))

  S_base <- as.numeric(cfg$equity_value_entry)
  K <- as.numeric(cfg$strike_price)
  r <- as.numeric(cfg$risk_free_rate)
  sigma_base <- as.numeric(cfg$equity_volatility)
  T <- as.numeric(cfg$hold_period_years)
  initial_investment <- as.numeric(CFG$irr$initial_investment)

  type_mult_map <- cfg$credit_type_sigma_multiplier
  sigma_type_mult <- if (!is.null(type_mult_map[[credit_type]])) as.numeric(type_mult_map[[credit_type]]) else 1

  base_greeks <- bsm_price_greeks(
    S = S_base,
    K = K,
    r = r,
    sigma = sigma_base * sigma_type_mult,
    T = T,
    context = "kicker_call_base"
  )

  erosion_by_scenario <- aggregate(value_erosion_pct ~ scenario, data = dcf_results_df, FUN = mean)
  merged <- merge(vol_surface_df[, c("scenario", "equity_sigma")], erosion_by_scenario,
                  by = "scenario", all.x = TRUE, sort = FALSE)
  merged$value_erosion_pct[is.na(merged$value_erosion_pct)] <- 0

  rows <- lapply(seq_len(nrow(merged)), function(i) {
    sc <- merged$scenario[i]
    S_stressed <- S_base * (1 - as.numeric(merged$value_erosion_pct[i]))
    sigma_stressed <- as.numeric(merged$equity_sigma[i]) * sigma_type_mult

    greeks <- bsm_price_greeks(
      S = pmax(S_stressed, 1e-6),
      K = K,
      r = r,
      sigma = sigma_stressed,
      T = T,
      context = sprintf("kicker_call_%s", gsub(" ", "_", sc))
    )

    moneyness <- S_stressed / K
    kicker_signal <- if (moneyness > 1.02) {
      "IN_THE_MONEY"
    } else if (moneyness < 0.98) {
      "OUT_THE_MONEY"
    } else {
      "AT_THE_MONEY"
    }

    data.frame(
      scenario = sc,
      call_price_base = base_greeks$call_price,
      call_price_stressed = greeks$call_price,
      kicker_irr_contribution = greeks$call_price / initial_investment,
      delta_call = greeks$delta_call,
      moneyness = moneyness,
      kicker_signal = kicker_signal,
      stringsAsFactors = FALSE
    )
  })

  out_df <- do.call(rbind, rows)
  cat(sprintf("%s%s[32/34] kicker_call -- complete -- in_the_money=%d%s\n",
              NEON$bold,
              NEON$cyan,
              sum(out_df$kicker_signal == "IN_THE_MONEY", na.rm = TRUE),
              NEON$reset))
  out_df
}
