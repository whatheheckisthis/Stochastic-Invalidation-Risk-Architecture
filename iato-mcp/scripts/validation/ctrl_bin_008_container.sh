#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

CONTAINER_NAME="${1:-}"

if [[ -z "${CONTAINER_NAME}" ]]; then
  assert "CTRL-BIN-008" "unknown_container" "0" "no_container_name_supplied"
  exit 1
fi

INSPECT="$(podman inspect "${CONTAINER_NAME}" --format '{{.HostConfig.SecurityOpt}}' 2>/dev/null || echo "")"

if printf '%s' "${INSPECT}" | grep -q 'no-new-privileges'; then
  assert "CTRL-BIN-008" "${CONTAINER_NAME}" "1" "no_new_privileges_confirmed"
  exit 0
fi

assert "CTRL-BIN-008" "${CONTAINER_NAME}" "0" "no_new_privileges_absent inspect=${INSPECT:0:100}"
exit 1
