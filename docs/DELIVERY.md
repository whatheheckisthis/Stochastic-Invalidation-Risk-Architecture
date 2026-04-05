# DELIVERY

## 1.0 Overview

This document defines the **operational delivery model** for Stochastic-Invalidation-Risk-Architecture (SIRA): how operators prepare runs, execute analyses, capture evidence, and deliver outputs as a constrained analytical product. It intentionally focuses on **engagement execution** and **runtime usage behavior** rather than deep internal architecture.

The practical operating pattern in this repository is terminal-native and script-driven:

- Configuration is loaded from `config/sira.toml`.
- A full end-to-end run is initiated through `run_all.R`.
- Preflight validation is performed before analysis.
- Data source selection is controlled by manifest and hash checks.
- Outputs are emitted to the `output/` directory as charts and `.rds` metadata objects.

In delivery terms, SIRA is not deployed as a long-lived service. It is delivered as a **controlled analytical execution package** where each engagement run produces timestamped, reproducible evidence artifacts and deterministic scenario outputs tied to an explicit seed and governed input state.

This model is optimized for environments where operators need to demonstrate not only analytical outcomes, but also **how** those outcomes were produced.

---

## 2.0 Engagement Model

### Fixed scope

Each engagement uses a fixed, bounded scope:

1. Run the governed workflow using repository scripts.
2. Use configuration values declared in `config/sira.toml`.
3. Use only manifest-registered dataset entries for synthetic or live mode.
4. Produce and preserve run artifacts from the same run session.

Scope is intentionally finite: the system provides scenario-conditioned risk analytics and downstream financial stress outputs; it does not provide autonomous policy interpretation, unattended orchestration, or external decision execution.

### Controlled inputs

Inputs are controlled at three layers:

| Input Layer | Repository Mechanism | Operational Effect |
|---|---|---|
| Runtime & thresholds | `config/sira.toml` | Centralizes scenario parameters, risk thresholds, liability/credit assumptions, and options settings. |
| Dataset source | `data/manifest/data_manifest.toml` + preflight hash checks | Restricts runs to declared active files and validates integrity before processing. |
| Execution command | `Rscript run_all.R` (or equivalent R invocation) | Ensures standard sequence is used, avoiding ad hoc partial runs in delivery contexts. |

Controlled input handling means an operator should not silently swap files, bypass checks, or patch assumptions mid-run without producing a new, explicit run and evidence set.

### Deterministic outputs

The delivery model targets deterministic replay under the same governed state:

- A fixed seed (`runtime.seed`) is applied.
- Scenario generation and signal thresholds are config-driven.
- Output artifacts are emitted with stable naming patterns.
- Failure states terminate early with non-zero exit status.

Deterministic here means: same code revision, same config, same data file/hash state, same runtime dependencies, same command path -> materially reproducible outputs.

---

## 3.0 Execution Workflow

### 3.1 Setup

Before an engagement run, the operator prepares the execution context.

**Checklist:**

1. Confirm R runtime availability and minimum version alignment (`runtime.min_r_version` in config).
2. Confirm required packages are available (at minimum, `ggplot2`, `RcppTOML`, `base64enc`).
3. Confirm data and output directories are accessible.
4. Confirm configuration and manifest files are present and parseable.
5. Confirm selected data source has valid hash metadata for its mode expectations.

In standard operation, the preflight script (`scripts/00_env_check.R`) performs these checks during run startup and fails fast on unmet conditions. Operators should still perform basic readiness checks before formal engagement windows, especially in air-gapped environments where package installation is restricted.

**Recommended setup command:**

```bash
Rscript run_all.R
```

This command path is preferred because it executes the full gated sequence, rather than ad hoc script sourcing.

### 3.2 Run (`run_all.R`)

`run_all.R` is the operational entry point for delivery engagements. It orchestrates script loading, preflight, data load, analytics, visualization, and summary generation under a guarded `safe_stage` wrapper.

**Execution behavior characteristics:**

- Stage execution is explicit and ordered.
- Errors are trapped per stage and converted into terminal-visible failure records.
- On error, the process prints elapsed time and exits with status `1`.
- On success, the process prints completion metadata and key output locations.

**Typical high-level sequence:**

1. Preflight environment and governance checks.
2. Config load.
3. Governed dataset load (live/synthetic mode selection from manifest checks).
4. Core scenario analysis and SELL/HOLD signal generation.
5. Visual output generation.
6. Spread stress and capital stack output generation.
7. Valuation and deal analytics outputs.
8. Options/hedging outputs and summary.
9. End-of-run summary with output file references.

