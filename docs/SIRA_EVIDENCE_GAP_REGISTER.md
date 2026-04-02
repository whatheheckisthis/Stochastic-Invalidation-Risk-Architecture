# SIRA — Evidence Gap Register

> **Scope:** This document is a governed gap register,
> not an audit finding. The gaps declared below are
> known, bounded, and assigned to operator action items.
> A gap declared here is under control. A gap not
> declared here is not.
>
> This document is a delivery artefact of the SIRA
> assurance programme. It is read in conjunction with
> `docs/RISK_COMMITTEE.md` and
> `docs/COMPLIANCE_CROSSWALK.csv`.

---

## Gap register schema

Each gap is declared against the following fields,
consistent with the SIRA compliance crosswalk schema:

| Field | Description |
|---|---|
| Gap ID | Unique identifier |
| Category | Stochastic implementation, Empirical calibration, Backtesting |
| Description | What is absent and why it matters |
| Current state | What exists in the repository now |
| Boundary | Why the gap exists at this stage |
| Risk if unclosed | What a reviewer would conclude without this declaration |
| Closure path | What the operator must produce to close the gap |
| Owner | Repository (R) or Operator (O) |
| Status | OPEN, IN_PROGRESS, CLOSED |

---

## Gap 1 — Stochastic modelling implementation

| Field | Content |
|---|---|
| Gap ID | EG-001 |
| Category | Stochastic implementation |
| Description | No executed model output, run artefact, or simulation result is present in the repository. The stochastic recovery engine is defined, governed, and documented but has not produced a live or synthetic output that is committed as evidence. |
| Current state | `scripts/02_analysis.R` defines the simulation logic. `config/sira.toml` declares all parameters. `notebooks/sira_scenarios.ipynb` defines the interactive execution surface. No output from any executed run is present in `output/`. |
| Boundary | The engine is designed to execute against operator-supplied or governed synthetic data. No governed synthetic dataset has been committed to `data/synthetic/` under the manifest architecture. Without a governed input, no output can be committed as evidence. |
| Risk if unclosed | A model risk reviewer will note the absence of any executed output and may classify the engine as unvalidated. Without this declaration, that finding appears as an oversight. With it, the finding is a governed gap with a defined closure path. |
| Closure path | 1. Populate `data/synthetic/sira_synthetic_base.csv` and `sira_synthetic_stress.csv` under the data manifest architecture. 2. Execute `Rscript run_all.R` against the governed synthetic dataset. 3. Commit the output artefacts from `output/` to the repository under version control. 4. Record the run in `audit/session/` and commit the session metadata. 5. Update `docs/COMPLIANCE_CROSSWALK.csv` — row for `scripts/02_analysis.R` SR 11-7 Outcomes Analysis from PARTIAL to FULL. |
| Owner | O |
| Status | OPEN |

### Governance note

The absence of executed output is not evidence that the
engine does not work. It is evidence that the engine has
not yet been executed against a governed input dataset.
The architecture — manifest-based ingestion, SHA-256
hash verification, deterministic seeding, session audit
logging — is designed precisely to make the first
governed run auditable and reproducible. The gap is
pre-run, not post-failure.

---

## Gap 2 — Empirical calibration of risk distributions

