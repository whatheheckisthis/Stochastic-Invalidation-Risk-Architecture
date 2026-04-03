#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

PAYLOAD="${1:-}"
SCHEMA="${2:-}"

if [[ ! -f "${PAYLOAD}" || ! -f "${SCHEMA}" ]]; then
  assert "CTRL-BIN-002" "${PAYLOAD:-unknown}" "0" "file_not_found=payload_or_schema_missing"
  exit 1
fi

if xmllint --noout --schema "${SCHEMA}" "${PAYLOAD}" 2>/dev/null; then
  assert "CTRL-BIN-002" "${PAYLOAD}" "1" "schema_valid schema=${SCHEMA##*/}"
  exit 0
fi

ERRORS="$(xmllint --schema "${SCHEMA}" "${PAYLOAD}" 2>&1 | head -3 | tr '\n' '|' || true)"
assert "CTRL-BIN-002" "${PAYLOAD}" "0" "schema_violation errors=${ERRORS:0:200}"
exit 1
