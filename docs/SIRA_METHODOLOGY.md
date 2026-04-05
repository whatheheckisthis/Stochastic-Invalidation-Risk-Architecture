# SIRA — Methodology Narrative

> **License:** Apache License 2.0 — derived material use
> permitted under license terms. See `LICENSE` and `NOTICE`
> at repository root.
>
> **Academic use:** This material must not be used to underpin
> coursework content or submitted as original work in any
> assessed academic context. It is a practitioner artefact,
> not peer-reviewed literature. Trace all analytical claims
> to their cited primary sources. See [`notebooks/DISCLAIMER.md`](../notebooks/DISCLAIMER.md)
> for full terms.


> This document explains why SIRA is built the way it is.
> It is a narrative companion to the formal assumptions registry
> ([`SIRA_ASSUMPTIONS.md`](SIRA_ASSUMPTIONS.md)). Read this for context; read the
> assumptions registry for precision.

---

## What SIRA is

SIRA is a stress testing engine for distressed bond and direct
lending portfolios. It answers one question:

> Given five adverse market scenarios, how do stressed recoveries
> distribute across a portfolio — and which positions warrant
> immediate risk escalation?

The answer is a binary signal per position per scenario: SELL or HOLD.
That signal feeds a capital stack analysis, a valuation layer, and an
options intelligence layer. The full architecture produces a unified
committee summary across all four layers.

SIRA is not a live risk system. It is not a regulatory capital model.
It is a scenario stress and signal triage layer that increases
adverse-case visibility and comparability across assets.

---

## Why five scenarios

Five scenarios were chosen to span the stress mechanism space
relevant to direct lending and distressed bond portfolios:

**Baseline** establishes the reference case under normal market
functioning. Without a baseline, stressed scenarios have no
comparator. The baseline is not a forecast — it is a calibration
anchor.

**Liquidity Crunch** captures the compressed recovery environment
that follows market-wide liquidity withdrawal. Bid-ask spreads
widen, forced sellers accept lower prices, and recoveries compress
toward lower bounds. This is the most common adverse scenario in
recent private credit history.

**Jurisdictional Freeze** models the effect of legal process
disruption — regulatory intervention, cross-border enforcement
failure, or resolution framework breakdown. Recovery collapses
toward the ruin threshold not because asset value disappears but
because the legal mechanism for realising it is unavailable.

**Counterparty Default** models gap-down valuation shock. A major
counterparty fails suddenly, triggering correlated price dislocations
across the portfolio. This scenario requires a heavy-tail distribution
because the loss profile is not gradual — it is a discontinuous jump.

**Hyper-Inflationary** models FX devaluation impairment of real
bond value. The nominal recovery may be unchanged but its real
purchasing power — and therefore its economic value to the lender —
is materially reduced. This scenario is particularly relevant for
cross-border direct lending portfolios.

---

## Why Beta and Power Law — not Normal

The choice of distribution is the central modelling decision in SIRA.
It is not a style preference. It is a control boundary.

Distressed recovery outcomes have three structural properties that
rule out the Normal (Gaussian) distribution:

**Bounded support.** Recovery fractions cannot exceed 1 (full
recovery) or fall below 0 (negative recovery is not economically
meaningful for a bond position). Gaussian distributions have
unbounded support — they assign positive probability to recoveries
above 100% and below 0%. These are not possible outcomes and should
not be modelled as if they were.

**Asymmetry.** Distressed recovery distributions are skewed, not
symmetric. The typical workout outcome concentrates mass toward
either a structured resolution (moderate to high recovery) or a
disorderly impairment (low recovery). The Gaussian assumption of
symmetric tails mis-specifies both the upside and the downside.

**Fat tails.** High-risk downward moves in recovery happen more
often than the Normal distribution predicts. Under counterparty
default and macro dislocation scenarios, extreme low-recovery events
are materially more probable than a thin-tailed distribution implies.

The Beta distribution addresses the first two properties. It is
defined on bounded support and accommodates a broad family of
unimodal and skewed shapes through its shape parameters. For
scenarios where recovery fluctuates within constrained ranges and
reverts around scenario-conditioned central tendencies, Beta provides
coherent stress sampling.

The Power Law distribution addresses the third property. It is
appropriate where tail realisations dominate loss behaviour and
extreme outcomes are structurally more probable than Beta or Normal
assumptions imply. SIRA applies Power Law to Counterparty Default
and Hyper-Inflationary scenarios, where jump discontinuities and
macro dislocations justify extreme-value-oriented tail emphasis.

The Gaussian reference draw that appears in the notebook is not
a model output. It is a structural comparison — a visual proof
that the Gaussian assumption would systematically understate
downside risk in every scenario SIRA models. It is retained in the
notebook because removing it would silently remove the evidence base
for the distribution choice. See § Gaussian / RNORM Design Rationale below.

---

## Why the signal is binary (SELL / HOLD)

A three-state signal set (SELL / WATCH / HOLD) was evaluated during
development. WATCH was excluded from the core signal layer for one
reason: the binary set is sufficient for the declared analytical scope.

