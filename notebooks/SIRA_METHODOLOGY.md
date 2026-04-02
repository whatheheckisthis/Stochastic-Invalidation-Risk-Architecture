# SIRA — Methodology Narrative

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
for the distribution choice. See [`SIRA_RNORM_RATIONALE.md`](SIRA_RNORM_RATIONALE.md).

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
is deliberate and documented (`README.md NG-002`).

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

The non-goals register (`README.md NG-001 to NG-021`) is not
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
- NG-004: Not a compliance attestation
- NG-016: BSM replication assumes continuous liquid trading
- NG-017: Vol surface is scenario-governed, not market-calibrated
- NG-018: Merton linkage is explanatory framing only

These are not admissions of weakness. They are the boundaries
within which the model's outputs are valid and reliable.
