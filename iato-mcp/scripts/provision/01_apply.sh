#!/usr/bin/env bash
set -euo pipefail

TARGET_SCRIPT="${1:-}"
CONFIG_PATH="${2:-}"

if [[ -z "${TARGET_SCRIPT}" || ! -f "${TARGET_SCRIPT}" ]]; then
  echo "apply: target script missing" >&2
  exit 1
fi

if [[ -n "${CONFIG_PATH}" && ! -f "${CONFIG_PATH}" ]]; then
  echo "apply: config missing: ${CONFIG_PATH}" >&2
  exit 1
fi

bash "${TARGET_SCRIPT}" "${CONFIG_PATH}"
