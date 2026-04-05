# IATO MCP ARCHITECTURE

## 1.0 Overview
The IĀTŌ MCP orchestration layer is the execution subsystem that receives tool calls through the MCP server and performs bounded operational actions through a shell-based dispatch harness. The implementation combines TypeScript request handling in `iato-mcp/src/server.ts` with a single Bash control entrypoint in `iato-mcp/orchestrator/dispatch.sh`. The server validates action names, validates configuration inputs, invokes dispatch, and returns a structured action summary including exit code and audit log reference. This creates one consistent execution path from MCP input to runtime side effects. 

Within the broader Stochastic Invalidation Risk Architecture (SIRA) repository, this module is the runtime control plane for infrastructure and environment operations. The analytics and financial model scripts under top-level `scripts/` and `run_all.R` remain separate from this orchestration path, while the IĀTŌ module provides standardized preflight, apply, verify, state-check, container lifecycle, and topology preflight behavior in `iato-mcp/scripts/` and `iato-mcp/orchestrator/`. 

This document describes system implementation and execution structure.
It does not define governance rationale, control effectiveness, or assurance mappings.

## 2.0 System Design Principles
The orchestration implementation follows a small set of explicit design principles that are visible in code and scripts.

1. **Deterministic execution:** The dispatch layer uses a fixed case statement with a bounded action list, and the TypeScript server uses `isEnumeratedAction(...)` against `ENUMERATED_ACTIONS` before invocation. This avoids ambiguous routing and keeps action selection deterministic.
2. **Bounded action space:** Only enumerated actions are accepted. Unknown actions halt with explicit audit events (`DISPATCH_HALT`) in both TypeScript and Bash paths.
3. **Fail-fast semantics:** Each critical stage exits immediately on invalid input or tool dependency absence (for example: missing script, missing config, missing `xmllint`, missing `podman`). Dispatch wraps stage calls with immediate halt conditions.
4. **Reproducibility:** Config and payload validation are schema-based (`iato_policy.xsd`, `network.xsd`, `dress_service.xsd`), and audit logs are written with timestamp, host, user, pid, event, and detail fields to produce a consistent execution history.

These principles are implemented through script composition rather than dynamic orchestration engines, which keeps runtime behavior transparent and easy to trace from source files.

## 3.0 Execution Architecture
### 3.1 Dispatch Model
The runtime model is centered on a single action router: `iato-mcp/orchestrator/dispatch.sh`. The script creates a per-session audit log file in `iato-mcp/audit/session/`, emits `DISPATCH_START`, and routes one action at a time through a `case` statement.

The action set defined in both `dispatch.sh` and `src/dispatch.ts` is:
- `apply`
- `state_check`
- `decommission`
- `spawn_container`
- `teardown_container`
- `vsphere_preflight`
- `wsdl_preflight`

Unknown actions are rejected. In Bash this is handled by the default case with `DISPATCH_HALT` and exit 1. In TypeScript, `runDispatch(...)` checks `isEnumeratedAction(...)` and returns a structured failure without shell invocation. This dual gate prevents unrecognized command execution at both the API and shell layers.

### 3.2 Execution Flow
The `apply` path uses a strict sequence:
1. `scripts/provision/00_preflight.sh`
2. `scripts/provision/01_apply.sh`
3. `scripts/provision/02_verify.sh`

`00_preflight.sh` verifies target script presence and requires `sha256sum`. `01_apply.sh` executes the requested script with optional config path after existence checks. `02_verify.sh` requires `xmllint` and validates configuration against `config/schema/iato_policy.xsd`.

The state and environment actions use dedicated scripts:
- `state_check` → `orchestrator/state_check.sh`
- `decommission` → `orchestrator/decommission.sh`
- `spawn_container` → `scripts/container/podman_spawn.sh`
- `teardown_container` → `scripts/container/podman_teardown.sh`
- `vsphere_preflight` → `scripts/vsphere/preflight_iac.sh`
- `wsdl_preflight` → `scripts/provision/03_wsdl_preflight.sh`

Every action emits audit records through `audit_emit`, and dispatch completes with `DISPATCH_COMPLETE` on success.

### 3.3 State Management
State handling is explicit and operation-specific:
- `state_check.sh` validates config presence, logs start/fail/ok events, checks for `xmllint`, and validates workstation policy configs against `iato_policy.xsd`.
- Dispatch treats non-zero return from `state_check` as a deviation condition, records `HALT reason=state_deviation_detected`, and exits with status 2.
- The TypeScript server maps exit code 2 to a targeted response string (`STATE_DEVIATION_DETECTED ... Invoke decommission.`), creating a clear recovery directive.
- `decommission.sh` performs teardown and workspace reset behavior for orchestration logs by removing session logs and recreating `.gitkeep`.

