# Technical Crosswalk — GRC-Driven Design Elements (SIRA + IĀTŌ)

## Purpose

This crosswalk isolates **only** the platform elements that exist because of explicit GRC principles, then maps them to:

- **OCEG GRC Capability Model concepts** (purpose limitation, traceability, non-autonomy, Principled Performance)
- **NZISM** governance/assurance intent (risk-based controls, evidence, accreditation readiness)
- **FAIR** quantification constructs (loss event scenarios, control effectiveness/variance, loss magnitude drivers)
- **NIST RMF (light wrapper)** for lifecycle assurance framing

The goal is to preserve the "why" so controls are not mistaken for cargo-cult governance.

---

## Crosswalk Table

### Design intent → control mechanics → assurance mapping

| GRC-driven element | Why it exists (governance rationale) | OCEG principle anchor | NZISM governance/assurance linkage | FAIR linkage (quant risk view) | NIST RMF / assurance wrapper | Evidence in repo |
|---|---|---|---|---|---|---|
| **Single dispatch entrypoint** (`iato-mcp/orchestrator/dispatch.sh`) | Prevents ad hoc command execution and enforces a bounded action vocabulary. | **Non-autonomy**, **traceability**, Principled Performance | Deterministic control execution path supports auditable governance decisions and reduces operator-induced variance. | Constrains threat event frequency from unsafe operations by reducing uncontrolled action paths. | **Implement + Monitor** (execution controls and continuous evidence) | `iato-mcp/orchestrator/dispatch.sh`<br>`docs/IATO_MCP_ARCHITECTURE.md` |
| **Enumerated/deny-by-default actions** (unknown action halts) | Eliminates hidden capability expansion and implicit privileges. | **Purpose limitation**, **non-autonomy** | Supports least-functionality posture and explicit authorization boundaries. | Improves control strength against misuse/abuse scenarios by narrowing attack/action surface. | **Select + Implement** | `iato-mcp/orchestrator/dispatch.sh`<br>`docs/ETHOS.md` |
| **Mandatory preflight chain** (`00_preflight` → `01_apply` → `02_verify`) | Enforces preconditions before state change; fail-loud instead of fail-open. | Principled Performance, **traceability** | Aligns to assurance expectation that changes are validated before promotion/accreditation steps. | Reduces variance in control effectiveness (fewer malformed deployments). | **Assess + Authorize** (gated readiness) | `iato-mcp/orchestrator/dispatch.sh`<br>`iato-mcp/scripts/provision/*` |
| **Timestamped session audit logs** (`audit_emit`) | Makes each action reconstructable for review, incident analysis, and assurance evidence. | **Traceability**, Principled Performance | Directly supports evidence-of-effectiveness and audit trail retention expectations. | Enables post-event calibration of control efficacy and scenario frequency assumptions. | **Monitor** | `iato-mcp/orchestrator/audit_log.sh`<br>`docs/IATO_MCP_ARCHITECTURE.md` |
| **State deviation semantics (exit 2) + decommission path** | Distinguishes drift from generic failures and triggers rebuild rather than local patching. | Principled Performance, **non-autonomy** | Supports integrity of accredited baseline and controlled remediation workflow. | Models control invalidation events (e.g., environment compromise) and recovery response quality. | **Monitor + Respond** (RMF monitor cadence) | `iato-mcp/orchestrator/state_check.sh`<br>`iato-mcp/orchestrator/decommission.sh`<br>`docs/IATO_MCP_ARCHITECTURE.md` |
| **Rootless Podman with hard security flags** | Mechanical least privilege and blast-radius reduction at runtime. | Principled Performance | Supports NZISM intent for privilege restriction, isolation, and hardened execution boundaries. | Lowers probable loss magnitude and event propagation in compromise scenarios. | **Select + Implement** | `iato-mcp/scripts/container/podman_spawn.sh`<br>`docs/IATO_MCP_ARCHITECTURE.md`<br>`docs/ETHOS.md` |
| **XSD-validated configuration as control boundary** | Prevents structurally invalid or policy-invalid config from reaching execution. | Principled Performance, **purpose limitation** | Governance-by-schema supports repeatable accreditation evidence and policy conformance checks. | Reduces control failure probability from configuration error; tightens estimate confidence intervals. | **Categorize + Select + Assess** | `iato-mcp/config/schema/*.xsd`<br>`docs/ETHOS.md`<br>`docs/IATO_MCP_ARCHITECTURE.md` |
| **vSphere IaC preflight before promotion** | Pushes control validation left to reduce production blast radius and audit noise. | Principled Performance | Supports risk-based governance and pre-deployment assurance verification. | Scenario testing improves estimation of loss event frequency under infrastructure misconfiguration shocks. | **Assess + Authorize** | `iato-mcp/scripts/vsphere/preflight_iac.sh`<br>`iato-mcp/scripts/vsphere/validate_topology.sh`<br>`docs/ETHOS.md` |
| **Runtime env/data preflight in SIRA** (`scripts/00_env_check.R`) | Verifies dependency integrity, manifest status, hash checks, and live-data gating before analytics. | **Traceability**, Principled Performance | Supports evidence that analytic outputs run under controlled, verified conditions. | Creates measurable control quality signals (hash pass/fail, approval completeness) for FAIR scenario inputs. | **Assess + Monitor** | `scripts/00_env_check.R`<br>`data/manifest/data_manifest.toml` |
| **Manifest + lineage registry** (`data/manifest`, `data/lineage`) | Formalizes data custody, mode segregation, approval fields, and source trace. | **Traceability**, **purpose limitation** | Aligns with assurance expectations for data provenance and accountable use boundaries. | Improves estimation of secondary loss risk tied to data integrity/provenance defects. | **Categorize + Monitor** | `data/manifest/data_manifest.toml`<br>`data/lineage/*.toml`<br>`data/lineage/README.md` |
| **Synthetic/live mode guardrails with halt on live hash failure** | Prevents silent downgrade/fallback when live data controls are incomplete. | Principled Performance, **non-autonomy** | Demonstrates deterministic control behavior and prevents unapproved ingestion paths. | Maps directly to “control failure under stress” assumptions in ransomware/supply-chain shock scenarios. | **Implement + Monitor** | `scripts/00_env_check.R` |
| **Non-goals register** (`notebooks/sira_non_goals_table.md`) | Hard-bounds intended use so outputs cannot be misrepresented as autonomous decisions or compliance attestations. | **Purpose limitation**, **non-autonomy** | Supports governance boundary definition and controlled claims in assurance reporting. | Prevents model misuse scenarios that would inflate threat event frequency and loss magnitude. | **Categorize + Authorize** (intended-use boundary) | `notebooks/sira_non_goals_table.md`<br>`docs/SIRA_EVIDENCE_GAP_REGISTER.md` |
| **Notebook disclaimer + NOTICE discipline** | Separates license rights from assurance claims and prevents authority laundering in academic/regulatory contexts. | **Purpose limitation**, **traceability** | Reinforces truthful evidence handling and claim discipline in governance artefacts. | Reduces legal/reputational secondary loss from misuse of outputs/claims. | **Govern (overlay)** | `notebooks/DISCLAIMER.md`<br>`notebooks/NOTICE_BLOCK.md`<br>`NOTICE`<br>`LICENSE` |
| **Deterministic seed/config-driven scenarios** | Reproducible outcomes for committee review and challenge rather than opaque model behavior. | **Traceability**, Principled Performance | Supports repeatable assurance testing and evidence reproducibility. | Enables stable control-effectiveness comparisons across FAIR loss scenarios. | **Assess + Monitor** | `config/sira.toml`<br>`scripts/02_analysis.R`<br>`run_all.R` |
| **Stochastic invalidation stress layer** (tail shocks, scenario invalidation) | Explicitly models control breakdown under severe conditions instead of assuming static control efficacy. | Principled Performance | Aligns with risk-based assurance expectation that controls are tested under stress, not only nominal operation. | Native fit for FAIR: estimate distribution shifts when controls degrade under ransomware/supply-chain events. | **Assess + Monitor** (ongoing risk response) | `scripts/stochastic_invalidation_base_r.R`<br>`scripts/02_analysis.R`<br>`docs/CREDIT_RISK_LAYER.md` |

