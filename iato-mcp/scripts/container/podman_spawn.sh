#!/usr/bin/env bash
set -euo pipefail

CONFIG_PATH="${1:-}"
if ! command -v podman >/dev/null 2>&1; then
  echo "podman_spawn: podman not found" >&2
  exit 1
fi

IMAGE="docker.io/library/alpine:3.20"
NAME="iato-mcp-sandbox"

podman run --rm -d --name "${NAME}" --userns=keep-id "${IMAGE}" sleep 3600
printf 'container spawned: %s (config=%s)\n' "${NAME}" "${CONFIG_PATH:-none}"