This pattern enforces an explicit check → detect → rebuild pathway rather than in-place mutation of unknown state.

## 4.0 Runtime Environment
### 4.1 Container Model
Container lifecycle is controlled by `podman_spawn.sh` and `podman_teardown.sh`.

`podman_spawn.sh`:
- requires `podman`
- starts `docker.io/library/alpine:3.20`
- uses container name `iato-mcp-sandbox`
- runs detached with `--rm`
- uses rootless user namespace mapping via `--userns=keep-id`

`podman_teardown.sh`:
- requires `podman`
- removes the same named container with `podman rm -f`
- tolerates absent containers (`|| true`) and returns a stable completion message

The environment config `config/environments/container_base.xml` defines container policy fields (`runtime`, `rootless`, `image`), while runtime scripts enforce dependency presence and bounded command behavior.

### 4.2 Configuration Model
The module uses XML configuration and XSD schemas for structural validation.

Core schema and config files include:
- `config/schema/iato_policy.xsd` with `iatoPolicy` fields (`environment`, `applicationControl`, `ssdfProfile`, `workload`)
- `config/environments/workstation.xml` as an example policy instance
- `config/schema/network.xsd` and `config/environments/vsphere_preflight.xml` for topology preflight structure
- `config/schema/container.xsd` and `config/environments/container_base.xml` for container policy structure
- `config/schema/dress_service.xsd` for WSDL payload preflight validation

Validation occurs in two layers:
1. **TypeScript pre-dispatch validation** in `src/validate.ts` using `xmllint-wasm` with fallback to `xmllint` subprocess.
2. **Shell-stage validation** in provisioning, state, vSphere, and WSDL scripts using `xmllint` against the relevant schema.

Invalid or missing configuration halts action execution before side-effect stages proceed.

## 5.0 Infrastructure Orchestration
### 5.1 Provisioning Flow
Provisioning behavior is script-driven and linear. The `apply` action in dispatch provides script path plus config path and enforces preflight and verification around the apply step.

Dependency handling in this flow is operationally explicit:
- missing target script causes hard failure in both preflight and apply stages
- missing config blocks apply/verify and other config-dependent actions
- missing tool dependencies (`sha256sum`, `xmllint`, `podman`) halt immediately

Because each stage is a dedicated script, responsibilities remain isolated: preflight checks artifact readiness, apply performs execution, verify enforces post-apply config validity. Dispatch acts as the orchestration coordinator and stop gate.

### 5.2 vSphere Preflight
The vSphere preflight path uses `scripts/vsphere/preflight_iac.sh`, which requires a config path and invokes `validate_topology.sh`.

`validate_topology.sh` enforces:
- config presence
- `xmllint` availability
- schema validation against `config/schema/network.xsd`

This preflight serves as a promotion gate by requiring topology policy files to satisfy schema-defined structure before promotion-related flows proceed.

## 6.0 Audit & Observability
### 6.1 Logging Model
The audit model has two implementations aligned by format intent:

- **Shell audit logger** (`orchestrator/audit_log.sh`) emits UTC millisecond timestamps and records in the form:  
  `TIMESTAMP | IATO-MCP | host=... user=... pid=... | EVENT | DETAIL`
- **TypeScript audit logger** (`src/audit.ts`) writes the same major fields to session log files under `audit/session/` and mirrors output to stderr.

Dispatch creates per-run session log files named with timestamp and process id. Server startup, tool calls, validation outcomes, action starts, halts, and completions are all emitted as discrete events.

### 6.2 Evidence Generation
Evidence artifacts are generated as plain text logs and validation outputs:
- action session logs in `iato-mcp/audit/session/*.log`
- assertion logs from validation scripts via `ASSERT_LOG`
- command stdout/stderr captured and surfaced through MCP tool responses

The binary validation entrypoint `scripts/validation/compliance_state.sh` executes a chain of control scripts and writes summarized engagement state and boolean compliance records. `read_binary_log.sh` can render assertion logs into machine-readable summaries. This produces reproducible operational traces from raw script checks to aggregate state output.

## 7.0 Failure & Recovery Model
Failure behavior is designed as immediate stop with explicit error context.

