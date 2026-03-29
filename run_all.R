# ============================================================================
# Script Name : run_all.R
# Purpose     : Terminal-native orchestration for full SIRA workflow.
# ============================================================================

run_start <- Sys.time()
ptm <- proc.time()

cat("==============================================\n")
cat("Stochastic Invalidation & Risk Architecture\n")
cat(sprintf("Runtime: %s\n", R.version.string))
cat(sprintf("Started: %s\n", format(run_start, "%Y-%m-%d %H:%M:%S")))
cat("==============================================\n")

safe_stage <- function(stage_name, expr) {
  tryCatch(
    expr,
    error = function(e) {
      message(sprintf("[FATAL] %s failed -- %s", stage_name, conditionMessage(e)))
      elapsed <- proc.time() - ptm
      cat("==============================================\n")
      cat(sprintf("Exit status: FAILURE\nElapsed: %.2fs\n", as.numeric(elapsed["elapsed"])))
      cat("==============================================\n")
      quit(save = "no", status = 1)
    }
  )
}

safe_stage("source scripts/00_env_check.R", source("scripts/00_env_check.R"))
safe_stage("env_check", run_env_check(min_r_version = "4.0.0", data_dir = "data", output_dir = "output"))

safe_stage("source scripts/01_load_data.R", source("scripts/01_load_data.R"))
safe_stage("source scripts/02_analysis.R", source("scripts/02_analysis.R"))
safe_stage("source scripts/03_visualize.R", source("scripts/03_visualize.R"))

loaded <- safe_stage("load_data", load_portfolio_data(data_dir = "data", seed = 20260329))
cat(sprintf("Data mode: %s\n", loaded$metadata$data_mode))

results <- safe_stage("analysis", run_sira_analysis(load_output = loaded, seed = 20260329))
plot_file <- safe_stage("visualize", visualize_sira(results_df = results, output_dir = "output", filename = "sell_hold_signals.png"))

elapsed <- proc.time() - ptm
cat("==============================================\n")
cat("SIRA run completed\n")
cat(sprintf("Finished: %s\n", format(Sys.time(), "%Y-%m-%d %H:%M:%S")))
cat(sprintf("Elapsed: %.2fs\n", as.numeric(elapsed["elapsed"])))
cat(sprintf("Output: %s\n", plot_file))
cat("Exit status: SUCCESS\n")
cat("==============================================\n")
