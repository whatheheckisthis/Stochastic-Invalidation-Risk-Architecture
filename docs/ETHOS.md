# Professional-Practice 

**Primary documents:**

- [`docs/ETHOS.md`](ETHOS.md) — architectural philosophy
  and stack rationale
- [`docs/DELIVERY.md`](DELIVERY.md) — engagement model,
  delivery artefacts, and GRC control mappings

Read those two documents first. Everything else in this
repository is the operational substrate that supports them.

> This document is a delivery artefact of the IĀTŌ assurance
> programme. It is the operating model. Every other document in
> this repository is the operational substrate that satisfies it.
> Read this document before any other.

---

## Intent

This document defines the structural and operational parameters
of a high-assurance development environment. It is an operating
model, not a configuration guide. The scope is hardening at the
architecture level — before code reaches a pipeline, before a
container starts, before a binary is trusted.

The framework targets ISM and Essential Eight (E8) Maturity Level
4 (ML4). It treats Developer Experience (DX) as an uncontrolled
variable and replaces it with a policy-driven infrastructure
stack: Claude Code, OpenClaw (MCP), Rootless Podman, and
VMware vSphere.

---

## Ethos

```
High-Assurance Systems Engineering Ethos
├── Threat Model
│   ├── Primary vector: unvetted abstractions, not absent tooling
│   └── Black-box dependencies obscure ISA state and kernel behaviour
├── Security Model
│   ├── Security as a mechanical property of architecture
│   ├── Hardening-first over reactive monitoring
│   └── SIEM dependency treated as evidence of misconfiguration
├── Execution Model
│   ├── Terminal-first, auditable command chains
│   ├── MCP-driven orchestration with versioned Bash scripts
│   └── Ephemeral workstations decommissioned on deviation
└── Assurance Surface
    ├── XSD-validated configuration before runtime
    ├── Rootless Podman with user-namespace isolation
    └── Air-gapped vSphere staging for IaC pre-flight validation
```

---

## Operating Themes

These themes govern every tooling decision in the stack.
A decision that cannot be traced to one of these themes
is not a governed decision.

**Security as a structural property of the workflow.**
Not a post-deployment layer. Not a monitoring overlay.
Security is designed into the architecture before the
first line of code executes. A system that requires
continuous alerting to remain secure is fundamentally
misconfigured.

**Abstraction reduction as the primary attack surface
minimisation mechanism.** Every unvetted abstraction is
an unaudited trust relationship. The stack eliminates
abstractions that cannot be inspected — automated
installers, GUI consoles, managed extensions — and
replaces them with terminal-native, auditable toolchains.

**Orchestration-first automation with fully inspectable,
versioned shell execution.** The AI is a systems
administrator with an auditable action log. It executes
versioned Bash scripts. It does not infer configuration
from context. It applies the version-controlled script
or stops.

**Formal configuration validation enforced at the
configuration phase, not runtime.** XML with strict XSD
validation is the configuration format. Parameters must
conform to the defined GRC policy or the configuration
does not run. This is a control boundary, not a style
choice.

**Local staging parity with production.** Misconfigurations
are remediated before cloud promotion, not after. By the
time a template reaches a cloud provider, it is compliant
by default.

---

## 01 — Strategic Intent: Reduction of Architectural Surface

The primary threat in enterprise systems engineering is not
the absence of security tooling. It is the presence of
unvetted abstractions. Automated installers, GUI-based cloud
consoles, and managed IDE extensions introduce opaque
dependencies that obscure the underlying Instruction Set
Architecture (ISA) and kernel state. These are not convenience
features. They are unaudited trust relationships.

First-principles hardening requires:

**Minimalist toolchains.** Environment interaction restricted
to auditable, terminal-based interfaces. Shadow IT eliminated
by design, not policy.

**Instruction-level visibility.** A direct path to hardware
and hypervisor maintained for validating low-level properties:
branchless execution, instruction trace invariance, MMIO
boundary conformance.

**GRC convergence.** Every tooling decision — container
runtime, configuration syntax, binary source — maps to a
traceable control objective in the governance framework.

