# ============================================================================
# Script Name : 34_vol_surface.R
# Purpose     : Scenario-implied volatility surface for option modules.
# ============================================================================

build_vol_surface <- function() {
  cat(sprintf("%s%s[34/34] vol_surface -- %s%s\n",
              NEON$bold, NEON$cyan, format(Sys.time(), "%Y-%m-%d %H:%M:%S"), NEON$reset))

  cfg <- CFG$vol_surface
  scenario_names <- CFG$scenarios$names

  base_firm_vol <- as.numeric(cfg$base_firm_vol)
  base_equity_vol <- as.numeric(cfg$base_equity_vol)
  base_portfolio_vol <- as.numeric(cfg$base_portfolio_vol)

  rows <- lapply(scenario_names, function(sc) {
    key <- gsub("-", "_", gsub(" ", "_", sc))
    sc_cfg <- CFG$scenarios[[key]]
    shock_multiplier <- as.numeric(sc_cfg$shock_multiplier)
    fx_devaluation <- if (is.null(sc_cfg$fx_devaluation)) 0 else as.numeric(sc_cfg$fx_devaluation)

    firm_sigma <- base_firm_vol * shock_multiplier
    equity_sigma <- base_equity_vol * shock_multiplier
    portfolio_sigma <- base_portfolio_vol * shock_multiplier

    if (sc == "Counterparty Default") {
      exponent <- as.numeric(sc_cfg$exponent)
      tail_factor <- 1 + (1 / max(exponent, 1e-6))
      firm_sigma <- firm_sigma * tail_factor
      equity_sigma <- equity_sigma * tail_factor
      portfolio_sigma <- portfolio_sigma * tail_factor
    }

    if (sc == "Hyper-Inflationary") {
      inflation_factor <- 1 + fx_devaluation
      firm_sigma <- firm_sigma * inflation_factor
      equity_sigma <- equity_sigma * inflation_factor
      portfolio_sigma <- portfolio_sigma * inflation_factor
    }

    data.frame(
      scenario = sc,
      firm_sigma = pmax(firm_sigma, 1e-6),
      equity_sigma = pmax(equity_sigma, 1e-6),
      portfolio_sigma = pmax(portfolio_sigma, 1e-6),
      stringsAsFactors = FALSE
    )
  })

  out_df <- do.call(rbind, rows)
  cat(sprintf("%s%s[34/34] vol_surface -- complete -- scenarios=%d%s\n",
              NEON$bold, NEON$cyan, nrow(out_df), NEON$reset))
  out_df
}