- Dispatch wraps each action branch with `|| { audit_emit "HALT" ...; exit N; }` style guards.
- Missing arguments, missing files, or missing dependencies exit with non-zero status without continuing to downstream stages.
- Unknown actions are rejected before script execution.
- `state_check` deviation uses dedicated exit code 2, allowing callers to distinguish deviation from generic failures.
- The TypeScript server propagates exit code, captures stderr, and generates action summaries that include an explicit decommission recommendation for deviation states.

Recovery mechanics are intentionally narrow:
- `decommission` path performs container teardown and session workspace reset.
- Re-execution occurs by invoking a new bounded action through dispatch after corrective steps.
- No automatic retry loops or implicit mutation stages are embedded in dispatch, keeping operator intent explicit.

## 8.0 Data & Control Boundaries
The architecture separates boundaries by artifact type and execution role.

1. **Runtime boundary:** Operational effects are performed by shell scripts under `iato-mcp/orchestrator/` and `iato-mcp/scripts/`; MCP server code invokes but does not embed infrastructure command logic.
2. **Configuration boundary:** Environment and policy inputs are XML files under `iato-mcp/config/environments/`; schema definitions under `iato-mcp/config/schema/` govern accepted structure.
3. **Infrastructure boundary:** Topology checks are isolated to vSphere preflight scripts and network schema validation.
4. **Audit boundary:** Log generation is centralized to audit helpers (`audit_log.sh`, `audit.ts`) writing to `iato-mcp/audit/session/`.
5. **Action boundary:** Allowed operations are constrained to enumerated action constants and dispatch case branches.

These boundaries constrain side effects, minimize ambiguity in call paths, and preserve direct traceability from input action to script output and audit records.

## 9.0 System Interaction Diagram
```text
[Operator / MCP Client]
          |
          v
[iato-mcp/src/server.ts]
  - tool schema check
  - enumerated action gate
  - config validation
          |
          v
[iato-mcp/orchestrator/dispatch.sh]
          |
          +--> [00_preflight.sh] --fail--> [HALT + audit]
          |           |
          |           v
          |       [01_apply.sh] --fail--> [HALT + audit]
          |           |
          |           v
          |       [02_verify.sh] --fail--> [HALT + audit]
          |
          +--> [state_check.sh] --deviation(exit 2)--> [decommission.sh]
          |
          +--> [podman_spawn.sh / podman_teardown.sh]
          |
          +--> [vsphere preflight_iac.sh -> validate_topology.sh]
          |
          +--> [03_wsdl_preflight.sh]
          |
          v
[audit/session/*.log + tool response summary]
```

## 10.0 Execution Flow Table
| Stage | Script | Purpose | Failure Mode | Output |
| ----- | ------ | ------- | ------------ | ------ |
| Dispatch start | `orchestrator/dispatch.sh` | Route one bounded action and initialize audit file | Missing action or unknown action halts | Session log records (`DISPATCH_START`, `DISPATCH_HALT`, `DISPATCH_COMPLETE`) |
| Preflight | `scripts/provision/00_preflight.sh` | Validate target script presence and `sha256sum` availability | Missing script or checksum tool | `preflight ok` message or non-zero exit |
| Apply | `scripts/provision/01_apply.sh` | Execute target script with config argument | Missing script/config or script failure | Target script stdout/stderr |
| Verify | `scripts/provision/02_verify.sh` | Validate config against `iato_policy.xsd` | Missing config or `xmllint` or schema violation | `verify ok` message or non-zero exit |
| State check | `orchestrator/state_check.sh` | Validate current config state and detect deviations | Config/tool failure; deviation mapped to exit 2 by dispatch | Audit events for check start/fail/ok |
| Decommission | `orchestrator/decommission.sh` | Teardown container and reset session logs | Teardown script failure | `DECOMMISSION_*` audit events |
| Container spawn | `scripts/container/podman_spawn.sh` | Start rootless sandbox container | Missing `podman` or run failure | `container spawned` message |
| Container teardown | `scripts/container/podman_teardown.sh` | Remove sandbox container | Missing `podman` | `container removed` message |
| vSphere preflight | `scripts/vsphere/preflight_iac.sh` + `validate_topology.sh` | Validate topology config against `network.xsd` | Missing config/`xmllint` or schema failure | `topology validated` and `vsphere preflight ok` |
| WSDL preflight | `scripts/provision/03_wsdl_preflight.sh` | Validate payload and policy constraints before service operation | Missing payload/config/schema, schema violation, policy violation | `WSDL_PREFLIGHT_*` audit events |

