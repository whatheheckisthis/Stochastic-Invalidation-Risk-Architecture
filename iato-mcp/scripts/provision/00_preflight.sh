#!/usr/bin/env bash
set -euo pipefail

TARGET_SCRIPT="${1:-}"
if [[ -z "${TARGET_SCRIPT}" || ! -f "${TARGET_SCRIPT}" ]]; then
  echo "preflight: target script missing" >&2
  exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
  sha256sum "${TARGET_SCRIPT}" >/dev/null
else
  echo "preflight: sha256sum unavailable" >&2
  exit 1
fi

echo "preflight ok: ${TARGET_SCRIPT}"
