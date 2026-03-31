# RISK COMMITTEE QUESTION REGISTER — SIRA

## 1) Model Scope and Boundary

| ID | Committee Question | Architecture-Backed Response | Evidence Basis | Gap Status |
|---|---|---|---|---|
| 1.1 | What does SIRA claim to measure, and what does it explicitly not claim to measure? | SIRA measures scenario-conditioned stressed recovery behaviour and emits binary SELL/HOLD triage signals using `stressed_recovery`, `ruin_threshold`, and `z_score` logic. It explicitly does **not** claim to be a live risk system, OMS/EMS, full credit model, compliance attestation, or IRB-equivalent model. | Runtime flow in `scripts/02_analysis.R`; scope and non-goals register in `README.md`. | Closed by architecture. |
| 1.2 | How are the five scenarios selected, and who owns scenario governance? | The engine consumes scenario names from `CFG$scenarios$names` and resolves each scenario config dynamically from `CFG$scenarios[[key]]`. Architecture establishes deterministic loading and execution only; governance ownership (function, role, committee charter) is not encoded in code or config. | `scripts/02_analysis.R`, `config/sira.toml`. | **Documented gap — operator response required:** assign scenario governance owner and approval forum. |
| 1.3 | What is the update cadence for scenario parameters, and who approves changes? | Scenario parameters are TOML-declared (`shape1`, `shape2`, `exponent`, `ruin_threshold`, `shock_multiplier`, `fx_devaluation`) and are consumed at run time without hardcoding. No native cadence or approver workflow is implemented. | `config/sira.toml`, `scripts/00_config.R`, `scripts/02_analysis.R`. | **Documented gap — operator response required:** define review cadence and approver authority. |

## 2) Distribution Selection Rationale

| ID | Committee Question | Architecture-Backed Response | Evidence Basis | Gap Status |
|---|---|---|---|---|
| 2.1 | Why is Beta used for Baseline, Liquidity Crunch, and Jurisdictional Freeze? | Those scenarios are configured with `distribution = "beta"`. The implementation uses bounded Beta draws and clamps recovery to `(0.001, 0.995)`, aligning with bounded recovery fractions and non-Gaussian shape flexibility. | `config/sira.toml`, `scripts/02_analysis.R`, methodology text in `README.md`. | Closed by architecture. |
| 2.2 | Why is Power Law used for Counterparty Default and Hyper-Inflationary? | Those scenarios are configured with `distribution = "powerlaw"`; implementation generates heavy-tail outcomes via inverse-transform logic and applies scenario shocks (`price` coupling and `fx_devaluation`) to represent jump-risk stress. | `config/sira.toml`, `scripts/02_analysis.R`, scenario table in `README.md`. | Closed by architecture. |
| 2.3 | What empirical or theoretical basis supports these selections for distressed direct lending recovery? | Architecture includes methodological rationale (bounded recovery behaviour and tail-heavy jump-risk regimes). It does not include empirical calibration datasets, statistical fit diagnostics, or literature traceability in-repo. | `README.md`, execution logic in `scripts/02_analysis.R`. | **Documented gap — operator response required:** provide validation memo with empirical fit and theory references. |
| 2.4 | What happens at distribution boundary conditions (near-zero recovery, parameter degeneracy)? | Engine clamps generated and shocked recovery into `[0.001, 0.995]`, preventing singular 0/1 endpoints. Ruin evaluation uses `stressed_recovery <= ruin_threshold`. Degenerate/invalid parameter protection beyond parser/type coercion is not explicitly implemented (e.g., no explicit positivity checks for Beta shapes or Power Law exponent). | `scripts/02_analysis.R`, config parse path in `scripts/00_env_check.R` and `scripts/00_config.R`. | **Partial with gap:** add parameter-domain validation controls at config ingest. |

## 3) Signal Integrity

