# ETHOS

## 1.0 Overview

### Purpose of ETHOS

This document defines the control philosophy of the SIRA + IĀTŌ repository at the intent layer: why the system is shaped the way it is, what behaviors are considered acceptable, and what boundaries are treated as non-negotiable. ETHOS is not a runbook, a validation report, or a control test register. It is the governing logic that explains why bounded dispatch exists, why deterministic configuration is preferred, why explicit audit records are mandatory, and why some forms of convenience are intentionally rejected.

The repository combines two distinct but aligned domains:

- **SIRA analytics** (top-level `run_all.R`, `config/sira.toml`, and `scripts/`) for stochastic risk and valuation calculations under a fixed parameter set.
- **IĀTŌ orchestration** (`iato-mcp/`) for bounded operational actions executed through enumerated dispatch and audit-first logging.

The philosophy layer exists to keep those domains coherent. Without ETHOS, implementation details could drift toward implicit behavior, hidden autonomy, or silent error handling that would make outcomes difficult to trust or reproduce.

### Position in system (foundation layer)

ETHOS is the foundation layer beneath architecture and delivery documentation. Architecture describes *what is built* and how components interact. Delivery documents describe *what artefacts are produced* and how engagements are performed. ETHOS defines *why* those structures exist and the behavioral constraints they are meant to preserve.

Concretely, ETHOS frames the repository around four structural commitments:

1. **Execution must be bounded, not open-ended.**
2. **State changes must be intentional and auditable.**
3. **Failure must halt execution rather than degrade silently.**
4. **Operator authority must remain explicit and visible.**

These commitments appear repeatedly in the codebase because they are philosophical choices first, implementation choices second.

---

## 2.0 Core Design Principles

### 2.1 Determinism over autonomy

The system favors deterministic pathways over adaptive or autonomous behavior. Determinism here means that equivalent inputs, configuration, and runtime context should produce equivalent behavior, and that the path from intent to output can be reconstructed after execution.

This is visible in both major layers:

- SIRA centralizes operational parameters in `config/sira.toml` and seeds stochastic components through a declared runtime seed.
- IĀTŌ enforces a finite action space (`apply`, `state_check`, `decommission`, etc.) and rejects unknown actions rather than inferring alternatives.

The philosophical reason is simple: when systems make hidden choices, accountability is diluted. By contrast, deterministic systems preserve reviewability. A reviewer can inspect declared config and call history and explain why an output occurred.

### 2.2 Bounded execution (no open-ended actions)

Bounded execution means the system only performs actions that were explicitly designed, named, and constrained in advance. It refuses “do whatever seems best” instruction patterns. Dispatch is treated as a contract, not a suggestion.

In practice this means:

- Enumerated actions are fixed and finite.
- Tool interfaces require explicit fields (`scriptPath`, `configPath`) for side-effect actions.
- Unknown action names are rejected with halt semantics.

This philosophy reduces ambiguity, limits side-effect surface area, and makes threat modeling tractable. A bounded action space is easier to audit than a dynamic action space because reviewers can evaluate complete behavior rather than probabilistic behavior.

### 2.3 Fail-fast over fail-open

The repository is built on halt-on-failure semantics. This principle is not merely defensive programming; it is a governance position. If critical assumptions fail (invalid config, missing dependencies, unresolved state), continuation is treated as unsafe because it can create outputs that appear valid but are structurally untrustworthy.

Fail-fast behavior preserves integrity by converting uncertainty into visible interruption. In this philosophy, a failed run is preferable to a successful-but-ambiguous run.

### 2.4 Explicit over implicit behavior

The system prefers declared behavior over inferred behavior at every control boundary:

- explicit config loading instead of hidden defaults,
- explicit mode governance for synthetic/live data,
- explicit audit records for each major event,
- explicit operator-triggered remediation rather than automatic retries.

The philosophical benefit is that intent remains inspectable. Explicitness supports post-hoc reconstruction, peer review, and accountable operations without relying on tribal knowledge.

---

## 3.0 Control Philosophy

### 3.1 Non-autonomous system design

The repository is intentionally non-autonomous. It can execute deterministic scripts and produce analytical signals, but it does not claim independent authority to decide operational policy, trading activity, or governance outcomes.

Non-autonomy is expressed structurally:

- The action set is predefined.
- Read-only and state-changing paths are separated.
- Signals are analytical outputs, not self-executing instructions.
- Recovery/decommission is operator-invoked, not auto-triggered with hidden side effects.

This protects against “automation drift,” where systems gradually absorb decisions that were never formally delegated.

#### No hidden decision-making

Hidden decision-making is rejected because it prevents meaningful attribution. The system can evaluate rules and execute declared actions, but it should not invent policy or silently reinterpret intent. Any behavior that changes state must be traceable to explicit user/operator input plus deterministic control logic.

