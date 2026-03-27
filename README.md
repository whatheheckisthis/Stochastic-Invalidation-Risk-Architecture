# JPMorgan-Stock-Viewer

A lightweight R workflow that loads a price series, computes simple SELL/HOLD signals from downside returns, and exports a bar chart summary.

---

## What this project does

The pipeline runs in three stages:

1. **Load data** (`scripts/01_load_data.R`)
   - Reads the first CSV file from `data/`.
   - Uses the `price` column when available (otherwise the first column).
   - Falls back to a synthetic default price series when no CSV exists.

2. **Analyze signals** (`scripts/02_analysis.R`)
   - Computes first differences (`returns <- diff(price_data)`).
   - Sets a SELL threshold at the 10th percentile of returns.
   - Labels each return as:
     - `SELL` if return is at or below the threshold
     - `HOLD` otherwise
   - Produces summary metrics:
     - observations
     - sell_count
     - hold_count
     - sell_ratio

3. **Visualize output** (`scripts/03_visualize.R`)
   - Creates a PNG bar chart of SELL vs HOLD counts.
   - Writes output to `output/sell_hold_signals.png`.

`run_all.R` orchestrates the full load → analyze → visualize flow.

---

## Repository structure

```text
.
├── README.md
├── run_all.R
├── data/
│   └── .gitkeep
├── scripts/
│   ├── 01_load_data.R
│   ├── 02_analysis.R
│   └── 03_visualize.R
├── output/
│   └── sell_hold_signals.png
└── docs/
    ├── ARCHITECTURE.md
    ├── DEFENSE_APPENDIX.md
    ├── DELIVERY.md
    ├── ETHOS.md
    ├── STOCHASTIC_SIMULATION_EXTENSION.md
    └── WORKER_COMPAT.md
```

---

## Quick start

### Prerequisites

- R 3.6+
- No external packages required (visualization uses Base R graphics)

### Run the full pipeline

```bash
Rscript run_all.R
```

You should see a console summary and a generated file at:

```text
output/sell_hold_signals.png
```

---

## Input format

Place a CSV in `data/` with either:

- a `price` column (recommended), or
- a first column containing numeric prices.

Example:

```csv
price
100
99.5
100.2
98.7
```

If no CSV is provided, synthetic data is used automatically.

---

## Notes

- This is a simple, rules-based demo workflow for signal labeling.
- Signals are analytical outputs and not investment advice.
