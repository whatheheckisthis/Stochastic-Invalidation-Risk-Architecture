#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/../.." && pwd)"

ASSERT_LOG="${ASSERT_LOG:-${ROOT_DIR}/audit/session/$(date +%Y%m%dT%H%M%S)_compliance_$$.log}"
export ASSERT_LOG

CONFIG_PATH="${1:-}"
PAYLOAD_PATH="${2:-}"
CONTAINER_NAME="${3:-}"
MC_OUTPUT="${4:-}"

RESULTS=()

run_ctrl() {
  local script_path="${1}"
  shift
  if bash "${script_path}" "$@"; then
    RESULTS+=("1")
  else
    RESULTS+=("0")
  fi
}

CONFIG_HASH=""
if [[ -n "${CONFIG_PATH}" && -f "${CONFIG_PATH}" ]]; then
  CONFIG_HASH="$(sha256sum "${CONFIG_PATH}" | awk '{print $1}')"
fi

RUN_ALL_R_PATH="${ROOT_DIR}/../run_all.R"
WORKSPACE_HASH=""
if [[ -f "${RUN_ALL_R_PATH}" ]]; then
  WORKSPACE_HASH="$(sha256sum "${RUN_ALL_R_PATH}" | awk '{print $1}')"
fi

run_ctrl "${SCRIPT_DIR}/ctrl_bin_001_checksum.sh" "${CONFIG_PATH}" "${CONFIG_HASH}"
run_ctrl "${SCRIPT_DIR}/ctrl_bin_002_schema.sh" "${PAYLOAD_PATH}" "${ROOT_DIR}/config/schema/dress_service.xsd"
run_ctrl "${SCRIPT_DIR}/ctrl_bin_003_image_policy.sh" "${PAYLOAD_PATH}" "reference"
run_ctrl "${SCRIPT_DIR}/ctrl_bin_004_price_bounds.sh" "${PAYLOAD_PATH}"
run_ctrl "${SCRIPT_DIR}/ctrl_bin_005_name_bounds.sh" "${PAYLOAD_PATH}"
run_ctrl "${SCRIPT_DIR}/ctrl_bin_006_array_bounds.sh" "${PAYLOAD_PATH}" "500"
run_ctrl "${SCRIPT_DIR}/ctrl_bin_007_workspace.sh" "${RUN_ALL_R_PATH}" "${WORKSPACE_HASH}"
run_ctrl "${SCRIPT_DIR}/ctrl_bin_008_container.sh" "${CONTAINER_NAME}"
run_ctrl "${SCRIPT_DIR}/ctrl_bin_009_audit_log.sh" "${ROOT_DIR}/audit/session"
run_ctrl "${SCRIPT_DIR}/ctrl_bin_010_mc_reliability.sh" "${MC_OUTPUT}" "0.999"

COMPLIANT=1
for result in "${RESULTS[@]}"; do
  if [[ "${result}" -eq 0 ]]; then
    COMPLIANT=0
    break
  fi
done

PASS_COUNT="$(printf '%s\n' "${RESULTS[@]}" | grep -c '^1$' || true)"
FAIL_COUNT="$(printf '%s\n' "${RESULTS[@]}" | grep -c '^0$' || true)"

printf '%s | COMPLIANCE_STATE | engagement | %s | controls_passed=%s/%s controls_failed=%s\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)" "${COMPLIANT}" "${PASS_COUNT}" "${#RESULTS[@]}" "${FAIL_COUNT}"

if [[ "${COMPLIANT}" -eq 1 ]]; then
  COMPLIANCE_STR="TRUE"
else
  COMPLIANCE_STR="FALSE"
fi

printf '%s | COMPLIANCE_BOOLEAN | engagement | %s | compliant=%s\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)" "${COMPLIANT}" "${COMPLIANCE_STR}" | tee -a "${ASSERT_LOG}"

exit $((1 - COMPLIANT))
