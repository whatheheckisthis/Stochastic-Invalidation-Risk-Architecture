# MCP Orchestration Layer: Architecture and Control Reference

> This document is a delivery artefact of the IĀTŌ assurance programme.
> It extends `docs/ETHOS.md` into operational implementation detail for the
> MCP orchestration layer. Read ETHOS.md first — this document assumes it.

---

## Relationship to ETHOS

ETHOS.md defines the operating model. This document defines the implementation
that satisfies it. Every section below maps to a named operating theme or
numbered section in ETHOS.md. Where ETHOS makes a claim, this document
provides the mechanism.

| ETHOS section | This document section |
|---|---|
| 01 — Strategic Intent: Reduction of Architectural Surface | §1 Threat model and scope |
| 02 — Deterministic Orchestration: Claude Code and MCP | §2 Orchestration layer |
| 03 — Least Privilege Execution: Rootless Podman and XSD | §3 Container runtime and schema |
| 04 — Infrastructure Portability: VMware vSphere | §4 vSphere pre-flight |
| 05 — Control Mapping: GRC Alignment | §5 Compliance crosswalk |
| 06 — Operating Criteria | §6 Evidence register |

---

## §1 — Threat Model and Scope

ETHOS identifies the primary threat as unvetted abstractions, not absent tooling:

> *"Automated installers, GUI-based cloud consoles, and managed IDE extensions
> introduce opaque dependencies that obscure the underlying ISA and kernel state.
> These are not convenience features. They are unaudited trust relationships."*

The MCP orchestration layer is the architectural response. It removes human
discretion from the execution path and replaces it with a deterministic
dispatch harness backed by version-controlled, checksum-verified scripts.

Scope of this layer:

- All provisioning and configuration actions on the WSL2 host
- All container lifecycle operations (spawn, teardown, rebuild)
- All IaC pre-flight validation before vSphere or cloud promotion
- All audit record production for compliance evidence

Out of scope:

- Cloud provider management planes (operator-executed after pre-flight pass)
- Secret injection (operator-managed, not stored in config or audit logs)
- CI/CD pipeline integration (operator-scoped per engagement)

---

## §2 — Orchestration Layer

### Architecture

```
Claude Code
    │
    │  MCP protocol
    ▼
OpenClaw server  ──────────────────────────────────────────────────
    │                                                              │
    │  WSL2 bridge                                                 │
    ▼                                                              │
orchestrator/dispatch.sh   ← single entry point, no bypass       │
    │                                                              │
    ├── audit_log.sh        ← every action, timestamped           │
    ├── state_check.sh      ← known-good comparator               │
    └── decommission.sh     ← eliminate and rebuild on deviation  │
                                                                   │
scripts/                                                           │
    ├── provision/          ← checksum + XSD + apply + verify     │
    ├── container/          ← rootless Podman spawn / teardown    │
    └── vsphere/            ← IaC pre-flight, network assertion   │
                                                                   │
config/                                                            │
    ├── schema/*.xsd        ← policy schemas, parser-level        │
    └── environments/*.xml  ← governed state declarations ────────┘
```

### Governing principle

This is not a generative coding tool. It is a systems administrator
with an auditable action log.

The AI executes versioned Bash scripts stored in a protected repository.
It does not infer configuration from context. It applies the
version-controlled script or stops.

ETHOS §02 states this directly. The dispatch harness enforces it mechanically:
unknown actions halt with a logged exit code. There is no catch-all passthrough.
No shell injection surface. No silent failure.

### Dispatch harness (`orchestrator/dispatch.sh`)

Single entry point. Claude Code calls this script. Nothing else.

Enumerated actions:

| Action | Script invoked | Halt condition |
|---|---|---|
| `apply` | `00_preflight` → `01_apply` → `02_verify` | Any stage failure |
| `state_check` | `state_check.sh` | Deviation detected (exit 2) |
| `decommission` | `decommission.sh` | Rebuild script failure |
| `spawn_container` | `podman_spawn.sh` | XSD invalid or Podman failure |
| `teardown_container` | `podman_teardown.sh` | Podman failure |
| `vsphere_preflight` | `preflight_iac.sh` | XSD invalid or topology failure |
| unknown | — | Immediate halt, logged |

Exit 2 on state deviation is a distinct signal from exit 1 on operational
failure. Callers must handle both — exit 2 is the decommission trigger.

### Audit log (`orchestrator/audit_log.sh`)

Every terminal action is logged through the MCP layer with a timestamp.
This is the proof-of-work artefact for compliance audits — not a secondary output.

ETHOS §02 is unambiguous on this: auditability is the primary output of
the orchestration layer, not a side effect.

Log record format (machine-parseable, human-readable):

```
2026-04-01T04:12:33.441Z | IATO-MCP | host=ws01 user=dhruv pid=4421 | ACTION | apply script=01_apply.sh config=workstation.xml
```

Fields: `timestamp | programme | host user pid | event | detail`

Session files:

