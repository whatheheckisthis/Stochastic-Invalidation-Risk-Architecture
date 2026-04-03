#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

PAYLOAD="${1:-}"

if [[ ! -f "${PAYLOAD}" ]]; then
  assert "CTRL-BIN-005" "${PAYLOAD:-unknown}" "0" "payload_not_found"
  exit 1
fi

NAMES_RAW="$(xmllint --xpath "//*[local-name()='Name']" "${PAYLOAD}" 2>/dev/null || true)"
if [[ -z "${NAMES_RAW}" ]]; then
  assert "CTRL-BIN-005" "${PAYLOAD}" "0" "no_name_elements_found"
  exit 1
fi

# Convert to line-delimited values safely.
NAMES="$(xmllint --xpath "//*[local-name()='Name']/text()" "${PAYLOAD}" 2>/dev/null | tr ' ' '\n' || true)"
if [[ -z "${NAMES}" ]]; then
  assert "CTRL-BIN-005" "${PAYLOAD}" "0" "no_name_text_values_found"
  exit 1
fi

while IFS= read -r name; do
  [[ -z "${name}" ]] && continue
  len="${#name}"
  if [[ "${len}" -lt 1 || "${len}" -gt 200 ]]; then
    assert "CTRL-BIN-005" "${PAYLOAD}" "0" "name_length_out_of_bounds length=${len} allowed=[1,200]"
    exit 1
  fi
done <<< "${NAMES}"

assert "CTRL-BIN-005" "${PAYLOAD}" "1" "all_names_within_bounds"
exit 0