Operationally, this sequence produces a complete analytical bundle suitable for review without requiring interactive notebook steps.

### 3.3 Output generation

Output generation is part of the run itself, not an optional post-process. Files are written to `CFG$data$output_path` (default: `output/`).

Representative engagement outputs include:

| Output Type | Typical Artifact | Delivery Use |
|---|---|---|
| Signal visualization | `output/sell_hold_signals.png` | Rapid visual inspection of scenario-level SELL/HOLD behavior. |
| Capital chart | `output/capital_stack_spread.png` | Scenario solvency/spread posture communication. |
| Data governance metadata | `output/data_governance_metadata.rds` | Proof of selected data mode and manifest lineage context. |
| Capital metadata | `output/capital_stack_metadata.rds` | Persisted scenario summary for assurance and replay. |
| Deal metadata | run summary metadata artifact produced by deal summary stage | Structured downstream review input. |

Additionally, terminal logs provide stage timestamps, pass/fail checks, scenario completion counts, and high-level run KPIs (e.g., option summary row counts, worst-case scenario labels).

---

## 4.0 Operator Responsibilities

The delivery model is operator-mediated. Responsibilities are explicit and bounded.

| Responsibility | Description | Boundary |
|---|---|---|
| Environment readiness | Ensure runtime prerequisites and package dependencies exist before execution window. | Operator does not alter analysis logic during engagement; only ensures prerequisites. |
| Input governance | Confirm config and manifest are the intended engagement versions; avoid undeclared input substitutions. | Operator may select approved mode (live/synthetic) through manifest state, not by bypassing controls. |
| Controlled execution | Launch and monitor `run_all.R`, record command and runtime context. | Operator does not skip core stages for production delivery unless engagement explicitly defines reduced scope. |
| Failure triage | Interpret fail-fast output, identify stage of failure, and route escalation. | Operator does not suppress failures or manually mark a failed run as complete. |
| Evidence packaging | Preserve logs, charts, and metadata artifacts in an engagement evidence bundle. | Operator does not modify artifacts post-run except for packaging/indexing metadata. |
| Analytical communication | Present outputs as scenario analytics and risk signals with known limitations. | Operator does not present outputs as automated decisions or binding directives. |

Operationally, the operator is the control point between code execution and stakeholder consumption.

---

## 5.0 Evidence & Outputs

Evidence is the core delivery unit. A run without preserved evidence is incomplete from an engagement perspective.

### Logs

Minimum expected logging evidence:

- Run start and end timestamps.
- Preflight check lines with PASS/FAIL statuses.
- Stage-level completion markers.
- Failure details (if any), including stage name and error message.
- Exit status (success/failure).

Operators should capture terminal output to a log file for each engagement run, for example via shell redirection or transcript capture.

### Charts

Chart artifacts are expected to be retained as direct interpretive evidence:

1. SELL/HOLD signal chart (`sell_hold_signals.png`):
   - Demonstrates cross-scenario distribution of stressed recovery signals.
   - Supports analyst narrative around concentration of downside conditions.

2. Capital stack spread chart (`capital_stack_spread.png`):
   - Demonstrates spread capture vs obligation context.
   - Supports solvency posture communication for scenario review.

Charts should be delivered with the corresponding run log and metadata files from the same execution.

### Scenario outputs

Scenario outputs include both direct table-like terminal summaries and persisted metadata objects. At minimum, delivery packets should include:

- Data governance metadata `.rds` output.
- Capital metadata `.rds` output.
- Deal summary metadata output.
- Any additional stage artifacts generated in the run.

A practical evidence package template:

| Artifact Group | Required Items | Rationale |
|---|---|---|
| Runtime evidence | Full console log + command used | Demonstrates run path and stage integrity. |
| Visual evidence | Signal and capital charts | Enables fast scenario interpretation by reviewers. |
| Structured metadata | `.rds` files written by run stages | Enables replay validation and machine-readable assurance trails. |
| Input snapshot | Config + manifest versions used | Binds outputs to the governed input state. |

---

## 6.0 Workflow Diagram (MANDATORY)

```text
[Operator Input]
     ↓
[Preflight Checks]
     ↓
[Execution]
     ↓
[Outputs]
     ↓
[Review]
```

**Interpretation of flow:**

