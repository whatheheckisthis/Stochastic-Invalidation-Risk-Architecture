# ============================================================================
# Script Name : 01_load_data.R
# Purpose     : Load distressed-asset price data from data/.
#               If no CSV is provided, build a synthetic default series.
# Author      : Codex Assistant
# Created     : 2026-03-27
# R Version   : 3.6+
# ============================================================================

load_data <- function(data_dir = "data", seed = 42) {
  set.seed(seed)

  if (!dir.exists(data_dir)) {
    dir.create(data_dir, recursive = TRUE)
  }

  csv_files <- list.files(data_dir, pattern = "\\.csv$", full.names = TRUE)

  if (length(csv_files) > 0) {
    raw_data <- utils::read.csv(csv_files[1], stringsAsFactors = FALSE)

    if ("price" %in% names(raw_data)) {
      price_vector <- as.numeric(raw_data$price)
    } else {
      first_col <- raw_data[[1]]
      price_vector <- as.numeric(first_col)
    }

    price_vector <- price_vector[!is.na(price_vector)]

    if (length(price_vector) == 0) {
      stop("Input CSV does not contain numeric price observations.")
    }
  } else {
    number_of_days <- 1000L
    price_vector <- numeric(number_of_days)
    price_vector[1] <- 1.0

    for (day_index in 2:number_of_days) {
      daily_step <- rnorm(1, mean = 0, sd = 0.02)
      price_vector[day_index] <- max(0, price_vector[day_index - 1] + daily_step)
    }
  }

  list(
    bond_prices = price_vector,
    source_file = if (length(csv_files) > 0) csv_files[1] else "synthetic_default"
  )
}
