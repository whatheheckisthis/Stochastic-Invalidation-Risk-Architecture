# GRC CONTROL RATIONALE CROSSWALK

## 1.0 Purpose
This document defines why controls exist and how control intent maps to OCEG, NZISM, FAIR, and NIST RMF.

This document defines control intent.
Implementation status, evidence, and control gaps are maintained in `CONTROL_ASSURANCE_REGISTER.csv`.

## 2.0 Scope
This is a read-only interpretation layer. It does not define runtime behavior, enforcement logic, evidence sufficiency, or control effectiveness.

## 3.0 Framework Interpretation
### 3.1 OCEG
Controls are interpreted through purpose limitation, traceability, non-autonomy, and principled performance.

### 3.2 NZISM
Controls are interpreted as governance and assurance mechanisms for risk-based operation and audit readiness.

### 3.3 FAIR
Controls are interpreted as drivers of loss event frequency, control strength variance, and loss magnitude behavior.

### 3.4 NIST RMF
Controls are interpreted within the RMF lifecycle context (Categorize, Select, Implement, Assess, Authorize, Monitor).

## 4.0 Rationale Register
| Rationale_ID | Rationale_Theme | Linked_Control_IDs | Control_References | Mapping_Notes |
|---|---|---|---|---|
| RAT-001 | Deterministic seed/config-driven scenarios | CTRL-001, CTRL-006, CTRL-008, CTRL-019, CTRL-020, CTRL-028, CTRL-029, CTRL-030, CTRL-031, CTRL-032, CTRL-033, CTRL-036, CTRL-037, CTRL-038, CTRL-045, CTRL-046, CTRL-049 | Accuracy and Integrity of Risk Data Aggregation; CC3 Risk assessment and gap analysis; CC7.2 Monitoring and Exception Visibility; Conceptual Soundness; Configuration Management; Evidence artefact production; Greeks-based P&L Attribution; Model Development Documentation; Model Development-Change Control; Model Validation; Ongoing Monitoring; Outcomes Analysis and Ongoing Monitoring; Output Integrity and Aggregation Consistency; Risk Aggregation and State Classification Integrity; Traceability — primary document chain | Interpretive anchor for controls currently showing: FULL, PARTIAL. |
| RAT-002 | XSD-validated configuration as control boundary | CTRL-002 | CC8.1 Change Management | Interpretive anchor for controls currently showing: PARTIAL. |
| RAT-003 | Runtime env/data preflight in SIRA | CTRL-003, CTRL-023 | Application Control + Patch/Version Discipline; Integrity Verification Controls | Interpretive anchor for controls currently showing: FULL, PARTIAL. |
| RAT-004 | Rootless Podman with hard security flags | CTRL-004, CTRL-014, CTRL-043, CTRL-044 | Architecture-level hardening declaration; ISM-0604/ISM-1148 (Network Isolation and Continuity); ISM-1486/ISM-1544 (System Hardening and Verification); Operating model declaration | Interpretive anchor for controls currently showing: FULL, PARTIAL. |
| RAT-005 | Stochastic invalidation stress layer | CTRL-005, CTRL-007, CTRL-016, CTRL-017, CTRL-018, CTRL-024, CTRL-025, CTRL-026, CTRL-027, CTRL-035 | Assumption Governance and Liability Boundary Control; CC3 Risk Assessment; Conceptual Soundness; Income-vs-Loss Stress Transparency; LGD Estimation Governance; Leverage Stress and Tail Resilience; Non-Modellable Risk Factor Stress Capture; Ongoing Monitoring; Outcomes Analysis; Stress Calibration and Tail Risk Capture | Interpretive anchor for controls currently showing: DECLARED_LIMITATION, FULL, PARTIAL. |
| RAT-006 | Single dispatch entrypoint | CTRL-009, CTRL-015, CTRL-034 | CC6.6 Logical and Procedural Access to Change Execution; CC7.2 Monitoring and Exception Handling; Model Documentation | Interpretive anchor for controls currently showing: FULL, PARTIAL. |
| RAT-007 | Manifest + lineage registry | CTRL-010, CTRL-013, CTRL-021, CTRL-022 | Accuracy and Integrity; Data Architecture and Infrastructure; Input Data Integrity and Lineage Disclosure; Operational Resilience/Recovery Preparedness | Interpretive anchor for controls currently showing: FULL, PARTIAL. |
| RAT-008 | Non-goals register | CTRL-011, CTRL-012 | Model Boundary and Intended Use Documentation; Use Test and Governance Boundary | Interpretive anchor for controls currently showing: DECLARED_LIMITATION, FULL. |
| RAT-009 | Notebook disclaimer + NOTICE discipline | CTRL-039, CTRL-040, CTRL-041, CTRL-042 | Academic use boundary; Attribution notice; Copyright and redistribution; Notice block canonical source | Interpretive anchor for controls currently showing: FULL. |
| RAT-010 | Timestamped session audit logs | CTRL-047, CTRL-048 | Audit logging evidence mapping; Documentation integrity | Interpretive anchor for controls currently showing: FULL. |

## 5.0 Integrity Rule
Each control appears once in this interpretation layer by rationale theme. Coverage and gap status remain exclusively in the assurance register.