| ID | Committee Question | Architecture-Backed Response | Evidence Basis | Gap Status |
|---|---|---|---|---|
| 3.1 | Why SELL/HOLD rather than three-state or continuous output? | Binary signal is intentional and declared: signal assignment is rule-based and constrained to `{SELL, HOLD}`. Non-goals register records that WATCH was evaluated and excluded for this implementation scope. | `scripts/02_analysis.R`, non-goals section in `README.md`. | Closed by architecture. |
| 3.2 | What is the ruin threshold derivation: static, scenario-specific, or operator-defined? | Ruin threshold is scenario-specific and operator-defined via `CFG$scenarios.<scenario>$ruin_threshold`, then applied deterministically in rule logic. Derivation methodology itself is not encoded. | `config/sira.toml`, `scripts/02_analysis.R`. | **Documented gap — operator response required:** maintain threshold derivation standard and approval evidence. |
| 3.3 | How are Z-score thresholds calibrated and against what reference distribution? | `z_score` is computed per `asset_id` across scenarios using standardized `stressed_recovery`; SELL trigger compares to `CFG$signals$sell_zscore_threshold`. No in-repo calibration framework or reference population governance is implemented. | `scripts/02_analysis.R`, `config/sira.toml`. | **Documented gap — operator response required:** define calibration window, sampling policy, and revalidation cycle. |
| 3.4 | What is the false positive/false negative posture under each scenario? | Architecture produces observable SELL/HOLD outcomes but does not include confusion-matrix testing, labelled truth sets, or scenario-level Type I/II targets. | `scripts/02_analysis.R`, output aggregation in `scripts/03_visualize.R`. | **Documented gap — operator response required:** establish error posture targets and monitoring metrics. |

## 4) Model Risk

| ID | Committee Question | Architecture-Backed Response | Evidence Basis | Gap Status |
|---|---|---|---|---|
| 4.1 | What model risk framework does this sit within (SR 11-7, FRTB, internal MRM)? | SIRA declares no certified framework conformance and positions itself as analytical tooling with explicit non-goals against attestation. Mapping to a formal MRM regime is external governance work. | Non-goals register in `README.md`; delivery/governance docs under `docs/`. | **Documented gap — operator response required:** register model class and governing framework. |
| 4.2 | Has the model been back-tested; if not, what is the validation plan? | Repository supports deterministic reruns via `CFG$runtime$seed` and can ingest live files from `CFG$data$path`; it does not contain completed back-testing evidence or a formal validation protocol. | `scripts/01_load_data.R`, `scripts/02_analysis.R`, `config/sira.toml`. | **Documented gap — operator response required:** approve back-test design and acceptance criteria. |
| 4.3 | What are known limitations of stochastic simulation vs IRB model output? | SIRA non-goals explicitly state it is not a full credit model and not a substitute for IRB validation; outputs are scenario-level stress signals, not regulatory capital estimates. | Non-goals in `README.md`. | Closed by architecture boundary. |
| 4.4 | How does deterministic synthetic fallback affect reliability, and what disclosures are required in live decisions? | Synthetic fallback activates when no recognized data files exist; seed-controlled reproducibility is enforced. Data mode (`live` vs `synthetic`) is recorded in metadata and printed in runtime output. Governance disclosure requirements for live decision usage are not codified in workflow. | `scripts/01_load_data.R`, `run_all.R`, `README.md`. | **Partial with gap:** operator must mandate disclosure/approval when `data_mode = synthetic`. |

## 5) Operational Controls

| ID | Committee Question | Architecture-Backed Response | Evidence Basis | Gap Status |
|---|---|---|---|---|
| 5.1 | How is model version controlled and how are parameter changes audited? | Code/config are repository-managed and parameters are centralized in TOML. Native parameter change ledger, signer identity, and dual-control approval are not implemented in runtime. | `config/sira.toml`, repository structure in `README.md`. | **Partial with gap:** operator workflow required for auditable change control. |
| 5.2 | What is the air-gap deployment procedure, and who holds the validated runtime manifest? | Architecture is air-gap compatible by design (no network dependence; local package/runtime requirements documented). Custody and sign-off of a validated runtime manifest are not encoded. | Runtime and dependency statements in `README.md`; preflight in `scripts/00_env_check.R`. | **Documented gap — operator response required:** define manifest owner and controlled release process. |
| 5.3 | How are SELL signals escalated, and who has override authority? | Engine emits SELL/HOLD only; no escalation routing, case management integration, or override role model is implemented. | `scripts/02_analysis.R`, `scripts/03_visualize.R`, non-goals in `README.md`. | **Documented gap — operator response required:** define escalation matrix and override governance. |

## 6) Governance and Accountability

