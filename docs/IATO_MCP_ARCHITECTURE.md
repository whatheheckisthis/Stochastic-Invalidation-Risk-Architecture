# IATO MCP ARCHITECTURE

## 1.0 Purpose
This document defines implementation structure for MCP orchestration.

## 1.1 Scope
It covers dispatch flow, execution boundaries, audit flow, and infrastructure preflight mechanics.

## 2.0 Execution Structure
### 2.1 Dispatch model
A single dispatch entrypoint governs enumerated actions (`apply`, `state_check`, `decommission`, `spawn_container`, `teardown_container`, `vsphere_preflight`). Unknown actions halt.

### 2.2 Preflight chain
Execution follows preflight → apply → verify sequencing with fail-fast behavior.

### 2.3 Deviation handling
State deviations are treated as controlled invalidation events and trigger decommission/rebuild semantics.

## 3.0 Runtime Boundaries
### 3.1 Container boundary
Runtime execution is rootless with constrained privileges and declared network modes.

### 3.2 Configuration boundary
Configuration is schema-validated before execution and rejected on policy-invalid structure.

## 4.0 Infrastructure Promotion
### 4.1 Pre-promotion checks
Infrastructure changes undergo topology and isolation checks before promotion.

### 4.2 Evidence production
Each orchestration action emits auditable records suitable for downstream assurance linkage.
