# ============================================================================
# Script Name : 03_visualize.R
# Purpose     : Visualize per-asset per-scenario SELL/HOLD output.
# ============================================================================

visualize_sira <- function(results_df, output_dir = "output", filename = "sell_hold_signals.png") {
  cat(sprintf("[03/03] visualize -- %s\n", format(Sys.time(), "%Y-%m-%d %H:%M:%S")))

  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("[FATAL] ggplot2 is required but not installed.")
  }

  scenario_order <- c(
    "Baseline",
    "Liquidity Crunch",
    "Jurisdictional Freeze",
    "Counterparty Default",
    "Hyper-Inflationary"
  )

  plot_df <- results_df
  plot_df$scenario <- factor(plot_df$scenario, levels = scenario_order)
  plot_df$asset_id <- factor(plot_df$asset_id, levels = rev(unique(plot_df$asset_id)))

  p <- ggplot2::ggplot(
    plot_df,
    ggplot2::aes(
      x = stressed_recovery,
      y = asset_id,
      color = signal,
      size = pmax(0.2, abs(z_score)),
      alpha = pmax(0.3, stressed_recovery)
    )
  ) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~ scenario, ncol = 2, scales = "free_x") +
    ggplot2::scale_color_manual(values = c("SELL" = "#C62828", "HOLD" = "#2E7D32")) +
    ggplot2::scale_size_continuous(range = c(2.0, 7.0), name = "|z-score|") +
    ggplot2::scale_alpha_continuous(range = c(0.4, 0.95), guide = "none") +
    ggplot2::labs(
      title = "SIRA SELL/HOLD Signals by Asset and Scenario",
      subtitle = "Point position = stressed recovery, size = z-score severity",
      x = "Stressed Recovery",
      y = "Asset",
      color = "Signal"
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold"),
      legend.position = "bottom",
      panel.grid.minor = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(face = "bold")
    )

  out_path <- file.path(output_dir, filename)
  ggplot2::ggsave(out_path, plot = p, width = 14, height = 8.5, dpi = 300)

  fi <- file.info(out_path)
  file_size <- if (!is.na(fi$size)) sprintf("%d bytes", as.integer(fi$size)) else "unknown size"
  cat(sprintf("[OUTPUT] %s -- written -- %s\n", out_path, file_size))

  scenario_signal <- as.data.frame.matrix(xtabs(~ scenario + signal, data = plot_df))
  mean_rec <- aggregate(stressed_recovery ~ scenario, data = plot_df, FUN = mean)
  table_df <- merge(
    data.frame(scenario = rownames(scenario_signal), scenario_signal, row.names = NULL, stringsAsFactors = FALSE),
    mean_rec,
    by = "scenario",
    all.x = TRUE
  )

  if (!"SELL" %in% names(table_df)) table_df$SELL <- 0
  if (!"HOLD" %in% names(table_df)) table_df$HOLD <- 0

  table_df <- table_df[match(scenario_order, table_df$scenario), c("scenario", "SELL", "HOLD", "stressed_recovery")]
  names(table_df)[4] <- "mean_recovery"

  cat("\nTERMINAL SUMMARY (per scenario)\n")
  cat(sprintf("%-24s %8s %8s %14s\n", "Scenario", "SELL", "HOLD", "MeanRecovery"))
  cat(sprintf("%-24s %8s %8s %14s\n", strrep("-", 24), strrep("-", 8), strrep("-", 8), strrep("-", 14)))

  for (i in seq_len(nrow(table_df))) {
    cat(sprintf("%-24s %8d %8d %14.6f\n",
                table_df$scenario[i],
                as.integer(table_df$SELL[i]),
                as.integer(table_df$HOLD[i]),
                as.numeric(table_df$mean_recovery[i])))
  }

  cat("[03/03] visualize -- complete\n")

  invisible(out_path)
}
