#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-}"
SCHEMA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../config/schema" && pwd)"

if [[ -z "${CONFIG_PATH}" || ! -f "${CONFIG_PATH}" ]]; then
  echo "verify: missing config" >&2
  exit 1
fi

if ! command -v xmllint >/dev/null 2>&1; then
  echo "verify: xmllint not found" >&2
  exit 1
fi

xmllint --noout --schema "${SCHEMA_DIR}/iato_policy.xsd" "${CONFIG_PATH}"
echo "verify ok: ${CONFIG_PATH}"
