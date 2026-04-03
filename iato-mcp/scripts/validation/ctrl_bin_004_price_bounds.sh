#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

PAYLOAD="${1:-}"

if [[ ! -f "${PAYLOAD}" ]]; then
  assert "CTRL-BIN-004" "${PAYLOAD:-unknown}" "0" "payload_not_found"
  exit 1
fi

PRICES="$(xmllint --xpath "//*[local-name()='Price']/text()" "${PAYLOAD}" 2>/dev/null || echo "")"

if [[ -z "${PRICES}" ]]; then
  assert "CTRL-BIN-004" "${PAYLOAD}" "0" "no_price_elements_found"
  exit 1
fi

for price in ${PRICES}; do
  if ! [[ "${price}" =~ ^[0-9]+$ ]] || [[ "${price}" -lt 1 ]] || [[ "${price}" -gt 999999 ]]; then
    assert "CTRL-BIN-004" "${PAYLOAD}" "0" "price_out_of_bounds value=${price} allowed=[1,999999]"
    exit 1
  fi
done

assert "CTRL-BIN-004" "${PAYLOAD}" "1" "all_prices_within_bounds"
exit 0
