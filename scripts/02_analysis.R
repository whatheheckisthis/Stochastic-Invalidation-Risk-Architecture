# ============================================================================
# Script Name : 02_analysis.R
# Purpose     : Stochastic invalidation and SELL/HOLD risk signal pipeline.
# ============================================================================

run_sira_analysis <- function(load_output) {
  cat(sprintf("%s%s[02/03] analysis -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  set.seed(as.integer(CFG$runtime$seed))

  portfolio <- load_output$portfolio
  if (!is.data.frame(portfolio) || nrow(portfolio) == 0) {
    stop("[ERROR] Portfolio input is empty or invalid.")
  }

  scenario_names <- CFG$scenarios$names
  scenario_total <- length(scenario_names)

  scenario_cfg <- function(name) {
    key <- gsub("-", "_", gsub(" ", "_", name))
    CFG$scenarios[[key]]
  }

  generate_recovery <- function(anchor, cfg, n) {
    if (cfg$distribution == "beta") {
      rec <- stats::rbeta(n, shape1 = as.numeric(cfg$shape1) * anchor + 0.5,
                          shape2 = as.numeric(cfg$shape2) * (1 - anchor) + 0.5)
    } else if (cfg$distribution == "powerlaw") {
      tail <- (stats::runif(n) ^ (-1 / as.numeric(cfg$exponent))) - 1
      rec <- 1 / (1 + tail)
    } else {
      stop("[ERROR] Unsupported scenario distribution in configuration.")
    }

    pmin(0.995, pmax(0.001, rec))
  }

  scenario_frames <- lapply(seq_along(scenario_names), function(i) {
    sc <- scenario_names[[i]]
    cfg <- scenario_cfg(sc)
    n <- nrow(portfolio)

    base_rec <- generate_recovery(portfolio$recovery_anchor, cfg, n)
    shocked_recovery <- base_rec * as.numeric(cfg$shock_multiplier)

    if (sc == "Counterparty Default") {
      shocked_recovery <- shocked_recovery * pmax(0.08, portfolio$price / 100)
    }

    if (sc == "Hyper-Inflationary") {
      fx_mult <- 1 - as.numeric(cfg$fx_devaluation)
      shocked_recovery <- shocked_recovery * fx_mult
    }

    if (sc == "Jurisdictional Freeze") {
      th <- as.numeric(cfg$ruin_threshold)
      prox_collapse <- th + abs(stats::rnorm(n, mean = 0, sd = 0.02))
      shocked_recovery <- pmin(shocked_recovery, prox_collapse)
    }

    shocked_recovery <- pmin(0.995, pmax(0.001, shocked_recovery))

    cat(sprintf("%s[SCENARIO %d/%d] %s -- complete -- %d assets processed%s\n",
                NEON$magenta, i, scenario_total, sc, n, NEON$reset))

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
      ruin_threshold = as.numeric(cfg$ruin_threshold),
      stringsAsFactors = FALSE
    )
  })

  results <- do.call(rbind, scenario_frames)

  z_vals <- ave(results$stressed_recovery, results$asset_id, FUN = function(x) as.numeric(scale(x)))
  results$z_score <- round(z_vals, 6)
  results$ruin_flag <- results$stressed_recovery <= results$ruin_threshold

  z_threshold <- as.numeric(CFG$signals$sell_zscore_threshold)
  results$signal <- ifelse(results$ruin_flag | results$z_score <= z_threshold, "SELL", "HOLD")
  results$signal <- factor(results$signal, levels = c("SELL", "HOLD"))

  results$audit_id <- sprintf("%s__%s", results$asset_id, gsub(" ", "_", results$scenario))
  results$run_seed <- as.integer(CFG$runtime$seed)

  ruin_count <- sum(results$ruin_flag, na.rm = TRUE)
  sell_count <- sum(results$signal == "SELL", na.rm = TRUE)
  cat(sprintf("%s%s[02/03] analysis -- complete -- scenarios=%d ruin_flags=%d sell_signals=%d%s\n",
              NEON$bold, NEON$cyan, scenario_total, ruin_count, sell_count, NEON$reset))

  results[order(results$asset_id, results$scenario), ]
}
