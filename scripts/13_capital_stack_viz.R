# ============================================================================
# Script Name : 13_capital_stack_viz.R
# Purpose     : Terminal-native and chart outputs for capital stack stress.
# ============================================================================

visualize_capital_stack <- function(spread_stress_output) {
  scenario_df <- spread_stress_output$scenario_df

  cat("\nCapital Stack Stress Summary\n")
  cat("─────────────────────────────────────────────\n")
  cat(sprintf("Annuity Pool:        $%s\n", format(round(as.numeric(CFG$liability$annuity_pool_size), 2), big.mark = ",", scientific = FALSE)))
  cat(sprintf("Deployed Credit:     $%s\n", format(round(as.numeric(CFG$credit$deployed_capital), 2), big.mark = ",", scientific = FALSE)))
  cat(sprintf("Gross Yield:         %.2f%%\n", as.numeric(CFG$credit$gross_yield) * 100))
  cat(sprintf("Obligation Rate:     %.2f%%\n", as.numeric(CFG$liability$payout_rate) * 100))
  cat(sprintf("Target Spread:       %.2f%%\n", (as.numeric(CFG$credit$gross_yield) - as.numeric(CFG$liability$payout_rate)) * 100))
  cat("─────────────────────────────────────────────\n")
  cat("Scenario Results:\n")

  for (i in seq_len(nrow(scenario_df))) {
    cat(sprintf("%-18s Spread: %7.2f%%    Signal: %s\n",
                scenario_df$scenario[i],
                as.numeric(scenario_df$spread_ratio[i]) * 100,
                scenario_df$capital_stack_signal[i]))
  }

  worst_row <- scenario_df[scenario_df$scenario == spread_stress_output$worst_case, , drop = FALSE]

  cat("─────────────────────────────────────────────\n")
  cat(sprintf("Worst Case:   %s\n", spread_stress_output$worst_case))
  cat(sprintf("Solvency Headroom (worst): $%s\n",
              format(round(as.numeric(worst_row$solvency_headroom[1]), 2), big.mark = ",", scientific = FALSE)))

  out_plot <- file.path(sub("/$", "", CFG$data$output_path), "capital_stack_spread.png")

  if (requireNamespace("ggplot2", quietly = TRUE)) {
    plot_df <- scenario_df
    plot_df$scenario <- factor(plot_df$scenario, levels = CFG$scenarios$names)
    plot_df$capital_stack_signal <- factor(plot_df$capital_stack_signal, levels = c("SOLVENT", "WATCH", "BREACH"))

    obligation_rate <- as.numeric(CFG$liability$payout_rate)
    plot_long <- rbind(
      data.frame(scenario = plot_df$scenario, metric = "SpreadCapturedRate", value = plot_df$spread_ratio, signal = plot_df$capital_stack_signal),
      data.frame(scenario = plot_df$scenario, metric = "ObligationRate", value = obligation_rate, signal = plot_df$capital_stack_signal)
    )

    p <- ggplot2::ggplot(plot_long, ggplot2::aes(x = scenario, y = value, fill = signal)) +
      ggplot2::geom_col(position = "dodge") +
      ggplot2::facet_wrap(~ metric, scales = "free_y") +
      ggplot2::scale_fill_manual(values = c("SOLVENT" = "#2E7D32", "WATCH" = "#FFB300", "BREACH" = "#C62828")) +
      ggplot2::scale_y_continuous(labels = function(x) sprintf("%.1f%%", x * 100)) +
      ggplot2::labs(
        title = "Capital Stack Spread vs Obligation by Scenario",
        x = "Scenario",
        y = "Rate",
        fill = "Signal"
      ) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 25, hjust = 1))

    ggplot2::ggsave(
      out_plot,
      plot = p,
      width = as.numeric(CFG$output$png_width),
      height = as.numeric(CFG$output$png_height),
      dpi = as.numeric(CFG$output$png_dpi)
    )
  }

  out_meta <- file.path(sub("/$", "", CFG$data$output_path), "capital_stack_metadata.rds")
  saveRDS(
    list(
      run_timestamp_utc = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
      runtime_seed = as.integer(CFG$runtime$seed),
      scenario_summary = scenario_df,
      worst_case = spread_stress_output$worst_case,
      signal_counts = spread_stress_output$signal_counts,
      headroom_summary = spread_stress_output$headroom_summary
    ),
    out_meta
  )

  list(plot_path = out_plot, metadata_path = out_meta)
}
