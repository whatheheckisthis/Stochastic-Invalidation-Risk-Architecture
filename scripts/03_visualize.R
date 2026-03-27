# Visualization stage: render SELL/HOLD stress signals by scenario.

plot_stress_signals <- function(analysis_result, output_file = "output/sell_hold_signals.png") {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    warning("ggplot2 is not available; skipping visualization.")
    return(invisible(NULL))
  }

  dir.create(dirname(output_file), showWarnings = FALSE, recursive = TRUE)

  detail <- analysis_result$detailed

  signal_summary <- aggregate(
    asset_id ~ scenario + signal,
    data = detail,
    FUN = length
  )
  names(signal_summary)[names(signal_summary) == "asset_id"] <- "count"

  p <- ggplot2::ggplot(signal_summary, ggplot2::aes(x = scenario, y = count, fill = signal)) +
    ggplot2::geom_col(position = "stack", width = 0.7) +
    ggplot2::scale_fill_manual(values = c(Sell = "#D32F2F", Hold = "#2E7D32")) +
    ggplot2::labs(
      title = "Distressed Bond Stress Signals",
      subtitle = "SELL/HOLD counts by stress scenario",
      x = "Scenario",
      y = "Asset Count",
      fill = "Signal"
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 15, hjust = 1))

  ggplot2::ggsave(output_file, plot = p, width = 10, height = 6, dpi = 300)

  invisible(output_file)
}
