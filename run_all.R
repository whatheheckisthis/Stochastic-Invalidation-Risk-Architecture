source("scripts/01_load_data.R")
source("scripts/02_analysis.R")
source("scripts/03_visualize.R")

data_bundle <- load_stress_data(data_dir = "data", seed = 42)
analysis <- run_stress_analysis(data_bundle = data_bundle, n_sim = 10000, seed = 42)

cat("=== Scenario Summary ===\n")
print(analysis$summary)

plot_path <- plot_stress_signals(analysis, output_file = "output/sell_hold_signals.png")
if (!is.null(plot_path)) {
  cat(sprintf("Saved signal plot to: %s\n", plot_path))
}
