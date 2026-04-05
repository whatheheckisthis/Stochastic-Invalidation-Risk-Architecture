# CREDIT RISK LAYER

## 1.0 Purpose
This document defines the implementation view for scenario-driven credit risk analytics in SIRA.

## 1.1 Scope
It describes model execution modules, scenario flow, and output mechanics without governance crosswalk mapping.

## 2.0 Analytical Flow
### 2.1 Input and scenario loading
Scenario parameters are loaded from controlled configuration inputs and applied deterministically.

### 2.2 Distribution modules
Bounded recovery regimes use Beta logic; heavy-tail regimes use Power Law logic.

### 2.3 Stress transforms
Scenario stress multipliers and thresholds are applied to produce stressed recovery behavior.

## 3.0 Signal Construction
### 3.1 Ruin threshold logic
Scenario-level ruin logic evaluates stressed recovery against configured thresholds.

### 3.2 SELL/HOLD triage logic
Signal output is computed deterministically from stressed outcomes and z-score thresholding.

## 4.0 Execution Outputs
### 4.1 Runtime artefacts
Execution emits scenario results, aggregation outputs, and reproducible run artefacts.

### 4.2 Boundary statement
This layer is implementation documentation and does not declare control effectiveness.