| Field | Content |
|---|---|
| Gap ID | EG-002 |
| Category | Empirical calibration |
| Description | No empirical dataset, statistical fit evidence, or calibration memo is present to support the Beta and Power Law parameter choices declared in `config/sira.toml`. The distribution rationale is documented in `docs/CREDIT_RISK_LAYER.md §4` on structural grounds. It is not supported by fitted parameters derived from observed workout data. |
| Current state | `docs/CREDIT_RISK_LAYER.md §4.1` and `§4.2` provide formal justification for Beta and Power Law selection based on structural properties of distressed recovery outcomes. `RISK_COMMITTEE.md §2.3` declares this gap explicitly: "Architecture includes methodological rationale. It does not include empirical calibration datasets, statistical fit diagnostics, or literature traceability in-repo." |
| Boundary | Empirical calibration requires access to historical workout data for direct lending and distressed bond portfolios. This data is proprietary to the deploying institution and cannot be committed to a public repository. The calibration gap is structural to any open-source model governance framework — it is closed at deployment, not at design time. |
| Risk if unclosed | A model risk reviewer applying SR 11-7 will require empirical fit evidence as a precondition for production use. Without this declaration, the gap appears as an omission in the model development process. With it, the gap is a correctly bounded pre-deployment requirement with a named closure path. |
| Closure path | 1. Obtain historical workout recovery data for the target portfolio type from the operator's data governance function. 2. Fit Beta parameters (`shape1`, `shape2`) to observed recovery data for mean-reverting regimes using maximum likelihood estimation or method of moments. 3. Fit Power Law exponent to tail observations for jump-risk regimes. 4. Produce a calibration memo documenting: dataset provenance, fitting methodology, goodness-of-fit diagnostics (KS test, QQ plot), and approved parameter values. 5. Update `config/sira.toml` with calibrated parameters under change control. 6. Commit calibration memo to `docs/` as a controlled artefact. 7. Update `RISK_COMMITTEE.md §2.3` gap status from OPEN to CLOSED with reference to the calibration memo. |
| Owner | O |
| Status | OPEN |

### Governance note

The structural justification in `CREDIT_RISK_LAYER.md §4`
is not a substitute for empirical calibration. It is
the theoretical basis that makes calibration meaningful —
it establishes why Beta and Power Law are the correct
distribution families before fitting parameters to data.
A model that is empirically calibrated without structural
justification is fragile. A model that is structurally
justified without empirical calibration is incomplete.
Both are required for production-grade use.

---

## Gap 3 — Backtested financial performance models

| Field | Content |
|---|---|
| Gap ID | EG-003 |
| Category | Backtesting |
| Description | No historical workout data, backtesting protocol, or performance diagnostic against realised recovery outcomes is present. The SELL/HOLD signal logic has not been evaluated against a historical record of credit decisions and their outcomes. False positive and false negative rates are undeclared. |
| Current state | `RISK_COMMITTEE.md §3.4` declares: "Architecture produces observable SELL/HOLD outcomes but does not include confusion-matrix testing, labelled truth sets, or scenario-level Type I/II targets." `RISK_COMMITTEE.md §4.2` declares: "Repository supports deterministic reruns via `CFG$runtime$seed` and can ingest live files from `CFG$data$path`; it does not contain completed back-testing evidence or a formal validation protocol." |
| Boundary | Backtesting requires a labelled historical dataset — credit decisions with known outcomes. This requires: (a) a portfolio with resolved workout cases, (b) a mapping between the decision point and the eventual recovery outcome, and (c) sufficient history to produce statistically meaningful signal performance metrics. None of these can be produced without operator-supplied historical data. The backtesting infrastructure — deterministic rerun capability, live data ingestion path, session audit logging — is in place. The historical data is not. |
| Risk if unclosed | SR 11-7 requires outcomes analysis as a component of model validation. A model without backtesting evidence cannot be classified as validated under SR 11-7. Without this declaration, the absence of backtesting appears as a validation failure. With it, the absence is a correctly scoped pre-validation gap that will be closed when historical data is available. |
| Closure path | 1. Obtain a labelled historical dataset: portfolio positions, decision-point recovery estimates, and realised workout outcomes. 2. Define a backtesting protocol covering: time horizon, scenario mapping, signal threshold sensitivity, and acceptable Type I/II error rates. Submit protocol for model risk committee approval. 3. Execute `run_all.R` against historical data using `CFG$data$path` to point at the historical dataset. 4. Compute confusion matrix per scenario: true SELL, false SELL, true HOLD, false HOLD. 5. Produce a backtesting report documenting: signal performance by scenario, threshold sensitivity, comparison against benchmark (e.g. naive recovery threshold rule). 6. Commit backtesting report to `docs/` as a controlled artefact. 7. Update `RISK_COMMITTEE.md §4.2` and `COMPLIANCE_CROSSWALK.csv` SR 11-7 Outcomes Analysis row to FULL. |
| Owner | O |
| Status | OPEN |

### Governance note

