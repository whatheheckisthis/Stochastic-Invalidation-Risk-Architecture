# Professional-Practice

>This repository is bound by the governing documents below. All operative content — determinative schemas, versioned scripts, and auditable artefacts — exists exclusively to satisfy the obligations defined within them and carries no independent scope beyond that purpose. Any work product, configuration, script, or governance document outside those boundaries is outside the declared scope of this practice and must not be interpreted as extending, modifying, or superseding the operating model or engagement framework they define.

| Document | Location | Governs |
|---|---|---|
| ETHOS.md | [`docs/ETHOS.md`](docs/ETHOS.md) | Architectural philosophy and stack rationale |
| DELIVERY.md | [`docs/DELIVERY.md`](docs/DELIVERY.md) | Engagement model, delivery artefacts, and GRC control mappings |


# Stochastic-Invalidation-Risk-Architecture (SIRA)

---

Distressed bond recovery, stress testing, and signal generation
across five adverse market scenarios — with a full capital stack,
valuation intelligence, and options pricing layer.

[![Focus](https://img.shields.io/badge/Focus-Quant%20Risk%20Modelling-0A66C2?style=flat-square)](#)
[![Approach](https://img.shields.io/badge/Approach-Auditability%20by%20Design-2E7D32?style=flat-square)](#)
[![Runtime](https://img.shields.io/badge/Runtime-R%20%2B%20ggplot2-276DC3?style=flat-square)](#)
[![Config](https://img.shields.io/badge/Config-TOML%20Declared--Intent-8B5CF6?style=flat-square)](#)
[![Env](https://img.shields.io/badge/Env-Air--Gapped%20Compatible-333333?style=flat-square)](#)



## Executive Summary

SIRA evaluates a distressed bond and direct lending portfolio across
five adverse scenarios and produces scenario-level and asset-level
outputs across four integrated layers:

**Core stress engine**
- Stochastic recovery simulation using Beta and Power Law
  distributions to capture non-normal, tail-heavy recovery behaviour.
- Z-score diagnostics to identify assets with materially weak
  recovery outcomes relative to the scenario cross-section.
- Ruin threshold logic to classify invalidation events where recovery
  falls below scenario-specific survival levels.
- SELL/HOLD signals to support risk triage.

**Capital stack layer**
- Annuity liability engine modelling obligation structure under stress.
- Credit deployment engine computing net spread against obligations.
- Spread stress aggregator emitting SOLVENT/WATCH/BREACH per scenario.

**Valuation and deal intelligence layer**
- Stress-conditioned DCF, M&A screening, accretion/dilution,
  LBO viability, and IRR attribution — each consuming in-session
  scenario outputs from the core engine.

**Options intelligence layer**
- Black-Scholes pricing derived from Itô's Lemma and replicating
  portfolio argument (Haugh, Columbia IEOR E4706).
- Recovery put, equity kicker call, and annuity floor put — each
  stress-conditioned against the scenario vol surface.
- Full Greeks engine with delta-gamma-vega P&L attribution.
- Delta-hedge replication error simulation per scenario.

All operator-configurable parameters are declared in
`config/sira.toml` — the single source of truth for scenario
definitions, distribution parameters, signal thresholds, capital
stack parameters, and options inputs. No analytical script contains
hardcoded values. The runtime surface is fully terminal-native with
structured stdout emission.

---

## Methodology

### 1. Preflight (`scripts/00_env_check.R`)

Confirms minimum R version, ggplot2 and RcppTOML availability, TOML
parseability, output directory writability, and data manifest
integrity before any analytical work begins. SHA-256 hash validation
is applied to all active manifest entries; live-mode files halt on
hash mismatch. Halts with a labelled non-zero exit on any failed
check.

### 2. Load Configuration (`scripts/00_config.R`)

Parses `config/sira.toml` via RcppTOML and exposes a single named
list `CFG` to the runtime environment. Initialises the `NEON` colour
palette, gated on `isatty(stdout())`.

### 3. Load Inputs (`scripts/01_load_data.R`)

Consumes `data/manifest/data_manifest.toml` and loads only active
governed files for the preflight-selected `data_mode` (`live` or
`synthetic`). Live/synthetic segregation is enforced at folder level
with lineage reference captured in run metadata. Synthetic mode emits
an explicit disclosure notice to stdout.

### 4. Run Analysis (`scripts/02_analysis.R`)

Generates stressed recoveries per scenario from parameters declared
in `CFG$scenarios`:

- Beta distribution for baseline and liquidity-driven conditions —
  appropriate where LGD follows a bounded, mean-reverting pattern
  with shape parameters tuned to scenario severity.
- Power Law tails for jump-risk regimes — applied where extreme
  outcomes are structurally more probable than Beta or normal
  distributions predict.

Iterates scenarios dynamically from `CFG$scenarios$names` — no
hardcoded scenario list. Applies scenario shocks then computes:
```
z_score    = scale(stressed_recovery)
ruin_flag  = stressed_recovery <= ruin_threshold
signal    ∈ {SELL, HOLD}
LGD_proxy  = 1 - stressed_recovery
```

### 5. Visualise and Emit (`scripts/03_visualize.R`)

Writes `output/sell_hold_signals.png` via ggplot2. Emits a
terminal-native fixed-width summary table showing per-scenario
SELL/HOLD counts and mean recovery.

### 6. Capital Stack (`scripts/10–13`)
```
10_liability_engine.R   → annuity obligation PV and solvency headroom
11_credit_deployment.R  → gross yield, net income, spread captured
12_spread_stress.R      → SOLVENT/WATCH/BREACH per scenario
13_capital_stack_viz.R  → terminal summary + capital_stack_spread.png
```

Spread engine model:
```
gross_income              = deployed_capital × gross_yield + fees
net_income_after_defaults = gross_income − scenario LGD stress
spread_captured           = net_income − annual_obligation
```

Solvency headroom is further adjusted by the annuity floor put
price from the options layer before final spread signal emission.

### 7. Valuation and Deal Intelligence (`scripts/20–25`)
```
20_dcf.R          → stress-conditioned PV and impairment signal
21_ma.R           → ACQUIRE/REVIEW/PASS acquisition screen
22_accretion.R    → spread delta under stressed pro-forma yield
23_lbo.R          → DSCR, stressed IRR, leverage viability signal
24_irr.R          → IRR attribution: coupon, fee, kicker, recovery
25_deal_summary.R → unified committee table, worst-case, dominant risk
```

DCF stressed case:
```
PV_stressed = Σ(coupon / (1+r_stressed)^t)
            + (stressed_recovery × face_value) / (1+r_stressed)^T
```

IRR attribution decomposition:
```
coupon_contribution   = PV(coupons)  / initial_investment
fee_contribution      = fee_income   / initial_investment
kicker_contribution   = call_price_stressed / initial_investment
recovery_contribution = terminal_recovery   / initial_investment
```

### 8. Options Intelligence Layer (`scripts/30–36`)

Grounded in Haugh (2016), Columbia IEOR E4706.

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
RISK_COMMITTEE.md.

**Volatility surface**

Scenario-governed, not market-calibrated. Skew implemented
via parameterised adjustment:
```
σ(K) = σ_base + skew_factor × (ATM_K − K) / ATM_K
```

Arbitrage constraints enforced per Haugh Section 2:
butterfly and calendar spread checks emitted to preflight log.

**Delta-hedge replication error (Haugh eq. 24)**
```
P&L = Σ (St²/2 × Γt × (σ²_implied − σ²_scenario) × Δt)
```

Positive P&L → scenario vol below implied → hedge gain.
Negative P&L → scenario vol above implied → solvency erosion.
Signal: HEDGE_GAIN / HEDGE_NEUTRAL / HEDGE_LOSS per scenario.

### 9. Orchestration (`run_all.R`)

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

Terminal harness emits header, per-stage progress, wall-clock
elapsed time, and exit status. Mid-pipeline failures halt with
labelled error output — no silent partial runs.

---

## Five Stress Scenarios

| Scenario | Stress mechanism | Distribution | Vol multiplier |
|---|---|---|---|
| Baseline | Normal market functioning | Beta | 1.00× |
| Liquidity Crunch | Elevated vol, compressed recoveries | Beta | shock_multiplier |
| Jurisdictional Freeze | Recovery collapses toward ruin threshold | Beta | shock_multiplier |
| Counterparty Default | Gap-down valuation shock | Power Law | exponent-implied |
| Hyper-Inflationary | FX devaluation impairs real bond value | Power Law | fx_devaluation |

All scenario parameters — shape, exponent, ruin threshold, shock
multiplier, FX devaluation, vol multiplier — declared in
`config/sira.toml`. No scenario definition exists outside the TOML.

---

## Repository Structure
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

> Requires R (>= 4.0.0), ggplot2, and RcppTOML. All BSM
> computation uses base R stats (pnorm, dnorm, qnorm, uniroot).
> No external data sources, live feeds, or network connectivity
> required at runtime. In air-gapped deployments, RcppTOML must
> be available from a local mirror or vendored package store.

---

## Governance Artefacts

| Artefact | Purpose |
|---|---|
| `docs/CREDIT_RISK_LAYER.md` | LGD/PD framing, IRB boundary, distribution rationale, committee preparation |
| `docs/RISK_COMMITTEE.md` | Pre-structured challenge register across model scope, signal integrity, model risk, and operational controls |
| `docs/DEFENSE_APPENDIX.md` | Epsilon and sigma as co-primary defense objects; controls matrix mapped to ISM, SOC 2, E8 ML4 |
| `docs/COMPLIANCE_CROSSWALK.csv` | Component-level coverage assessment across SR 11-7, FRTB, Basel III IRB, BCBS 239, SOC 2, E8 ML4, ISM |
| `data/manifest/data_manifest.toml` | Controlled input registry with SHA-256, lineage references, and approval fields |

## Quickstart — MCP Orchestration Server

> The MCP server exposes enumerated actions only. Claude Code cannot infer
> configuration from context, execute arbitrary shell commands, or register
> actions at runtime. It applies the version-controlled script or stops.

---

## Requirements

### MCP server runtime

These dependencies must be present before `npm install`
is run. The server will not start without them.

| Dependency | Minimum version | Purpose |
|---|---|---|
| Node.js | 20.0.0 | MCP server runtime |
| npm | 9.0.0 | Package management |
| Bash | 5.0 | Dispatch and orchestration scripts |

### Host-layer dependencies

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
| Podman | 4.0.0 | Rootless container operations | `podman --version` |
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

## Install and build

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

## Pre-flight checklist

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

## Register with Claude Code

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

## Verify the server is running

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

## Enumerated actions

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

## Exit codes

| Code | Meaning | Required response |
|---|---|---|
| 0 | Success | Proceed |
| 1 | Operational failure | Inspect audit log, resolve before retry |
| 2 | State deviation detected | Invoke `decommission` — do not retry the failed action |

Exit 2 is a distinct signal. The audit log will contain `STATE_DEVIATION`
entries identifying which files deviated and their declared vs actual checksums.

---

## Audit log location

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

## Development mode

Run without building first:

```bash
npm run dev
```

Uses `ts-node` to execute TypeScript directly. Suitable for local iteration.
Do not register `npm run dev` with Claude Code — use the compiled
`dist/server.js` for all governed use.




----

## Non-goals

> **Non-Goals Register:** The full runtime boundary
> declaration for this programme is maintained as a
> governed artefact at
> [`notebooks/sira_non_goals_table.md`](notebooks/sira_non_goals_table.md).
> That document is the authoritative source. Reproductions
> or summaries elsewhere in this repository are
> non-authoritative and must not be treated as complete.


## License and disclaimer

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

