# ============================================================================
# Script Name : 35_options_summary.R
# Purpose     : Consolidated options summary with Greeks and hedge attribution.
# ============================================================================

run_options_summary <- function(recovery_put_df, kicker_call_df, annuity_floor_df, greeks_df, hedge_df) {
  cat(sprintf("%s%s[35/36] options_summary -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  recovery_view <- data.frame(
    option_name = "recovery_put",
    scenario = recovery_put_df$scenario,
    base_value = recovery_put_df$put_price_base,
    stressed_value = recovery_put_df$put_price_stressed,
    stringsAsFactors = FALSE
  )

  kicker_view <- data.frame(
    option_name = "kicker_call",
    scenario = kicker_call_df$scenario,
    base_value = kicker_call_df$call_price_base,
    stressed_value = kicker_call_df$call_price_stressed,
    stringsAsFactors = FALSE
  )

  floor_view <- data.frame(
    option_name = "annuity_floor",
    scenario = annuity_floor_df$scenario,
    base_value = annuity_floor_df$put_price_base,
    stressed_value = annuity_floor_df$put_price_stressed,
    stringsAsFactors = FALSE
  )

  base <- rbind(recovery_view, kicker_view, floor_view)
  out_df <- merge(base, greeks_df, by = c("option_name", "scenario"), all.x = TRUE, sort = FALSE)
  out_df <- merge(out_df, hedge_df, by = c("option_name", "scenario"), all.x = TRUE, sort = FALSE)
  out_df$value_change <- out_df$stressed_value - out_df$base_value

  out_path <- file.path(sub("/$", "", CFG$data$output_path), "options_summary.csv")
  utils::write.csv(out_df, out_path, row.names = FALSE)

  cat(sprintf("%s%s[35/36] options_summary -- complete -- artifact=%s%s\n",
              NEON$bold, NEON$cyan, out_path, NEON$reset))
  out_df
}
