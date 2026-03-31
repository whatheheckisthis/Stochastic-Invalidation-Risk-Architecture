# ============================================================================
# Script Name : 01_load_data.R
# Purpose     : Load portfolio data from governed manifest-selected source.
# ============================================================================

load_portfolio_data <- function(preflight) {
  cat(sprintf("%s%s[01/03] load_data -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  if (missing(preflight) || is.null(preflight$data_mode)) {
    stop("[ERROR] preflight data_mode is required; refusing to re-derive mode in load stage.")
  }

  set.seed(as.integer(CFG$runtime$seed))

  manifest_path <- file.path("data", "manifest", "data_manifest.toml")
  manifest <- tryCatch(RcppTOML::parseTOML(manifest_path), error = function(e) NULL)
  if (is.null(manifest)) {
    stop("[ERROR] data manifest is not parseable at load stage.")
  }

  entries <- manifest$files
  if (is.null(entries)) {
    entries <- list()
  } else if (!is.list(entries) || !is.list(entries[[1]])) {
    entries <- list(entries)
  }

  selected_mode <- as.character(preflight$data_mode)
  active_mode_entries <- Filter(function(x) {
    identical(as.character(x$status), "active") && identical(as.character(x$mode), selected_mode)
  }, entries)

  if (length(active_mode_entries) == 0) {
    stop(sprintf("[ERROR] No active manifest entries found for data_mode=%s", selected_mode))
  }

  entry <- active_mode_entries[[1]]
  source_file <- as.character(entry$relative_path)
  if (!file.exists(source_file)) {
    stop(sprintf("[ERROR] Declared manifest source missing: %s", source_file))
  }

  raw_df <- tryCatch(utils::read.csv(source_file, stringsAsFactors = FALSE), error = function(e) NULL)
  if (is.null(raw_df) || !is.data.frame(raw_df) || nrow(raw_df) == 0) {
    stop(sprintf("[ERROR] Unable to load governed dataset: %s", source_file))
  }

  normalize_portfolio <- function(df) {
    nm <- tolower(names(df))
    names(df) <- nm
    n <- nrow(df)

    out <- data.frame(
      asset_id = if ("asset_id" %in% nm) as.character(df$asset_id) else sprintf("BOND_%03d", seq_len(n)),
      issuer = if ("issuer" %in% nm) as.character(df$issuer) else sprintf("Issuer_%02d", (seq_len(n) %% 10) + 1),
      currency = if ("currency" %in% nm) as.character(df$currency) else "USD",
      region = if ("region" %in% nm) as.character(df$region) else "NA",
      sector = if ("sector" %in% nm) as.character(df$sector) else "Corporate",
      notional = if ("notional" %in% nm) as.numeric(df$notional) else if ("face_value" %in% nm) as.numeric(df$face_value) else rep(100, n),
      price = if ("price" %in% nm) as.numeric(df$price) else if ("recovery_anchor" %in% nm) as.numeric(df$recovery_anchor) * 100 else rep(95, n),
      coupon = if ("coupon" %in% nm) as.numeric(df$coupon) else rep(0.05, n),
      maturity_years = if ("maturity_years" %in% nm) as.numeric(df$maturity_years) else rep(5, n),
      rating = if ("rating" %in% nm) as.character(df$rating) else rep("BBB", n),
      stringsAsFactors = FALSE
    )

    out$price[is.na(out$price) | !is.finite(out$price)] <- 95
    out$notional[is.na(out$notional) | !is.finite(out$notional)] <- 100

    if ("recovery_anchor" %in% nm) {
      out$recovery_anchor <- pmin(0.95, pmax(0.05, as.numeric(df$recovery_anchor)))
    } else {
      out$recovery_anchor <- pmin(0.95, pmax(0.05, out$price / 100))
    }

    out
  }

  portfolio <- normalize_portfolio(raw_df)

  if (selected_mode == "live") {
    cat(sprintf("%s%s[LIVE MODE] Run is using governed live data (%s).%s\n",
                NEON$bold, NEON$yellow, source_file, NEON$reset))
  } else {
    cat(sprintf("%s%s[SYNTHETIC MODE] Run is using governed synthetic data. Live decision usage requires operator disclosure and approval. See data/manifest/data_manifest.toml.%s\n",
                NEON$bold, NEON$yellow, NEON$reset))
  }

  cat(sprintf("%s%s[01/03] load_data -- complete -- rows=%d assets=%d%s\n",
              NEON$bold, NEON$cyan, nrow(portfolio), length(unique(portfolio$asset_id)), NEON$reset))

  list(
    portfolio = portfolio,
    metadata = list(
      source_file = source_file,
      generated_at_utc = as.character(Sys.time()),
      seed = as.integer(CFG$runtime$seed),
      row_count = nrow(portfolio),
      data_mode = selected_mode,
      file_id = as.character(entry$file_id),
      lineage_ref = as.character(entry$lineage_ref),
      manifest_version = as.character(manifest$manifest$schema_version),
      hash_verified = isTRUE(preflight$hash_warnings == 0L)
    )
  )
}
