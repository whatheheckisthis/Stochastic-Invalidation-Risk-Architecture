# ============================================================================
# Script Name : run_all.R
# Purpose     : Orchestrate load -> analysis -> visualization workflow.
# Author      : Codex Assistant
# Created     : 2026-03-27
# R Version   : 3.6+
# ============================================================================

source("scripts/01_load_data.R")
source("scripts/02_analysis.R")
source("scripts/03_visualize.R")

loaded_data <- load_data(data_dir = "data", seed = 42)
analysis_results <- run_analysis(price_data = loaded_data$bond_prices)

cat("=== Analysis Summary ===\n")
print(analysis_results$summary)

output_file <- visualize_signals(
  analysis_results = analysis_results,
  output_dir = "output",
  filename = "sell_hold_signals.png"
)

cat(sprintf("Generated file: %s\n", output_file))
