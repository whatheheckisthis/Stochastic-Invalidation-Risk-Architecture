# Analysis stage: stochastic recovery simulation, Z-Scores, and Ruin Threshold evaluation.

sample_recovery <- function(n, distribution, shape1, shape2) {
  if (distribution == "beta") {
    return(stats::rbeta(n, shape1 = shape1, shape2 = shape2))
  }

  if (distribution == "power_law") {
    alpha <- max(shape2, 1.1)
    u <- stats::runif(n, min = 1e-6, max = 0.999999)
    x <- (1 - u)^(-1 / alpha)
    scaled <- (x - min(x)) / (max(x) - min(x) + 1e-9)
    return(pmax(0.01, pmin(0.99, 1 - scaled)))
  }

  stop(sprintf("Unsupported distribution: %s", distribution))
}

run_stress_analysis <- function(data_bundle, n_sim = 10000, seed = 42) {
  set.seed(seed)

  scenario_params <- data_bundle$scenario_params
  portfolio <- data_bundle$portfolio

  results <- lapply(seq_len(nrow(scenario_params)), function(i) {
    s <- scenario_params[i, ]
    draws <- sample_recovery(
      n = nrow(portfolio),
      distribution = s$recovery_distribution,
      shape1 = s$rec_shape1,
      shape2 = s$rec_shape2
    )

    shocked_recovery <- pmax(
      0,
      pmin(
        1,
        draws * (1 - s$gap_down) * (1 - s$fx_devaluation)
      )
    )

    stressed_value <- portfolio$exposure_usd * shocked_recovery
    z_score <- as.numeric(scale(shocked_recovery))
    ruin_flag <- shocked_recovery <= s$ruin_threshold

    signal <- ifelse(
      ruin_flag | z_score < -1.5,
      "Sell",
      ifelse(z_score < -0.35, "Hold", "Hold")
    )

    data.frame(
      scenario = s$scenario,
      asset_id = portfolio$asset_id,
      exposure_usd = portfolio$exposure_usd,
      stressed_recovery = shocked_recovery,
      stressed_value = stressed_value,
      z_score = z_score,
      ruin_threshold = s$ruin_threshold,
      ruin_flag = ruin_flag,
      signal = signal,
      stringsAsFactors = FALSE
    )
  })

  detailed <- do.call(rbind, results)

  scenario_summary <- aggregate(
    cbind(stressed_recovery, stressed_value, z_score, ruin_flag) ~ scenario,
    data = detailed,
    FUN = mean
  )
  names(scenario_summary)[names(scenario_summary) == "ruin_flag"] <- "ruin_probability"

  list(detailed = detailed, summary = scenario_summary, n_sim = n_sim)
}
