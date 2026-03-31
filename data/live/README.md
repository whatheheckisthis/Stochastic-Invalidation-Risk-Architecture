# Live Data Folder — Governance Notice

`data/live/` is a controlled drop-zone for operator-onboarded live data.

## Operator instructions

1. Do not commit live datasets to git.
2. Add/update corresponding `[[files]]` entry in `data/manifest/data_manifest.toml` under approved change control.
3. Populate `hash_sha256`, `approved_by`, and `approved_date` prior to ingestion.
4. Create/maintain dataset lineage record in `data/lineage/`.
5. If SHA-256 verification fails at preflight, halt run and escalate per operations procedure.
