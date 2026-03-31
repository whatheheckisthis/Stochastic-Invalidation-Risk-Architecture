#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "${CONFIG_PATH}" || ! -f "${CONFIG_PATH}" ]]; then
  echo "vsphere preflight: missing config" >&2
  exit 1
fi

bash "${SCRIPT_DIR}/validate_topology.sh" "${CONFIG_PATH}"
echo "vsphere preflight ok: ${CONFIG_PATH}"
