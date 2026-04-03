# Binary Validation Layer (IĀTŌ)

This directory implements a strict binary assertion chain for WSDL payload
validation and IĀTŌ workspace state.

- Assertions emit exactly one record format:
  `TIMESTAMP | CONTROL_ID | TARGET | RESULT | DETAIL`
- `RESULT` is always `1` (pass) or `0` (fail).
- Each control script emits one assertion and exits `0` or `1`.
- `compliance_state.sh` computes engagement compliance as the minimum result
  (Boolean AND of all ten controls).

## Controls

- `CTRL-BIN-001` — Script checksum match
- `CTRL-BIN-002` — XSD schema conformance
- `CTRL-BIN-003` — Image storage policy
- `CTRL-BIN-004` — Price bounds `[1,999999]`
- `CTRL-BIN-005` — Name bounds `[1,200]`
- `CTRL-BIN-006` — Array bounds `DressPerPrice <= 500`
- `CTRL-BIN-007` — Workspace known-good state
- `CTRL-BIN-008` — Rootless container no-new-privileges
- `CTRL-BIN-009` — Session audit log presence
- `CTRL-BIN-010` — Monte Carlo reliability `>= 0.999`

## Operator usage

```bash
export ASSERT_LOG=iato-mcp/audit/session/$(date +%Y%m%dT%H%M%S)_assert_$$.log
bash iato-mcp/scripts/validation/compliance_state.sh \
  iato-mcp/config/environments/workstation.xml \
  iato-mcp/config/environments/container_base.xml \
  iato_container \
  /path/to/mc_output.csv

bash iato-mcp/scripts/validation/read_binary_log.sh "$ASSERT_LOG"
```
