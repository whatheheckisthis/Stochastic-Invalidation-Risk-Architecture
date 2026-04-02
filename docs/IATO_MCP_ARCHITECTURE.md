# IĀTŌ MCP Architecture — Control Plane and Runtime

**Primary documents:**

- [`docs/ETHOS.md`](ETHOS.md) — architectural philosophy
  and stack rationale
- [`docs/DELIVERY.md`](DELIVERY.md) — engagement model,
  delivery artefacts, and GRC control mappings

Read those two documents first. Everything else in this
repository is the operational substrate that supports them.

---

## 1 — Strategic Intent

This document defines the implementation detail for the operating model declared in [`docs/ETHOS.md`](ETHOS.md).

## 2 — Orchestration Layer

MCP-driven orchestration governs auditable command execution.

## 3 — Container Runtime and Schema Validation

Rootless container execution and schema validation are non-negotiable controls.

## 4 — Infrastructure Pre-flight and Promotion Controls

Infrastructure changes require pre-flight validation before promotion.

## 5 — Control Mapping and Crosswalk

- [`docs/governance/control-crosswalk.csv`](governance/control-crosswalk.csv)

## 6 — Operator Action Items

Control gaps and exceptions are tracked as governed artefacts.
