# ============================================================================
# Script Name : 00_env_check.R
# Purpose     : Terminal-native preflight checks for SIRA runtime.
# ============================================================================

run_env_check <- function() {
  ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(sprintf("[00/05] env_check -- %s\n", ts))

  config_path <- file.path("config", "sira.toml")
  checks <- list()

  ggplot_ok <- requireNamespace("ggplot2", quietly = TRUE)
  checks[["ggplot2 installed"]] <- ggplot_ok
  cat(sprintf("[CHECK] ggplot2 loadable -- %s\n", if (ggplot_ok) "PASS" else "FAIL"))

  toml_ok <- requireNamespace("RcppTOML", quietly = TRUE)
  checks[["RcppTOML installed"]] <- toml_ok
  cat(sprintf("[CHECK] RcppTOML loadable -- %s\n", if (toml_ok) "PASS" else "FAIL"))

  data_dir <- "data"
  data_exists <- dir.exists(data_dir)
  data_readable <- data_exists && file.access(data_dir, mode = 4) == 0
  checks[["data dir readable"]] <- data_readable
  cat(sprintf("[CHECK] %s exists/readable -- %s\n", data_dir, if (data_readable) "PASS" else "FAIL"))

  output_dir <- "output"
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  }
  output_writable <- dir.exists(output_dir) && file.access(output_dir, mode = 2) == 0
  checks[["output dir writable"]] <- output_writable
  cat(sprintf("[CHECK] %s exists/writable -- %s\n", output_dir, if (output_writable) "PASS" else "FAIL"))

  config_exists <- file.exists(config_path)
  checks[["config exists"]] <- config_exists
  cat(sprintf("[CHECK] %s exists -- %s\n", config_path, if (config_exists) "PASS" else "FAIL"))

  cfg_preview <- NULL
  config_parseable <- FALSE
  if (toml_ok && config_exists) {
    cfg_preview <- tryCatch(RcppTOML::parseTOML(config_path), error = function(e) NULL)
    config_parseable <- !is.null(cfg_preview)
  }
  checks[["config parseable"]] <- config_parseable
  cat(sprintf("[CHECK] %s parseable -- %s\n", config_path, if (config_parseable) "PASS" else "FAIL"))

  r_ok <- FALSE
  if (config_parseable) {
    min_required <- as.character(cfg_preview$runtime$min_r_version)
    current_r <- getRversion()
    r_ok <- current_r >= as.numeric_version(min_required)
    checks[["R version"]] <- r_ok
    cat(sprintf("[CHECK] R version >= %s -- %s (current: %s)\n",
                min_required, if (r_ok) "PASS" else "FAIL", as.character(current_r)))

    top_keys <- names(cfg_preview)
    scenario_count <- length(cfg_preview$scenarios$names)
    cat(sprintf("[CONFIG] top_keys=%s | scenarios=%d | data_path=%s | output_path=%s\n",
                paste(top_keys, collapse = ","),
                scenario_count,
                cfg_preview$data$path,
                cfg_preview$data$output_path))
  }

  if (!all(unlist(checks))) {
    message("[ERROR] Environment preflight failed; aborting run.")
    quit(save = "no", status = 1)
  }

  cat("[00/05] env_check -- complete\n")
  invisible(TRUE)
}