SELL/HOLD is pre-trade risk escalation triage. The decision it
supports is whether a position warrants immediate credit committee
attention. A WATCH state implies a graduated response — which
requires a defined response protocol, an owner, a timeline, and
an escalation trigger. In the absence of a governed WATCH response
protocol, a third state adds signal surface without adding decision
value. It creates the appearance of precision without the governance
to back it.

WATCH is valid in the capital stack spread stress layer
(SOLVENT / WATCH / BREACH) because the graduated response path
exists there — hedging, reallocation, regulatory notification are
defined operator responses to spread compression. The asymmetry
is deliberate and documented ([`SIRA_NON_GOALS.md`](SIRA_NON_GOALS.md#analytical-boundaries--ng-001-to-ng-006)).

---

## Why the capital stack layer exists

The recovery signal layer answers: which positions are stressed?
The capital stack layer answers: can the institution survive
the aggregate stress?

An institution may have a manageable number of SELL signals at the
position level but still face a solvency problem at the portfolio
level if the net spread between credit yield and annuity obligations
is negative. The capital stack layer makes that aggregate view
explicit and stress-conditions it against the same five scenarios
as the recovery layer.

The spread model — annuity obligations funded by private credit
deployment — reflects the Apollo-style capital machine: collect
annuity capital, deploy into private credit, earn spread. SIRA
stress-tests whether that spread survives adverse scenarios.

---

## Why Black-Scholes is included

The options layer connects three instruments that already exist
in the SIRA architecture to their option-theoretic equivalents:

- The distressed bond recovery is an implicit put option on firm
  value (Merton, 1970s). The bondholder holds the right to recover
  what remains of firm value when it falls below the debt face value.

- The equity kicker in a direct lending position is a call option
  on portfolio company equity. The lender participates in upside
  above the warrant strike.

- The indexed annuity floor is a put option that protects the
  insurer against return collapse below the guaranteed payout rate.

The inclusion of Black-Scholes is not decorative. It provides a
second recovery estimate (BSM implied recovery) that can be compared
against the SIRA stochastic recovery. Where the two estimates
converge, both models are reinforcing. Where they diverge, the
gap is diagnostic evidence about which structural assumption is
driving the difference. That is genuine model intelligence.

The BSM limitation notice emitted by the engine is not a disclaimer.
It is a control. BSM assumes continuous trading in a liquid market.
Private credit is illiquid. The assumption violation is known,
documented, and bounds the interpretation of BSM outputs to
analytical stress evidence — not market prices.

---

## Why the model has a non-goals register

The non-goals register ([`SIRA_NON_GOALS.md`](SIRA_NON_GOALS.md)) is not
a liability disclaimer. It is a boundary control instrument.

A model without explicit non-goals is vulnerable to scope creep —
being used for purposes it was not designed for, producing
outputs that look authoritative in contexts where they are not
valid. The non-goals register prevents category error, constrains
misuse, improves model inventory classification quality, and
increases auditability by making excluded claims explicit at
design time.

The most important non-goals for the notebook layer are:

- NG-003: Not a full credit model
  ([`SIRA_NON_GOALS.md`](SIRA_NON_GOALS.md#analytical-boundaries--ng-001-to-ng-006))
- NG-004: Not a compliance attestation
  ([`SIRA_NON_GOALS.md`](SIRA_NON_GOALS.md#analytical-boundaries--ng-001-to-ng-006))
- NG-016: BSM replication assumes continuous liquid trading
  ([`SIRA_NON_GOALS.md`](SIRA_NON_GOALS.md#options-and-bsm-boundaries--ng-016-to-ng-021))
- NG-017: Vol surface is scenario-governed, not market-calibrated
  ([`SIRA_NON_GOALS.md`](SIRA_NON_GOALS.md#options-and-bsm-boundaries--ng-016-to-ng-021))
- NG-018: Merton linkage is explanatory framing only
  ([`SIRA_NON_GOALS.md`](SIRA_NON_GOALS.md#options-and-bsm-boundaries--ng-016-to-ng-021))

These are not admissions of weakness. They are the boundaries
within which the model's outputs are valid and reliable.

## 8. Gaussian / RNORM Design Rationale

This subsection consolidates the technical rationale previously maintained as a standalone Gaussian reference governance note.

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
  # SIRA_METHODOLOGY.md#8-gaussian--rnorm-design-rationale to reflect the change.
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
2. Updating this document ([`SIRA_METHODOLOGY.md#8-gaussian--rnorm-design-rationale`](SIRA_METHODOLOGY.md#8-gaussian--rnorm-design-rationale)) to record
   the governance decision and its evidence basis
3. Updating `COMPLIANCE_CROSSWALK.csv` if the distribution
   choice maps to a covered control
4. A model risk committee sign-off on the rationale change

Absent these steps, removal is an ungoverned modification to
the model's evidence base.


---

## Related Documents

- Assumptions Registry: [`SIRA_ASSUMPTIONS.md`](SIRA_ASSUMPTIONS.md)
- Governance Boundaries: [`SIRA_NON_GOALS.md`](SIRA_NON_GOALS.md)
