#!/usr/bin/env bash

AUDIT_LOG="${AUDIT_LOG:-/dev/stderr}"

audit_emit() {
  local EVENT="${1:-UNKNOWN}"
  local DETAIL="${2:-}"
  local TIMESTAMP
  TIMESTAMP="$(date -u +%Y-%m-%dT%H:%M:%S.%3NZ)"
  local HOST
  HOST="$(hostname -s 2>/dev/null || echo unknown)"
  local USER
  USER="$(id -un 2>/dev/null || echo unknown)"
  local PID="$$"

  local RECORD
  RECORD="$(printf '%s | %s | host=%s user=%s pid=%s | %s | %s\n' \
    "${TIMESTAMP}" "IATO-MCP" "${HOST}" "${USER}" "${PID}" \
    "${EVENT}" "${DETAIL}")"

  echo "${RECORD}" | tee -a "${AUDIT_LOG}"
}

export -f audit_emit
