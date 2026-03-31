#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="${1:-}"
source "${SCRIPT_DIR}/audit_log.sh"

audit_emit "DECOMMISSION_START" "config=${CONFIG_PATH}"

bash "${SCRIPT_DIR}/../scripts/container/podman_teardown.sh" "${CONFIG_PATH:-}"

rm -f "${SCRIPT_DIR}/../audit/session"/*.log || true
touch "${SCRIPT_DIR}/../audit/session/.gitkeep"

audit_emit "DECOMMISSION_COMPLETE" "workspace_reset=true"
