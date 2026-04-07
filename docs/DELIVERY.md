
# DELIVERY MODEL

## Capability Domains

| Domain | Delivery Capability |
|--------|-------------------|
| SecDevOps | Enforcement of control integrity across CI/CD pipelines and runtime environments under policy-constrained execution contexts |
| GRC | Structured control gap identification and evidence-based validation against defined target control frameworks |
| Quantitative Risk Governance | Scenario-conditioned risk analytics with deterministic replay and auditable model execution lineage |

---

## Operating Model

| Attribute | Delivery Positioning |
|----------|--------------------|
| Engagement Type | Fixed-term control uplift with defined entry/exit criteria |
| Scope Discipline | Explicitly bounded; no rolling scope or iterative backlog dependency |
| Delivery Construct | Controlled execution workflow with full audit traceability |
| Output Standard | Assessor-ready evidence pack aligned to external validation requirements |
| Assurance Position | Independent validation and control effectiveness demonstration (not advisory-led transformation) |

---

## Delivery Outcomes

- Formalised **control state assessment** against a defined target operating model  
- Execution of **governed validation workflows** under constrained runtime conditions  
- Production of **deterministic, reproducible analytical outputs** (where applicable)  
- Assembly of a **structured assurance artefact set** suitable for independent review  

---

## Evidence Composition

| Artefact Class | Assurance Function |
|---------------|------------------|
| Input State (configuration, data lineage, parameter sets) | Establishes traceability and input governance |
| Execution Record (logs, command path, runtime context) | Demonstrates procedural integrity and control adherence |
| Analytical Outputs (charts, datasets, scenario summaries) | Provides observable risk and control outcomes |
| Platform Audit Evidence (system audit logs / cloud policy telemetry) | Confirms enforcement of the underlying control environment |

---

## Delivery Workflow

```text
Governed Input State
        ↓
Policy-Constrained Execution
        ↓
Deterministic Output Generation
        ↓
Evidence Consolidation
        ↓
Independent Review / Validation
````

### Execution Constraints

* No uncontrolled or ad hoc execution paths
* No partial or staged delivery artefacts
* No post-execution modification outside governed change control

---

## Core Delivery Principles

| Principle                     | Interpretation                                                                            |
| ----------------------------- | ----------------------------------------------------------------------------------------- |
| Control Boundedness           | All engagements operate within predefined control and scope boundaries                    |
| Evidence Primacy              | Verifiable artefacts—not narrative assertion—must support all conclusions                 |
| Deterministic Reproducibility | Outputs must be replayable under identical governed conditions                            |
| Fail-Fast Integrity           | Control breaches or invalid states result in immediate termination and recorded exception |

---

## Explicit Non-Scope

* Continuous advisory or retained consulting models
* Unbounded transformation or programme delivery
* Automated decisioning or policy enforcement mechanisms
* Persistent managed services or monitoring constructs

---

## Completion Criteria

| Condition            | Requirement                                                      |
| -------------------- | ---------------------------------------------------------------- |
| Controlled Execution | Full workflow executed within a policy-enforced environment      |
| Output Integrity     | All artefacts generated and preserved without modification       |
| Reproducibility      | Outputs can be re-derived from the same governed input state     |
| Audit Traceability   | Execution fully supported by system or platform audit evidence   |
| Delivery Status      | Only complete, successful runs are considered valid deliverables |

---

## Practice Definition

> Delivery of fixed-term assurance engagements focused on control validation, deterministic analytical execution, and production of externally assessable evidence supporting control effectiveness.

---

# Evidence Specification

Each engagement produces a **structured, assessor-ready evidence pack** to support independent validation of:

* Control effectiveness
* Execution integrity
* Platform enforcement posture

The evidence pack is **not a report** — it is a **reconstructable execution record**.

---

## Evidence Pack Structure

| Artefact Layer                  | Included Components                                                                                                                                                    | Assurance Objective                                                       |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| Input Governance                | Configuration snapshot (`config` state)<br>Data manifest and lineage references<br>File hash validation outputs (SHA/checksum)<br>SELinux file context state (`ls -Z`) | Establishes input integrity, provenance, and policy-aligned data handling |
| Execution Trace                 | Full console log (stdout/stderr)<br>Command invocation record<br>Runtime environment details (R version, packages)<br>Execution timestamps and stage markers           | Demonstrates procedural integrity and controlled execution pathway        |
| Analytical Outputs              | Scenario outputs (tables/summaries)<br>Visual artefacts (charts)<br>Serialized metadata (`.rds` or equivalent)<br>Deterministic seed reference                         | Provides observable outcomes with replay capability                       |
| Platform Audit Evidence (RHEL)  | SELinux enforcement state (`getenforce`)<br>File context validation<br>`auditd` extract (`ausearch`)<br>AVC denial records                                             | Confirms Mandatory Access Control (MAC) enforcement                       |
| Platform Audit Evidence (Azure) | Log Analytics export<br>Container/runtime logs<br>Managed Identity trace<br>Azure Policy compliance snapshot                                                           | Confirms cloud control plane enforcement                                  |
| Output Integrity                | Output directory listing<br>File hashes<br>SELinux context validation on outputs                                                                                       | Ensures artefact immutability and integrity                               |

---

### Control Evidence

Evidence packs generated on RHEL systems include **Mandatory Access Control validation** as a first-class assurance artefact.

### Mode Confirmation

```bash
getenforce  # must return Enforcing
```

### File Context Verification

```bash
ls -Z data/
ls -Z output/
```

### Audit Trail Extraction

```bash
ausearch -ts [START_TIME] -te [END_TIME] -i > audit_extract.log
```

### AVC (Access Vector Cache) Denials

* Included where present
* Treated as **control exceptions**, not suppressed events

**Assurance Position:**

> Execution is valid only when performed under active SELinux enforcement with a complete audit trail demonstrating policy adherence.

---

## Evidence Characteristics

| Property        | Description                                                                  |
| --------------- | ---------------------------------------------------------------------------- |
| Reconstructable | Third party can re-run and validate outputs using preserved inputs           |
| Deterministic   | Outputs tied to explicit seed, configuration, and dataset state              |
| Tamper-evident  | Hash validation and audit logs expose unauthorised modification              |
| Policy-aligned  | Execution bound to OS-level (SELinux) or cloud-level (Azure Policy) controls |
| Complete        | Includes both successful and failed execution traces                         |

---

## Packaging Standard

Evidence is delivered as a **single indexed bundle**, typically structured as:

```text
/evidence_pack/
├── inputs/
├── logs/
├── outputs/
├── audit/
└── metadata/
```

### Packaging Rules

* No post-run modification of artefacts
* All timestamps preserved
* Hashes generated post-run and included
* Index file (`README` or manifest) included for navigation

---

## Assurance Outcome

The evidence pack enables an external reviewer to:

* Validate **control enforcement at OS or cloud layer**
* Trace **inputs → execution → outputs**
* Confirm **data integrity and lineage**
* Reproduce **analytical results under governed conditions**
* Identify and assess **control exceptions (e.g. SELinux AVC events)**

---
## Delivery Position

- Independent assurance practice executing bounded control validation workflows  
- **Primary** deliverable is an **externally assessable**, audit-aligned evidence pack demonstrating execution integrity and control effectiveness **(not narrative assessment)**
  
---
