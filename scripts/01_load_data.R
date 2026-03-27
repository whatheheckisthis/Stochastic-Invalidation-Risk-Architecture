# Load stress-scenario inputs for the distressed asset workflow.
# Supports CSV/RDS/RData drops in data/ and falls back to deterministic synthetic examples.

load_stress_data <- function(data_dir = "data", seed = 42) {
  set.seed(seed)

  if (!dir.exists(data_dir)) {
    stop(sprintf("Data directory not found: %s", data_dir))
  }

  csv_files <- list.files(data_dir, pattern = "\\.csv$", full.names = TRUE)
  rds_files <- list.files(data_dir, pattern = "\\.rds$", full.names = TRUE)
  rdata_files <- list.files(data_dir, pattern = "\\.RData$", full.names = TRUE)

  scenario_params <- data.frame(
    scenario = c(
      "Baseline",
      "Liquidity Crunch",
      "Jurisdictional Freeze",
      "Counterparty Default",
      "Hyper-Inflationary"
    ),
    recovery_distribution = c("beta", "beta", "beta", "power_law", "power_law"),
    rec_shape1 = c(7.5, 1.9, 0.4, 1.0, 1.1),
    rec_shape2 = c(3.0, 6.5, 9.5, 2.7, 2.4),
    volatility_mult = c(1.0, 2.2, 1.5, 2.8, 1.9),
    gap_down = c(0.00, 0.05, 0.30, 0.35, 0.12),
    fx_devaluation = c(0.00, 0.03, 0.08, 0.04, 0.38),
    ruin_threshold = c(0.30, 0.42, 0.90, 0.55, 0.63),
    stringsAsFactors = FALSE
  )

  portfolio <- data.frame(
    asset_id = sprintf("BOND-%03d", seq_len(120)),
    exposure_usd = runif(120, min = 1.8e6, max = 1.15e7),
    base_price = pmax(35, pmin(95, rnorm(120, mean = 71, sd = 12))),
    base_recovery = pmax(0.05, pmin(0.98, rbeta(120, shape1 = 4.2, shape2 = 3.4))),
    stringsAsFactors = FALSE
  )

  if (length(csv_files) > 0) {
    csv_data <- lapply(csv_files, utils::read.csv, stringsAsFactors = FALSE)
    named <- tools::file_path_sans_ext(basename(csv_files))
    names(csv_data) <- named
  } else {
    csv_data <- list()
  }

  if (length(rds_files) > 0) {
    rds_data <- lapply(rds_files, readRDS)
    named <- tools::file_path_sans_ext(basename(rds_files))
    names(rds_data) <- named
  } else {
    rds_data <- list()
  }

  if (length(rdata_files) > 0) {
    loaded_objects <- list()
    for (f in rdata_files) {
      env <- new.env(parent = emptyenv())
      load(f, envir = env)
      loaded_objects[[tools::file_path_sans_ext(basename(f))]] <- as.list(env)
    }
  } else {
    loaded_objects <- list()
  }

  list(
    scenario_params = scenario_params,
    portfolio = portfolio,
    source_files = list(csv = csv_data, rds = rds_data, rdata = loaded_objects)
  )
}