The absence of backtesting is not evidence that the
signal logic is incorrect. It is evidence that the
signal logic has not yet been evaluated against
historical outcomes. The distinction matters for SR
11-7 classification: an unbacktested model is not
a failed model — it is a model at a pre-validation
stage of its lifecycle. This gap register declares
that stage explicitly and defines the path to
validation. A model that acknowledges its validation
stage honestly is more defensible before a risk
committee than one that does not.

---

## Summary table

| Gap ID | Category | Owner | Status | Closure dependency |
|---|---|---|---|---|
| EG-001 | Stochastic implementation | O | OPEN | Governed synthetic dataset committed to manifest |
| EG-002 | Empirical calibration | O | OPEN | Historical workout data and calibration memo |
| EG-003 | Backtesting | O | OPEN | Labelled historical dataset and approved protocol |

All three gaps share a common dependency: operator-supplied
data. The architecture is complete. The evidence layer
that depends on live or historical data is bounded by
the operator's data governance function, not by the
model design.

---

## Relationship to COMPLIANCE_CROSSWALK.csv

The following crosswalk rows are directly affected by
these gaps. Their current coverage assessment reflects
the pre-data state. Coverage upgrades are contingent
on gap closure.

| Component | Framework | Control | Current coverage | Upgrades on |
|---|---|---|---|---|
| `scripts/02_analysis.R` | SR 11-7 | Outcomes Analysis and Ongoing Monitoring | PARTIAL | EG-001 closure |
| `scripts/02_analysis.R` | Basel III IRB | LGD Estimation Governance | DECLARED_LIMITATION | EG-002 closure |
| `scripts/02_analysis.R` | FRTB Article 325 | Stress Calibration | PARTIAL | EG-002 closure |
| Synthetic fallback | BCBS 239 Principle 6 | Input Data Integrity | PARTIAL | EG-001 closure |
| SELL/HOLD signal output | SR 11-7 | Use Test and Governance Boundary | DECLARED_LIMITATION | EG-003 closure |

---

## Operator action register

Consolidated operator actions required to close all
three gaps, in dependency order:

1. Establish data governance authority for historical
   workout data ingestion (prerequisite for EG-002
   and EG-003).
2. Commit governed synthetic datasets to
   `data/synthetic/` under the manifest architecture
   (closes EG-001 prerequisite).
3. Execute `Rscript run_all.R` against governed
   synthetic data and commit output artefacts
   (closes EG-001).
4. Obtain and fit empirical calibration data;
   produce and commit calibration memo
   (closes EG-002).
5. Define and approve backtesting protocol;
   execute against historical data; produce and
   commit backtesting report (closes EG-003).
6. Update `COMPLIANCE_CROSSWALK.csv` coverage
   assessments as each gap closes.
7. Update `RISK_COMMITTEE.md` gap status entries
   as each gap closes.

8. Append to `notebooks/sira_non_goals_table.md` —
   add new domain partition after the existing
   Options and BSM boundaries section:

   **Evidence and validation boundaries —
   NG-022 to NG-024**

   | ID | Boundary | Detail |
   |---|---|---|
   | NG-022 | Executed model outputs not present | The engine is governed at the architecture and documentation layer prior to live data ingestion. No committed run artefact constitutes a production output. See `docs/SIRA_EVIDENCE_GAP_REGISTER.md EG-001`. |
   | NG-023 | Distribution parameters not empirically calibrated | Beta and Power Law parameters are structurally justified but not fitted to empirical workout data in this repository. Calibration is an operator action item. See `docs/SIRA_EVIDENCE_GAP_REGISTER.md EG-002`. |
   | NG-024 | No backtesting evidence present | Signal logic has not been evaluated against historical recovery outcomes. Backtesting is an operator action item contingent on a labelled historical dataset. See `docs/SIRA_EVIDENCE_GAP_REGISTER.md EG-003`. |


---

## Non-goals

- Not an audit finding — this register is produced
  by the practice, not by an external reviewer.
- Not a model failure declaration — gaps are pre-data
  stage boundaries, not model defects.
- Not a complete validation plan — the closure paths
  define what is required; the validation protocol
  itself is an operator-governed document.
- Not static — this register must be updated as gaps
  close. A closed gap with no update to this register
  is an ungoverned state change.
