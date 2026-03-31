# ============================================================================
# Script Name : 00_env_check.R
# Purpose     : Terminal-native preflight checks for SIRA runtime.
# ============================================================================

run_env_check <- function() {
  ts <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(sprintf("[00/05] env_check -- %s\n", ts))

  config_path <- file.path("config", "sira.toml")
  manifest_path <- file.path("data", "manifest", "data_manifest.toml")
  checks <- list()

  ggplot_ok <- requireNamespace("ggplot2", quietly = TRUE)
  checks[["ggplot2 installed"]] <- ggplot_ok
  cat(sprintf("[CHECK] ggplot2 loadable -- %s\n", if (ggplot_ok) "PASS" else "FAIL"))

  toml_ok <- requireNamespace("RcppTOML", quietly = TRUE)
  checks[["RcppTOML installed"]] <- toml_ok
  cat(sprintf("[CHECK] RcppTOML loadable -- %s\n", if (toml_ok) "PASS" else "FAIL"))

  sha256_ok <- exists("sha256sum", where = asNamespace("tools"), mode = "function", inherits = FALSE)
  checks[["SHA-256 capability"]] <- sha256_ok
  cat(sprintf("[CHECK] base R SHA-256 (tools::sha256sum) -- %s\n", if (sha256_ok) "PASS" else "FAIL"))

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

  manifest_exists <- file.exists(manifest_path)
  checks[["manifest exists"]] <- manifest_exists
  cat(sprintf("[CHECK] %s exists -- %s\n", manifest_path, if (manifest_exists) "PASS" else "FAIL"))

  governance <- list(
    data_mode = "synthetic",
    manifest_version = NA_character_,
    files_verified = 0L,
    hash_warnings = 0L,
    approval_status = "incomplete",
    selected_file = NULL
  )

  if (toml_ok && manifest_exists) {
    manifest <- tryCatch(RcppTOML::parseTOML(manifest_path), error = function(e) NULL)
    manifest_parseable <- !is.null(manifest)
    checks[["manifest parseable"]] <- manifest_parseable
    cat(sprintf("[CHECK] %s parseable -- %s\n", manifest_path, if (manifest_parseable) "PASS" else "FAIL"))

    if (manifest_parseable) {
      governance$manifest_version <- as.character(manifest$manifest$schema_version)

      entries <- manifest$files
      if (is.null(entries)) {
        entries <- list()
      } else if (!is.list(entries) || !is.list(entries[[1]])) {
        entries <- list(entries)
      }

      active_entries <- Filter(function(x) identical(as.character(x$status), "active"), entries)

      has_live <- FALSE
      live_hash_failed <- FALSE
      live_hash_passed <- FALSE

      for (entry in active_entries) {
        rel <- as.character(entry$relative_path)
        mode <- as.character(entry$mode)
        hash_declared <- trimws(as.character(entry$hash_sha256))
        exists_on_disk <- nzchar(rel) && file.exists(rel)

        if (!exists_on_disk) {
          checks[[sprintf("manifest file exists: %s", entry$file_id)]] <- FALSE
          cat(sprintf("[CHECK] manifest file %s exists -- FAIL (%s)\n", entry$file_id, rel))
          next
        }

        checks[[sprintf("manifest file exists: %s", entry$file_id)]] <- TRUE
        cat(sprintf("[CHECK] manifest file %s exists -- PASS (%s)\n", entry$file_id, rel))
        governance$files_verified <- governance$files_verified + 1L

        hash_verified <- FALSE
        if (nzchar(hash_declared)) {
          actual <- unname(as.character(tools::sha256sum(rel)))
          hash_verified <- identical(tolower(actual), tolower(hash_declared))

          if (!hash_verified) {
            governance$hash_warnings <- governance$hash_warnings + 1L
            cat(sprintf("[WARN] hash mismatch for %s (%s)\n", entry$file_id, rel))
          }
        } else {
          governance$hash_warnings <- governance$hash_warnings + 1L
          cat(sprintf("[WARN] hash missing for %s (%s)\n", entry$file_id, rel))
        }

        if (identical(mode, "live")) {
          has_live <- TRUE
          if (nzchar(hash_declared) && hash_verified) {
            live_hash_passed <- TRUE
          } else {
            live_hash_failed <- TRUE
          }
        }

        if (is.null(governance$selected_file) && mode == governance$data_mode) {
          governance$selected_file <- entry
        }
      }

      if (has_live && live_hash_failed) {
        stop("[ERROR] Live data present but hash verification failed/incomplete; halting before fallback.")
      }

      if (has_live && live_hash_passed) {
        governance$data_mode <- "live"
        live_candidates <- Filter(function(x) {
          identical(as.character(x$status), "active") && identical(as.character(x$mode), "live")
        }, entries)
        if (length(live_candidates) > 0) {
          governance$selected_file <- live_candidates[[1]]
        }
      } else {
        syn_candidates <- Filter(function(x) {
          identical(as.character(x$status), "active") && identical(as.character(x$mode), "synthetic")
        }, entries)
        governance$data_mode <- "synthetic"
        if (length(syn_candidates) > 0) {
          governance$selected_file <- syn_candidates[[1]]
        }
      }

      governance$approval_status <- if (governance$hash_warnings == 0L) "complete" else "incomplete"

      cat(sprintf("[DATA] data_mode=%s | manifest_version=%s | files_verified=%d | hash_warnings=%d | approval_status=%s\n",
                  governance$data_mode,
                  governance$manifest_version,
                  governance$files_verified,
                  governance$hash_warnings,
                  governance$approval_status))
    }
  } else {
    checks[["manifest parseable"]] <- FALSE
    cat(sprintf("[CHECK] %s parseable -- FAIL\n", manifest_path))
  }

  if (!all(unlist(checks))) {
    message("[ERROR] Environment preflight failed; aborting run.")
    quit(save = "no", status = 1)
  }

  cat("[00/05] env_check -- complete\n")
  invisible(governance)
}
