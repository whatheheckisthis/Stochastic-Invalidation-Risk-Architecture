# DELIVERY

## Engagement Model
1. Define intent and scope.
2. Map risks to controls.
3. Implement and test.
4. Capture evidence.
5. Review and record provenance.

## Delivery Artefacts
- Intent statement (what and why).
- Control mapping + SDLC gate mapping.
- Test execution outputs.
- Runtime verification outputs.
- Commit hash and rationale.
- Residual risk notes.

## GRC Control Mapping
| Area | Risk | Control Objective | Evidence |
|---|---|---|---|
| Requirements | Ambiguous behavior | Intent and boundaries documented before change | README + ticket/commit rationale |
| Implementation | Control drift | Function-level control expectations documented | Code diff + control matrix |
| Testing | Undetected regressions | Required unit and edge-case checks executed | `client_test.py` output |
| Release Readiness | Weak change governance | Commit provenance and review notes required | Git history + PR summary |
| Operations | Runtime uncertainty | Repeatable runbook and endpoint checks | server/client/curl outputs |

## SDLC Gating Controls Matrix
| Gate ID | SDLC Stage | Required Controls | Pass Criteria | Evidence |
|---|---|---|---|---|
| G1 | Plan | Intent statement + scope + non-goals | All documented and reviewed | README + docs/ETHOS.md |
| G2 | Design | Threat model + control mapping | Risks mapped to explicit controls | docs/DELIVERY.md + docs/ARCHITECTURE.md |
| G3 | Build | Change bounded to declared scope | Diff matches declared intent | Git diff + commit message |
| G4 | Verify | Unit tests and edge checks executed | Tests pass or deviations documented | test command logs |
| G5 | Release | Provenance and residual risk noted | Commit + PR metadata complete | Git history + PR description |
| G6 | Operate | Runbook reproducibility validated | Runtime commands work as documented | server/client/curl outputs |
