# ============================================================================
# Script Name : 03_visualize.R
# Purpose     : Render SELL/HOLD signal chart using Base R graphics only.
# Author      : Codex Assistant
# Created     : 2026-03-27
# R Version   : 3.6+
# ============================================================================

visualize_signals <- function(analysis_results, output_dir = "output", filename = "sell_hold_signals.png") {
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  output_file <- file.path(output_dir, filename)

  sell_count <- as.integer(analysis_results$signal_counts["SELL"])
  hold_count <- as.integer(analysis_results$signal_counts["HOLD"])

  png(filename = output_file, width = 1000, height = 600)
  barplot(
    height = c(sell_count, hold_count),
    names.arg = c("SELL", "HOLD"),
    col = c("#C62828", "#2E7D32"),
    main = "Distressed Asset Signals",
    ylab = "Count",
    ylim = c(0, max(1, sell_count, hold_count) * 1.15)
  )
  dev.off()

  output_file
}