Reactive InfoSec — SIEM alerting, post-hoc incident response —
is an admission that the architecture was not hardened at
design time. The objective is to minimise the attack surface
to the point where the majority of reactive monitoring has
no surface to operate on.

**Implementation mechanism:** `docs/IATO_MCP_ARCHITECTURE.md §1`

---

## 02 — Deterministic Orchestration: Claude Code and the
## MCP Control Plane

Zero configuration drift requires a deterministic orchestration
layer. In this stack, that responsibility belongs to Claude Code
operating via the Model Context Protocol (MCP), backed by an
OpenClaw server providing a standardised bridge to the WSL2 host.

This is not a generative coding tool. It is a systems
administrator with an auditable action log.

**State enforcement** — the AI executes versioned Bash scripts
stored in a protected repository. It does not infer configuration
from context. It applies the version-controlled script or stops.

**Auditable command chains** — every terminal action is logged
through the MCP layer with a timestamp. This is the proof-of-work
artefact for compliance audits, not a secondary output.

### E8 ML4 compliance via MCP-driven orchestration

| Criterion | Implementation | Document |
|---|---|---|
| Application Control | Provisioning scripts pull only checksum-verified, signed binaries from trusted upstream sources | `docs/IATO_MCP_ARCHITECTURE.md §2` |
| Workstation ephemerality | Any workspace deviation from the known-good state triggers decommission and redeploy from root script | `orchestrator/state_check.sh` + `decommission.sh` |
| Auditability | MCP layer produces time-stamped command records per session | `orchestrator/audit_log.sh` |

The local laboratory is a sterile environment. Deviation is
not corrected in-place — it is eliminated and rebuilt.
[ISM Application Control; ASD E8 ML4]

### Dispatch constraint

Claude Code can invoke exactly six enumerated actions via the
MCP server. No others exist. Unknown action strings halt
immediately and are logged. There is no catch-all. There is
no passthrough. There is no free rein.

| Action | Effect |
|---|---|
| `apply` | Provisions workspace from verified script |
| `state_check` | Compares live FS against SHA-256 in XSD config |
| `decommission` | Eliminates and rebuilds from root script |
| `spawn_container` | Starts rootless Podman container |
| `teardown_container` | Removes container — no in-place repair |
| `vsphere_preflight` | Validates IaC before cloud promotion |

**Implementation mechanism:** `docs/IATO_MCP_ARCHITECTURE.md §2`

---

## 03 — Least Privilege Execution: Rootless Podman and
## Schema Validation

Docker requires a persistent root-level daemon. That daemon
is a privilege escalation vector on the local host. It is
not acceptable in this stack.

Rootless Podman operates via Linux user namespaces. Root
privileges inside a container are mapped to non-privileged
UID/GIDs on the host. Container breakout cannot compromise
the workstation kernel because the escalation path does not
exist at the host level. Each container is a child process
of the user shell — no central daemon, no single point of
failure. [ISM: Restrict Administrative Privileges]

### Configuration correctness via XSD

JSON and YAML are operationally convenient. They are not
appropriate for high-assurance configuration management.
Neither enforces schema at the parser level. Both permit
structurally valid files that violate policy constraints
silently.

This framework uses XML with strict Schema Validation (XSD).
Configurations are validated against the schema before
execution. Parameters — memory alignment, network isolation,
service entitlements — must conform to the defined GRC policy
or the configuration does not run. Runtime errors caused by
misconfiguration are caught at the configuration phase.

This is not a style choice. It is a control boundary.

### Schema-level controls (non-negotiable)

| XSD constraint | Effect |
|---|---|
| `rootless="true"` with `fixed="true"` | Cannot be set to false — schema rejects it |
| `memory/limit_mib` enumeration | Power-of-two values only (128–4096) |
| `network/mode` enumeration | `none`, `internal`, `slirp4netns` only |
| `sha256` pattern `[a-f0-9]{64}` | Malformed hashes rejected at parse time |
| `environment/mode` enumeration | `sterile`, `preflight`, `audit` only |

**Implementation mechanism:** `docs/IATO_MCP_ARCHITECTURE.md §3`

---

