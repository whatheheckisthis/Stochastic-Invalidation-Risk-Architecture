#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="${1:-}"

if [[ ! -f "${LOG_FILE}" ]]; then
  printf 'ERROR: log file not found: %s\n' "${LOG_FILE}"
  exit 1
fi

printf '\n'
printf '%-26s | %-18s | %-6s | %s\n' "TIMESTAMP" "CONTROL" "RESULT" "DETAIL"
printf '%s\n' "$(printf '%.0s-' {1..100})"

while IFS='|' read -r ts ctrl target result detail; do
  ts="$(printf '%s' "${ts}" | xargs)"
  ctrl="$(printf '%s' "${ctrl}" | xargs)"
  result="$(printf '%s' "${result}" | xargs)"
  detail="$(printf '%s' "${detail}" | xargs)"

  if [[ "${result}" == "1" ]]; then
    result_display='1 PASS'
  elif [[ "${result}" == "0" ]]; then
    result_display='0 FAIL'
  else
    result_display="${result}"
  fi

  printf '%-26s | %-18s | %-6s | %s\n' "${ts}" "${ctrl}" "${result_display}" "${detail}"
done < "${LOG_FILE}"

TOTAL="$(grep -c '|' "${LOG_FILE}" || true)"
PASS="$(grep -c '| 1 |' "${LOG_FILE}" || true)"
FAIL="$(grep -c '| 0 |' "${LOG_FILE}" || true)"

printf '\n'
printf 'Controls asserted: %s\n' "${TOTAL}"
printf 'Passed (1):        %s\n' "${PASS}"
printf 'Failed (0):        %s\n' "${FAIL}"
if [[ "${FAIL}" -eq 0 ]]; then
  printf 'Compliance state:  TRUE\n'
else
  printf 'Compliance state:  FALSE\n'
fi
