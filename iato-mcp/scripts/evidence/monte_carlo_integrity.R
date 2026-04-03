#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(RcppTOML)
  library(base64enc)
})

TOML_PATH <- Sys.getenv("SIRA_TOML_PATH", file.path("config", "sira.toml"))
CFG <- RcppTOML::parseTOML(TOML_PATH)
SEED <- CFG$runtime$seed
N_SIM <- 10000L
PREFLIGHT <- file.path("iato-mcp", "scripts", "provision", "03_wsdl_preflight.sh")
TMP_DIR <- tempdir()

set.seed(SEED)

generate_payload <- function(scenario, index) {
  tmp <- file.path(TMP_DIR, sprintf("payload_%s_%05d.xml", scenario, index))

  content <- switch(
    scenario,
    "valid_reference" = sprintf(
      '<?xml version="1.0" encoding="UTF-8"?>\n<Result xmlns="http://www.shehzad.edu/webservice"><DressPerPrice><Name>Dress %d</Name><Price>%d</Price><ImageURL>https://cdn.example.com/img/%d.jpg</ImageURL></DressPerPrice></Result>',
      index,
      sample(1:999999, 1),
      index
    ),
    "hexbinary_violation" = sprintf(
      '<?xml version="1.0" encoding="UTF-8"?>\n<Result xmlns="http://www.shehzad.edu/webservice"><DressPerPrice><Name>Dress %d</Name><Price>%d</Price><Image>%s</Image></DressPerPrice></Result>',
      index,
      sample(1:999999, 1),
      paste(as.hexmode(sample(0:255, 64, replace = TRUE)), collapse = "")
    ),
    "inline_base64_violation" = sprintf(
      '<?xml version="1.0" encoding="UTF-8"?>\n<Result xmlns="http://www.shehzad.edu/webservice"><DressPerPrice><Name>Dress %d</Name><Price>%d</Price><Image>%s</Image></DressPerPrice></Result>',
      index,
      sample(1:999999, 1),
      base64enc::base64encode(as.raw(sample(0:255, 128, replace = TRUE)))
    ),
    "price_out_of_bounds" = sprintf(
      '<?xml version="1.0" encoding="UTF-8"?>\n<Result xmlns="http://www.shehzad.edu/webservice"><DressPerPrice><Name>Dress %d</Name><Price>%d</Price><ImageURL>https://cdn.example.com/img/%d.jpg</ImageURL></DressPerPrice></Result>',
      index,
      sample(c(sample(-999999:-1, 1), sample(1000000:9999999, 1)), 1),
      index
    ),
    "empty_name" = sprintf(
      '<?xml version="1.0" encoding="UTF-8"?>\n<Result xmlns="http://www.shehzad.edu/webservice"><DressPerPrice><Name></Name><Price>%d</Price><ImageURL>https://cdn.example.com/img/%d.jpg</ImageURL></DressPerPrice></Result>',
      sample(1:999999, 1),
      index
    )
  )

  writeLines(content, tmp)
  tmp
}

run_gate <- function(payload_path, config_path) {
  exit_code <- system2("bash", args = c(PREFLIGHT, payload_path, config_path), stdout = FALSE, stderr = FALSE)
  exit_code != 0
}

scenarios <- list(
  list(name = "valid_reference", expects_halt = FALSE, description = "Valid reference-mode payload — gate must pass"),
  list(name = "hexbinary_violation", expects_halt = TRUE, description = "hexBinary policy violation — gate must halt (POLICY-IMG-001)"),
  list(name = "inline_base64_violation", expects_halt = TRUE, description = "Inline base64 in reference mode — gate must halt (POLICY-IMG-002)"),
  list(name = "price_out_of_bounds", expects_halt = TRUE, description = "Price outside schema bounds — gate must halt"),
  list(name = "empty_name", expects_halt = TRUE, description = "Empty name element — gate must halt")
)

TEMP_CONFIG <- file.path(TMP_DIR, "test_config.xml")
writeLines('<?xml version="1.0"?><iato_config schema_version="1.0" policy_ref="POLICY-IMG-002-TEST"><service image_storage="reference"/></iato_config>', TEMP_CONFIG)

results <- lapply(scenarios, function(sc) {
  correct <- integer(N_SIM)
  cat(sprintf("\nScenario: %s\n", sc$description))
  cat(sprintf("Simulations: %d\n", N_SIM))

  for (i in seq_len(N_SIM)) {
    payload <- generate_payload(sc$name, i)
    gate_halted <- run_gate(payload, TEMP_CONFIG)
    correct[i] <- as.integer(gate_halted == sc$expects_halt)
    unlink(payload)
  }

  detection_rate <- mean(correct)
  z <- 1.96
  n <- N_SIM
  p <- detection_rate
  ci_lower <- (p + z^2 / (2 * n) - z * sqrt(p * (1 - p) / n + z^2 / (4 * n^2))) / (1 + z^2 / n)
  ci_upper <- (p + z^2 / (2 * n) + z * sqrt(p * (1 - p) / n + z^2 / (4 * n^2))) / (1 + z^2 / n)

  data.frame(
    Scenario = sc$name,
    Description = sc$description,
    N = N_SIM,
    Correct = sum(correct),
    Detection_Rate = round(detection_rate, 6),
    CI_Lower_95 = round(ci_lower, 6),
    CI_Upper_95 = round(ci_upper, 6),
    Gate_Reliable = detection_rate >= 0.999,
    stringsAsFactors = FALSE
  )
})

results_table <- do.call(rbind, results)

cat(strrep("═", 80), "\n")
cat("IĀTŌ MONTE CARLO EVIDENCE INTEGRITY REPORT\n")
cat(sprintf("Seed: %d  |  Simulations per scenario: %s\n", SEED, format(N_SIM, big.mark = ",")))
cat(strrep("═", 80), "\n")
print(results_table[, c("Scenario", "Detection_Rate", "CI_Lower_95", "CI_Upper_95", "Gate_Reliable")], row.names = FALSE)
cat(strrep("─", 80), "\n")

failed_gates <- results_table[!results_table$Gate_Reliable, "Scenario"]
if (length(failed_gates) > 0) {
  cat("EVIDENCE INTEGRITY HALT — Gates below 99.9% detection threshold:\n")
  cat(paste(" -", failed_gates, collapse = "\n"), "\n")
  quit(status = 1)
}

cat("All gates meet 99.9% detection threshold.\n")
cat("Evidence integrity: PASS\n")
cat(strrep("═", 80), "\n")

if (!dir.exists("output")) {
  dir.create("output", recursive = TRUE, showWarnings = FALSE)
}
OUTPUT_PATH <- file.path("output", sprintf("monte_carlo_integrity_%s.csv", format(Sys.time(), "%Y%m%dT%H%M%S")))
write.csv(results_table, OUTPUT_PATH, row.names = FALSE)
cat(sprintf("Results written to: %s\n", OUTPUT_PATH))
