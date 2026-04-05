# Notebooks

This directory is organized for deterministic execution and audit traceability.

- `analysis/`: analytical execution notebooks.
- `governance/`: governance-only notebook artefacts.
- `review/`: read-only presentation notebooks.
- `_superseded/`: historical notebooks retained for audit only.

## How to Navigate This Repository

## What this folder contains

This folder is a self-contained model review package for the
Stochastic Invalidation and Risk Architecture (SIRA) engine.
It can be reviewed independently of the wider repository.

Core documents accompany the executable notebook:

| File | Purpose | Primary audience |
|---|---|---|
| `README.md` | This file. Orientation and navigation. | Everyone |
| `SIRA_ASSUMPTIONS.md` | Model assumptions registry. Criteria, units, formulae, limitations. | Model risk reviewers, auditors |
| `SIRA_METHODOLOGY.md` | Full methodology narrative. Why the model is built the way it is. | Risk committee, senior reviewers |
| `ARCHITECTURE_APPENDIX_PATH_RESOLUTION.md` | Technical record of the runtime path resolution strategy. | Operators, DevSecOps, compliance engineers |
| `SIRA_VALIDATION_CHECKLIST.md` | Structured checklist for formal model risk review. | Model risk officers, auditors |

---

## Recommended reading order by role

### Risk committee member
1. `SIRA_METHODOLOGY.md` — understand what the model does and why
2. `SIRA_ASSUMPTIONS.md §1–2` — recovery layer and capital stack
3. `SIRA_VALIDATION_CHECKLIST.md` — pre-structured challenge questions

### Model risk reviewer / validator
1. `SIRA_ASSUMPTIONS.md` — complete assumptions registry
2. `SIRA_METHODOLOGY.md` — Gaussian reference governance
3. `SIRA_VALIDATION_CHECKLIST.md` — structured validation checklist
4. `analysis/sira_scenarios_analysis.ipynb` — executable verification

### Auditor / compliance officer
1. `SIRA_VALIDATION_CHECKLIST.md` — evidence requirements by control
2. `SIRA_ASSUMPTIONS.md §5–7` — portability, duplication, non-goals
3. `ARCHITECTURE_APPENDIX_PATH_RESOLUTION.md` — runtime environment controls

### Operator / DevSecOps
1. `ARCHITECTURE_APPENDIX_PATH_RESOLUTION.md` — path resolver strategies and mitigations
2. `SIRA_ASSUMPTIONS.md §5` — portability assumptions table
3. `analysis/sira_scenarios_analysis.ipynb` Cell 00–02 — dependency check and setup

---

## Relationship to the wider SIRA repository

This notebook folder is a governed inspection surface over the
SIRA engine. It does not replace the pipeline (`run_all.R`).
It does not write to `output/` or modify any governed artefact.

The authoritative governance documents live in this directory:

| Repository document | Relationship to this folder |
|---|---|
| [`CREDIT_RISK_LAYER.md`](CREDIT_RISK_LAYER.md) | Source of derivation citations in `SIRA_ASSUMPTIONS.md` |
| [`RISK_COMMITTEE.md`](RISK_COMMITTEE.md) | Source of committee questions in `SIRA_VALIDATION_CHECKLIST.md` |
| [`DEFENSE_APPENDIX.md`](DEFENSE_APPENDIX.md) | Source of epsilon/sigma governance in `SIRA_ASSUMPTIONS.md §4` |
| [`COMPLIANCE_CROSSWALK.csv`](COMPLIANCE_CROSSWALK.csv) | Schema reference for `SIRA_ASSUMPTIONS.md` structure |
| [`SIRA_NON_GOALS.md`](SIRA_NON_GOALS.md) | Canonical non-goals register (NG-001 to NG-024) cited throughout |

If a citation in this folder says `CREDIT_RISK_LAYER.md §3.1`,
the full text is in [`CREDIT_RISK_LAYER.md`](CREDIT_RISK_LAYER.md). The notebook
folder documents are deliberately self-contained summaries —
they do not reproduce the source documents in full.

---

## What this folder is not

- Not a standalone compliance attestation
- Not a replacement for instrument-level credit analysis
- Not a market pricing engine
- Not a live risk system

Full non-goals register: [`SIRA_NON_GOALS.md`](SIRA_NON_GOALS.md)
