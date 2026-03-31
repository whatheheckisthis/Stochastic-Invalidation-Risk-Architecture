# Lineage Records

Each governed dataset must have a dedicated lineage record TOML file.

## Required practice

1. Copy `lineage_template.toml` when onboarding a new dataset.
2. Ensure `file_id`, `filename`, and `mode` exactly match the manifest entry.
3. For synthetic datasets, record the generation seed.
4. Maintain `review_status` and approval fields under change control.
