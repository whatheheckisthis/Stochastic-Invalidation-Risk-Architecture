# ============================================================================
# Script Name : 00_config.R
# Purpose     : Load TOML configuration and define terminal color palette.
# ============================================================================

load_sira_config <- function() {
  config_path <- file.path("config", "sira.toml")
  CFG <<- RcppTOML::parseTOML(config_path)

  NEON <<- if (isatty(stdout())) {
    list(
      cyan = "\033[96m",
      magenta = "\033[95m",
      yellow = "\033[93m",
      green = "\033[92m",
      red = "\033[91m",
      reset = "\033[0m",
      bold = "\033[1m"
    )
  } else {
    list(
      cyan = "",
      magenta = "",
      yellow = "",
      green = "",
      red = "",
      reset = "",
      bold = ""
    )
  }

  cat(sprintf("[CONFIG] sira.toml loaded -- %d top-level keys\n", length(names(CFG))))
  invisible(CFG)
}
