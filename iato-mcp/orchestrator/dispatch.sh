#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUDIT_DIR="${SCRIPT_DIR}/../audit/session"
mkdir -p "${AUDIT_DIR}"
AUDIT_LOG="${AUDIT_DIR}/$(date +%Y%m%dT%H%M%S)_$$.log"
export AUDIT_LOG
ACTION="${1:-}"
SCRIPT_PATH="${2:-}"
CONFIG_PATH="${3:-}"

source "${SCRIPT_DIR}/audit_log.sh"

audit_emit "DISPATCH_START" "action=${ACTION} script=${SCRIPT_PATH} config=${CONFIG_PATH}"

if [[ -z "${ACTION}" ]]; then
  audit_emit "DISPATCH_HALT" "reason=no_action_specified"
  exit 1
fi

case "${ACTION}" in
  apply)
    audit_emit "ACTION" "apply script=${SCRIPT_PATH} config=${CONFIG_PATH}"
    bash "${SCRIPT_DIR}/../scripts/provision/00_preflight.sh" "${SCRIPT_PATH}" \
      || { audit_emit "HALT" "reason=preflight_failed"; exit 1; }
    bash "${SCRIPT_DIR}/../scripts/provision/01_apply.sh" "${SCRIPT_PATH}" "${CONFIG_PATH}" \
      || { audit_emit "HALT" "reason=apply_failed"; exit 1; }
    bash "${SCRIPT_DIR}/../scripts/provision/02_verify.sh" "${CONFIG_PATH}" \
      || { audit_emit "HALT" "reason=verify_failed"; exit 1; }
    ;;
  state_check)
    audit_emit "ACTION" "state_check config=${CONFIG_PATH}"
    bash "${SCRIPT_DIR}/state_check.sh" "${CONFIG_PATH}" \
      || { audit_emit "HALT" "reason=state_deviation_detected"; exit 2; }
    ;;
  decommission)
    audit_emit "ACTION" "decommission config=${CONFIG_PATH}"
    bash "${SCRIPT_DIR}/decommission.sh" "${CONFIG_PATH}" \
      || { audit_emit "HALT" "reason=decommission_failed"; exit 1; }
    ;;
  spawn_container)
    audit_emit "ACTION" "spawn_container config=${CONFIG_PATH}"
    bash "${SCRIPT_DIR}/../scripts/container/podman_spawn.sh" "${CONFIG_PATH}" \
      || { audit_emit "HALT" "reason=container_spawn_failed"; exit 1; }
    ;;
  teardown_container)
    audit_emit "ACTION" "teardown_container config=${CONFIG_PATH}"
    bash "${SCRIPT_DIR}/../scripts/container/podman_teardown.sh" "${CONFIG_PATH}" \
      || { audit_emit "HALT" "reason=container_teardown_failed"; exit 1; }
    ;;
  vsphere_preflight)
    audit_emit "ACTION" "vsphere_preflight config=${CONFIG_PATH}"
    bash "${SCRIPT_DIR}/../scripts/vsphere/preflight_iac.sh" "${CONFIG_PATH}" \
      || { audit_emit "HALT" "reason=vsphere_preflight_failed"; exit 1; }
    ;;
  *)
    audit_emit "DISPATCH_HALT" "reason=unknown_action action=${ACTION}"
    exit 1
    ;;
esac

audit_emit "DISPATCH_COMPLETE" "action=${ACTION} exit=0"
