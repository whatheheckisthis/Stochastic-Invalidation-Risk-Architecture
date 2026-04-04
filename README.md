# Stochastic-Invalidation-Risk-Architecture (SIRA)

>This repository is governed exclusively by the documents referenced below and shall be construed and applied in accordance with their terms. All operative components — including determinative schemas, version-controlled scripts, and auditable artefacts — are implemented solely for the purpose of discharging the obligations prescribed therein and shall have no independent mandate, interpretive authority, or operative scope beyond that purpose.



| Document | Location | Governs |
|---|---|---|
| ETHOS.md | [`docs/ETHOS.md`](docs/ETHOS.md) | Architectural philosophy and stack rationale |
| DELIVERY.md | [`docs/DELIVERY.md`](docs/DELIVERY.md) | Engagement model, delivery artefacts, and GRC control mappings |

[![Focus](https://img.shields.io/badge/Focus-Risk%20%26%20Control%20Analytics-0A66C2?style=flat-square)](#)
[![Approach](https://img.shields.io/badge/Approach-Governance%20%26%20Auditability%20by%20Design-2E7D32?style=flat-square)](#)
[![Runtime](https://img.shields.io/badge/Runtime-Controlled%20R%20Execution%20Environment-276DC3?style=flat-square)](#)
[![Config](https://img.shields.io/badge/Config-Policy--Driven%20TOML%20Configuration-8B5CF6?style=flat-square)](#)
[![Env](https://img.shields.io/badge/Env-Controlled%20%2F%20Air--Gapped%20Deployment-333333?style=flat-square)](#)


### 1.0 Executive Summary — Assurance Architecture

**SIRA (Stochastic-Invalidation-Risk-Architecture) and IĀTŌ-MCP (Intent-Auditable-Trust-Object) form a dual-layer Governance, Risk, and Compliance (GRC) assurance architecture**. 

- Designed to separate model risk production from execution control enforcement. The architecture establishes a clear segregation of duties between quantitative risk generation and deterministic orchestration governance, ensuring alignment with model risk management, regulatory auditability, and controlled system execution standards.

- This structure is designed to satisfy core GRC assurance expectations across model risk governance, operational resilience, and regulatory traceability, ensuring that all outputs are both **mathematically defensible and operationally auditable**.

---

### 2.0 Control Layer Definition

### 2.1 SIRA — Quantitative Risk Controls

>SIRA functions as the **analytical risk engine** under model risk governance frameworks. It is responsible for scenario-conditioned stochastic modelling and risk signal generation.

### 2.1.1 Control Function & GRC Mapping Matrix

| Control Domain | Control Function | Description | GRC Mapping |
|----------------|------------------|-------------|-------------|
| Scenario Stress Testing | Multi-regime simulation | Executes stress scenarios across defined adverse conditions | SR 11-7, FRTB |
| Asset Recovery Modelling | Distressed valuation dynamics | Simulates recovery trajectories for stressed credit assets | Basel III IRB |
| Risk Classification | Binary signal generation | Produces deterministic risk outputs (signal / no signal) | Model Risk Governance |
| Output Lineage Control | Traceable model outputs | Ensures full reconstruction of model state and outputs | BCBS 239 |
| Model Governance Alignment | Regulatory mapping | Ensures structured compliance alignment across frameworks | SOC 2, SR 11-7 |

---

### 2.2 IĀTŌ-MCP — Execution Governance & Control Plane

>IĀTŌ operates as the **deterministic execution control layer**, enforcing strict operational governance over all computational actions.

### 2.2.1 Control Function & GRC Mapping Matrix

| Control Domain | Control Function | Description | GRC Mapping |
|----------------|------------------|-------------|-------------|
| Execution Determinism | Controlled action execution | Ensures all operations are explicitly defined and repeatable | ITGC |
| Pre-Execution Validation | Control gating | Blocks unauthorized or unverified execution paths | Change Management Controls |
| Immutable Logging | Audit trail enforcement | Records all actions as tamper-resistant event logs | Audit Logging / SOC 2 |
| State Verification | System integrity checks | Ensures system state consistency before/after execution | Operational Risk Management |
| Environment Lifecycle Control | Compute governance | Manages provisioning and teardown of execution environments | ITGC / Infrastructure Controls |

---

### 2.3 Key Control Functions:
- Deterministic execution of model and system actions
- Pre-execution validation (control gating)
- Immutable action trace logging (audit trail enforcement)
- State verification and integrity checks
- Controlled lifecycle management of compute environments

### 2.4 Control Constraints:
- No contextual inference permitted
- No autonomous configuration generation
- No execution without explicit enumeration
- No unlogged or non-atomic operations

### 2.5 GRC Control Mapping:
- Operational Risk Management (ORM)
- IT General Controls (ITGC)
- Change Management Controls
- Audit Logging & Evidence Preservation
- Segregation of Duties (SoD)
- System Integrity Assurance


---


### 3.0 **Scope Constraint**

| Component                      | Constraint Statement                                                                                                                                                                                  |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Operative Content Boundary** | All operative content — including determinative schemas, version-controlled scripts, and auditable artefacts — exists solely to satisfy explicitly defined obligations within the governing framework |
| **Authority Limitation**       | No component carries an independent mandate, interpretive authority, or scope beyond its defined purpose                                                                                                 |

---

### 4.0 **Configuration and Control Framework**

| Element                 | Description                                                                                                    |
| ----------------------- | -------------------------------------------------------------------------------------------------------------- |
| **Source of Truth**     | `config/sira.toml` serves as the authoritative configuration file                                              |
| **Declared Parameters** | Scenario structures, distribution parameters, signal thresholds, capital stack assumptions, and options inputs |
| **Control Principle**   | No analytical logic contains hardcoded parameters                                                              |
| **Execution Model**     | Fully configuration-driven and traceable                                                                       |

---

### 5.0 **Runtime and Auditability**

| Capability                | Description                                               |
| ------------------------- | --------------------------------------------------------- |
| **Execution Environment** | Fully terminal-native runtime                             |
| **Traceability**          | Structured `stdout` output for logging and audit trails     |
| **Deployment Context**    | Designed for controlled, air-gapped environments          |
| **Reproducibility**       | Outputs are reproducible, attributable, and audit-aligned |

---

### 6.0 **GRC Positioning**

| Principle                     | Statement                                                                                                   |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------- |
| **Role**                      | Supporting analytical construct within predefined governance boundaries                                     |
| **Decision Authority**        | Does not constitute decision-making authority                                                               |
| **Framework Integrity**       | Does not redefine risk frameworks or investment mandates                                                    |
| **Purpose Limitation**        | Exists solely to fulfill externally defined modelling and analytical obligations                            |
| **Interpretation Constraint** | Outputs must be interpreted strictly within the governing framework and are not independently authoritative |

---

### 7.0 Methodology (GRC Assurance Framework)

### 7.1 **System Initialization & Control Environment**

This system operates as a **financial engineering control environment**, where all execution is gated by pre-run validation, governed configuration, and enforced data lineage constraints.

| Stage                                       | Control Objective                                      | Control Design                                                                                                                                                         | Assurance Condition                                                       |
| ------------------------------------------- | ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| **Preflight Validation** (`00_env_check.R`) | Ensure runtime integrity before analytical execution | Environment version checks (R, dependencies); configuration parse validation; output writability checks; data manifest integrity verification; SHA-256 hash validation | Execution is terminated on any control failure (hard stop, non-zero exit) |
| **Configuration Control** (`00_config.R`)   | Establish single governed parameter source             | Loads `config/sira.toml` into structured runtime object (`CFG`)                                                                                                        | No analytical execution permitted without validated configuration state   |
| **Data Lineage Control** (`01_load_data.R`) | Enforce data provenance and mode separation            | Enforces `live` vs `synthetic` segregation via manifest governance                                                                                                     | Any lineage mismatch results in execution halt                            |

**GRC Principle:**
No computation is permitted outside a validated control environment.

---

### 7.2 **Stress & Risk Modelling**

This layer implements **scenario-driven financial risk transformation**, converting governed inputs into stress-conditioned recovery and risk signals.

| Function                            | Control Objective                                     | Methodological Basis                                                            | Output Classification       |
| ----------------------------------- | ----------------------------------------------------- | ------------------------------------------------------------------------------- | --------------------------- |
| Stress Simulation (`02_analysis.R`) | Generate scenario-conditioned recovery distributions  | Bounded (Beta) and tail-risk (Power Law) modelling under defined stress regimes | Stressed recovery paths     |
| Risk Diagnostics                    | Identify relative and absolute downside vulnerability | Z-score normalisation and ruin-threshold evaluation                             | Risk classification outputs |
| Signal Generation                   | Produce deterministic decision signals                | Rule-based mapping of recovery outcomes                                         | SELL / HOLD signals         |
| Loss Estimation                     | Quantify downside exposure                            | LGD transformation: (1 - recovery)                                              | LGD distribution            |

**GRC Constraint:**
Outputs are descriptive risk signals only and do not constitute discretionary decision authority.

---

### 7.3 **Capital Stack & Solvency Control Framework**

This layer models **financial resilience under stress**, assessing solvency capacity relative to contractual obligations.

| Component                                    | Control Objective                        | Financial Engineering Function               | Output                   |
| -------------------------------------------- | ---------------------------------------- | -------------------------------------------- | ------------------------ |
| Liability Engine (`10_liability_engine.R`)   | Quantify present value obligations       | Discounted annuity liability modelling       | Solvency baseline        |
| Credit Deployment (`11_credit_deployment.R`) | Measure income generation capacity       | Yield and net income estimation under stress | Spread capture           |
| Stress Aggregation (`12_spread_stress.R`)    | Assess solvency under adverse conditions | Spread vs obligation stress comparison       | `SOLVENT` / `WATCH` / `BREACH` |
| Capital Reporting (`13_capital_stack_viz.R`) | Provide structured capital visibility    | Aggregated capital state representation      | Capital stack outputs    |

### 7.3.1 **Capital Flow Control Model**

| Metric          | Control Expression                   |
| --------------- | ------------------------------------ |
| Gross Income    | deployed capital × yield + fees      |
| Net Income      | gross income − LGD stress impact     |
| Spread Position | net income − contractual obligations |

**Governance Constraint:**
Solvency classification is adjusted post-derivatives hedging effect before the final state emission.

---

### 7.4 **Valuation & Transaction Analytics**

This layer provides **stress-conditioned valuation and transaction screening**, supporting structured financial interpretation under scenario constraints.

| Function                                  | Control Objective                      | Output                            |
| ----------------------------------------- | -------------------------------------- | --------------------------------- |
| DCF Valuation (`20_dcf.R`)                | Stress-adjusted intrinsic valuation    | Present value + impairment signal |
| M&A Screening (`21_ma.R`)                 | Transaction feasibility classification | `ACQUIRE` / `REVIEW` / `PASS`           |
| Accretion Analysis (`22_accretion.R`)     | Post-transaction spread impact         | Yield delta                       |
| LBO Assessment (`23_lbo.R`)               | Leverage sustainability under stress   | DSCR, IRR viability               |
| IRR Attribution (`24_irr.R`)              | Decompose return drivers               | Coupon / fee / kicker / recovery  |
| Committee Synthesis (`25_deal_summary.R`) | Consolidated decision reporting        | Risk-weighted summary output      |

---

### 7.5 **Derivatives & Options Risk Engine**

This layer implements **risk-neutral financial engineering models** for derivative valuation and hedge behaviour under stress scenarios.

| Component                                | Control Objective                         | Output                     |
| ---------------------------------------- | ----------------------------------------- | -------------------------- |
| Black-Scholes Engine (`30–36`)           | Risk-neutral pricing framework            | Option valuations          |
| Greeks Engine (`30b_greeks.R`)           | Sensitivity decomposition                 | `Δ, Γ, ν, θ, ρ`              |
| Volatility Surface (`34_vol_surface.R`)  | Scenario-conditioned volatility structure | `σ(K)` surface               |
| Delta Hedging (`36_delta_hedge.R`)       | Replication error measurement             | Hedge P&L                  |
| Options Summary (`35_options_summary.R`) | Aggregate exposure view                   | Hedge state classification |

---

### 7.5.1 Options Intelligence Layer (`scripts/30–36`)

*Grounded in Haugh (2016), Columbia IEOR E4706.*

**BSM derivation basis**

Stock price follows geometric Brownian motion:
```
dSt = µSt dt + σSt dWt
```

Under risk-neutral measure Q (drift µ eliminated):
```
dSt = rSt dt + σSt dWtQ
```

Black-Scholes PDE:
```
rS(∂C/∂S) + (∂C/∂t) + (½)σ²S²(∂²C/∂S²) − rC = 0
```

Closed-form solution with continuous dividend yield q:
```
d1 = (log(S/K) + (r − q + σ²/2)(T−t)) / (σ√(T−t))
d2 = d1 − σ√(T−t)
C  = exp(−q(T−t)) × S × Φ(d1) − exp(−r(T−t)) × K × Φ(d2)
P  = C − exp(−qT) × S + exp(−rT) × K   [put-call parity]
```

The elimination of µ from the PDE is a governance feature in
SIRA's context: firm value drift is unobservable and
scenario-dependent. Risk-neutral pricing removes it by construction.

**Greeks (Haugh Section 3)**
```
Δ_call = exp(−qT) × Φ(d1)
Δ_put  = Δ_call − exp(−qT)
Γ      = exp(−qT) × φ(d1) / (S × σ × √T)
ν      = exp(−qT) × S × √T × φ(d1)
θ_call = −(exp(−qT) × S × φ(d1) × σ)/(2√T)
         + q × exp(−qT) × S × Φ(d1)
         − r × K × exp(−rT) × Φ(d2)
ρ_call = K × T × exp(−rT) × Φ(d2)
```

P&L attribution per scenario (Taylor approximation):
```
P&L ≈ Δ×ΔS + (Γ/2)×ΔS² + ν×Δσ
```

**Instrument mapping**

| Instrument | Option type | Underlying | Strike |
|---|---|---|---|
| Distressed bond recovery | Put on firm value | Firm asset value V | Debt face value D |
| Equity kicker | Call on company equity | Equity value at entry | Warrant strike K |
| Indexed annuity floor | Put on portfolio return | Net portfolio yield | Floor rate |

**Leverage effect (Merton/Haugh)**

As stressed recovery declines, firm equity vol rises:
```
σ_equity ≈ (V/E) × σ_firm
```

This creates a documented stress amplification mechanism:
lower recovery → higher implied vol → higher put price →
larger solvency headroom erosion. Named and governed in
`RISK_COMMITTEE.md`

**Volatility surface**

Scenario-governed, not market-calibrated. Skew implemented
via parameterised adjustment:
```
σ(K) = σ_base + skew_factor × (ATM_K − K) / ATM_K
```

Arbitrage constraints enforced per Haugh Section 2:
butterfly and calendar spread checks emitted to the preflight log.

**Delta-hedge replication error (Haugh eq. 24)**
```
P&L = Σ (St²/2 × Γt × (σ²_implied − σ²_scenario) × Δt)
```

Positive P&L → scenario vol below implied → hedge gain.
Negative P&L → scenario vol above implied → solvency erosion.
Signal: `HEDGE_GAIN` / `HEDGE_NEUTRAL` / `HEDGE_LOSS` per scenario.

---

### 7.6 **System Orchestration & Execution Governance**

This layer enforces **deterministic execution sequencing and failure containment**.

| Stage                             | Control Function                   | Assurance Property                      |
| --------------------------------- | ---------------------------------- | --------------------------------------- |
| Pipeline Controller (`run_all.R`) | Sequential execution orchestration | Deterministic execution order           |
| Monitoring Layer                  | Runtime observability              | Execution traceability                  |
| Failure Handling                  | Hard-stop enforcement              | No partial or degraded states permitted |

### 7.6.1 **Execution Constraint**

### 7.6.2 Orchestration (`run_all.R`)

Full pipeline execution order:
```
00_env_check → 00_config → 01_load_data → 02_analysis →
03_visualize → 10_liability_engine → 11_credit_deployment →
12_spread_stress → 13_capital_stack_viz → 20_dcf → 21_ma →
22_accretion → 23_lbo → 24_irr → 25_deal_summary →
30_bs_core → 30b_greeks → 34_vol_surface → 31_recovery_put →
32_kicker_call → 33_annuity_floor → 36_delta_hedge →
35_options_summary → 25_deal_summary [final pass]
```

Terminal harness emits header, per-stage progress, wall-clock time
elapsed, and exit status. Mid-pipeline failures halt with
labelled error output — no silent partial runs.

**Control Rule:**
All execution is atomic; partial completion states are invalid.

---

## 8.0 **Scenario Governance Framework**

Scenarios define **controlled stress environments for financial engineering simulation**.

| Scenario | Stress mechanism | Distribution | Vol multiplier |
|---|---|---|---|
| Baseline | Normal market functioning | Beta | `1.00×` |
| Liquidity Crunch | Elevated vol, compressed recoveries | Beta | `shock_multiplier` |
| Jurisdictional Freeze | Recovery collapses toward ruin threshold | Beta | `shock_multiplier` |
| Counterparty Default | Gap-down valuation shock | Power Law | exponent-implied |
| Hyper-Inflationary | FX devaluation impairs real bond value | Power Law | `fx_devaluation` |

All scenario parameters — shape, exponent, ruin threshold, shock
multiplier, FX devaluation, vol multiplier — are declared in
`config/sira.toml`. No scenario definition exists outside the TOML.

---

### 8.1 **Scenario Control**

| Rule                   | Governance Requirement                                 |
| ---------------------- | ------------------------------------------------------ |
| Single Source of Truth | All scenario definitions reside in `config/sira.toml`  |
| No Hardcoding          | Scenario logic is externalised from analytical scripts |
| Version Control        | Scenario parameters are immutable per execution run    |

---

### 9.0 **Global GRC Assurance**

This system operates as a **bounded financial engineering simulation and risk analytics environment** under strict governance constraints.

| Dimension              | Control Statement                                                      |
| ---------------------- | ---------------------------------------------------------------------- |
| Authority              | No module constitutes decision authority                               |
| Scope                  | Execution is strictly bounded by configuration and manifest controls   |
| Interpretive Power     | No analytical output is independently authoritative                    |
| Output Nature          | Advisory, diagnostic, and computational only                           |
| Governance Requirement | All outputs must be interpreted within the governing framework context |


---

### 10.0 Repository Structure
```text
.
├── README.md
├── run_all.R
├── config/
│   └── sira.toml
├── data/
│   ├── README.md
│   ├── live/                        # Controlled staging — never committed
│   ├── synthetic/                   # Canonical governed datasets
│   ├── manifest/                    # data_manifest.toml + schema
│   └── lineage/                     # Per-file lineage records
├── scripts/
│   ├── 00_env_check.R
│   ├── 00_config.R
│   ├── 01_load_data.R
│   ├── 02_analysis.R
│   ├── 03_visualize.R
│   ├── 10_liability_engine.R
│   ├── 11_credit_deployment.R
│   ├── 12_spread_stress.R
│   ├── 13_capital_stack_viz.R
│   ├── 20_dcf.R
│   ├── 21_ma.R
│   ├── 22_accretion.R
│   ├── 23_lbo.R
│   ├── 24_irr.R
│   ├── 25_deal_summary.R
│   ├── 30_bs_core.R
│   ├── 30b_greeks.R
│   ├── 31_recovery_put.R
│   ├── 32_kicker_call.R
│   ├── 33_annuity_floor.R
│   ├── 34_vol_surface.R
│   ├── 35_options_summary.R
│   └── 36_delta_hedge.R
├── docs/
│   ├── CREDIT_RISK_LAYER.md
│   ├── RISK_COMMITTEE.md
│   ├── DEFENSE_APPENDIX.md
│   └── COMPLIANCE_CROSSWALK.csv
└── output/
    ├── sell_hold_signals.png
    ├── capital_stack_spread.png
    └── capital_stack_metadata.rds
```
```bash
Rscript run_all.R
```

---

### 11.0 Governance Artefacts

| Artefact | Purpose |
|---|---|
| `docs/CREDIT_RISK_LAYER.md` | LGD/PD framing, IRB boundary, distribution rationale, committee preparation |
| `docs/RISK_COMMITTEE.md` | Pre-structured challenge register across model scope, signal integrity, model risk, and operational controls |
| `docs/DEFENSE_APPENDIX.md` | Epsilon and sigma as co-primary defense objects; controls matrix mapped to ISM, SOC 2, E8 ML4 |
| `docs/COMPLIANCE_CROSSWALK.csv` | Component-level coverage assessment across SR 11-7, FRTB, Basel III IRB, BCBS 239, SOC 2, E8 ML4, ISM |
| `data/manifest/data_manifest.toml` | Controlled input registry with SHA-256, lineage references, and approval fields |

## 12.0 Quickstart — MCP Orchestration Server

> The MCP server exposes enumerated actions only. Claude Code cannot infer
> configuration from context, execute arbitrary shell commands, or register
> actions at runtime. It applies the version-controlled script or stops.

---

### 12.1 Requirements

### 12.1.1 MCP server runtime

These dependencies must be present before `npm install.`
is run. The server will not start without them.

| Dependency | Minimum version | Purpose |
|---|---|---|
| Node.js | `20.0.0` | MCP server runtime |
| npm | `9.0.0` | Package management |
| Bash | `5.0` | Dispatch and orchestration scripts |

### 12.1.2 Host-layer dependencies

These dependencies are invoked by the Bash orchestration
layer at action execution time, not by the Node.js server
at startup. The server starts without them. Actions that
invoke them will halt with a logged error if they are
absent.

> **Scope:** Host-layer dependencies are outside the npm
> package boundary. They must be installed and verified
> on the WSL2 host independently of `npm install`. See
> the pre-flight checklist below for verification
> commands.
>
> Host-layer dependency governance:
> [`docs/IATO_MCP_ARCHITECTURE.md §3`](docs/IATO_MCP_ARCHITECTURE.md#3--container-runtime-and-schema-validation)
> — Rootless Podman and XSD schema validation.

| Dependency | Minimum version | Purpose | Verification |
|---|---|---|---|
| Podman | `4.0.0` | Rootless container operations | `podman --version` |
| xmllint | any | XSD validation fallback (subprocess) | `xmllint --version` |

**Install xmllint on WSL2/Ubuntu if not present:**

```bash
apt-get install -y libxml2-utils
```

**Install Podman on WSL2/Ubuntu if not present:**

```bash
apt-get install -y podman
```

---

### 12.2 Install and build

```bash
npm install
npm run build
```

`npm run build` compiles TypeScript to `dist/`. The compiled server is the
artefact Claude Code invokes — do not point Claude Code at `src/`.

Verify the build:

```bash
ls dist/server.js   # must exist before registering with Claude Code
```

---

### 12.3 Pre-flight checklist

Complete before first use. The server will start without these steps
but actions will halt at the first gate they fail.

**1. Script permissions**

```bash
chmod +x orchestrator/dispatch.sh
chmod +x orchestrator/audit_log.sh
chmod +x orchestrator/state_check.sh
chmod +x orchestrator/decommission.sh
chmod +x scripts/provision/00_preflight.sh
chmod +x scripts/provision/01_apply.sh
chmod +x scripts/provision/02_verify.sh
chmod +x scripts/container/podman_spawn.sh
chmod +x scripts/container/podman_teardown.sh
chmod +x scripts/vsphere/preflight_iac.sh
chmod +x scripts/vsphere/validate_topology.sh
```

**2. Audit directory**

```bash
mkdir -p audit/session
```

Session log files are written here per dispatch invocation.
Append-only, never committed, retained on disk for compliance evidence.

**3. SHA-256 fields in XML configs**

Every `<file>` entry in `config/environments/*.xml` requires a populated
`sha256` attribute before `state_check` or `apply` will pass preflight.
Empty hash fields cause an immediate halt — this is by design.

Generate hashes for your governed files:

```bash
sha256sum /path/to/file | awk '{print $1}'
```

Populate the value in the relevant XML config under `<file sha256="..."/>`.

**4. GPG keyring (optional but recommended)**

If your scripts carry `.sig` files, import the signing key before first use:

```bash
gpg --import /path/to/trusted-key.asc
```

`00_preflight.sh` skips GPG verification if no `.sig` file is present and
logs a notice. It does not treat a missing `.sig` as a failure — that
threshold is operator-defined.

---

### 12.4 Register with Claude Code

Add the server to Claude Code's MCP configuration.
The config file location depends on your Claude Code version —
typically `.mcp/config.json` in the project root or
`~/.config/claude-code/config.json` globally.

```json
{
  "mcpServers": {
    "iato": {
      "command": "node",
      "args": ["dist/server.js"],
      "cwd": "/absolute/path/to/iato-mcp"
    }
  }
}
```

Use an absolute path for `cwd`. Relative paths are not reliable
across Claude Code invocation contexts.

Restart Claude Code after editing the MCP config.

---

## 12.5 Verify the server is running

Start the server manually to confirm it initialises without error:

```bash
npm start
```

Expected stderr output on clean start:

```
2026-04-01T04:12:00.000Z | IATO-MCP | host=ws01 user=dhruv pid=1234 | SERVER_START | pid=1234 actions=apply,state_check,decommission,spawn_container,teardown_container,vsphere_preflight
2026-04-01T04:12:00.012Z | IATO-MCP | host=ws01 user=dhruv pid=1234 | SERVER_READY | transport=stdio
```

Two lines. If neither appears, check Node.js version and that `dist/server.js`
exists. If only the first appears, the MCP SDK transport initialisation failed —
confirm `@modelcontextprotocol/sdk` installed correctly.

Stop with `Ctrl+C`. Claude Code manages the process lifecycle in normal use —
this manual start is for verification only.

---

### 12.6 Enumerated actions

Claude Code can invoke exactly these six actions via the MCP server.
No others exist. Unknown action strings halt immediately and are logged.

| Tool | Bash entry point | State change |
|---|---|---|
| `apply` | `dispatch.sh apply` | YES — provisions workspace |
| `state_check` | `dispatch.sh state_check` | NO — read and compare only |
| `decommission` | `dispatch.sh decommission` | YES — eliminates and rebuilds |
| `spawn_container` | `dispatch.sh spawn_container` | YES — starts container |
| `teardown_container` | `dispatch.sh teardown_container` | YES — removes container |
| `vsphere_preflight` | `dispatch.sh vsphere_preflight` | NO — assertions only |

Three read-only governance tools are also available:
`read_risk_committee`, `read_defense_appendix`, `read_compliance_crosswalk`.
These invoke no shell and produce no state change.

---

### 12.7 Exit codes

| Code | Meaning | Required response |
|---|---|---|
| 0 | Success | Proceed |
| 1 | Operational failure | Inspect audit log, resolve before retry |
| 2 | State deviation detected | Invoke `decommission` — do not retry the failed action |

Exit 2 is a distinct signal. The audit log will contain `STATE_DEVIATION`
entries identifying which files deviated and their declared vs actual checksums.

---

### 12.8 Audit log location

Each dispatch invocation writes a session log:

```
audit/session/YYYYMMDDTHHMMSS_PID.log
```

Log entries are append-only and machine-parseable:

```
2026-04-01T04:12:33.441Z | IATO-MCP | host=ws01 user=dhruv pid=4421 | ACTION | apply script=01_apply.sh config=workstation.xml
```

These files are `.gitignored` from commit and retained on disk.
Retention schedule and off-host backup are operator responsibilities —
see operator action items in `docs/IATO_MCP_ARCHITECTURE.md §6`.

---

### 12.9 Development mode

Run without building first:

```bash
npm run dev
```

Uses `ts-node` to execute TypeScript directly. Suitable for local iteration.
Do not register `npm run dev` with Claude Code — use the compiled
`dist/server.js` for all governed use.




----

### 13.0 Non-goals

> **Non-Goals Register:** The full runtime boundary
> declaration for this programme is maintained as a
> governed artefact at
> [`notebooks/sira_non_goals_table.md`](notebooks/sira_non_goals_table.md).
> That document is the authoritative source. Reproductions
> or summaries elsewhere in this repository are
> non-authoritative and must not be treated as complete.


## 14.0 License and disclaimer

This project is licensed under the Apache License, Version 2.0.
See `LICENSE` and `NOTICE` at repository root for full terms.

Derived material use is permitted under license terms. Attribution
is required. See `NOTICE` for attribution format.

**Academic use notice:** The SIRA codebase, documentation, and
notebook literature suite must not be used to underpin coursework
content or submitted as original work in any assessed academic
context. This material is a practitioner artefact. All analytical
claims should be traced to their cited primary sources. See
`notebooks/DISCLAIMER.md` for full terms and permitted academic
uses.

