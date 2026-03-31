#!/usr/bin/env bash
set -euo pipefail

NAME="iato-mcp-sandbox"
if ! command -v podman >/dev/null 2>&1; then
  echo "podman_teardown: podman not found" >&2
  exit 1
fi

podman rm -f "${NAME}" >/dev/null 2>&1 || true
echo "container removed: ${NAME}"
