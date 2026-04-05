# ETHOS

## 1.0 Purpose
This document defines the control philosophy for SIRA + IĀTŌ. It is the foundation layer for governance intent and system constraints.

## 1.1 Scope
This layer defines operating intent only. It does not define implementation mechanics, runtime enforcement logic, control coverage, evidence, or gap status.

## 2.0 Operating Model
### 2.1 Deterministic governance
The system is designed for deterministic, auditable execution where governed actions are explicit, bounded, and reproducible.

### 2.2 Least-privilege execution
Execution boundaries are constrained to minimize privilege, reduce uncontrolled pathways, and preserve accountable operator control.

### 2.3 Evidence-first accountability
Control operation is expected to produce verifiable evidence suitable for committee, audit, and assurance review.

## 3.0 Control Philosophy
### 3.1 Non-autonomous control posture
The platform provides analytical support and deterministic orchestration. It does not assert autonomous governance authority.

### 3.2 Traceability as a control requirement
Control intent, implementation, and assurance artefacts must remain linkable without ambiguity.

### 3.3 Separation of interpretation and effectiveness
Control rationale is maintained in the rationale crosswalk layer. Control effectiveness is maintained only in the assurance register layer.

## 4.0 System Constraints
### 4.1 No silent scope expansion
Control scope is bounded by explicit control definitions and documented non-goals.

### 4.2 No implicit control claims
Coverage, evidence sufficiency, and gaps must be declared in the assurance register; they must not be inferred from narrative text.

### 4.3 Layer integrity
Governance intent, rationale interpretation, assurance status, and architecture implementation remain separate documentation layers.

## 5.0 Layer References
- Control rationale layer: `docs/GRC_CONTROL_RATIONALE_CROSSWALK.md`
- Control assurance layer: `docs/CONTROL_ASSURANCE_REGISTER.csv`
- System architecture layer: `docs/IATO_MCP_ARCHITECTURE.md`, `docs/CREDIT_RISK_LAYER.md`, `docs/DELIVERY.md`
