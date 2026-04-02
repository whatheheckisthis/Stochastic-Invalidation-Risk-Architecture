# IĀTŌ — Engagement Model and Delivery Framework

> This document is a delivery artefact of the IĀTŌ assurance
> programme. It governs the engagement model: what a fixed-term
> uplift engagement produces, how it is structured, and what
> control obligations attach to it.
>
> Read [`docs/ETHOS.md`](ETHOS.md) before this document.
> ETHOS defines the operating model this document operationalises.

---

## Engagement model

The practice operates fixed-term uplift engagements. Each
engagement targets a defined, evidenced target state — not
an open-ended improvement programme. The scope is closing
control gaps between the client's operational environment
and a documented target posture aligned to ISM, SOC 2, or
Essential Eight ML4.

An engagement has three properties that distinguish it from
general consulting:

**Fixed scope.** The control gaps to be closed are identified
and agreed before engagement commencement. Out-of-scope items
are documented in an exception register, not absorbed into
delivery.

**Evidenced target state.** The target state is defined in
terms of auditable control evidence — not maturity ratings,
not self-assessment scores. At engagement close, each control
objective has a corresponding evidence artefact or a
documented gap with a named owner.

**Deterministic execution.** Delivery is executed through
the IĀTŌ stack. Configuration is version-controlled and
XSD-validated. Actions are logged through the MCP layer.
The engagement produces an auditable execution record, not
just outputs.

---

## Engagement phases

### Phase 0 — Control gap analysis

Duration: days, not weeks.

Inputs:
- Client's current control posture (self-assessed or
  independently assessed)
- Target framework (ISM, SOC 2, E8 ML4, or combination)
- Existing architecture documentation

Outputs:
- Control gap register: gaps by framework, priority, and
  estimated closure effort
- Engagement scope declaration: which gaps are in-scope
  for this fixed term
- Exception register: out-of-scope gaps with named owner
  and target resolution date

Governance artefacts produced:
  `control-gap-register.csv`
  `engagement-scope.md`
  `exception-register.csv`

---

### Phase 1 — Environment hardening

Duration: defined by scope, not calendar.

The IĀTŌ stack is deployed against the client's environment.
Each action is executed through the MCP dispatch harness.
Every execution is logged. No configuration is inferred
from context — all scripts and configs are version-controlled
and checksum-verified before execution.

Hardening targets by layer:

| Layer | Target | Control |
|---|---|---|
| Workstation | Known-good state declared in XSD | E8 ML4: Application Control |
| Container runtime | Rootless Podman, user-namespace isolation | ISM: Restrict Admin Privileges |
| Configuration | XSD-validated XML, no JSON/YAML for policy-critical config | ISM: Configuration Management |
| IaC templates | vSphere pre-flight before cloud promotion | NIST SSDF: PW.1.2 |
| Audit surface | MCP session logs, timestamped, append-only | E8 ML4: Audit Logging |

Governance artefacts produced:
  `audit/session/*.log` (MCP execution records)
  `config/environments/*.xml` (declared state)
  `config/schema/*.xsd` (policy schemas)
  `scripts/provision/` (versioned execution scripts)

---

### Phase 2 — SDLC security gating

Duration: defined by pipeline scope.

SDLC security gates are implemented as pipeline stages
that must pass before code advances. Gates are declarative —
they check against a defined policy, not a subjective
assessment.

Gate types:

| Gate | Mechanism | Failure mode |
|---|---|---|
| Binary provenance | SHA-256 + GPG signature verification | Pipeline halt, logged |
| Schema conformance | XSD validation of configuration files | Pipeline halt, logged |
| Container policy | Rootless Podman spawn flags verified | Pipeline halt, logged |
| IaC pre-flight | vSphere topology and CIDR assertions | Pipeline halt, logged |
| Audit completeness | Session log presence check per stage | Pipeline halt, logged |

Each gate produces a pass/fail record that becomes part of
the release evidence bundle.

