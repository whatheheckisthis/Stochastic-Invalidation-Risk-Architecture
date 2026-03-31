# ============================================================================
# Script Name : run_all.R
# Purpose     : Terminal-native orchestration for full SIRA workflow.
# ============================================================================

ptm <- proc.time()

safe_stage <- function(stage_name, expr) {
  tryCatch(
    expr,
    error = function(e) {
      if (exists("NEON", inherits = TRUE)) {
        message(sprintf("%s%s[ERROR] %s failed -- %s%s", NEON$bold, NEON$red, stage_name, conditionMessage(e), NEON$reset))
      } else {
        message(sprintf("[ERROR] %s failed -- %s", stage_name, conditionMessage(e)))
      }
      elapsed <- proc.time() - ptm
      if (exists("NEON", inherits = TRUE)) {
        cat(sprintf("%s==============================================%s\n", NEON$bold, NEON$reset))
        cat(sprintf("%sElapsed: %.2fs | Exit status: FAILURE%s\n", NEON$bold, as.numeric(elapsed["elapsed"]), NEON$reset))
        cat(sprintf("%s==============================================%s\n", NEON$bold, NEON$reset))
      } else {
        cat("==============================================\n")
        cat(sprintf("Elapsed: %.2fs | Exit status: FAILURE\n", as.numeric(elapsed["elapsed"])))
        cat("==============================================\n")
      }
      quit(save = "no", status = 1)
    }
  )
}

safe_stage("source scripts/00_env_check.R", source("scripts/00_env_check.R"))
preflight <- safe_stage("env_check", run_env_check())
safe_stage("source scripts/00_config.R", source("scripts/00_config.R"))
safe_stage("config_load", load_sira_config())
safe_stage("source scripts/01_load_data.R", source("scripts/01_load_data.R"))
safe_stage("source scripts/02_analysis.R", source("scripts/02_analysis.R"))
safe_stage("source scripts/03_visualize.R", source("scripts/03_visualize.R"))
safe_stage("source scripts/10_liability_engine.R", source("scripts/10_liability_engine.R"))
safe_stage("source scripts/11_credit_deployment.R", source("scripts/11_credit_deployment.R"))
safe_stage("source scripts/12_spread_stress.R", source("scripts/12_spread_stress.R"))
safe_stage("source scripts/13_capital_stack_viz.R", source("scripts/13_capital_stack_viz.R"))
safe_stage("source scripts/20_dcf.R", source("scripts/20_dcf.R"))
safe_stage("source scripts/21_ma.R", source("scripts/21_ma.R"))
safe_stage("source scripts/22_accretion.R", source("scripts/22_accretion.R"))
safe_stage("source scripts/23_lbo.R", source("scripts/23_lbo.R"))
safe_stage("source scripts/24_irr.R", source("scripts/24_irr.R"))
safe_stage("source scripts/25_deal_summary.R", source("scripts/25_deal_summary.R"))

run_start <- Sys.time()
cat(sprintf("%s%s==============================================%s\n", NEON$bold, NEON$cyan, NEON$reset))
cat(sprintf("%s%sStochastic Invalidation & Risk Architecture%s\n", NEON$bold, NEON$cyan, NEON$reset))
cat(sprintf("%s%sRuntime: %s%s\n", NEON$bold, NEON$cyan, R.version.string, NEON$reset))
cat(sprintf("%s%sStarted: %s%s\n", NEON$bold, NEON$cyan, format(run_start, "%Y-%m-%d %H:%M:%S"), NEON$reset))
cat(sprintf("%s%s==============================================%s\n", NEON$bold, NEON$cyan, NEON$reset))

loaded <- safe_stage("load_data", load_portfolio_data(preflight = preflight))
cat(sprintf("%s%sData mode: %s%s\n", NEON$bold, NEON$cyan, loaded$metadata$data_mode, NEON$reset))
cat(sprintf("%s%sData file_id: %s | lineage_ref: %s | manifest_version: %s | hash_verified: %s%s\n",
            NEON$bold,
            NEON$cyan,
            loaded$metadata$file_id,
            loaded$metadata$lineage_ref,
            loaded$metadata$manifest_version,
            as.character(loaded$metadata$hash_verified),
            NEON$reset))

data_governance_artifact <- file.path(CFG$data$output_path, "data_governance_metadata.rds")
saveRDS(loaded$metadata, data_governance_artifact)
cat(sprintf("%sData governance metadata: %s%s\n", NEON$green, data_governance_artifact, NEON$reset))

results <- safe_stage("analysis", run_sira_analysis(load_output = loaded))
plot_file <- safe_stage("visualize", visualize_sira(results_df = results))
spread_results <- safe_stage("spread_stress", run_spread_stress(core_results_df = results))
capital_outputs <- safe_stage("capital_stack_viz", visualize_capital_stack(spread_stress_output = spread_results))
dcf_results <- safe_stage("dcf_engine", run_dcf_engine(core_results_df = results, load_output = loaded))
ma_results <- safe_stage("ma_engine", run_ma_engine(dcf_results_df = dcf_results))
accretion_results <- safe_stage("accretion_engine", run_accretion_engine(spread_stress_output = spread_results))
lbo_results <- safe_stage("lbo_engine", run_lbo_engine(dcf_results_df = dcf_results))
irr_results <- safe_stage("irr_engine", run_irr_engine(core_results_df = results))
deal_summary <- safe_stage(
  "deal_summary",
  run_deal_summary(
    core_results_df = results,
    spread_stress_output = spread_results,
    dcf_results = dcf_results,
    ma_results = ma_results,
    accretion_results = accretion_results,
    lbo_results = lbo_results,
    irr_results = irr_results
  )
)

elapsed <- proc.time() - ptm
cat(sprintf("%s==============================================%s\n", NEON$bold, NEON$reset))
cat(sprintf("%sSIRA run completed%s\n", NEON$bold, NEON$reset))
cat(sprintf("%sFinished: %s%s\n", NEON$bold, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))
cat(sprintf("%sElapsed: %.2fs%s\n", NEON$bold, as.numeric(elapsed["elapsed"]), NEON$reset))
cat(sprintf("%sOutput: %s%s\n", NEON$green, plot_file, NEON$reset))
cat(sprintf("%sCapital stack plot: %s%s\n", NEON$green, capital_outputs$plot_path, NEON$reset))
cat(sprintf("%sCapital stack metadata: %s%s\n", NEON$green, capital_outputs$metadata_path, NEON$reset))
cat(sprintf("%sDeal intelligence metadata: %s%s\n", NEON$green, deal_summary$metadata_path, NEON$reset))
cat(sprintf("%sDeal worst-case: %s | dominant risk: %s%s\n", NEON$yellow, deal_summary$worst_case, deal_summary$dominant_risk, NEON$reset))
cat(sprintf("%sExit status: SUCCESS%s\n", NEON$bold, NEON$reset))
cat(sprintf("%s==============================================%s\n", NEON$bold, NEON$reset))
