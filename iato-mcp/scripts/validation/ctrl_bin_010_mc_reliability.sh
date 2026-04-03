#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

MC_OUTPUT="${1:-}"
THRESHOLD="${2:-0.999}"

if [[ ! -f "${MC_OUTPUT}" ]]; then
  assert "CTRL-BIN-010" "${MC_OUTPUT:-unknown}" "0" "mc_output_not_found"
  exit 1
fi

MIN_RATE="$(awk -F',' 'NR>1 {print $5}' "${MC_OUTPUT}" | sort -n | head -1)"

if [[ -z "${MIN_RATE}" ]]; then
  assert "CTRL-BIN-010" "${MC_OUTPUT}" "0" "mc_output_invalid missing_detection_rate_values"
  exit 1
fi

PASS="$(awk -v rate="${MIN_RATE}" -v threshold="${THRESHOLD}" 'BEGIN { print (rate >= threshold) ? 1 : 0 }')"

if [[ "${PASS}" -eq 1 ]]; then
  assert "CTRL-BIN-010" "${MC_OUTPUT}" "1" "gate_reliability_confirmed min_rate=${MIN_RATE} threshold=${THRESHOLD}"
  exit 0
fi

assert "CTRL-BIN-010" "${MC_OUTPUT}" "0" "gate_reliability_below_threshold min_rate=${MIN_RATE} threshold=${THRESHOLD}"
exit 1
