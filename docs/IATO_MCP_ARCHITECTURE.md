# IATO MCP ARCHITECTURE

## 1.0 Purpose
This document defines implementation structure for MCP orchestration.

This document describes system implementation and execution structure.
It does not define governance rationale, control effectiveness, or assurance mappings.

## 1.1 Scope
It covers dispatch flow, execution boundaries, audit flow, and infrastructure preflight mechanics.

## 2.0 Execution Structure
### 2.1 Dispatch Model
A single dispatch entrypoint governs enumerated actions (`apply`, `state_check`, `decommission`, `spawn_container`, `teardown_container`, `vsphere_preflight`). Unknown actions halt.

### 2.2 Preflight Chain
Execution follows preflight → apply → verify sequencing with fail-fast behavior.

### 2.3 Deviation Handling
State deviations are treated as controlled invalidation events and trigger decommission/rebuild semantics.

## 3.0 Runtime Boundaries
### 3.1 Container Boundary
Runtime execution is rootless with constrained privileges and declared network modes.

### 3.2 Configuration Boundary
Configuration is schema-validated before execution and rejected on policy-invalid structure.

## 4.0 Infrastructure Promotion
### 4.1 Pre-Promotion Checks
Infrastructure changes undergo topology and isolation checks before promotion.

### 4.2 Evidence Production
Each orchestration action emits auditable records suitable for downstream assurance linkage.

Governance rationale and control mapping are defined in:
`docs/GRC_CONTROL_RATIONALE_CROSSWALK.md`

Control effectiveness, evidence, and gap tracking are maintained in:
`docs/CONTROL_ASSURANCE_REGISTER.csv`
