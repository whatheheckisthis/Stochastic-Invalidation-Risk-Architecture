#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

PAYLOAD="${1:-}"
MAX_RECORDS="${2:-500}"

if [[ ! -f "${PAYLOAD}" ]]; then
  assert "CTRL-BIN-006" "${PAYLOAD:-unknown}" "0" "payload_not_found"
  exit 1
fi

COUNT_RAW="$(xmllint --xpath "count(//*[local-name()='DressPerPrice'])" "${PAYLOAD}" 2>/dev/null || echo 0)"
COUNT="${COUNT_RAW%.*}"

if [[ "${COUNT}" -ge 1 && "${COUNT}" -le "${MAX_RECORDS}" ]]; then
  assert "CTRL-BIN-006" "${PAYLOAD}" "1" "array_within_bounds count=${COUNT} max=${MAX_RECORDS}"
  exit 0
fi

assert "CTRL-BIN-006" "${PAYLOAD}" "0" "array_out_of_bounds count=${COUNT} allowed=[1,${MAX_RECORDS}]"
exit 1
