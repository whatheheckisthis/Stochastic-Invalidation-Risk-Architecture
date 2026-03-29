# ============================================================================
# Script Name : 01_load_data.R
# Purpose     : Load portfolio data from /data or create deterministic fallback.
# ============================================================================

load_portfolio_data <- function(data_dir = "data", seed = 20260329) {
  cat(sprintf("[01/03] load_data -- %s\n", format(Sys.time(), "%Y-%m-%d %H:%M:%S")))
  set.seed(seed)

  if (!dir.exists(data_dir)) {
    dir.create(data_dir, recursive = TRUE)
  }

  recognized <- list.files(
    data_dir,
    pattern = "\\.(csv|rds|RData|rda)$",
    ignore.case = TRUE,
    full.names = TRUE
  )

  normalize_portfolio <- function(df) {
    if (!is.data.frame(df) || nrow(df) == 0) {
      return(NULL)
    }

    nm <- tolower(names(df))
    names(df) <- nm

    n <- nrow(df)

    out <- data.frame(
      asset_id = if ("asset_id" %in% nm) as.character(df$asset_id) else sprintf("BOND_%03d", seq_len(n)),
      issuer = if ("issuer" %in% nm) as.character(df$issuer) else sprintf("Issuer_%02d", (seq_len(n) %% 10) + 1),
      currency = if ("currency" %in% nm) as.character(df$currency) else "USD",
      region = if ("region" %in% nm) as.character(df$region) else "NA",
      sector = if ("sector" %in% nm) as.character(df$sector) else "Corporate",
      notional = if ("notional" %in% nm) as.numeric(df$notional) else rep(100, n),
      price = if ("price" %in% nm) as.numeric(df$price) else rep(95, n),
      coupon = if ("coupon" %in% nm) as.numeric(df$coupon) else rep(0.05, n),
      maturity_years = if ("maturity_years" %in% nm) as.numeric(df$maturity_years) else rep(5, n),
      rating = if ("rating" %in% nm) as.character(df$rating) else rep("BBB", n),
      stringsAsFactors = FALSE
    )

    out$price[is.na(out$price)] <- median(out$price, na.rm = TRUE)
    out$price[!is.finite(out$price)] <- 95
    out$notional[is.na(out$notional)] <- 100
    out$notional[!is.finite(out$notional)] <- 100

    out$recovery_anchor <- pmin(0.95, pmax(0.05, out$price / 100))

    out
  }

  portfolio <- NULL
  source_file <- "synthetic_default"
  data_mode <- "synthetic"

  if (length(recognized) > 0) {
    for (f in recognized) {
      ext <- tolower(sub("^.*\\.", "", f))
      candidate <- NULL

      if (ext == "csv") {
        candidate <- tryCatch(utils::read.csv(f, stringsAsFactors = FALSE), error = function(e) NULL)
      } else if (ext == "rds") {
        candidate <- tryCatch(readRDS(f), error = function(e) NULL)
      } else if (ext %in% c("rdata", "rda")) {
        env <- new.env(parent = emptyenv())
        ok <- tryCatch({
          load(f, envir = env)
          TRUE
        }, error = function(e) FALSE)

        if (ok) {
          objs <- mget(ls(env), envir = env)
          idx <- which(vapply(objs, is.data.frame, logical(1L)))
          if (length(idx) > 0) {
            candidate <- objs[[idx[1]]]
          }
        }
      }

      normalized <- normalize_portfolio(candidate)
      if (!is.null(normalized)) {
        portfolio <- normalized
        source_file <- f
        data_mode <- "live"
        break
      }
    }
  }

  if (is.null(portfolio)) {
    cat("[WARN] No data in /data — synthetic defaults active\n")

    asset_n <- 24L
    issuer_pool <- c("Andes Capital", "BlueHarbor", "Crux Lending", "Deltaline", "Eastbridge")
    ccy_pool <- c("USD", "EUR", "GBP", "JPY", "BRL")
    region_pool <- c("NA", "EU", "APAC", "LATAM")
    sector_pool <- c("Corporate", "Sovereign", "Financial", "Utility")
    rating_pool <- c("AAA", "AA", "A", "BBB", "BB")

    portfolio <- data.frame(
      asset_id = sprintf("BOND_%03d", seq_len(asset_n)),
      issuer = sample(issuer_pool, asset_n, replace = TRUE),
      currency = sample(ccy_pool, asset_n, replace = TRUE),
      region = sample(region_pool, asset_n, replace = TRUE),
      sector = sample(sector_pool, asset_n, replace = TRUE),
      notional = round(runif(asset_n, min = 40, max = 250), 2),
      price = round(runif(asset_n, min = 62, max = 104), 2),
      coupon = round(runif(asset_n, min = 0.015, max = 0.09), 4),
      maturity_years = sample(1:12, asset_n, replace = TRUE),
      rating = sample(rating_pool, asset_n, replace = TRUE),
      stringsAsFactors = FALSE
    )

    portfolio$recovery_anchor <- pmin(0.95, pmax(0.05, portfolio$price / 100))
  }

  cat(sprintf("[01/03] load_data -- complete -- rows=%d assets=%d\n", nrow(portfolio), length(unique(portfolio$asset_id))))

  list(
    portfolio = portfolio,
    metadata = list(
      source_file = source_file,
      generated_at_utc = as.character(Sys.time()),
      seed = seed,
      row_count = nrow(portfolio),
      data_mode = data_mode
    )
  )
}
