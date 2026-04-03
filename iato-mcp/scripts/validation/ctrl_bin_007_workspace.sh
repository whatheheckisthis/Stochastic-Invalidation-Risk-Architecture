#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

TARGET_PATH="${1:-}"
DECLARED_HASH="${2:-}"

if [[ -z "${TARGET_PATH}" || -z "${DECLARED_HASH}" ]]; then
  assert "CTRL-BIN-007" "${TARGET_PATH:-unknown}" "0" "missing_argument=target_or_hash_not_supplied"
  exit 1
fi

if [[ ! -e "${TARGET_PATH}" ]]; then
  assert "CTRL-BIN-007" "${TARGET_PATH}" "0" "target_not_found"
  exit 1
fi

if [[ -f "${TARGET_PATH}" ]]; then
  ACTUAL_HASH="$(sha256sum "${TARGET_PATH}" | awk '{print $1}')"
else
  ACTUAL_HASH="$(tar -cf - "${TARGET_PATH}" 2>/dev/null | sha256sum | awk '{print $1}')"
fi

if [[ "${ACTUAL_HASH}" == "${DECLARED_HASH}" ]]; then
  assert "CTRL-BIN-007" "${TARGET_PATH}" "1" "known_good_state_confirmed"
  exit 0
fi

assert "CTRL-BIN-007" "${TARGET_PATH}" "0" "state_deviation_detected declared=${DECLARED_HASH:0:16}... actual=${ACTUAL_HASH:0:16}..."
exit 1
