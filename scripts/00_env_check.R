# ============================================================================
# Script Name : 00_env_check.R
# Purpose     : Terminal-native preflight checks for SIRA runtime.
# ============================================================================

run_env_check <- function(min_r_version = "4.0.0", data_dir = "data", output_dir = "output") {
  ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(sprintf("[00/04] env_check -- %s\n", ts))

  checks <- list()

  current_r <- getRversion()
  checks[["R version"]] <- current_r >= as.numeric_version(min_r_version)
  cat(sprintf("[CHECK] R version >= %s -- %s (current: %s)\n",
              min_r_version,
              if (checks[["R version"]]) "PASS" else "FAIL",
              as.character(current_r)))

  ggplot_ok <- requireNamespace("ggplot2", quietly = TRUE)
  checks[["ggplot2 installed"]] <- ggplot_ok
  cat(sprintf("[CHECK] ggplot2 loadable -- %s\n", if (ggplot_ok) "PASS" else "FAIL"))

  data_exists <- dir.exists(data_dir)
  data_readable <- data_exists && file.access(data_dir, mode = 4) == 0
  checks[["data dir readable"]] <- data_readable
  cat(sprintf("[CHECK] %s exists/readable -- %s\n", data_dir, if (data_readable) "PASS" else "FAIL"))

  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  }
  output_writable <- dir.exists(output_dir) && file.access(output_dir, mode = 2) == 0
  checks[["output dir writable"]] <- output_writable
  cat(sprintf("[CHECK] %s exists/writable -- %s\n", output_dir, if (output_writable) "PASS" else "FAIL"))

  if (!all(unlist(checks))) {
    message("[FATAL] Environment preflight failed; aborting run.")
    quit(save = "no", status = 1)
  }

  cat("[00/04] env_check -- complete\n")
  invisible(TRUE)
}
