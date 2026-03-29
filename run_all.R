# ============================================================================
# Script Name : run_all.R
# Purpose     : Orchestrate full SIRA load -> analysis -> visualization flow.
# ============================================================================

source("scripts/01_load_data.R")
source("scripts/02_analysis.R")
source("scripts/03_visualize.R")

loaded <- load_portfolio_data(data_dir = "data", seed = 20260329)
results <- run_sira_analysis(load_output = loaded, seed = 20260329)
plot_file <- visualize_sira(results_df = results, output_dir = "output", filename = "sell_hold_signals.png")

cat("SIRA run completed.\n")
cat(sprintf("Source: %s\n", loaded$metadata$source_file))
cat(sprintf("Assets: %d\n", loaded$metadata$row_count))
cat(sprintf("Output: %s\n", plot_file))
