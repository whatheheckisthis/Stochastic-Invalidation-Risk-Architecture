#!/usr/bin/env bash
# Binary assertion emitter
# One function. One log format. No exceptions.

ASSERT_LOG="${ASSERT_LOG:-/dev/stderr}"

# Usage: assert CTRL_ID TARGET RESULT DETAIL
# RESULT must be 1 or 0 — enforced here as a final guardrail
assert() {
  local ctrl_id="${1:-UNKNOWN}"
  local target="${2:-unknown}"
  local result="${3:-0}"
  local detail="${4:-no_detail}"
  local timestamp

  timestamp="$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)"

  # Enforce binary output strictly.
  if [[ "${result}" != "1" && "${result}" != "0" ]]; then
    detail="assert_error=non_binary_result_original_${result} ${detail}"
    result="0"
  fi

  local record
  record="${timestamp} | ${ctrl_id} | ${target} | ${result} | ${detail}"

  printf '%s\n' "${record}" | tee -a "${ASSERT_LOG}"
}

export -f assert
