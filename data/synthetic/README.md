# Synthetic Dataset Provenance

This folder contains canonical synthetic datasets used for deterministic development and testing.

- `sira_synthetic_base.csv`: baseline synthetic dataset.
- `sira_synthetic_stress.csv`: adverse synthetic dataset for stress-path validation.

Both files are governed by:
- manifest records in `data/manifest/data_manifest.toml`
- lineage records in `data/lineage/`

Synthetic datasets are generated from seeded logic and are safe to version-control.
