# SIRA Notice Block — Canonical Text

> This file defines the canonical notice block that appears
> at the top of every document in the SIRA notebook literature
> suite. It is a maintenance reference. Do not delete.

---

## Notice block text

The following block is inserted at the top of every suite
document below the document title, before any content:

---

```
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
```

---

## Application instructions

Add this block to the following files immediately after the
document title (`# Title`) and before the first horizontal
rule or section heading:

  notebooks/SIRA_ASSUMPTIONS.md
  notebooks/SIRA_READER_GUIDE.md
  notebooks/SIRA_METHODOLOGY.md
  notebooks/SIRA_PATH_RESOLVER.md
  notebooks/SIRA_RNORM_RATIONALE.md
  notebooks/SIRA_REVIEWER_CHECKLIST.md

Do not add to:
  LICENSE       — governed by Apache 2.0 format convention
  NOTICE        — governed by Apache 2.0 format convention
  DISCLAIMER.md — is the source document, not a recipient
  NOTICE_BLOCK.md — is the maintenance reference

## Update procedure

If the notice block text requires updating:
  1. Update this file (NOTICE_BLOCK.md) first
  2. Propagate the change to all six recipient documents
  3. Record the change in a commit message that references
     this file as the source of truth
  4. Do not update recipient documents independently —
     divergence between the canonical text and deployed
     text creates a maintenance liability
