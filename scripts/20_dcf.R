# ============================================================================
# Script Name : 20_dcf.R
# Purpose     : Stress-conditioned DCF engine for direct lending positions.
# ============================================================================

run_dcf_engine <- function(core_results_df, load_output) {
  cat(sprintf("%s%s[20/25] dcf_engine -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  if (!is.data.frame(core_results_df) || nrow(core_results_df) == 0) {
    stop("[ERROR] DCF engine requires non-empty core_results_df.")
  }
  if (is.null(load_output$portfolio) || !is.data.frame(load_output$portfolio) || nrow(load_output$portfolio) == 0) {
    stop("[ERROR] DCF engine requires normalized portfolio from load_output.")
  }

  cfg <- CFG$dcf
  face_value <- as.numeric(cfg$face_value)
  coupon_rate <- as.numeric(cfg$coupon_rate)
  term_years <- as.integer(cfg$term_years)
  discount_rate_base <- as.numeric(cfg$discount_rate_base)
  impairment_threshold <- as.numeric(cfg$impairment_threshold)

  if (is.na(face_value) || face_value <= 0 || is.na(coupon_rate) || term_years <= 0) {
    stop("[ERROR] DCF config values are invalid (face_value/coupon_rate/term_years).")
  }

  portfolio <- unique(load_output$portfolio[, c("asset_id", "recovery_anchor")])
  scenario_df <- merge(
    core_results_df[, c("asset_id", "scenario", "stressed_recovery")],
    portfolio,
    by = "asset_id",
    all.x = TRUE,
    sort = FALSE
  )

  recovery_override <- cfg$recovery_override
  has_override <- !is.null(recovery_override) && !is.na(suppressWarnings(as.numeric(recovery_override)))
  recovery_anchor <- if (has_override) as.numeric(recovery_override) else scenario_df$recovery_anchor
  recovery_anchor <- pmin(0.995, pmax(0.001, as.numeric(recovery_anchor)))

  coupon_cf <- rep(face_value * coupon_rate, term_years)
  discount_years <- seq_len(term_years)
  pv_coupon_base <- sum(coupon_cf / ((1 + discount_rate_base) ^ discount_years))

  stressed_rate_cfg <- cfg$discount_rate_stressed
  get_stressed_discount_rate <- function(scenario_name) {
    if (is.list(stressed_rate_cfg)) {
      key <- gsub("-", "_", gsub(" ", "_", scenario_name))
      val <- stressed_rate_cfg[[key]]
      if (is.null(val)) {
        val <- stressed_rate_cfg[["default"]]
      }
      if (is.null(val)) {
        stop(sprintf("[ERROR] Missing dcf.discount_rate_stressed mapping for scenario=%s", scenario_name))
      }
      return(as.numeric(val))
    }

    as.numeric(stressed_rate_cfg)
  }

  scenario_df$dcf_base_value <- pv_coupon_base + ((face_value * recovery_anchor) / ((1 + discount_rate_base) ^ term_years))

  scenario_df$dcf_stressed_value <- mapply(function(stressed_recovery, scenario_name) {
    dr <- get_stressed_discount_rate(scenario_name)
    pv_coupon_stressed <- sum(coupon_cf / ((1 + dr) ^ discount_years))
    pv_coupon_stressed + ((face_value * as.numeric(stressed_recovery)) / ((1 + dr) ^ term_years))
  }, scenario_df$stressed_recovery, scenario_df$scenario)

  scenario_df$value_erosion_pct <- ifelse(
    scenario_df$dcf_base_value <= 0,
    NA_real_,
    (scenario_df$dcf_base_value - scenario_df$dcf_stressed_value) / scenario_df$dcf_base_value
  )

  scenario_df$signal <- ifelse(scenario_df$value_erosion_pct > impairment_threshold, "IMPAIRED", "STABLE")

  out_df <- scenario_df[, c("asset_id", "scenario", "dcf_base_value", "dcf_stressed_value", "value_erosion_pct", "signal")]
  out_df <- out_df[order(out_df$asset_id, out_df$scenario), ]

  cat(sprintf("%s%s[20/25] dcf_engine -- complete -- rows=%d impaired=%d%s\n",
              NEON$bold,
              NEON$cyan,
              nrow(out_df),
              sum(out_df$signal == "IMPAIRED", na.rm = TRUE),
              NEON$reset))

  out_df
}
