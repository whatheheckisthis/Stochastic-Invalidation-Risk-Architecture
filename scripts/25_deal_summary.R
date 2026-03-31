# ============================================================================
# Script Name : 25_deal_summary.R
# Purpose     : Cross-module deal intelligence summary for committee review.
# ============================================================================

run_deal_summary <- function(core_results_df,
                             spread_stress_output,
                             dcf_results,
                             ma_results,
                             accretion_results,
                             lbo_results,
                             irr_results) {
  cat(sprintf("%s%s[25/25] deal_summary -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  scenario_df <- spread_stress_output$scenario_df
  scenario_names <- scenario_df$scenario

  annuity_cfg <- CFG$annuity
  annuity_type <- tolower(as.character(annuity_cfg$type))

  apply_annuity_modifier <- function(scenario_name, base_obligation, irr_stressed) {
    if (annuity_type == "variable") {
      payout_proxy <- max(as.numeric(CFG$liability$payout_rate), ifelse(is.na(irr_stressed), 0, irr_stressed))
      return(base_obligation * (1 + payout_proxy))
    }

    if (annuity_type == "indexed") {
      floor_rate <- as.numeric(annuity_cfg$indexed$floor_rate)
      participation_rate <- as.numeric(annuity_cfg$indexed$participation_rate)
      index_cap_rate <- as.numeric(annuity_cfg$indexed$index_cap_rate)
      upside <- max(ifelse(is.na(irr_stressed), 0, irr_stressed) - floor_rate, 0)
      credited_rate <- min(index_cap_rate, floor_rate + participation_rate * upside)
      return(base_obligation * (1 + credited_rate))
    }

    if (identical(scenario_name, "Hyper-Inflationary")) {
      return(base_obligation * as.numeric(CFG$liability$inflation_sensitivity))
    }

    base_obligation
  }

  summary_rows <- lapply(scenario_names, function(sc) {
    dcf_sc <- dcf_results[dcf_results$scenario == sc, , drop = FALSE]
    ma_sc <- ma_results[ma_results$scenario == sc, , drop = FALSE]
    acc_sc <- accretion_results$stressed_df[accretion_results$stressed_df$scenario == sc, , drop = FALSE]
    lbo_sc <- lbo_results[lbo_results$scenario == sc, , drop = FALSE]
    irr_sc <- irr_results[irr_results$scenario == sc, , drop = FALSE]
    cap_sc <- scenario_df[scenario_df$scenario == sc, , drop = FALSE]

    value_erosion_pct <- mean(dcf_sc$value_erosion_pct, na.rm = TRUE)
    sell_count <- sum(core_results_df$signal[core_results_df$scenario == sc] == "SELL", na.rm = TRUE)
    total_assets <- sum(core_results_df$scenario == sc)

    adjusted_obligation <- apply_annuity_modifier(
      scenario_name = sc,
      base_obligation = as.numeric(cap_sc$annual_obligation[1]),
      irr_stressed = as.numeric(irr_sc$irr_stressed[1])
    )

    capital_stack_spread <- (as.numeric(cap_sc$net_income_after_defaults[1]) - adjusted_obligation) /
      as.numeric(CFG$credit$deployed_capital)
    solvency_signal <- ifelse(capital_stack_spread < 0 || as.numeric(cap_sc$solvency_headroom[1]) < 0, "BREACH", "SOLVENT")

    cat("\n┌─────────────────────────────────────────────────────────┐\n")
    cat("│ SIRA DEAL INTELLIGENCE SUMMARY                          │\n")
    cat(sprintf("│ Scenario: %-46s│\n", substr(sc, 1, 46)))
    cat("├──────────────┬──────────────────────────┬───────────────┤\n")
    cat(sprintf("│ DCF          │ Value erosion: %6.2f%%     │ %-13s│\n", 100 * value_erosion_pct, unique(dcf_sc$signal)[1]))
    cat(sprintf("│ M&A          │ Discount to par: %6.2f%%    │ %-13s│\n", 100 * as.numeric(ma_sc$discount_to_par[1]), as.character(ma_sc$ma_signal[1])))
    cat(sprintf("│ Accretion    │ Spread delta: %6.1f bps    │ %-13s│\n", 10000 * as.numeric(acc_sc$spread_delta[1]), as.character(acc_sc$accretion_signal_stressed[1])))
    cat(sprintf("│ LBO          │ DSCR: %5.2f IRR: %6.2f%%  │ %-13s│\n", as.numeric(lbo_sc$dscr[1]), 100 * as.numeric(lbo_sc$irr_stressed[1]), as.character(lbo_sc$lbo_signal[1])))
    cat(sprintf("│ IRR          │ Stressed IRR: %6.2f%%      │ %-13s│\n", 100 * as.numeric(irr_sc$irr_stressed[1]), as.character(irr_sc$irr_signal[1])))
    cat("├──────────────┴──────────────────────────┴───────────────┤\n")
    cat(sprintf("│ Capital Stack Spread: %6.2f%%  Solvency: %-12s│\n", 100 * capital_stack_spread, solvency_signal))
    cat(sprintf("│ Core SIRA SELL count: %3d/%-3d                           │\n", sell_count, total_assets))
    cat("└─────────────────────────────────────────────────────────┘\n")

    data.frame(
      scenario = sc,
      dcf_value_erosion_pct = value_erosion_pct,
      dcf_signal = unique(dcf_sc$signal)[1],
      ma_discount_to_par = as.numeric(ma_sc$discount_to_par[1]),
      ma_signal = as.character(ma_sc$ma_signal[1]),
      accretion_spread_delta = as.numeric(acc_sc$spread_delta[1]),
      accretion_signal = as.character(acc_sc$accretion_signal_stressed[1]),
      lbo_dscr = as.numeric(lbo_sc$dscr[1]),
      lbo_irr_stressed = as.numeric(lbo_sc$irr_stressed[1]),
      lbo_signal = as.character(lbo_sc$lbo_signal[1]),
      irr_stressed = as.numeric(irr_sc$irr_stressed[1]),
      irr_signal = as.character(irr_sc$irr_signal[1]),
      capital_stack_spread = capital_stack_spread,
      solvency_signal = solvency_signal,
      sell_count = sell_count,
      total_assets = total_assets,
      stringsAsFactors = FALSE
    )
  })

  summary_df <- do.call(rbind, summary_rows)

  risk_score <- with(summary_df,
                     ifelse(dcf_signal == "IMPAIRED", 3, 0) +
                       ifelse(lbo_signal == "IMPAIRED", 2, 0) +
                       ifelse(irr_signal == "IMPAIRED", 1, 0))
  worst_idx <- which.max(risk_score)
  worst_case <- summary_df$scenario[worst_idx]

  dominant_risk <- if (summary_df$dcf_signal[worst_idx] == "IMPAIRED") {
    "DCF impairment"
  } else if (summary_df$lbo_signal[worst_idx] == "IMPAIRED") {
    "DSCR failure"
  } else {
    "IRR floor breach"
  }

  cat(sprintf("\nWorst-case scenario: %s\n", worst_case))
  cat(sprintf("Dominant risk: %s\n", dominant_risk))

  out_meta <- file.path(sub("/$", "", CFG$data$output_path), "deal_intelligence_metadata.rds")
  saveRDS(
    list(
      run_timestamp_utc = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
      annuity_type = annuity_type,
      credit_type = CFG$credit_type$type,
      summary_df = summary_df,
      worst_case = worst_case,
      dominant_risk = dominant_risk
    ),
    out_meta
  )

  cat(sprintf("%s%s[25/25] deal_summary -- complete -- metadata=%s%s\n",
              NEON$bold, NEON$cyan, out_meta, NEON$reset))

  list(summary_df = summary_df, worst_case = worst_case, dominant_risk = dominant_risk, metadata_path = out_meta)
}