### 3.2 Traceability as a structural requirement

Traceability is not documentation overhead; it is an operational precondition. The architecture assumes that an output is only trustworthy if a reviewer can reconstruct:

- what was requested,
- what was validated,
- what action path executed,
- what halted or completed,
- and where audit evidence was written.

This is why logging is first-class in the orchestration layer and why metadata artefacts are persisted in analytics flow. Traceability is treated as a property of execution, not an afterthought.

Reproducibility follows from this same philosophy. Declared seeds, governed manifest selection, explicit schema checks, and deterministic dispatch all reduce unexplained variability. Reproducibility does not imply that every model output is universally “true”; it means the process is reconstructable under the same constraints.

### 3.3 Purpose limitation

Purpose limitation is the discipline of constraining system claims to what the system is designed to do. The repository performs bounded analytics and bounded orchestration. It does not present itself as a universal decision engine, autonomous remediation framework, or unrestricted runtime shell.

This philosophy protects users and reviewers from category errors. A stochastic risk output is informative but not equivalent to a production order decision. A successful schema check is meaningful but not equivalent to broad operational safety certification.

#### Explicit non-goals

The non-goals posture in this repository is not rhetorical. It is a control boundary. The system explicitly does **not** claim:

- automatic decision authority,
- open-ended environment management,
- hidden privilege expansion,
- semantic guarantees beyond declared validation scope.

By naming non-goals, the repository avoids overstating assurance and keeps operator responsibilities visible.

---

## 4.0 Enforcement Through Architecture

| Principle | Mechanism | Implementation Anchor |
|---|---|---|
| Determinism over autonomy | Single source of runtime parameters and seeded execution | `config/sira.toml`, `scripts/00_config.R`, `scripts/01_load_data.R` |
| Bounded execution | Enumerated action gate and case-based dispatch router | `iato-mcp/src/dispatch.ts`, `iato-mcp/src/server.ts`, `iato-mcp/orchestrator/dispatch.sh` |
| Fail-fast over fail-open | Immediate non-zero exits on missing inputs, invalid schema, failed stages, or state deviation | `run_all.R`, `scripts/00_env_check.R`, `iato-mcp/src/validate.ts`, `iato-mcp/orchestrator/dispatch.sh` |
| Explicit over implicit | Required config/script arguments for state-changing actions; no unknown action fallback | `iato-mcp/src/server.ts`, `iato-mcp/orchestrator/dispatch.sh` |
| Traceability as requirement | Structured session logging with timestamp, host, user, pid, event, detail | `iato-mcp/orchestrator/audit_log.sh`, `iato-mcp/src/audit.ts` |
| Purpose limitation | Read-only governance document tools separated from execution tools | `iato-mcp/src/server.ts` |
| Controlled data mode selection | Manifest-governed selection and hash-dependent live-mode acceptance | `scripts/00_env_check.R`, `scripts/01_load_data.R`, `data/manifest/data_manifest.toml` |
| Operator-owned remediation | Explicit decommission action path instead of automatic hidden repair | `iato-mcp/orchestrator/decommission.sh`, `iato-mcp/src/server.ts` |

The architectural pattern is deliberate: philosophy is enforced by narrowing possible behaviors, not by assuming “good” operator intent.

---

## 5.0 System Constraints

### No silent fallback

The system rejects silent fallback in control-critical paths. If validation fails, config is absent, schema is invalid, data lineage checks fail, or required tooling is unavailable, execution halts. This avoids a dangerous mode where the system keeps running while substituting implicit assumptions.

A related constraint is that fallback logic, where present, remains explicit and bounded. Example: validation may use a library path first and a subprocess path second, but both paths are explicit and both halt on invalid state.

### No implicit privilege escalation

The control philosophy prohibits hidden privilege expansion. Container operations are designed around declared, rootless security posture and config-specified limits. The system does not auto-promote privileges to “make things work.”

This matters philosophically because privilege escalation transforms execution semantics and trust boundaries. If privilege changes are needed, they should be explicit operator decisions outside hidden runtime behavior.

### No uncontrolled execution paths

Uncontrolled execution occurs when runtime actions can be triggered through ambiguous, undocumented, or inferred routes. ETHOS rejects this model. Execution must occur through known interfaces and bounded dispatch.

This includes both analytics and orchestration contexts:

- Analytics stages are sequenced explicitly in `run_all.R` with named stage wrappers.
- Operational actions are routed through enumerated action handlers and dispatch branches.

The result is not perfect prevention of misuse, but strong reduction of ambiguity. The system narrows where behavior can originate and how it can be justified.

---