- **Operator Input**: Operator confirms run intent, configuration baseline, and dataset governance posture.
- **Preflight Checks**: Runtime/package/config/manifest/hash checks run first; any hard failure stops pipeline.
- **Execution**: `run_all.R` executes full staged analytics and derivative/summary modules.
- **Outputs**: Charts, metadata artifacts, and terminal logs are generated and written.
- **Review**: Analysts and reviewers interpret outputs, verify evidence completeness, and determine escalation/follow-up.

---

## 7.0 Failure Handling

### Fail-fast behavior

SIRA delivery is designed to fail early and visibly:

- Preflight failure halts the run before analysis begins.
- Stage failures in orchestration are caught, labeled, and result in immediate exit.
- Non-zero exit status communicates incomplete delivery.

Fail-fast behavior is a feature, not a defect. It prevents partially valid outputs from being confused with complete engagement deliverables.

### Escalation expectations

Escalation should follow a simple operational ladder:

1. **Operator triage**: Determine failing stage and classify issue category (dependency, data integrity, parse error, runtime exception).
2. **Technical remediation owner**: Route to maintainer for code/config/data correction.
3. **Controlled rerun**: Re-run full pipeline once remediated; do not patch-deliver partial artifacts from failed attempts.
4. **Versioned handoff**: Package only successful rerun evidence set for stakeholder review.

For governance clarity, failed-run logs should still be retained in the engagement record as non-delivery attempts.

---

## 8.0 Deployment Modes

SIRA supports two practical deployment modes in this repository’s operating pattern.

### Local mode

Local mode is the default:

- Operator runs in a workstation terminal with direct access to repository files.
- Data mode resolution occurs through manifest checks at runtime.
- Output artifacts are generated locally under `output/`.

Best suited for controlled development, dry-runs, and analyst-supervised engagement execution.

### Air-gapped mode

Air-gapped mode is supported by the terminal-native and file-based design:

- No dependency on remote services for core analytical execution.
- All required scripts/config/data are local to the controlled environment.
- Evidence packaging remains file-based and transferable through approved channels.

In air-gapped operations, pre-engagement dependency validation is especially important because installing missing runtime packages may require a separate controlled process.

---

## 9.0 Limitations

The delivery model includes explicit limits that must be communicated in every engagement.

### Operator dependency

Execution quality depends on disciplined operator behavior:

- Correct invocation of the full run path.
- Accurate packaging and retention of evidence.
- Proper interpretation and escalation of failures.

This is deliberate; SIRA is built for controlled analytical execution, not autonomous unattended operation.

### No automated decisioning

Outputs are analytical signals and stress metrics. They are not self-executing actions and should not be represented as:

- Automated investment decisions,
- Autonomous approval/rejection authority,
- Policy substitutions without human review.

### Additional practical limits

- Runtime dependency failures (missing packages/tools) block execution.
- Data integrity gating may stop runs when hashes/manifests do not pass.
- Determinism assumes stable runtime/package versions and identical governed inputs.
- Output quality depends on scenario calibration and dataset quality in the configured run context.

These limits are normal for a governed analytical workflow and should be treated as operational guardrails.

---

## 10.0 Document Index

This section indexes delivery-adjacent repository documentation for operators and reviewers.

| Document | Primary Use in Delivery |
|---|---|
| `README.md` | High-level repository orientation and governance framing. |
| `docs/ETHOS.md` | Design intent and principles context (consult when delivery choices need principle alignment). |
| `config/sira.toml` | Single source for runtime/scenario parameters used during runs. |
| `run_all.R` | Canonical full-run orchestrator for engagement delivery. |
| `scripts/00_env_check.R` | Preflight gate behavior and dependency/data-integrity checks. |
| `scripts/01_load_data.R` | Governed dataset loading and mode handling. |
| `scripts/02_analysis.R` | Core scenario analytics and signal generation behavior. |
| `scripts/03_visualize.R` | Primary signal visualization artifact generation. |
| `scripts/13_capital_stack_viz.R` | Capital stack chart + metadata artifact generation. |
| `data/manifest/data_manifest.toml` | Data source governance declarations for run eligibility. |
| `data/lineage/*` | Lineage references associated with governed dataset declarations. |

---

### Delivery completion criteria (operational checklist)

An engagement run is considered delivered when all of the following are true:

1. Full workflow executed using `run_all.R`.
2. Process terminated with success status.
3. Required charts and metadata artifacts are present in output path.
4. Console log is captured and retained.
5. Inputs used (config/manifest context) are traceable to the run.
6. Review handoff includes both narrative interpretation and raw evidence artifacts.

If any item above is missing, the run should be marked **incomplete delivery** and re-executed under controlled conditions.