Governance artefacts produced:
  Release evidence bundle (signed attestations per gate)
  Gate configuration (version-controlled policy declarations)
  Exception log (gates bypassed under documented authority)

---

### Phase 3 — Evidence pack production

Duration: fixed, at engagement close.

The evidence pack is the primary engagement deliverable.
It is not a report. It is a structured set of artefacts
that a client's auditor, assessor, or risk committee can
use to verify control closure independently.

Evidence pack structure:

```
evidence-pack/
├── INDEX.md                    # pack manifest and navigation
├── control-gap-register.csv    # Phase 0 baseline
├── control-closure-register.csv # controls closed this engagement
├── exception-register.csv      # out-of-scope items with owners
├── audit/
│   └── session/                # MCP execution logs (full)
├── artefacts/
│   ├── config-baseline/        # XSD configs at engagement close
│   ├── gate-records/           # Pass/fail per pipeline gate
│   └── signatures/             # GPG-signed release attestations
└── crosswalk/
    └── control-crosswalk.csv   # component-to-framework mapping
```

Every item in the pack is either:
- A machine-generated record (audit logs, gate records)
- A version-controlled artefact (configs, schemas, scripts)
- A signed attestation (release evidence)

No item in the pack is a narrative assessment or a
self-reported score.

---

## Delivery artefacts by control objective

### ISM Application Control

| Artefact | Location | Evidence type |
|---|---|---|
| Binary checksum records | `audit/session/*.log` | Machine-generated |
| GPG signature verification logs | `audit/session/*.log` | Machine-generated |
| Provisioning script versions | `scripts/provision/` | Version-controlled |
| Preflight pass records | `evidence-pack/artefacts/gate-records/` | Machine-generated |

### ISM Restrict Administrative Privileges

| Artefact | Location | Evidence type |
|---|---|---|
| Rootless Podman spawn records | `audit/session/*.log` | Machine-generated |
| UID/GID map declarations | `config/environments/*.xml` | Version-controlled |
| Container policy schemas | `config/schema/container.xsd` | Version-controlled |
| No-daemon attestation | `evidence-pack/artefacts/signatures/` | Signed |

### E8 ML4 Audit Logging

| Artefact | Location | Evidence type |
|---|---|---|
| MCP session logs | `audit/session/*.log` | Machine-generated |
| Log format specification | `orchestrator/audit_log.sh` | Version-controlled |
| Retention schedule | Operator-defined | [OPERATOR] |
| Off-host backup evidence | Operator-managed | [OPERATOR] |

### E8 ML4 Workstation Ephemerality

| Artefact | Location | Evidence type |
|---|---|---|
| State check records | `audit/session/*.log` | Machine-generated |
| Deviation detection logs | `audit/session/*.log` | Machine-generated |
| Decommission execution records | `audit/session/*.log` | Machine-generated |
| Rebuild script versions | `scripts/provision/` | Version-controlled |

### SOC 2 CC7.2 — Monitoring and Exception Handling

| Artefact | Location | Evidence type |
|---|---|---|
| MCP pipeline execution logs | `audit/session/*.log` | Machine-generated |
| Stage failure records | `audit/session/*.log` | Machine-generated |
| Exception register | `evidence-pack/exception-register.csv` | Version-controlled |

### NIST SSDF PW.1.2 — IaC Pre-flight

| Artefact | Location | Evidence type |
|---|---|---|
| vSphere pre-flight pass records | `audit/session/*.log` | Machine-generated |
| Network isolation assertions | `scripts/vsphere/preflight_iac.sh` | Version-controlled |
| CIDR scope validation records | `audit/session/*.log` | Machine-generated |
| Cloud promotion gate records | `evidence-pack/artefacts/gate-records/` | Machine-generated |

---

## Control crosswalk schema

All control coverage assessments in this practice use a
consistent schema. The schema is compatible with the SIRA
compliance crosswalk used in the quantitative risk programme,
enabling cross-domain evidence management.

