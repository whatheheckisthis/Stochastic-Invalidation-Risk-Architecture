# SIRA Governed Data Directory

This directory enforces governed separation between live and synthetic datasets.

- `data/live/` is reserved for operator-onboarded live files under change control.
- `data/synthetic/` contains version-controlled canonical synthetic datasets for deterministic development/testing.
- `data/manifest/data_manifest.toml` is the controlled input registry.
- `data/lineage/` contains per-dataset lineage records.

## Governance notice

1. Live files **must never** be committed to git.
2. Every governed dataset must have:
   - a manifest entry, and
   - a corresponding lineage record.
3. Synthetic mode usage for live decisioning requires explicit disclosure and approval.
