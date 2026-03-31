# IATO MCP Orchestration Layer

This module provides a single-entry orchestration harness for MCP-initiated
operations targeting a WSL2 host with rootless Podman and XSD-validated XML
configuration.

## Entry point
- `orchestrator/dispatch.sh` is the only action entrypoint.
- All actions emit timestamped records to `audit/session/*.log`.

## Actions
- `apply`
- `state_check`
- `decommission`
- `spawn_container`
- `teardown_container`
- `vsphere_preflight`

## Quick smoke test
```bash
bash iato-mcp/orchestrator/dispatch.sh state_check "" iato-mcp/config/environments/workstation.xml
```