| Field | Values | Description |
|---|---|---|
| `Component` | filename or module | The artefact being assessed |
| `Framework` | ISM, SOC 2, E8 ML4, NIST SSDF, etc. | Governing framework |
| `Control_Reference` | control ID or section | Specific control within framework |
| `Control_Description` | free text | What the control requires |
| `Evidence_Type` | Machine-generated, Version-controlled, Signed, [OPERATOR] | How the evidence is produced |
| `Coverage_Assessment` | FULL, PARTIAL, DECLARED_LIMITATION | Degree of coverage |
| `Gap_Flag` | NO, OPERATOR_DEPENDENT | Whether a gap exists and who owns it |
| `Notes` | free text | Closure path for gaps |

`OPERATOR_DEPENDENT` means the architecture provides the
control surface but the operator must supply a procedural
or organisational control to close the gap. The engagement
documents these items explicitly — they are not left implicit.

---

## Engagement boundaries

### What an engagement delivers

- A defined set of controls closed against a declared target
  framework, with machine-generated evidence for each
- An auditable execution record through the MCP layer
- A structured evidence pack navigable by an external assessor
- An exception register that makes out-of-scope items
  explicit and accountable

### What an engagement does not deliver

- An open-ended maturity improvement programme
- A compliance attestation — evidence packs support
  attestation by the client's assessor; the practice
  does not self-attest on behalf of clients
- A managed security service — the engagement closes
  control gaps; ongoing operations are client-owned
- A secrets management service — credentials and keys
  are operator-managed; the practice does not handle
  client secrets
- A CI/CD pipeline as a service — pipeline integration
  is scoped per engagement and handed over at close

---

## Operator action items

Items that the client (operator) must complete for the
engagement to produce audit-ready evidence:

1. Designate a control owner for each gap in the control
   gap register before Phase 1 commences.
2. Define `audit/session/` retention schedule and off-host
   backup procedure before Phase 1 commences.
3. Populate `sha256` values in all XML configs at controlled
   release — no file entry ships with empty hash fields.
4. Install and authenticate govc before vSphere pre-flight
   is invoked.
5. Configure GPG keyring with trusted signing keys for
   binary verification in `00_preflight.sh`.
6. Define exception register sign-off authority before
   Phase 0 closes.
7. Confirm evidence pack custody and retention arrangements
   before engagement close.

---

## Non-goals

- **Not a maturity self-assessment.** The practice does not
  produce maturity scores. It produces evidenced control
  closure against a defined target state.
- **Not a gap analysis service in isolation.** Phase 0
  produces a gap register; it is the input to delivery,
  not the delivery itself.
- **Not a compliance certification body.** Evidence packs
  support the client's own assessors. The practice produces
  evidence; it does not certify compliance.
- **Not a tool vendor.** The IĀTŌ stack is a practice
  delivery mechanism, not a product. Tooling decisions are
  governed by the control objectives, not by vendor
  preference.

---

## References

- [`docs/ETHOS.md`](ETHOS.md)
  — operating model (read before this document)
- [`docs/IATO_MCP_ARCHITECTURE.md`](IATO_MCP_ARCHITECTURE.md)
  — implementation detail
- [`docs/governance/control-crosswalk.csv`](governance/control-crosswalk.csv)
  — full crosswalk
- ASD. *Essential Eight Maturity Model.*
  https://www.cyber.gov.au/resources-business-and-government/
  essential-cyber-security/essential-eight
- ASD. *Information Security Manual (ISM).*
  https://www.cyber.gov.au/resources-business-and-government/
  essential-cyber-security/ism
- NIST SP 800-218. *Secure Software Development Framework.*
  https://csrc.nist.gov/publications/detail/sp/800-218/final
- SOC 2 Trust Services Criteria (AICPA).
  https://www.aicpa-cima.com/resources/landing/system-and-
  organization-controls-soc-suite-of-services