| ID | Committee Question | Architecture-Backed Response | Evidence Basis | Gap Status |
|---|---|---|---|---|
| 6.1 | Who is the model owner? | No owner identity is encoded in runtime/config/docs as a controlled field. | Repository documents reviewed (`README.md`, `docs/*`). | **Documented gap — operator response required:** designate accountable model owner. |
| 6.2 | What is the exception and deviation process? | Delivery docs mention deviation recording as a control concept, but no formal exception workflow, SLA, or approval chain is operationalized in the engine. | `docs/DELIVERY.md`, `docs/WORKER_COMPAT.md`. | **Partial with gap:** operator must publish exception process artifact. |
| 6.3 | How does SIRA interact with instrument-level credit analysis and IRB outputs? | Non-goals and methodology position SIRA as complementary scenario stress triage, requiring independent instrument-level validation and not replacing IRB or credit underwriting outputs. | `README.md` non-goals and methodology. | Closed by architecture boundary. |

## 7) Capital Stack Extension Governance (Liability + Spread Engine)

| ID | Committee Question | Architecture-Backed Response | Evidence Basis | Gap Status |
|---|---|---|---|---|
| 7.1 | Who sets and approves `payout_rate` and other liability assumptions? | Liability assumptions are centralized under `[liability]` in `config/sira.toml` and consumed directly by `scripts/10_liability_engine.R`; the owner role and approval cadence are not encoded in runtime logic. | `config/sira.toml`, `scripts/10_liability_engine.R`. | **Documented gap — operator response required:** assign actuarial/treasury owner and approver chain. |
| 7.2 | How is WATCH spread threshold calibrated? | WATCH calibration is parameterized via `CFG$signals$watch_spread_threshold` and applied in `scripts/11_credit_deployment.R`; methodology source (historical quantile, policy floor, or committee setpoint) must be externally documented. | `config/sira.toml`, `scripts/11_credit_deployment.R`. | **Documented gap — operator response required:** approve derivation memo and refresh cycle. |
| 7.3 | What is the breach escalation path when headroom is negative? | Aggregator emits `BREACH` if spread is negative or solvency headroom falls below zero. Technical emission exists; escalation routing, regulatory notification ownership, and response SLA are not implemented in code. | `scripts/12_spread_stress.R`, `scripts/13_capital_stack_viz.R`. | **Documented gap — operator response required:** publish BREACH response runbook. |

---

## Operator Action Register (Required to Close Open Governance Items)

1. Assign formal model owner and scenario governance owner.
2. Approve parameter update cadence and change-approval controls.
3. Implement parameter-domain validation at configuration ingest.
4. Define Z-threshold and ruin-threshold calibration standards with evidence retention.
5. Establish back-testing and ongoing performance monitoring (including false positive/negative posture).
6. Mandate synthetic-mode disclosure and escalation controls for live decisions.
7. Define SELL escalation and override authority matrix.
8. Publish air-gap runtime manifest custody and release procedure.
9. Assign liability assumption governance owner (`payout_rate`, inflation sensitivity, duration, solvency buffer).
10. Ratify WATCH threshold calibration method and review frequency.
11. Approve solvency BREACH escalation workflow (hedging, reallocation, notification).

## 8) Data Governance Architecture (Manifest + Lineage + Hash Controls)

| ID | Committee Question | Architecture-Backed Response | Evidence Basis | Gap Status |
|---|---|---|---|---|
| 8.1 | Who owns data manifest approval authority? | Manifest approval authority is assigned to the operator-controlled Data Governance Approver role; live dataset activation requires populated `reviewer`, `approval_ref`, `approved_by`, and `approved_date` fields under change control. | `data/manifest/data_manifest.toml`, `data/manifest/manifest_schema.md`. | **Operator ownership declared; process execution external.** |
| 8.2 | What is the escalation path for hash verification failures? | `scripts/00_env_check.R` halts execution when any active live file hash is missing/mismatched. Synthetic hash issues emit warnings. Escalation target is Data Governance Approver and Risk Operations Lead per operator runbook. | `scripts/00_env_check.R`, `data/live/README.md`. | **Technical gate closed; escalation workflow operator-runbook controlled.** |
| 8.3 | What is the live file onboarding procedure? | Live onboarding requires: file placement in `data/live/`, manifest registration with status/mode/lineage/hash fields, lineage record creation, and approved change reference before ingestion. | `data/live/README.md`, `data/manifest/manifest_schema.md`, `data/lineage/README.md`. | Closed by architecture (repository boundary). |
| 8.4 | How is synthetic mode disclosure enforced for live decisions? | Load stage emits explicit synthetic-mode terminal warning and persists governed metadata (`data_mode`, `file_id`, `lineage_ref`, `manifest_version`, `hash_verified`) to run artifacts. | `scripts/01_load_data.R`, `run_all.R`. | Closed by architecture (repository boundary). |
