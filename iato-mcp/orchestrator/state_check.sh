#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="${1:-}"
source "${SCRIPT_DIR}/audit_log.sh"

if [[ -z "${CONFIG_PATH}" || ! -f "${CONFIG_PATH}" ]]; then
  audit_emit "STATE_CHECK_FAIL" "reason=missing_or_invalid_config path=${CONFIG_PATH}"
  exit 1
fi

audit_emit "STATE_CHECK_START" "config=${CONFIG_PATH}"

if ! command -v xmllint >/dev/null 2>&1; then
  audit_emit "STATE_CHECK_FAIL" "reason=xmllint_not_installed"
  exit 1
fi

SCHEMA_DIR="${SCRIPT_DIR}/../config/schema"
if [[ "${CONFIG_PATH}" == *"workstation.xml"* ]]; then
  xmllint --noout --schema "${SCHEMA_DIR}/iato_policy.xsd" "${CONFIG_PATH}"
fi

audit_emit "STATE_CHECK_OK" "config=${CONFIG_PATH}"
