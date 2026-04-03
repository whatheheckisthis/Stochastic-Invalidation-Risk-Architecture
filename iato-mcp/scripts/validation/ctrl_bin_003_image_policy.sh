#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/assert.sh"

PAYLOAD="${1:-}"
POLICY="${2:-reference}" # reference | inline

if [[ ! -f "${PAYLOAD}" ]]; then
  assert "CTRL-BIN-003" "${PAYLOAD:-unknown}" "0" "payload_not_found"
  exit 1
fi

HEXBINARY_COUNT="$(grep -Ec 'xs:hexBinary|hexBinary' "${PAYLOAD}" 2>/dev/null || true)"
HEXBINARY_COUNT="${HEXBINARY_COUNT:-0}"

if [[ "${HEXBINARY_COUNT}" -gt 0 ]]; then
  assert "CTRL-BIN-003" "${PAYLOAD}" "0" "policy_violation=POLICY-IMG-001 hexBinary_detected count=${HEXBINARY_COUNT}"
  exit 1
fi

if [[ "${POLICY}" == "reference" ]]; then
  INLINE_COUNT_RAW="$(xmllint --xpath "count(//*[local-name()='Image'][string-length(normalize-space(.)) > 0])" "${PAYLOAD}" 2>/dev/null || echo 0)"
  INLINE_COUNT="${INLINE_COUNT_RAW%.*}"

  if [[ "${INLINE_COUNT}" -gt 0 ]]; then
    assert "CTRL-BIN-003" "${PAYLOAD}" "0" "policy_violation=POLICY-IMG-002 inline_image_in_reference_mode count=${INLINE_COUNT}"
    exit 1
  fi
fi

assert "CTRL-BIN-003" "${PAYLOAD}" "1" "image_policy_satisfied policy=${POLICY}"
exit 0
