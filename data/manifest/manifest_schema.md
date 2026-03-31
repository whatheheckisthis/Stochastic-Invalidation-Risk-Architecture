# SIRA Data Manifest Schema

`data/manifest/data_manifest.toml` is the controlled registry for governed datasets.

## Top-level section

- `[manifest].schema_version` (string, required)
- `[manifest].last_reviewed` (ISO date string, required)
- `[manifest].reviewer` (string, required; operator-populated)
- `[manifest].approval_ref` (string, required; change/approval reference)

## File entries (`[[files]]`)

All fields are mandatory for `mode = "live"` entries.

- `file_id`: Stable dataset identifier (`SIRA-DAT-###`).
- `filename`: Physical file name.
- `relative_path`: Repository-relative path to file.
- `mode`: `live` or `synthetic`.
- `status`: `active` or `inactive`.
- `lineage_ref`: Repository-relative path to lineage record TOML.
- `hash_sha256`: SHA-256 digest (lowercase hex). Empty values trigger warning.
- `approved_by`: Approver identity.
- `approved_date`: Approval date (ISO date).

## Validation rules

1. `status = "active"` files must exist at `relative_path`.
2. If `hash_sha256` is populated, preflight recomputes SHA-256 using base R `tools::sha256sum()`.
3. Hash mismatch handling:
   - `mode = "live"` => hard stop (HALT).
   - `mode = "synthetic"` => warning, run may continue.
4. If `hash_sha256` is empty, preflight emits warning and marks approval status `incomplete`.
5. Data mode determination:
   - `live` if at least one active live file exists and all active live hash checks pass.
   - `synthetic` if only synthetic files are active.
   - hard stop if live files are active and any live hash check fails.