- One file per dispatch invocation
- Named `YYYYMMDDTHHMMSS_PID.log`
- Append-only — never overwritten
- Stored under `audit/session/`
- `.gitignored` from commit, retained on disk for compliance retention
- Retention schedule is an operator action item (see §6)

### State enforcement

ETHOS §02:

> *"Any workspace deviation from the known-good state triggers decommission
> and redeploy from root script."*

The local laboratory is a sterile environment. Deviation is not corrected
in-place — it is eliminated and rebuilt.

`state_check.sh` compares live filesystem state against SHA-256 checksums
declared in the XSD-validated XML configuration. Three exit paths:

- Exit 0 → known-good, proceed
- Exit 1 → operational failure (config invalid, tool unavailable)
- Exit 2 → state deviation detected — dispatch triggers `decommission.sh`

`decommission.sh` stops and removes all declared containers, removes all
declared workspace paths, then executes the rebuild script declared in the
XML config. The rebuild script itself is checksum-verified before execution.

---

## §3 — Container Runtime and Schema Validation

### Rootless Podman

ETHOS §03:

> *"Docker requires a persistent root-level daemon. That daemon is a privilege
> escalation vector on the local host. It is not acceptable in this stack."*

Rootless Podman operates via Linux user namespaces. Root privileges inside
a container are mapped to non-privileged UID/GIDs on the host. Container
breakout cannot compromise the workstation kernel because the escalation
path does not exist at the host level.

Each container is a child process of the user shell — no central daemon,
no single point of failure. [ISM: Restrict Administrative Privileges]

Flags enforced on every spawn — non-negotiable, sourced from XSD config:

| Flag | Purpose | Control |
|---|---|---|
| `--security-opt no-new-privileges` | Blocks in-container privilege escalation | ISM: Restrict Admin Privileges |
| `--read-only` | Immutable container filesystem | E8 ML4: Application Control |
| `--cap-drop ALL` | No Linux capabilities by default | ISM: Least Privilege |
| `--network none\|internal\|slirp4netns` | Declared in XSD, no runtime override | ISM: Network Segmentation |
| `--uidmap / --gidmap` | User namespace isolation, declared in XSD | ISM: Restrict Admin Privileges |

Network mode is an XSD enumeration — only `none`, `internal`, or `slirp4netns`
are valid at the schema level. Any other value causes XSD validation failure
before Podman is invoked.

### XSD schema validation

ETHOS §03:

> *"JSON and YAML are operationally convenient. They are not appropriate
> for high-assurance configuration management. Neither enforces schema at
> the parser level. Both permit structurally valid files that violate policy
> constraints silently."*

> *"This is not a style choice. It is a control boundary."*

XML with strict XSD validation is the configuration format for this layer.
Configurations are validated against the schema before execution. Parameters
must conform to the defined GRC policy or the configuration does not run.

Key schema-level controls:

| XSD constraint | Effect | Corresponding control |
|---|---|---|
| `rootless="true"` with `fixed="true"` | Cannot be set to false — schema rejects it | ISM: Restrict Admin Privileges |
| `memory/limit_mib` enumeration | Only power-of-two values valid (128–4096) | Host stability, resource governance |
| `network/mode` enumeration | Only `none`, `internal`, `slirp4netns` | Network isolation |
| `sha256` pattern `[a-f0-9]{64}` | Malformed hashes rejected at parse time | Integrity verification |
| `environment/mode` enumeration | `sterile`, `preflight`, `audit` | Deviation response governance |
| `environment/runtime` enumeration | `wsl2_ubuntu`, `vsphere_local`, `air_gapped` | Environment classification |

The `mode` attribute on `environment` maps directly to operational posture:

- `sterile` → deviation triggers decommission and rebuild
- `preflight` → deviation triggers halt, no rebuild
- `audit` → deviation logged only, execution continues

---

## §4 — vSphere Pre-flight

ETHOS §04:

> *"Testing IaC templates directly in a public cloud tenant introduces
> unnecessary cost, blast radius risk, and audit noise."*

> *"By the time it promotes, it is compliant by default."*

The vSphere pre-flight module enforces two assertions before any IaC
template is permitted to progress toward cloud promotion:

**Network isolation assertion** — the XML config's network isolation
attribute must be `vsphere_internal` or `full`. `host_only` is rejected
for vSphere pre-flight contexts — it indicates a workstation-only scope
that has not been configured for topology validation.

**CIDR scope assertion** — no network segment may declare a public routable
CIDR. RFC 1918 ranges (10.x, 172.16–31.x, 192.168.x) are the only valid
ranges for local pre-flight environments. External CIDRs indicate an
incompletely localised template that would introduce blast radius risk
if applied directly.

ETHOS §04 also identifies vSphere as the ARMv9 SVE2 instruction validation
layer. Headless management — CLI and API only, no GUI surface — is enforced
by the absence of any GUI tooling in the stack. The vSphere module in this
layer interacts exclusively through the govc CLI (operator-installed).

---

## §5 — Compliance Crosswalk

