# Defense Appendix

This appendix expands on recurring defense questions that typically come up during review of the model assumptions, implementation choices, and risk interpretation logic.

## Questions & Answers

### 1) Why use Standard Deviation?
Standard deviation is used because it gives a clear, quantitative measure of how widely recovery outcomes are spread around their average. In this project, that spread is a direct proxy for volatility in recovery behavior.

More specifically:
- A **low** standard deviation indicates outcomes are tightly clustered, which suggests relatively stable recovery expectations.
- A **high** standard deviation indicates wider dispersion, which suggests materially higher uncertainty and downside variability.

It is also useful defensively because it is:
- **Interpretable** by technical and non-technical audiences.
- **Comparable** across scenarios when evaluating whether one portfolio or stress case is structurally more volatile than another.
- **Actionable** in risk framing (for example, highlighting when central estimates may be less representative due to broad tails).

In short, standard deviation is not just a descriptive statistic here; it supports consistency in volatility communication, scenario comparison, and risk-aware decision-making.

### 2) How did you handle the "Fetching" issue?
The fetching issue was addressed by hard-coding synthetic data structures as deterministic fallback inputs. This design ensures the model remains executable even when external data calls are unavailable, delayed, or unstable.

Implementation intent:
- Preserve **100% run reliability** in offline/demo/defense settings.
- Eliminate dependency on transient connectivity conditions.
- Keep the pipeline reproducible for review panels that may rerun the project in constrained environments.

Practical trade-off:
- Synthetic fallback data improves robustness and presentation reliability,
  but it should be interpreted as a controlled proxy rather than live production truth.
- For production contexts, the same structure can be paired with live feeds and validation checks while retaining fallback behavior as a resilience layer.

This approach intentionally prioritizes continuity and reproducibility during evaluation.

### 3) What is the "Invalidation" point?
The invalidation point is the explicit numerical threshold where the cost of capital exceeds projected recovery. Beyond this threshold, the strategy no longer satisfies its economic viability condition under the given assumptions.

Interpretation in the model:
- **Below** the invalidation point: projected recovery remains sufficient relative to capital cost.
- **At/above** the invalidation point: expected economics break down, and the case is treated as invalidated under the current parameterization.

Why it matters:
- It acts as a transparent decision boundary instead of a subjective judgment call.
- It helps communicate when a scenario moves from acceptable to non-acceptable.
- It supports stress testing by showing how sensitive viability is to changes in rates, losses, or recovery assumptions.

Stating this boundary clearly makes the model easier to defend, audit, and operationalize.

## Simulation Extension Reference
For the discrete-time Base R random-walk build-out (with explicit ruin-stop logic and ASCII walkthrough), see `docs/STOCHASTIC_SIMULATION_EXTENSION.md`.
