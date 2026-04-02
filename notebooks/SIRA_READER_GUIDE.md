# SIRA Notebook — Reader Guide

**Primary documents:**

- [`docs/ETHOS.md`](../docs/ETHOS.md) — architectural philosophy
  and stack rationale
- [`docs/DELIVERY.md`](../docs/DELIVERY.md) — engagement model,
  delivery artefacts, and GRC control mappings

Read those two documents first. Everything else in this
repository is the operational substrate that supports them.

> **License:** Apache License 2.0 — derived material use
> permitted under license terms. See `LICENSE` and `NOTICE`
> at repository root.
>
> **Academic use:** This material must not be used to underpin
> coursework content or submitted as original work in any
> assessed academic context. It is a practitioner artefact,
> not peer-reviewed literature. Trace all analytical claims
> to their cited primary sources. See [`DISCLAIMER.md`](DISCLAIMER.md)
> for full terms.


> Read this first. It tells you what each file is for,
> who should read it, and in what order.

---

## What this folder contains

This folder is a self-contained model review package for the
Stochastic Invalidation and Risk Architecture (SIRA) engine.
It can be reviewed independently of the wider repository.

Five documents accompany the executable notebook:

| File | Purpose | Primary audience |
|---|---|---|
| `SIRA_READER_GUIDE.md` | This file. Orientation and navigation. | Everyone |
| `SIRA_ASSUMPTIONS.md` | Model assumptions registry. Criteria, units, formulae, limitations. | Model risk reviewers, auditors |
| `SIRA_METHODOLOGY.md` | Full methodology narrative. Why the model is built the way it is. | Risk committee, senior reviewers |
| `SIRA_PATH_RESOLVER.md` | Technical record of the runtime path resolution strategy. | Operators, DevSecOps, compliance engineers |
| `SIRA_RNORM_RATIONALE.md` | Governance record for the Gaussian reference draw. | Model validators, statistical reviewers |
| `SIRA_REVIEWER_CHECKLIST.md` | Structured checklist for formal model risk review. | Model risk officers, auditors |

---

## Recommended reading order by role

### Risk committee member
1. `SIRA_METHODOLOGY.md` — understand what the model does and why
2. `SIRA_ASSUMPTIONS.md §1–2` — recovery layer and capital stack
3. `SIRA_REVIEWER_CHECKLIST.md` — pre-structured challenge questions

### Model risk reviewer / validator
1. `SIRA_ASSUMPTIONS.md` — complete assumptions registry
2. `SIRA_RNORM_RATIONALE.md` — Gaussian reference governance
3. `SIRA_REVIEWER_CHECKLIST.md` — structured validation checklist
4. `sira_scenarios.ipynb` — executable verification

### Auditor / compliance officer
1. `SIRA_REVIEWER_CHECKLIST.md` — evidence requirements by control
2. `SIRA_ASSUMPTIONS.md §5–7` — portability, duplication, non-goals
3. `SIRA_PATH_RESOLVER.md` — runtime environment controls

### Operator / DevSecOps
1. `SIRA_PATH_RESOLVER.md` — path resolver strategies and mitigations
2. `SIRA_ASSUMPTIONS.md §5` — portability assumptions table
3. `sira_scenarios.ipynb` Cell 00–02 — dependency check and setup

---

## Relationship to the wider SIRA repository

This notebook folder is a governed inspection surface over the
SIRA engine. It does not replace the pipeline (`run_all.R`).
It does not write to `output/` or modify any governed artefact.

The authoritative governance documents live in [`docs/`](../docs/):

| Repository document | Relationship to this folder |
|---|---|
| [`docs/CREDIT_RISK_LAYER.md`](../docs/CREDIT_RISK_LAYER.md) | Source of derivation citations in `SIRA_ASSUMPTIONS.md` |
| [`docs/RISK_COMMITTEE.md`](../docs/RISK_COMMITTEE.md) | Source of committee questions in `SIRA_REVIEWER_CHECKLIST.md` |
| [`docs/DEFENSE_APPENDIX.md`](../docs/DEFENSE_APPENDIX.md) | Source of epsilon/sigma governance in `SIRA_ASSUMPTIONS.md §4` |
| [`docs/COMPLIANCE_CROSSWALK.csv`](../docs/COMPLIANCE_CROSSWALK.csv) | Schema reference for `SIRA_ASSUMPTIONS.md` structure |
| [`README.md`](../README.md) | Non-goals register (NG-001 to NG-021) cited throughout |

If a citation in this folder says `CREDIT_RISK_LAYER.md §3.1`,
the full text is in [`docs/CREDIT_RISK_LAYER.md`](../docs/CREDIT_RISK_LAYER.md). The notebook
folder documents are deliberately self-contained summaries —
they do not reproduce the source documents in full.

---

## What this folder is not

- Not a standalone compliance attestation
- Not a replacement for instrument-level credit analysis
- Not a market pricing engine
- Not a live risk system

Full non-goals register: `README.md NG-001 to NG-021`