## 6.0 Anti-Patterns (MANDATORY)

| Anti-Pattern | Why Rejected | System Response |
|---|---|---|
| Unknown or free-form action requests | Introduces ambiguous behavior and hidden side effects | Reject action, emit halt event, return non-success result |
| Continue-after-failure in critical stages | Produces outputs with unclear trust status | Immediate halt with non-zero exit and audit trail |
| Auto-remediation without operator intent | Obscures accountability for destructive/recovery actions | Require explicit `decommission` invocation |
| Implicit data-mode switching | Risks unreviewed use of live data pathways | Manifest-governed mode selection with hash checks and hard stop on invalid live state |
| Silent schema bypass | Allows malformed policy/config artifacts into runtime | Validate against schema; halt on failure |
| Hidden defaults that alter risk semantics | Breaks reproducibility and reviewability | Centralize parameters in declared configuration |
| Logging optionality for state-changing operations | Eliminates reconstruction capability | Emit per-event audit records with session file references |
| Privilege escalation as convenience | Weakens boundary assumptions and containment model | Use constrained container execution patterns and explicit config controls |

Anti-pattern handling is intended to be predictable: reject, halt, and log rather than compensate silently.

---

## 7.0 Boundary Conditions

### What system does NOT do

Under this philosophy, the repository does not:

1. Grant itself decision authority beyond declared computation and orchestration scope.
2. Execute arbitrary actions outside the bounded dispatch contract.
3. Treat schema validity as complete semantic correctness.
4. Convert analytical outputs into autonomous external actions.
5. Guarantee correctness when operator inputs are incorrect or governance steps are bypassed.
6. Replace external approval, review, or accountability functions.

These boundaries are intentional because certainty cannot be manufactured by software posture alone. The system can provide strong structural controls, but it cannot eliminate the need for human responsibility.

### Where operator responsibility begins

Operator responsibility begins at intent declaration and continues through interpretation:

- selecting correct action and parameters,
- ensuring config and payload intent is appropriate,
- reviewing halt conditions rather than bypassing them,
- interpreting analytical outputs within declared non-goals,
- deciding remediation/retry sequencing.

The philosophy therefore splits responsibility clearly:

- **System responsibility:** deterministic execution, explicit validation, auditable records, bounded behavior.
- **Operator responsibility:** contextual judgment, approval, consequence ownership, and boundary-respecting interpretation.

---

## 8.0 Philosophy Diagram (MANDATORY)

```text
[User Intent]
     ↓
[Bounded Dispatch]
     ↓
[Deterministic Execution]
     ↓
[Auditable Output]
```

Interpretation:

- **User Intent** is the only legitimate source of state-changing request authority.
- **Bounded Dispatch** constrains available actions to predefined pathways.
- **Deterministic Execution** applies explicit checks and fixed control flow, halting on violations.
- **Auditable Output** records enough context to reconstruct what occurred and why.

This diagram captures the control philosophy in one chain: intention is constrained, execution is made deterministic, and outputs are rendered reviewable.

---

## 9.0 Limitations

### Philosophy ≠ enforcement

ETHOS defines governing intent, but intent alone does not enforce behavior. Enforcement depends on code integrity, script integrity, runtime dependencies, and disciplined use of the provided interfaces. A strong philosophy can reduce ambiguity and improve control design, yet it does not replace technical and operational verification.

### Depends on operator discipline

The architecture is intentionally operator-facing and non-autonomous. That means correct outcomes depend on operator discipline in selecting actions, maintaining configuration quality, respecting halt signals, and interpreting outputs responsibly.

Even with deterministic dispatch and audit logs, misuse remains possible when users ignore boundaries. ETHOS therefore frames control posture as **shared accountability**: system constraints reduce risk, but disciplined operation is required to realize that reduction.

A practical implication is that success criteria should include not only whether scripts run, but whether the process remained within stated boundaries. Fast execution without boundary discipline is philosophically non-compliant even if technically successful.

---

## 10.0 Document Index

Primary implementation anchors for this philosophy:

- `iato-mcp/orchestrator/dispatch.sh`
- `config/sira.toml`
- `scripts/`

Additional supporting anchors:

- `run_all.R`
- `scripts/00_env_check.R`
- `scripts/00_config.R`
- `scripts/01_load_data.R`
- `iato-mcp/src/server.ts`
- `iato-mcp/src/dispatch.ts`
- `iato-mcp/src/validate.ts`
- `iato-mcp/src/audit.ts`
- `iato-mcp/orchestrator/audit_log.sh`
- `iato-mcp/orchestrator/decommission.sh`
- `data/manifest/data_manifest.toml`

This index is intentionally compact: it points to structural anchors that embody the philosophy without duplicating implementation-level architecture detail.
