# ============================================================================
# Script Name : 30_bs_core.R
# Purpose     : Black-Scholes-Merton pricing core with domain validation.
# ============================================================================

bsm_preflight_validate <- function(S, K, r, sigma, T, context = "bsm") {
  cat(sprintf("%s%s[BSM preflight] %s -- validating parameter domains%s\n",
              NEON$bold, NEON$cyan, context, NEON$reset))

  numeric_values <- c(S = S, K = K, r = r, sigma = sigma, T = T)
  if (any(!is.finite(numeric_values))) {
    stop(sprintf("[ERROR] %s contains non-finite parameters.", context))
  }
  if (S <= 0 || K <= 0) {
    stop(sprintf("[ERROR] %s requires S > 0 and K > 0.", context))
  }
  if (sigma <= 0) {
    stop(sprintf("[ERROR] %s requires sigma > 0.", context))
  }
  if (T <= 0) {
    stop(sprintf("[ERROR] %s requires T > 0.", context))
  }

  invisible(TRUE)
}

bsm_price_greeks <- function(S, K, r, sigma, T, context = "bsm") {
  S <- as.numeric(S)
  K <- as.numeric(K)
  r <- as.numeric(r)
  sigma <- as.numeric(sigma)
  T <- as.numeric(T)

  bsm_preflight_validate(S = S, K = K, r = r, sigma = sigma, T = T, context = context)

  d1 <- (log(S / K) + (r + 0.5 * sigma^2) * T) / (sigma * sqrt(T))
  d2 <- d1 - sigma * sqrt(T)

  call_price <- S * stats::pnorm(d1) - K * exp(-r * T) * stats::pnorm(d2)
  put_price <- K * exp(-r * T) * stats::pnorm(-d2) - S * stats::pnorm(-d1)

  delta_call <- stats::pnorm(d1)
  delta_put <- stats::pnorm(d1) - 1
  gamma <- stats::dnorm(d1) / (S * sigma * sqrt(T))
  vega <- S * stats::dnorm(d1) * sqrt(T)
  theta_call <- (-(S * stats::dnorm(d1) * sigma) / (2 * sqrt(T))) -
    (r * K * exp(-r * T) * stats::pnorm(d2))
  rho_call <- K * T * exp(-r * T) * stats::pnorm(d2)

  list(
    d1 = d1,
    d2 = d2,
    call_price = call_price,
    put_price = put_price,
    delta_call = delta_call,
    delta_put = delta_put,
    gamma = gamma,
    vega = vega,
    theta_call = theta_call,
    rho_call = rho_call
  )
}