## 11.0 Component Responsibility Table
| Component | Responsibility | Boundary | Evidence |
| --------- | -------------- | -------- | -------- |
| `src/server.ts` | MCP tool registration, request handling, dispatch invocation, response summarization | API/tool boundary | `TOOL_CALL`, `DISPATCH_*`, response summary text |
| `src/dispatch.ts` | Enumerated action constants and type guard | Action boundary | Compile-time action typing, runtime inclusion check |
| `src/validate.ts` | Pre-dispatch config existence and schema validation (`xmllint-wasm` + fallback) | Configuration boundary | `VALIDATE_PASS`, `VALIDATE_HALT`, command status |
| `orchestrator/dispatch.sh` | Single shell entrypoint and action router with fail-fast wrappers | Runtime orchestration boundary | Session log entries per action stage |
| `orchestrator/audit_log.sh` and `src/audit.ts` | Structured timestamped audit emission | Audit boundary | `audit/session/*.log` records |
| `scripts/provision/*` | Preflight, apply, verify execution sequence | Provisioning boundary | Stage stdout/stderr and halt reasons |
| `scripts/container/*` | Rootless container lifecycle control | Container boundary | spawn/teardown command outputs |
| `scripts/vsphere/*` | Network topology preflight for promotion gates | Infrastructure boundary | topology validation output |
| `scripts/validation/*` | Assertion chain and aggregated compliance-state computation | Validation evidence boundary | assertion logs and compliance summary records |
| `config/environments/*` + `config/schema/*` | Runtime policy input and structural contract definitions | Data contract boundary | XML/XSD validation pass/fail artifacts |

## 12.0 Limitations & Assumptions
1. **Local execution scope:** Scripts assume local execution context with access to Bash, repository paths, and expected tools (`xmllint`, `podman`, `sha256sum`) installed.
2. **Operator-provided inputs:** Action safety relies on caller-provided `scriptPath` and `configPath` being intentional and correct for the target environment.
3. **Dependency sensitivity:** Missing command-line tools produce hard halts; there is no internal package bootstrap.
4. **Schema-centered validation:** Structural correctness is enforced by XSD validation, but semantic correctness of every operational intent remains dependent on script logic and operator selection.
5. **No implicit remediation:** The system does not auto-repair on failure; recovery uses explicit follow-up actions, primarily decommission then re-run.
6. **Governance exclusions:** Governance rationale, external control mapping, and assurance register maintenance are intentionally documented outside this architecture file.

## 13.0 Document Index
Referenced implementation files and navigation pointers:

- Entrypoint and orchestration
  - `iato-mcp/orchestrator/dispatch.sh`
  - `iato-mcp/orchestrator/state_check.sh`
  - `iato-mcp/orchestrator/decommission.sh`
  - `iato-mcp/orchestrator/audit_log.sh`
- MCP server and validation
  - `iato-mcp/src/server.ts`
  - `iato-mcp/src/dispatch.ts`
  - `iato-mcp/src/validate.ts`
  - `iato-mcp/src/audit.ts`
- Provisioning and preflight scripts
  - `iato-mcp/scripts/provision/00_preflight.sh`
  - `iato-mcp/scripts/provision/01_apply.sh`
  - `iato-mcp/scripts/provision/02_verify.sh`
  - `iato-mcp/scripts/provision/03_wsdl_preflight.sh`
- Runtime/container scripts
  - `iato-mcp/scripts/container/podman_spawn.sh`
  - `iato-mcp/scripts/container/podman_teardown.sh`
- Infrastructure scripts
  - `iato-mcp/scripts/vsphere/preflight_iac.sh`
  - `iato-mcp/scripts/vsphere/validate_topology.sh`
- Validation and evidence scripts
  - `iato-mcp/scripts/validation/compliance_state.sh`
  - `iato-mcp/scripts/validation/read_binary_log.sh`
  - `iato-mcp/scripts/validation/README.md`
- Configuration and schemas
  - `iato-mcp/config/environments/workstation.xml`
  - `iato-mcp/config/environments/container_base.xml`
  - `iato-mcp/config/environments/vsphere_preflight.xml`
  - `iato-mcp/config/schema/iato_policy.xsd`
  - `iato-mcp/config/schema/container.xsd`
  - `iato-mcp/config/schema/network.xsd`
  - `iato-mcp/config/schema/dress_service.xsd`

Governance rationale is defined in:
`docs/GRC_CONTROL_RATIONALE_CROSSWALK.md`

Control effectiveness and evidence tracking is defined in:
`docs/CONTROL_ASSURANCE_REGISTER.csv`
