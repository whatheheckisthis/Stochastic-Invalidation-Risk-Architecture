# ============================================================================
# Script Name : 22_accretion.R
# Purpose     : Accretion/Dilution engine for yield posture assessment.
# ============================================================================

run_accretion_engine <- function(spread_stress_output) {
  cat(sprintf("%s%s[22/25] accretion_engine -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  if (is.null(spread_stress_output$scenario_df) || !is.data.frame(spread_stress_output$scenario_df)) {
    stop("[ERROR] Accretion engine requires spread_stress_output$scenario_df.")
  }

  cfg <- CFG$accretion
  existing_yield <- as.numeric(cfg$existing_yield)
  existing_aum <- as.numeric(cfg$existing_aum)
  target_yield <- as.numeric(cfg$target_yield)
  target_size <- as.numeric(cfg$target_size)
  obligation_rate <- as.numeric(cfg$obligation_rate)
  neutral_band <- as.numeric(cfg$neutral_band)

  pro_forma_yield <- ((existing_aum * existing_yield) + (target_size * target_yield)) / (existing_aum + target_size)
  spread_existing <- existing_yield - obligation_rate
  spread_proforma <- pro_forma_yield - obligation_rate
  spread_delta <- spread_proforma - spread_existing

  base_signal <- if (abs(spread_delta) <= neutral_band) {
    "NEUTRAL"
  } else if (spread_delta > 0) {
    "ACCRETIVE"
  } else {
    "DILUTIVE"
  }

  sc_df <- spread_stress_output$scenario_df
  stressed_rows <- lapply(seq_len(nrow(sc_df)), function(i) {
    sc <- sc_df$scenario[i]
    stressed_target_yield <- as.numeric(sc_df$net_income_after_defaults[i]) / target_size
    stressed_pro_forma_yield <- ((existing_aum * existing_yield) + (target_size * stressed_target_yield)) / (existing_aum + target_size)
    stressed_spread_proforma <- stressed_pro_forma_yield - obligation_rate
    stressed_delta <- stressed_spread_proforma - spread_existing

    stressed_signal <- if (abs(stressed_delta) <= neutral_band) {
      "NEUTRAL"
    } else if (stressed_delta > 0) {
      "ACCRETIVE"
    } else {
      "DILUTIVE"
    }

    data.frame(
      scenario = sc,
      spread_existing = spread_existing,
      spread_proforma = stressed_spread_proforma,
      spread_delta = stressed_delta,
      accretion_signal_stressed = stressed_signal,
      stringsAsFactors = FALSE
    )
  })

  stressed_df <- do.call(rbind, stressed_rows)

  out <- list(
    spread_existing = spread_existing,
    spread_proforma = spread_proforma,
    spread_delta = spread_delta,
    accretion_signal = base_signal,
    stressed_df = stressed_df
  )

  cat(sprintf("%s%s[22/25] accretion_engine -- complete -- base_signal=%s%s\n",
              NEON$bold, NEON$cyan, base_signal, NEON$reset))

  out
}
