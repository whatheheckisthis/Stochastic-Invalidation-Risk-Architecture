#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

SESSION_DIR="${1:-audit/session}"

LOG_COUNT="$(find "${SESSION_DIR}" -type f -name '*.log' -size +0c 2>/dev/null | wc -l | tr -d ' ')"

if [[ "${LOG_COUNT}" -gt 0 ]]; then
  assert "CTRL-BIN-009" "${SESSION_DIR}" "1" "session_log_present count=${LOG_COUNT}"
  exit 0
fi

assert "CTRL-BIN-009" "${SESSION_DIR}" "0" "no_session_log_found dir=${SESSION_DIR}"
exit 1
