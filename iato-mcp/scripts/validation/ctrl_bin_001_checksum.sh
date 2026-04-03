#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

TARGET_FILE="${1:-}"
DECLARED_HASH="${2:-}"

if [[ -z "${TARGET_FILE}" || -z "${DECLARED_HASH}" ]]; then
  assert "CTRL-BIN-001" "${TARGET_FILE:-unknown}" "0" "missing_argument=target_or_hash_not_supplied"
  exit 1
fi

if [[ ! -f "${TARGET_FILE}" ]]; then
  assert "CTRL-BIN-001" "${TARGET_FILE}" "0" "target_not_found"
  exit 1
fi

ACTUAL_HASH="$(sha256sum "${TARGET_FILE}" | awk '{print $1}')"

if [[ "${ACTUAL_HASH}" == "${DECLARED_HASH}" ]]; then
  assert "CTRL-BIN-001" "${TARGET_FILE}" "1" "checksum_match hash=${ACTUAL_HASH:0:16}..."
  exit 0
fi

assert "CTRL-BIN-001" "${TARGET_FILE}" "0" "checksum_mismatch declared=${DECLARED_HASH:0:16}... actual=${ACTUAL_HASH:0:16}..."
exit 1