---

## FAIR Interpretation Section

### FAIR-oriented interpretation for cyber scenarios (ransomware / supply-chain)

Use the above controls as **scenario variables**, not check-boxes:

1. **Threat event frequency inputs**
   - Action-surface controls (single dispatch, enumerated actions, XSD gating) reduce opportunity for unsafe or malicious execution paths.
2. **Vulnerability/control strength inputs**
   - Preflight rigor, hash verification, and state-deviation rebuild semantics are direct proxies for preventive and detective control strength.
3. **Loss magnitude shaping**
   - Rootless isolation, network mode constraints, and intended-use boundaries reduce probable primary/secondary loss ranges.
4. **Control invalidation modelling**
   - SIRA stochastic invalidation layer supports representing degraded control effectiveness under systemic shocks.

---

## Governance Narrative

### Minimal governance narrative (to avoid cargo-cult controls)

- **Purpose limitation:** The system is explicit about what it is *not* authorized to do (non-goals, disclaimers, bounded actions).
- **Traceability:** Every governed action and dataset path is reconstructable (logs, manifest, lineage, deterministic config).
- **Non-autonomy:** Controls intentionally block autonomous drift (deny-by-default actions, hard halts, no silent fallback).
- **Principled Performance:** Controls are engineered as runtime mechanics with measurable evidence, then stress-tested under failure conditions.

If a future control cannot be mapped to one of those four principles **and** an evidence artefact, it should be treated as non-governed overhead.
