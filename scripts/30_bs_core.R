# ============================================================================
# Script Name : 30_bs_core.R
# Purpose     : Rigorous Black-Scholes-Merton core derived from PDE framework.
#
# GBM dynamics (physical measure):
#   dS_t = mu * S_t dt + sigma * S_t dW_t
# GBM dynamics (risk-neutral measure Q):
#   dS_t = r  * S_t dt + sigma * S_t dW_t^Q
#
# Therefore terminal state under Q:
#   S_T = S_t * exp((r - sigma^2/2) * (T - t) + sigma * (W_T^Q - W_t^Q))
# S_T is log-normal under Q. The physical drift mu is eliminated by change of
# measure; this is a governance feature for SIRA because mu is unobservable.
#
# Black-Scholes PDE (call value C(S,t)):
#   rS * dC/dS + dC/dt + (1/2) * sigma^2 * S^2 * d2C/dS2 - rC = 0
# Boundary conditions:
#   C(S,T) = max(S-K, 0), C(0,t)=0, C(S,t)->S as S->infinity.
# Put prices are derived via put-call parity for internal consistency.
# ============================================================================

bsm_log_halt <- function(message_text, context = "bsm") {
  out_dir <- sub("/$", "", CFG$data$output_path)
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  log_file <- file.path(out_dir, "bsm_preflight_halts.log")
  stamp <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  cat(sprintf("%s | %s | %s\n", stamp, context, message_text), file = log_file, append = TRUE)
}

bsm_preflight_validate <- function(S, K, r, sigma, T, q = 0, context = "bsm") {
  cat(sprintf("%s%s[BSM preflight] %s -- validating parameter domains%s\n",
              NEON$bold, NEON$cyan, context, NEON$reset))

  numeric_values <- c(S = S, K = K, r = r, sigma = sigma, T = T, q = q)
  if (any(!is.finite(numeric_values))) {
    msg <- "Non-finite input detected — BSM undefined"
    bsm_log_halt(msg, context)
    stop(msg)
  }
  if (T <= 0) {
    msg <- "Option expired or invalid maturity — BSM undefined"
    bsm_log_halt(msg, context)
    stop(msg)
  }
  if (sigma <= 0) {
    msg <- "Zero or negative volatility — BSM undefined"
    bsm_log_halt(msg, context)
    stop(msg)
  }
  if (S <= 0) {
    msg <- "Invalid underlying level S <= 0 — BSM undefined"
    bsm_log_halt(msg, context)
    stop(msg)
  }
  if (K <= 0) {
    msg <- "Invalid strike K <= 0 — BSM undefined"
    bsm_log_halt(msg, context)
    stop(msg)
  }

  ratio <- S / K
  if (!is.finite(log(ratio))) {
    msg <- "Invalid log(S/K) term; check S and K domains"
    bsm_log_halt(msg, context)
    stop(msg)
  }

  invisible(TRUE)
}

bsm_d1_d2 <- function(S, K, r, sigma, T, q = 0, context = "bsm") {
  bsm_preflight_validate(S = S, K = K, r = r, sigma = sigma, T = T, q = q, context = context)
  sqrtT <- sqrt(T)
  d1 <- (log(S / K) + (r - q + 0.5 * sigma^2) * T) / (sigma * sqrtT)
  d2 <- d1 - sigma * sqrtT

  if (any(!is.finite(c(d1, d2)))) {
    msg <- "Non-finite d1/d2 encountered — BSM undefined"
    bsm_log_halt(msg, context)
    stop(msg)
  }

  list(d1 = d1, d2 = d2)
}

bsm_call_price <- function(S, K, r, sigma, T, q = 0, context = "bsm_call") {
  dd <- bsm_d1_d2(S = S, K = K, r = r, sigma = sigma, T = T, q = q, context = context)

  # Runtime boundary enforcement anchors.
  if (S <= .Machine$double.eps) return(0)

  exp(-q * T) * S * stats::pnorm(dd$d1) - exp(-r * T) * K * stats::pnorm(dd$d2)
}

bsm_put_from_parity <- function(call_price, S, K, r, T, q = 0) {
  call_price - exp(-q * T) * S + exp(-r * T) * K
}

bsm_price_greeks <- function(S, K, r, sigma, T, q = as.numeric(CFG$options$dividend_yield), context = "bsm") {
  S <- as.numeric(S); K <- as.numeric(K); r <- as.numeric(r)
  sigma <- as.numeric(sigma); T <- as.numeric(T); q <- as.numeric(q)

  dd <- bsm_d1_d2(S = S, K = K, r = r, sigma = sigma, T = T, q = q, context = context)
  d1 <- dd$d1
  d2 <- dd$d2
  sqrtT <- sqrt(T)

  call_price <- bsm_call_price(S = S, K = K, r = r, sigma = sigma, T = T, q = q, context = context)
  put_price <- bsm_put_from_parity(call_price = call_price, S = S, K = K, r = r, T = T, q = q)

  delta_call <- exp(-q * T) * stats::pnorm(d1)
  delta_put <- delta_call - exp(-q * T)
  gamma <- exp(-q * T) * stats::dnorm(d1) / (S * sigma * sqrtT)
  vega <- exp(-q * T) * S * sqrtT * stats::dnorm(d1)
  theta_call <- -(exp(-q * T) * S * stats::dnorm(d1) * sigma) / (2 * sqrtT) +
    q * exp(-q * T) * S * stats::pnorm(d1) -
    r * K * exp(-r * T) * stats::pnorm(d2)
  rho_call <- K * T * exp(-r * T) * stats::pnorm(d2)
  rho_put <- -K * T * exp(-r * T) * stats::pnorm(-d2)

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
    positive_theta_flag = theta_call > 0,
    rho_call = rho_call,
    rho_put = rho_put
  )
}
