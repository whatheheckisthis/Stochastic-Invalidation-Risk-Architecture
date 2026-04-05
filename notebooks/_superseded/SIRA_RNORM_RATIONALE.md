# ⚠️ SUPERSEDED

This document has been merged into:
`docs/SIRA_METHODOLOGY.md`

It is retained for audit traceability only.

Do NOT use this file for:
- system interpretation
- governance decisions
- modelling reference

---

# SIRA Notebook — Gaussian Reference Draw: Governance Record

> **License:** Apache License 2.0 — derived material use
> permitted under license terms. See `LICENSE` and `NOTICE`
> at repository root.
>
> **Academic use:** This material must not be used to underpin
> coursework content or submitted as original work in any
> assessed academic context. It is a practitioner artefact,
> not peer-reviewed literature. Trace all analytical claims
> to their cited primary sources. See [`DISCLAIMER.md`](DISCLAIMER.md)
> for full terms.


> This document is the governance record for the Normal (Gaussian)
> reference draws that appear in notebook cells 05–09 and cell 10.
> It exists to prevent a future reviewer from treating the pattern
> as careless duplication and removing it.
> Removing the Gaussian reference draws would silently remove the
> structural evidence base for SIRA's distribution choices.

---

## What the Gaussian reference draw is

In each scenario cell, alongside the SIRA stochastic recovery
draw (Beta or Power Law), a second set of draws is generated
from a Normal distribution with equivalent mean and standard
deviation:

```r
draw_rnorm_reference <- function(recoveries) {
  nr <- rnorm(length(recoveries),
    mean = mean(recoveries),
    sd   = sd(recoveries)
  )
  pmin(pmax(nr, 0.001), 0.995)
}
```

This draw is labelled "Normal (reference)" in every chart.
It is never used in signal logic. It does not affect SELL/HOLD
classification. It is a structural comparison, not a model output.

---

## Why it exists

SIRA's choice of Beta and Power Law over Normal distributions
is the central modelling decision. It is justified in
`CREDIT_RISK_LAYER.md §3.1` on three structural grounds:

1. **Bounded support.** Recovery fractions cannot meaningfully
   exceed 1 or fall below 0. Normal distributions assign
   positive probability to both impossible outcomes.

2. **Asymmetry.** Distressed recovery distributions are skewed.
   The Normal assumption of symmetric tails mis-specifies
   both upside and downside.

3. **Fat tails.** Extreme low-recovery events are materially
   more probable in distressed contexts than Normal distributions
   predict.

These are assertions without the reference draw. With the
reference draw, they are visible evidence. A reviewer who
looks at the log-scale density chart in Cell 08 (Counterparty
Default) can see directly that the Normal reference systematically
underestimates lower-tail mass relative to the Power Law draw.

The chart is the proof. The Gaussian reference draw is what
makes the chart possible.

---

## Why it must be retained

The Gaussian reference draw is the evidence base for the
distribution choice. If it is removed:

- The distribution rationale in `CREDIT_RISK_LAYER.md §3.1`
  becomes an assertion without visible support in the notebook
- A model risk reviewer cannot verify the distribution choice
  against the data
- The structural mis-specification claim ("Gaussian would
  understate downside risk") cannot be demonstrated interactively
- The committee presentation loses its primary visual argument
  for why Beta and Power Law were chosen

The draw adds negligible computational cost. The consolidation
into `draw_rnorm_reference()` in Cell 04 means it adds no
code duplication. Its removal would be a pure governance loss.

---

## Why consolidation into a helper function

The original pattern — repeated inline `rnorm()` calls in each
scenario cell — was acceptable for interactive clarity but
created a maintenance surface: five separate rnorm blocks,
each with slightly different variable names, each requiring
independent updates if the clipping bounds changed.

Consolidation into `draw_rnorm_reference()` in Cell 04:

- Creates a single point of update for the clipping logic
- Makes the governance annotation visible once rather than
  inline in five cells
- Preserves the self-contained nature of each scenario cell
  (each still calls the helper independently — no shared state)
- Allows the annotation to be authoritative rather than
  repeated commentary

The helper function is annotated in Cell 04 with the full
governance rationale. Each scenario cell calls it with a
one-line invocation. The annotation is read once; the
invocation is read five times.

---

## Annotation text (Cell 04 — authoritative record)

The following annotation is embedded in Cell 04 of the notebook.
It is reproduced here as the authoritative governance record:

```r
draw_rnorm_reference <- function(recoveries) {
  # Gaussian reference draw at equivalent mean/sd to SIRA recoveries.
  # Used for structural comparison only — NOT in SIRA signal logic.
  # Deliberate pattern — not careless duplication.
  #
  # Governance note: Gaussian is structurally inappropriate for
  # distressed recovery (CREDIT_RISK_LAYER.md §3.1). The reference
  # draw quantifies the mis-specification; it does not correct it.
  #
  # Removing this function would silently remove the evidence base
  # for SIRA's distribution choices from every scenario chart.
  # Do not remove without updating CREDIT_RISK_LAYER.md §3.1 and
  # SIRA_RNORM_RATIONALE.md to reflect the change.
  nr <- rnorm(length(recoveries),
    mean = mean(recoveries),
    sd   = sd(recoveries)
  )
  pmin(pmax(nr, 0.001), 0.995)
}
```

The final comment — "Do not remove without updating..." — is
a maintenance instruction embedded in the code. It names the
two documents that would need to be updated if the draw were
ever legitimately removed, ensuring that removal is a governed
decision rather than an inadvertent deletion.

---

## What a legitimate removal would require

If SIRA's distribution rationale were ever revised — for example,
if empirical calibration data demonstrated that Gaussian was
adequate for a specific portfolio — removal of the reference draw
would require:

1. Updating `CREDIT_RISK_LAYER.md §3.1` to reflect the revised
   distribution rationale
2. Updating this document ([`SIRA_RNORM_RATIONALE.md`](SIRA_RNORM_RATIONALE.md)) to record
   the governance decision and its evidence basis
3. Updating `COMPLIANCE_CROSSWALK.csv` if the distribution
   choice maps to a covered control
4. A model risk committee sign-off on the rationale change

Absent these steps, removal is an ungoverned modification to
the model's evidence base.