## 04 — Infrastructure Portability: VMware vSphere as
## Local Private Cloud

Testing IaC templates directly in a public cloud tenant
introduces unnecessary cost, blast radius risk, and audit
noise. vSphere provides a local, air-gapped environment with
enterprise-grade hardware fidelity — a data centre in a box.

IaC pre-flight staging allows complex network topologies
and IAM policies to be tested and validated locally.
Over-privileged service principals and improper subnetting
are identified and remediated before the code reaches a
cloud provider. By the time it promotes, it is compliant
by default. [NIST SP 800-218 SSDF]

Headless management — the vSphere environment is CLI and
API only. No GUI surface. This is also the validation layer
for architecture-specific instruction testing: ARMv9 SVE2
behaviour within a virtualised context that mirrors the
target production hardware. Instruction-level determinism
is confirmed across the deployment pipeline before anything
leaves the local environment.

**Implementation mechanism:** `docs/IATO_MCP_ARCHITECTURE.md §4`

---

## 05 — Control Mapping: GRC Alignment

| Tooling Component | SDLC Phase | ISM / E8 Control Objective |
|---|---|---|
| OpenClaw / MCP | Provisioning and Orchestration | Application Control — automated script validation and session auditability |
| Rootless Podman | Execution and Containerisation | Restrict Administrative Privileges — rootless user-namespace isolation |
| VMware vSphere | Pre-flight Staging and Validation | Secure Infrastructure Design — air-gapped IaC testing |
| WSL2 / Linux Kernel | Core Development | OS and Library Patching — automated local vulnerability remediation |
| XML Schema (XSD) | Configuration Management | Data Integrity — schema-enforced verification of infrastructure state |

Full crosswalk: [`docs/governance/control-crosswalk.csv`](governance/control-crosswalk.csv)
Implementation detail: `docs/IATO_MCP_ARCHITECTURE.md §5`

---

## 06 — Operating Criteria

Milestone-based operating criteria. Not feature delivery goals.

| Milestone | Criterion | Target Evidence |
|---|---|---|
| M1 — Workflow Conformance Gate | CI policy checks enforce repository workflow conformance | CI gate logs, conformance reports, exception register |
| M2 — Release Evidence Integrity | Signed artefact deliverables with provenance templates | Signed attestations, signature verification outputs, release evidence bundle |
| M4 — Formal Depth | Lean/HOL proof deliverables for security-critical decision logic where SOC context justifies | Proof artefacts, proof-to-control traceability notes |

Evidence produced per milestone:
`docs/IATO_MCP_ARCHITECTURE.md §6`

---

## Non-goals

- **Not a generative configuration system.** No config is
  inferred or generated from context. All config is
  version-controlled and XSD-validated before execution.
- **Not a self-healing system.** Deviation triggers
  elimination and rebuild, not in-place correction.
  This is a design property, not a limitation.
- **Not a cloud management plane.** vSphere is local
  pre-flight only. Cloud promotion is operator-executed.
- **Not a secrets manager.** No credentials or keys stored
  in config or audit logs.
- **Not a CI/CD pipeline.** Local sterile laboratory control
  plane. Pipeline integration is operator-scoped.
- **Not a SIEM replacement.** SIEM dependency is evidence
  of misconfiguration. This stack minimises the surface
  SIEM would need to monitor.

---

## References

- [`docs/IATO_MCP_ARCHITECTURE.md`](IATO_MCP_ARCHITECTURE.md)
  — implementation detail for every operating theme in
  this document
- [`docs/DELIVERY.md`](DELIVERY.md)
  — engagement model and delivery artefacts
- [`docs/governance/control-crosswalk.csv`](governance/control-crosswalk.csv)
  — full GRC control crosswalk
- ASD. *Essential Eight Maturity Model.*
  https://www.cyber.gov.au/resources-business-and-government/
  essential-cyber-security/essential-eight
- ASD. *Information Security Manual (ISM).*
  https://www.cyber.gov.au/resources-business-and-government/
  essential-cyber-security/ism
- NIST SP 800-218. *Secure Software Development Framework.*
  https://csrc.nist.gov/publications/detail/sp/800-218/final
