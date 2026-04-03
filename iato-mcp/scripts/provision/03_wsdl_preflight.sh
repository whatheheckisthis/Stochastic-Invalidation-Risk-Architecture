#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../../orchestrator/audit_log.sh"

PAYLOAD_PATH="${1:-}"
CONFIG_PATH="${2:-}"
SCHEMA_PATH="$(dirname "${BASH_SOURCE[0]}")/../../config/schema/dress_service.xsd"

audit_emit "WSDL_PREFLIGHT_START" "payload=${PAYLOAD_PATH} config=${CONFIG_PATH}"

if [[ -z "${PAYLOAD_PATH}" || ! -f "${PAYLOAD_PATH}" ]]; then
  audit_emit "WSDL_PREFLIGHT_HALT" "reason=payload_not_found path=${PAYLOAD_PATH}"
  exit 1
fi

if [[ -z "${CONFIG_PATH}" || ! -f "${CONFIG_PATH}" ]]; then
  audit_emit "WSDL_PREFLIGHT_HALT" "reason=config_not_found path=${CONFIG_PATH}"
  exit 1
fi

if [[ ! -f "${SCHEMA_PATH}" ]]; then
  audit_emit "WSDL_PREFLIGHT_HALT" "reason=schema_not_found path=${SCHEMA_PATH}"
  exit 1
fi

if ! xmllint --noout --schema "${SCHEMA_PATH}" "${PAYLOAD_PATH}" 2>/dev/null; then
  VALIDATION_ERRORS="$(xmllint --schema "${SCHEMA_PATH}" "${PAYLOAD_PATH}" 2>&1 || true)"
  audit_emit "WSDL_PREFLIGHT_HALT" "reason=schema_violation payload=${PAYLOAD_PATH} errors=${VALIDATION_ERRORS:0:300}"
  exit 1
fi

audit_emit "WSDL_PREFLIGHT_PASS" "payload=${PAYLOAD_PATH} schema=${SCHEMA_PATH}"

IMAGE_STORAGE="$(xmllint --xpath "string(//service/@image_storage)" "${CONFIG_PATH}" 2>/dev/null || echo "reference")"
if [[ -z "${IMAGE_STORAGE}" ]]; then
  IMAGE_STORAGE="reference"
fi

HEXBINARY_COUNT="$(grep -Eic 'xs:hexBinary|hexBinary' "${PAYLOAD_PATH}" 2>/dev/null || echo 0)"
if [[ "${HEXBINARY_COUNT}" -gt 0 ]]; then
  audit_emit "WSDL_PREFLIGHT_HALT" "reason=policy_violation policy=POLICY-IMG-001 detail=hexBinary_detected_in_payload"
  exit 1
fi

if [[ "${IMAGE_STORAGE}" == "reference" ]]; then
  INLINE_IMAGE_COUNT="$(xmllint --xpath 'count(//*[local-name()="Image"][string-length(normalize-space(.)) > 0])' "${PAYLOAD_PATH}" 2>/dev/null || echo 0)"
  if [[ "${INLINE_IMAGE_COUNT%.*}" -gt 0 ]]; then
    audit_emit "WSDL_PREFLIGHT_HALT" "reason=policy_violation policy=POLICY-IMG-002 detail=inline_image_in_reference_mode_payload count=${INLINE_IMAGE_COUNT}"
    exit 1
  fi
fi

audit_emit "WSDL_PREFLIGHT_COMPLETE" "payload=${PAYLOAD_PATH} image_policy=${IMAGE_STORAGE}"
exit 0