Full crosswalk reference: `docs/governance/control-crosswalk.csv`

Summary by component:

| Component | Framework | Control | Coverage | Gap flag |
|---|---|---|---|---|
| `dispatch.sh` | ISM | Application Control | FULL | NO |
| `audit_log.sh` | ISM | Event Logging ISM-0109 | FULL | NO |
| `audit_log.sh` | SOC 2 | CC7.2 Monitoring and Exception Handling | FULL | NO |
| `audit_log.sh` | E8 ML4 | Audit logging | FULL | NO |
| `00_preflight.sh` | E8 ML4 | Application Control — signed binary verification | FULL | NO |
| `00_preflight.sh` | ISM | Software integrity — checksum and GPG | FULL | NO |
| `state_check.sh` | E8 ML4 | Workstation ephemerality | FULL | NO |
| `decommission.sh` | E8 ML4 | Workstation ephemerality | FULL | NO |
| `iato_policy.xsd` | ISM | Configuration management — schema enforcement | FULL | NO |
| `podman_spawn.sh` | ISM | Restrict Administrative Privileges | FULL | NO |
| `podman_spawn.sh` | E8 ML4 | Application Control — container isolation | FULL | NO |
| `vsphere_preflight.sh` | NIST SSDF | PW.1.2 Pre-flight IaC validation | PARTIAL | OPERATOR_DEPENDENT |
| `audit/session/` | ISM | Records retention | PARTIAL | OPERATOR_DEPENDENT |

OPERATOR_DEPENDENT items:

- `vsphere_preflight.sh` — requires govc or equivalent vSphere CLI installed
  and authenticated by operator before invocation
- `audit/session/` — operator must define retention schedule and off-host
  backup procedure; in-repo storage is ephemeral scratchpad only

ETHOS §05 control mapping table is the authoritative reference for tooling
component to SDLC phase to ISM/E8 control objective alignment. This crosswalk
extends it with implementation-level coverage assessment and gap flags
consistent with the IĀTŌ crosswalk schema used in the SIRA programme.

---

## §6 — Evidence Register

ETHOS §06 defines milestone-based operating criteria. This section maps each
milestone to the evidence artefacts produced by the MCP orchestration layer.

| Milestone | ETHOS criterion | Evidence produced by this layer |
|---|---|---|
| M1 — Workflow Conformance Gate | CI policy checks enforce repository workflow conformance | `audit/session/*.log` per dispatch; preflight pass/fail records; XSD validation output |
| M2 — Release Evidence Integrity | Signed artefact deliverables with provenance templates | `00_preflight.sh` GPG verification records; SHA-256 comparison logs; config baseline diffs |
| M4 — Formal Depth | Lean/HOL proof deliverables for security-critical decision logic | Dispatch harness action enumeration is the formal boundary; proof scope is operator-defined per engagement |

### Operator action items

Items outside repository boundary — operator must complete before this
layer produces audit-ready evidence:

1. Populate `sha256` values in all XML configs at controlled release —
   no file entry ships with empty hash fields.
2. Define `audit/session/` retention schedule and off-host backup
   procedure for compliance evidence retention.
3. Install and authenticate govc (or equivalent vSphere CLI) before
   invoking `vsphere_preflight.sh`.
4. Configure GPG keyring with trusted signing keys for binary signature
   verification in `00_preflight.sh`.
5. Set `uid_map` and `gid_map` ranges in `workstation.xml` to match
   the host's `/etc/subuid` and `/etc/subgid` entries.
6. Validate xmllint availability in WSL2 environment:
   `apt-get install -y libxml2-utils`

---

## Non-goals

Consistent with ETHOS §01 and the IĀTŌ non-goals register:

- **Not a generative configuration system.** No config is inferred or
  generated from context. All config is version-controlled and XSD-validated
  before execution.
- **Not a self-healing system.** Deviation triggers elimination and rebuild,
  not in-place correction. This is a design property, not a limitation.
- **Not a cloud management plane.** The vSphere module is local pre-flight
  only. Cloud promotion is operator-executed after pre-flight pass.
- **Not a secrets manager.** No credentials, tokens, or keys are stored in
  XML config or audit logs. Operator-managed secret injection is assumed.
- **Not a CI/CD pipeline.** This is a local sterile laboratory control plane.
  Pipeline integration is operator-scoped per engagement.
- **Not a SIEM replacement.** ETHOS §01 is explicit: SIEM dependency is
  evidence of misconfiguration, not a target state. This layer minimises
  the surface SIEM would need to monitor.

---

## References

- ETHOS.md — `docs/ETHOS.md` (operating model; read before this document)
- ASD. *Essential Eight Maturity Model: Application Control Guidelines.*
- ASD. *Information Security Manual (ISM): Guidelines for Restricting
  Administrative Privileges and Container Security.*
- NIST SP 800-218. *Secure Software Development Framework (SSDF)
  for Infrastructure-as-Code Validation.*
- Control crosswalk: `docs/governance/control-crosswalk.csv`
