# ============================================================================
# Script Name : 02_analysis.R
# Purpose     : Stochastic invalidation and SELL/HOLD risk signal pipeline.
# ============================================================================

run_sira_analysis <- function(load_output, seed = 20260329) {
  cat(sprintf("[02/03] analysis -- %s\n", format(Sys.time(), "%Y-%m-%d %H:%M:%S")))
  set.seed(seed)

  portfolio <- load_output$portfolio
  if (!is.data.frame(portfolio) || nrow(portfolio) == 0) {
    stop("[FATAL] Portfolio input is empty or invalid.")
  }

  scenarios <- c(
    "Baseline",
    "Liquidity Crunch",
    "Jurisdictional Freeze",
    "Counterparty Default",
    "Hyper-Inflationary"
  )

  ruin_thresholds <- c(
    "Baseline" = 0.20,
    "Liquidity Crunch" = 0.28,
    "Jurisdictional Freeze" = 0.35,
    "Counterparty Default" = 0.40,
    "Hyper-Inflationary" = 0.32
  )

  fx_devaluation <- c("USD" = 0.88, "EUR" = 0.80, "GBP" = 0.78, "JPY" = 0.74, "BRL" = 0.64)

  generate_recovery <- function(anchor, scenario, n) {
    if (scenario == "Baseline") {
      rec <- stats::rbeta(n, shape1 = 6.0 * anchor + 1.5, shape2 = 6.0 * (1 - anchor) + 1.8)
    } else if (scenario == "Liquidity Crunch") {
      rec <- stats::rbeta(n, shape1 = 2.3 * anchor + 0.8, shape2 = 5.2 * (1 - anchor) + 2.2)
    } else if (scenario == "Jurisdictional Freeze") {
      rec <- stats::rbeta(n, shape1 = 1.6 * anchor + 0.5, shape2 = 7.4 * (1 - anchor) + 2.8)
    } else if (scenario == "Counterparty Default") {
      tail <- (stats::runif(n) ^ (-1 / 2.15)) - 1
      rec <- 1 / (1 + tail)
    } else {
      tail <- (stats::runif(n) ^ (-1 / 1.65)) - 1
      rec <- 1 / (1 + tail)
    }

    pmin(0.995, pmax(0.001, rec))
  }

  scenario_frames <- lapply(seq_along(scenarios), function(i) {
    sc <- scenarios[[i]]
    n <- nrow(portfolio)
    base_rec <- generate_recovery(portfolio$recovery_anchor, sc, n)

    shocked_recovery <- base_rec

    if (sc == "Counterparty Default") {
      gap_down <- 0.35
      shocked_recovery <- shocked_recovery * pmax(0.08, (portfolio$price / 100) * (1 - gap_down))
    }

    if (sc == "Hyper-Inflationary") {
      fx_mult <- fx_devaluation[portfolio$currency]
      fx_mult[is.na(fx_mult)] <- 0.70
      shocked_recovery <- shocked_recovery * fx_mult
    }

    if (sc == "Jurisdictional Freeze") {
      th <- ruin_thresholds[[sc]]
      prox_collapse <- th + abs(stats::rnorm(n, mean = 0, sd = 0.02))
      shocked_recovery <- pmin(shocked_recovery, prox_collapse)
    }

    shocked_recovery <- pmin(0.995, pmax(0.001, shocked_recovery))

    cat(sprintf("[SCENARIO %d/5] %s -- complete -- %d assets processed\n", i, sc, n))

    data.frame(
      asset_id = portfolio$asset_id,
      issuer = portfolio$issuer,
      currency = portfolio$currency,
      region = portfolio$region,
      sector = portfolio$sector,
      rating = portfolio$rating,
      notional = portfolio$notional,
      price = portfolio$price,
      recovery_anchor = portfolio$recovery_anchor,
      scenario = sc,
      base_recovery = round(base_rec, 6),
      stressed_recovery = round(shocked_recovery, 6),
      ruin_threshold = ruin_thresholds[[sc]],
      stringsAsFactors = FALSE
    )
  })

  results <- do.call(rbind, scenario_frames)

  z_vals <- ave(results$stressed_recovery, results$asset_id, FUN = function(x) {
    s <- scale(x)
    as.numeric(s)
  })

  results$z_score <- round(z_vals, 6)
  results$ruin_flag <- results$stressed_recovery <= results$ruin_threshold

  results$signal <- ifelse(
    results$ruin_flag | results$z_score <= -0.75,
    "SELL",
    "HOLD"
  )

  results$signal <- factor(results$signal, levels = c("SELL", "HOLD"))

  results$audit_id <- sprintf("%s__%s", results$asset_id, gsub(" ", "_", results$scenario))
  results$run_seed <- seed

  ruin_count <- sum(results$ruin_flag, na.rm = TRUE)
  sell_count <- sum(results$signal == "SELL", na.rm = TRUE)
  cat(sprintf("[02/03] analysis -- complete -- scenarios=%d ruin_flags=%d sell_signals=%d\n",
              length(scenarios), ruin_count, sell_count))

  results[order(results$asset_id, results$scenario), ]
}
