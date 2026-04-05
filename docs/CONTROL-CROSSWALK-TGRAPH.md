| Node_ID | Node_Type | Source_Field | Field_Value | Control_Tag | Linked_To | Relationship_Type |
| ------- | --------- | ------------ | ----------- | ----------- | --------- | ----------------- |
| N1 | Control | SIRA_Component | Block 1 - Core Runtime & Orchestration | BLOCK_1_CORE_RUNTIME_ORCHESTRATION |  | references |
| N2 | Attribute | SIRA_Component | Block 1 - Core Runtime & Orchestration | BLOCK_1_CORE_RUNTIME_ORCHESTRATION | N1 | has_attribute |
| N3 | Attribute | Control_Framework |  | BLOCK_1_CORE_RUNTIME_ORCHESTRATION | N1 | maps_to |
| N4 | Attribute | Control_Reference |  | BLOCK_1_CORE_RUNTIME_ORCHESTRATION | N1 | has_attribute |
| N5 | Attribute | Control_Description |  | BLOCK_1_CORE_RUNTIME_ORCHESTRATION | N1 | has_attribute |
| N6 | Attribute | Evidence_Type |  | BLOCK_1_CORE_RUNTIME_ORCHESTRATION | N1 | has_attribute |
| N7 | Attribute | Coverage_Assessment |  | BLOCK_1_CORE_RUNTIME_ORCHESTRATION | N1 | has_attribute |
| N8 | Attribute | Gap_Flag |  | BLOCK_1_CORE_RUNTIME_ORCHESTRATION | N1 | has_attribute |
| N9 | Attribute | Notes |  | BLOCK_1_CORE_RUNTIME_ORCHESTRATION | N1 | has_attribute |
| N10 | Control | SIRA_Component | config/sira.toml | CONFIG_SIRA_TOML |  | references |
| N11 | Attribute | SIRA_Component | config/sira.toml | CONFIG_SIRA_TOML | N10 | has_attribute |
| N12 | Attribute | Control_Framework | SR 11-7 | CONFIG_SIRA_TOML | N10 | maps_to |
| N13 | Attribute | Control_Reference | Model Development-Change Control | CONFIG_SIRA_TOML | N10 | has_attribute |
| N14 | Attribute | Control_Description | Centralized declaration of scenario/distribution/signal parameters with controlled updates and reproducible intent register | CONFIG_SIRA_TOML | N10 | has_attribute |
| N15 | Attribute | Evidence_Type | Configuration baseline + git history | CONFIG_SIRA_TOML | N10 | has_attribute |
| N16 | Attribute | Coverage_Assessment | PARTIAL | CONFIG_SIRA_TOML | N10 | has_attribute |
| N17 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | CONFIG_SIRA_TOML | N10 | has_attribute |
| N18 | Attribute | Notes | Architecture centralizes parameter control but approval workflow and signatory controls are operator-managed | CONFIG_SIRA_TOML | N10 | has_attribute |
| N19 | Control | SIRA_Component | config/sira.toml | CONFIG_SIRA_TOML |  | references |
| N20 | Attribute | SIRA_Component | config/sira.toml | CONFIG_SIRA_TOML | N19 | has_attribute |
| N21 | Attribute | Control_Framework | SOC 2 | CONFIG_SIRA_TOML | N19 | maps_to |
| N22 | Attribute | Control_Reference | CC8.1 Change Management | CONFIG_SIRA_TOML | N19 | has_attribute |
| N23 | Attribute | Control_Description | Parameter changes are isolated to TOML and can be reviewed as discrete configuration diffs | CONFIG_SIRA_TOML | N19 | has_attribute |
| N24 | Attribute | Evidence_Type | Versioned config diff evidence | CONFIG_SIRA_TOML | N19 | has_attribute |
| N25 | Attribute | Coverage_Assessment | PARTIAL | CONFIG_SIRA_TOML | N19 | has_attribute |
| N26 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | CONFIG_SIRA_TOML | N19 | has_attribute |
| N27 | Attribute | Notes | Supports traceability; formal change authorization requires external process | CONFIG_SIRA_TOML | N19 | has_attribute |
| N28 | Control | SIRA_Component | scripts/00_env_check.R | SCRIPTS_00_ENV_CHECK_R |  | references |
| N29 | Attribute | SIRA_Component | scripts/00_env_check.R | SCRIPTS_00_ENV_CHECK_R | N28 | has_attribute |
| N30 | Attribute | Control_Framework | Essential Eight ML4 | SCRIPTS_00_ENV_CHECK_R | N28 | maps_to |
| N31 | Attribute | Control_Reference | Application Control + Patch/Version Discipline | SCRIPTS_00_ENV_CHECK_R | N28 | has_attribute |
| N32 | Attribute | Control_Description | Preflight enforces runtime prerequisites and config parseability before execution to reduce uncontrolled runtime variance | SCRIPTS_00_ENV_CHECK_R | N28 | has_attribute |
| N33 | Attribute | Evidence_Type | Pre-execution check logs | SCRIPTS_00_ENV_CHECK_R | N28 | has_attribute |
| N34 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_00_ENV_CHECK_R | N28 | has_attribute |
| N35 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_00_ENV_CHECK_R | N28 | has_attribute |
| N36 | Attribute | Notes | No centralized endpoint attestation in-repo | SCRIPTS_00_ENV_CHECK_R | N28 | has_attribute |
| N37 | Control | SIRA_Component | scripts/00_env_check.R | SCRIPTS_00_ENV_CHECK_R |  | references |
| N38 | Attribute | SIRA_Component | scripts/00_env_check.R | SCRIPTS_00_ENV_CHECK_R | N37 | has_attribute |
| N39 | Attribute | Control_Framework | ISM | SCRIPTS_00_ENV_CHECK_R | N37 | maps_to |
| N40 | Attribute | Control_Reference | ISM-1486/ISM-1544 (System Hardening and Verification) | SCRIPTS_00_ENV_CHECK_R | N37 | has_attribute |
| N41 | Attribute | Control_Description | Environment and dependency validation prior to analytical execution supports controlled operating baseline | SCRIPTS_00_ENV_CHECK_R | N37 | has_attribute |
| N42 | Attribute | Evidence_Type | Runtime validation output | SCRIPTS_00_ENV_CHECK_R | N37 | has_attribute |
| N43 | Attribute | Coverage_Assessment | FULL | SCRIPTS_00_ENV_CHECK_R | N37 | has_attribute |
| N44 | Attribute | Gap_Flag | NO | SCRIPTS_00_ENV_CHECK_R | N37 | has_attribute |
| N45 | Attribute | Notes | Control objective met within local execution boundary | SCRIPTS_00_ENV_CHECK_R | N37 | has_attribute |
| N46 | Control | SIRA_Component | scripts/02_analysis.R (Beta distribution logic) | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC |  | references |
| N47 | Attribute | SIRA_Component | scripts/02_analysis.R (Beta distribution logic) | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N46 | has_attribute |
| N48 | Attribute | Control_Framework | Basel III IRB | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N46 | maps_to |
| N49 | Attribute | Control_Reference | LGD Estimation Governance | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N46 | has_attribute |
| N50 | Attribute | Control_Description | Bounded recovery modelling with scenario-specific Beta parameters provides stress-LGD proxy inputs without IRB equivalence claim | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N46 | has_attribute |
| N51 | Attribute | Evidence_Type | Model logic review + scenario output evidence | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N46 | has_attribute |
| N52 | Attribute | Coverage_Assessment | DECLARED_LIMITATION | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N46 | has_attribute |
| N53 | Attribute | Gap_Flag | NO | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N46 | has_attribute |
| N54 | Attribute | Notes | Explicit non-goal prevents misclassification as IRB capital model | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N46 | has_attribute |
| N55 | Control | SIRA_Component | scripts/02_analysis.R (Beta distribution logic) | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC |  | references |
| N56 | Attribute | SIRA_Component | scripts/02_analysis.R (Beta distribution logic) | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N55 | has_attribute |
| N57 | Attribute | Control_Framework | SR 11-7 | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N55 | maps_to |
| N58 | Attribute | Control_Reference | Outcomes Analysis and Ongoing Monitoring | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N55 | has_attribute |
| N59 | Attribute | Control_Description | Beta parameterized stress engine is deterministic under CFG runtime seed and auditable at run level | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N55 | has_attribute |
| N60 | Attribute | Evidence_Type | Reproducible run logs + seeded outputs | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N55 | has_attribute |
| N61 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N55 | has_attribute |
| N62 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N55 | has_attribute |
| N63 | Attribute | Notes | Formal validation testing and challenger benchmarking not yet codified | SCRIPTS_02_ANALYSIS_R_BETA_DISTRIBUTION_LOGIC | N55 | has_attribute |
| N64 | Control | SIRA_Component | scripts/02_analysis.R (Power Law logic) | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC |  | references |
| N65 | Attribute | SIRA_Component | scripts/02_analysis.R (Power Law logic) | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N64 | has_attribute |
| N66 | Attribute | Control_Framework | FRTB Article 325 | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N64 | maps_to |
| N67 | Attribute | Control_Reference | Stress Calibration and Tail Risk Capture | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N64 | has_attribute |
| N68 | Attribute | Control_Description | Power-law tail construction addresses non-linear jump risk under counterparty and hyperinflation scenarios | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N64 | has_attribute |
| N69 | Attribute | Evidence_Type | Scenario tail-behaviour evidence | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N64 | has_attribute |
| N70 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N64 | has_attribute |
| N71 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N64 | has_attribute |
| N72 | Attribute | Notes | Requires operator-owned empirical calibration justification | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N64 | has_attribute |
| N73 | Control | SIRA_Component | scripts/03_visualize.R output | SCRIPTS_03_VISUALIZE_R_OUTPUT |  | references |
| N74 | Attribute | SIRA_Component | scripts/03_visualize.R output | SCRIPTS_03_VISUALIZE_R_OUTPUT | N73 | has_attribute |
| N75 | Attribute | Control_Framework | BCBS 239 Principle 6 | SCRIPTS_03_VISUALIZE_R_OUTPUT | N73 | maps_to |
| N76 | Attribute | Control_Reference | Accuracy and Integrity of Risk Data Aggregation | SCRIPTS_03_VISUALIZE_R_OUTPUT | N73 | has_attribute |
| N77 | Attribute | Control_Description | Risk signal aggregation by scenario with deterministic ordering and standardized summary table generation | SCRIPTS_03_VISUALIZE_R_OUTPUT | N73 | has_attribute |
| N78 | Attribute | Evidence_Type | Generated chart + terminal summary table | SCRIPTS_03_VISUALIZE_R_OUTPUT | N73 | has_attribute |
| N79 | Attribute | Coverage_Assessment | FULL | SCRIPTS_03_VISUALIZE_R_OUTPUT | N73 | has_attribute |
| N80 | Attribute | Gap_Flag | NO | SCRIPTS_03_VISUALIZE_R_OUTPUT | N73 | has_attribute |
| N81 | Attribute | Notes | Output integrity is machine reproducible from identical inputs and seed | SCRIPTS_03_VISUALIZE_R_OUTPUT | N73 | has_attribute |
| N82 | Control | SIRA_Component | run_all.R orchestration | RUN_ALL_R_ORCHESTRATION |  | references |
| N83 | Attribute | SIRA_Component | run_all.R orchestration | RUN_ALL_R_ORCHESTRATION | N82 | has_attribute |
| N84 | Attribute | Control_Framework | SOC 2 | RUN_ALL_R_ORCHESTRATION | N82 | maps_to |
| N85 | Attribute | Control_Reference | CC7.2 Monitoring and Exception Handling | RUN_ALL_R_ORCHESTRATION | N82 | has_attribute |
| N86 | Attribute | Control_Description | Ordered stage execution with fail-fast error handling and explicit success/failure runtime emission | RUN_ALL_R_ORCHESTRATION | N82 | has_attribute |
| N87 | Attribute | Evidence_Type | Pipeline execution logs | RUN_ALL_R_ORCHESTRATION | N82 | has_attribute |
| N88 | Attribute | Coverage_Assessment | FULL | RUN_ALL_R_ORCHESTRATION | N82 | has_attribute |
| N89 | Attribute | Gap_Flag | NO | RUN_ALL_R_ORCHESTRATION | N82 | has_attribute |
| N90 | Attribute | Notes | Meets pipeline integrity objective for local batch execution | RUN_ALL_R_ORCHESTRATION | N82 | has_attribute |
| N91 | Control | SIRA_Component | Synthetic fallback (deterministic seed) | SYNTHETIC_FALLBACK_DETERMINISTIC_SEED |  | references |
| N92 | Attribute | SIRA_Component | Synthetic fallback (deterministic seed) | SYNTHETIC_FALLBACK_DETERMINISTIC_SEED | N91 | has_attribute |
| N93 | Attribute | Control_Framework | BCBS 239 Principle 6 | SYNTHETIC_FALLBACK_DETERMINISTIC_SEED | N91 | maps_to |
| N94 | Attribute | Control_Reference | Input Data Integrity and Lineage Disclosure | SYNTHETIC_FALLBACK_DETERMINISTIC_SEED | N91 | has_attribute |
| N95 | Attribute | Control_Description | Deterministic synthetic fallback ensures continuity while preserving explicit data mode metadata for lineage visibility | SYNTHETIC_FALLBACK_DETERMINISTIC_SEED | N91 | has_attribute |
| N96 | Attribute | Evidence_Type | Metadata record + runtime data mode output | SYNTHETIC_FALLBACK_DETERMINISTIC_SEED | N91 | has_attribute |
| N97 | Attribute | Coverage_Assessment | FULL | SYNTHETIC_FALLBACK_DETERMINISTIC_SEED | N91 | has_attribute |
| N98 | Attribute | Gap_Flag | NO | SYNTHETIC_FALLBACK_DETERMINISTIC_SEED | N91 | has_attribute |
| N99 | Attribute | Notes | Governed manifest, lineage, and hash controls prevent silent synthetic fallback for live data conditions within repository boundary | SYNTHETIC_FALLBACK_DETERMINISTIC_SEED | N91 | has_attribute |
| N100 | Control | SIRA_Component | SELL/HOLD signal output | SELL_HOLD_SIGNAL_OUTPUT |  | references |
| N101 | Attribute | SIRA_Component | SELL/HOLD signal output | SELL_HOLD_SIGNAL_OUTPUT | N100 | has_attribute |
| N102 | Attribute | Control_Framework | Basel III IRB | SELL_HOLD_SIGNAL_OUTPUT | N100 | maps_to |
| N103 | Attribute | Control_Reference | Use Test and Governance Boundary | SELL_HOLD_SIGNAL_OUTPUT | N100 | has_attribute |
| N104 | Attribute | Control_Description | Signal is pre-trade analytical triage output and not an automated execution or regulatory capital decision engine | SELL_HOLD_SIGNAL_OUTPUT | N100 | has_attribute |
| N105 | Attribute | Evidence_Type | Signal logic + non-goals register | SELL_HOLD_SIGNAL_OUTPUT | N100 | has_attribute |
| N106 | Attribute | Coverage_Assessment | DECLARED_LIMITATION | SELL_HOLD_SIGNAL_OUTPUT | N100 | has_attribute |
| N107 | Attribute | Gap_Flag | NO | SELL_HOLD_SIGNAL_OUTPUT | N100 | has_attribute |
| N108 | Attribute | Notes | Must remain subordinate to instrument-level credit analysis and policy controls | SELL_HOLD_SIGNAL_OUTPUT | N100 | has_attribute |
| N109 | Control | SIRA_Component | Non-goals register | NON_GOALS_REGISTER |  | references |
| N110 | Attribute | SIRA_Component | Non-goals register | NON_GOALS_REGISTER | N109 | has_attribute |
| N111 | Attribute | Control_Framework | SR 11-7 | NON_GOALS_REGISTER | N109 | maps_to |
| N112 | Attribute | Control_Reference | Model Boundary and Intended Use Documentation | NON_GOALS_REGISTER | N109 | has_attribute |
| N113 | Attribute | Control_Description | Explicit documentation of non-claims constrains misuse and supports inventory classification and governance review | NON_GOALS_REGISTER | N109 | has_attribute |
| N114 | Attribute | Evidence_Type | README non-goals section | NON_GOALS_REGISTER | N109 | has_attribute |
| N115 | Attribute | Coverage_Assessment | FULL | NON_GOALS_REGISTER | N109 | has_attribute |
| N116 | Attribute | Gap_Flag | NO | NON_GOALS_REGISTER | N109 | has_attribute |
| N117 | Attribute | Notes | Provides enforceable boundary conditions for model risk committees | NON_GOALS_REGISTER | N109 | has_attribute |
| N118 | Control | SIRA_Component | Air-gap compatibility | AIR_GAP_COMPATIBILITY |  | references |
| N119 | Attribute | SIRA_Component | Air-gap compatibility | AIR_GAP_COMPATIBILITY | N118 | has_attribute |
| N120 | Attribute | Control_Framework | Essential Eight ML4 | AIR_GAP_COMPATIBILITY | N118 | maps_to |
| N121 | Attribute | Control_Reference | Operational Resilience/Recovery Preparedness | AIR_GAP_COMPATIBILITY | N118 | has_attribute |
| N122 | Attribute | Control_Description | No external network dependency at runtime supports continuity in disconnected environments | AIR_GAP_COMPATIBILITY | N118 | has_attribute |
| N123 | Attribute | Evidence_Type | Runtime dependency manifest + offline execution evidence | AIR_GAP_COMPATIBILITY | N118 | has_attribute |
| N124 | Attribute | Coverage_Assessment | PARTIAL | AIR_GAP_COMPATIBILITY | N118 | has_attribute |
| N125 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | AIR_GAP_COMPATIBILITY | N118 | has_attribute |
| N126 | Attribute | Notes | Validated runtime manifest custody and release governance are external | AIR_GAP_COMPATIBILITY | N118 | has_attribute |
| N127 | Control | SIRA_Component | Air-gap compatibility | AIR_GAP_COMPATIBILITY |  | references |
| N128 | Attribute | SIRA_Component | Air-gap compatibility | AIR_GAP_COMPATIBILITY | N127 | has_attribute |
| N129 | Attribute | Control_Framework | ISM | AIR_GAP_COMPATIBILITY | N127 | maps_to |
| N130 | Attribute | Control_Reference | ISM-0604/ISM-1148 (Network Isolation and Continuity) | AIR_GAP_COMPATIBILITY | N127 | has_attribute |
| N131 | Attribute | Control_Description | Terminal-native offline operation aligns with isolated environment execution requirements | AIR_GAP_COMPATIBILITY | N127 | has_attribute |
| N132 | Attribute | Evidence_Type | Offline run evidence | AIR_GAP_COMPATIBILITY | N127 | has_attribute |
| N133 | Attribute | Coverage_Assessment | PARTIAL | AIR_GAP_COMPATIBILITY | N127 | has_attribute |
| N134 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | AIR_GAP_COMPATIBILITY | N127 | has_attribute |
| N135 | Attribute | Notes | Control satisfaction depends on operator enclave configuration | AIR_GAP_COMPATIBILITY | N127 | has_attribute |
| N136 | Control | SIRA_Component | run_all.R orchestration | RUN_ALL_R_ORCHESTRATION |  | references |
| N137 | Attribute | SIRA_Component | run_all.R orchestration | RUN_ALL_R_ORCHESTRATION | N136 | has_attribute |
| N138 | Attribute | Control_Framework | SOC 2 | RUN_ALL_R_ORCHESTRATION | N136 | maps_to |
| N139 | Attribute | Control_Reference | CC6.6 Logical and Procedural Access to Change Execution | RUN_ALL_R_ORCHESTRATION | N136 | has_attribute |
| N140 | Attribute | Control_Description | Single entry-point run orchestration limits ad hoc stage bypass and supports controlled execution path | RUN_ALL_R_ORCHESTRATION | N136 | has_attribute |
| N141 | Attribute | Evidence_Type | Entrypoint script + invocation records | RUN_ALL_R_ORCHESTRATION | N136 | has_attribute |
| N142 | Attribute | Coverage_Assessment | PARTIAL | RUN_ALL_R_ORCHESTRATION | N136 | has_attribute |
| N143 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | RUN_ALL_R_ORCHESTRATION | N136 | has_attribute |
| N144 | Attribute | Notes | Access controls around execution host are outside repository scope | RUN_ALL_R_ORCHESTRATION | N136 | has_attribute |
| N145 | Control | SIRA_Component | scripts/02_analysis.R (Power Law logic) | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC |  | references |
| N146 | Attribute | SIRA_Component | scripts/02_analysis.R (Power Law logic) | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N145 | has_attribute |
| N147 | Attribute | Control_Framework | FRTB Article 325 | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N145 | maps_to |
| N148 | Attribute | Control_Reference | Non-Modellable Risk Factor Stress Capture | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N145 | has_attribute |
| N149 | Attribute | Control_Description | Jump-risk oriented stress regime supports severe tail scenario evaluation where linear assumptions understate risk | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N145 | has_attribute |
| N150 | Attribute | Evidence_Type | Scenario-level signal and ruin-flag outputs | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N145 | has_attribute |
| N151 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N145 | has_attribute |
| N152 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N145 | has_attribute |
| N153 | Attribute | Notes | Formal linkage to desk-level FRTB governance requires operator framework mapping | SCRIPTS_02_ANALYSIS_R_POWER_LAW_LOGIC | N145 | has_attribute |
| N154 | Control | SIRA_Component | scripts/10_liability_engine.R | SCRIPTS_10_LIABILITY_ENGINE_R |  | references |
| N155 | Attribute | SIRA_Component | scripts/10_liability_engine.R | SCRIPTS_10_LIABILITY_ENGINE_R | N154 | has_attribute |
| N156 | Attribute | Control_Framework | SR 11-7 | SCRIPTS_10_LIABILITY_ENGINE_R | N154 | maps_to |
| N157 | Attribute | Control_Reference | Assumption Governance and Liability Boundary Control | SCRIPTS_10_LIABILITY_ENGINE_R | N154 | has_attribute |
| N158 | Attribute | Control_Description | Liability stack assumptions are TOML-governed and explicitly stress-adjusted under hyperinflation to surface headroom breach risk | SCRIPTS_10_LIABILITY_ENGINE_R | N154 | has_attribute |
| N159 | Attribute | Evidence_Type | Config diffs + deterministic run output | SCRIPTS_10_LIABILITY_ENGINE_R | N154 | has_attribute |
| N160 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_10_LIABILITY_ENGINE_R | N154 | has_attribute |
| N161 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_10_LIABILITY_ENGINE_R | N154 | has_attribute |
| N162 | Attribute | Notes | Requires documented owner and approval process for payout-rate and inflation assumptions | SCRIPTS_10_LIABILITY_ENGINE_R | N154 | has_attribute |
| N163 | Control | SIRA_Component | scripts/11_credit_deployment.R | SCRIPTS_11_CREDIT_DEPLOYMENT_R |  | references |
| N164 | Attribute | SIRA_Component | scripts/11_credit_deployment.R | SCRIPTS_11_CREDIT_DEPLOYMENT_R | N163 | has_attribute |
| N165 | Attribute | Control_Framework | Basel III IRB | SCRIPTS_11_CREDIT_DEPLOYMENT_R | N163 | maps_to |
| N166 | Attribute | Control_Reference | Income-vs-Loss Stress Transparency | SCRIPTS_11_CREDIT_DEPLOYMENT_R | N163 | has_attribute |
| N167 | Attribute | Control_Description | Spread engine computes gross and default-adjusted net income with scenario LGD proxy linkage while preserving non-IRB positioning | SCRIPTS_11_CREDIT_DEPLOYMENT_R | N163 | has_attribute |
| N168 | Attribute | Evidence_Type | Scenario-level spread output + seeded reproducibility evidence | SCRIPTS_11_CREDIT_DEPLOYMENT_R | N163 | has_attribute |
| N169 | Attribute | Coverage_Assessment | DECLARED_LIMITATION | SCRIPTS_11_CREDIT_DEPLOYMENT_R | N163 | has_attribute |
| N170 | Attribute | Gap_Flag | NO | SCRIPTS_11_CREDIT_DEPLOYMENT_R | N163 | has_attribute |
| N171 | Attribute | Notes | Analytical stress layer only and not insurer/regulatory capital output | SCRIPTS_11_CREDIT_DEPLOYMENT_R | N163 | has_attribute |
| N172 | Control | SIRA_Component | scripts/12_spread_stress.R | SCRIPTS_12_SPREAD_STRESS_R |  | references |
| N173 | Attribute | SIRA_Component | scripts/12_spread_stress.R | SCRIPTS_12_SPREAD_STRESS_R | N172 | has_attribute |
| N174 | Attribute | Control_Framework | BCBS 239 Principle 6 | SCRIPTS_12_SPREAD_STRESS_R | N172 | maps_to |
| N175 | Attribute | Control_Reference | Risk Aggregation and State Classification Integrity | SCRIPTS_12_SPREAD_STRESS_R | N172 | has_attribute |
| N176 | Attribute | Control_Description | Cross-scenario aggregation emits deterministic SOLVENT/WATCH/BREACH states with worst-case identification and headroom summaries | SCRIPTS_12_SPREAD_STRESS_R | N172 | has_attribute |
| N177 | Attribute | Evidence_Type | Machine-generated aggregate table + metadata artifact | SCRIPTS_12_SPREAD_STRESS_R | N172 | has_attribute |
| N178 | Attribute | Coverage_Assessment | FULL | SCRIPTS_12_SPREAD_STRESS_R | N172 | has_attribute |
| N179 | Attribute | Gap_Flag | NO | SCRIPTS_12_SPREAD_STRESS_R | N172 | has_attribute |
| N180 | Attribute | Notes | Aggregation logic and signal counts are reproducible from fixed config+seed | SCRIPTS_12_SPREAD_STRESS_R | N172 | has_attribute |
| N181 | Control | SIRA_Component | scripts/13_capital_stack_viz.R | SCRIPTS_13_CAPITAL_STACK_VIZ_R |  | references |
| N182 | Attribute | SIRA_Component | scripts/13_capital_stack_viz.R | SCRIPTS_13_CAPITAL_STACK_VIZ_R | N181 | has_attribute |
| N183 | Attribute | Control_Framework | SOC 2 | SCRIPTS_13_CAPITAL_STACK_VIZ_R | N181 | maps_to |
| N184 | Attribute | Control_Reference | CC7.2 Monitoring and Exception Visibility | SCRIPTS_13_CAPITAL_STACK_VIZ_R | N181 | has_attribute |
| N185 | Attribute | Control_Description | Terminal-native capital stack summary and color-coded chart provide consistent scenario-level operational visibility for escalation decisions | SCRIPTS_13_CAPITAL_STACK_VIZ_R | N181 | has_attribute |
| N186 | Attribute | Evidence_Type | Terminal summary + output artifacts | SCRIPTS_13_CAPITAL_STACK_VIZ_R | N181 | has_attribute |
| N187 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_13_CAPITAL_STACK_VIZ_R | N181 | has_attribute |
| N188 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_13_CAPITAL_STACK_VIZ_R | N181 | has_attribute |
| N189 | Attribute | Notes | Escalation ownership and notification workflow remain external governance controls | SCRIPTS_13_CAPITAL_STACK_VIZ_R | N181 | has_attribute |
| N190 | Control | SIRA_Component |  | ROW_22 |  | references |
| N191 | Attribute | SIRA_Component |  | ROW_22 | N190 | has_attribute |
| N192 | Attribute | Control_Framework |  | ROW_22 | N190 | maps_to |
| N193 | Attribute | Control_Reference |  | ROW_22 | N190 | has_attribute |
| N194 | Attribute | Control_Description |  | ROW_22 | N190 | has_attribute |
| N195 | Attribute | Evidence_Type |  | ROW_22 | N190 | has_attribute |
| N196 | Attribute | Coverage_Assessment |  | ROW_22 | N190 | has_attribute |
| N197 | Attribute | Gap_Flag |  | ROW_22 | N190 | has_attribute |
| N198 | Attribute | Notes |  | ROW_22 | N190 | has_attribute |
| N199 | Control | SIRA_Component | Block 2 - Data Governance & Integrity | BLOCK_2_DATA_GOVERNANCE_INTEGRITY |  | references |
| N200 | Attribute | SIRA_Component | Block 2 - Data Governance & Integrity | BLOCK_2_DATA_GOVERNANCE_INTEGRITY | N199 | has_attribute |
| N201 | Attribute | Control_Framework |  | BLOCK_2_DATA_GOVERNANCE_INTEGRITY | N199 | maps_to |
| N202 | Attribute | Control_Reference |  | BLOCK_2_DATA_GOVERNANCE_INTEGRITY | N199 | has_attribute |
| N203 | Attribute | Control_Description |  | BLOCK_2_DATA_GOVERNANCE_INTEGRITY | N199 | has_attribute |
| N204 | Attribute | Evidence_Type |  | BLOCK_2_DATA_GOVERNANCE_INTEGRITY | N199 | has_attribute |
| N205 | Attribute | Coverage_Assessment |  | BLOCK_2_DATA_GOVERNANCE_INTEGRITY | N199 | has_attribute |
| N206 | Attribute | Gap_Flag |  | BLOCK_2_DATA_GOVERNANCE_INTEGRITY | N199 | has_attribute |
| N207 | Attribute | Notes |  | BLOCK_2_DATA_GOVERNANCE_INTEGRITY | N199 | has_attribute |
| N208 | Control | SIRA_Component | data/manifest/data_manifest.toml | DATA_MANIFEST_DATA_MANIFEST_TOML |  | references |
| N209 | Attribute | SIRA_Component | data/manifest/data_manifest.toml | DATA_MANIFEST_DATA_MANIFEST_TOML | N208 | has_attribute |
| N210 | Attribute | Control_Framework | BCBS 239 Principle 2 | DATA_MANIFEST_DATA_MANIFEST_TOML | N208 | maps_to |
| N211 | Attribute | Control_Reference | Data Architecture and Infrastructure | DATA_MANIFEST_DATA_MANIFEST_TOML | N208 | has_attribute |
| N212 | Attribute | Control_Description | Manifest establishes controlled, versioned dataset registry with mode segregation and approval fields for governed ingestion. | DATA_MANIFEST_DATA_MANIFEST_TOML | N208 | has_attribute |
| N213 | Attribute | Evidence_Type | Versioned manifest artifact + preflight summary logs | DATA_MANIFEST_DATA_MANIFEST_TOML | N208 | has_attribute |
| N214 | Attribute | Coverage_Assessment | FULL | DATA_MANIFEST_DATA_MANIFEST_TOML | N208 | has_attribute |
| N215 | Attribute | Gap_Flag | NO | DATA_MANIFEST_DATA_MANIFEST_TOML | N208 | has_attribute |
| N216 | Attribute | Notes | Repository-embedded data architecture control implemented. | DATA_MANIFEST_DATA_MANIFEST_TOML | N208 | has_attribute |
| N217 | Control | SIRA_Component | data/lineage/*.toml | DATA_LINEAGE_TOML |  | references |
| N218 | Attribute | SIRA_Component | data/lineage/*.toml | DATA_LINEAGE_TOML | N217 | has_attribute |
| N219 | Attribute | Control_Framework | BCBS 239 Principle 3 | DATA_LINEAGE_TOML | N217 | maps_to |
| N220 | Attribute | Control_Reference | Accuracy and Integrity | DATA_LINEAGE_TOML | N217 | has_attribute |
| N221 | Attribute | Control_Description | Per-file lineage records capture dataset origin, generation method, schema version, and approval lifecycle metadata. | DATA_LINEAGE_TOML | N217 | has_attribute |
| N222 | Attribute | Evidence_Type | Lineage TOML records + manifest linkage | DATA_LINEAGE_TOML | N217 | has_attribute |
| N223 | Attribute | Coverage_Assessment | FULL | DATA_LINEAGE_TOML | N217 | has_attribute |
| N224 | Attribute | Gap_Flag | NO | DATA_LINEAGE_TOML | N217 | has_attribute |
| N225 | Attribute | Notes | Lineage integrity controls enforced for governed datasets. | DATA_LINEAGE_TOML | N217 | has_attribute |
| N226 | Control | SIRA_Component | scripts/00_env_check.R (SHA-256 verification) | SCRIPTS_00_ENV_CHECK_R_SHA_256_VERIFICATION |  | references |
| N227 | Attribute | SIRA_Component | scripts/00_env_check.R (SHA-256 verification) | SCRIPTS_00_ENV_CHECK_R_SHA_256_VERIFICATION | N226 | has_attribute |
| N228 | Attribute | Control_Framework | ISM | SCRIPTS_00_ENV_CHECK_R_SHA_256_VERIFICATION | N226 | maps_to |
| N229 | Attribute | Control_Reference | Integrity Verification Controls | SCRIPTS_00_ENV_CHECK_R_SHA_256_VERIFICATION | N226 | has_attribute |
| N230 | Attribute | Control_Description | Preflight recomputes SHA-256 for active manifest datasets and halts on live hash failure to prevent unverified ingestion. | SCRIPTS_00_ENV_CHECK_R_SHA_256_VERIFICATION | N226 | has_attribute |
| N231 | Attribute | Evidence_Type | Preflight hash verification output | SCRIPTS_00_ENV_CHECK_R_SHA_256_VERIFICATION | N226 | has_attribute |
| N232 | Attribute | Coverage_Assessment | FULL | SCRIPTS_00_ENV_CHECK_R_SHA_256_VERIFICATION | N226 | has_attribute |
| N233 | Attribute | Gap_Flag | NO | SCRIPTS_00_ENV_CHECK_R_SHA_256_VERIFICATION | N226 | has_attribute |
| N234 | Attribute | Notes | Integrity verification embedded in runtime gate. | SCRIPTS_00_ENV_CHECK_R_SHA_256_VERIFICATION | N226 | has_attribute |
| N235 | Control | SIRA_Component |  | ROW_27 |  | references |
| N236 | Attribute | SIRA_Component |  | ROW_27 | N235 | has_attribute |
| N237 | Attribute | Control_Framework |  | ROW_27 | N235 | maps_to |
| N238 | Attribute | Control_Reference |  | ROW_27 | N235 | has_attribute |
| N239 | Attribute | Control_Description |  | ROW_27 | N235 | has_attribute |
| N240 | Attribute | Evidence_Type |  | ROW_27 | N235 | has_attribute |
| N241 | Attribute | Coverage_Assessment |  | ROW_27 | N235 | has_attribute |
| N242 | Attribute | Gap_Flag |  | ROW_27 | N235 | has_attribute |
| N243 | Attribute | Notes |  | ROW_27 | N235 | has_attribute |
| N244 | Control | SIRA_Component | Block 3 - Analytical Stress Modules | BLOCK_3_ANALYTICAL_STRESS_MODULES |  | references |
| N245 | Attribute | SIRA_Component | Block 3 - Analytical Stress Modules | BLOCK_3_ANALYTICAL_STRESS_MODULES | N244 | has_attribute |
| N246 | Attribute | Control_Framework |  | BLOCK_3_ANALYTICAL_STRESS_MODULES | N244 | maps_to |
| N247 | Attribute | Control_Reference |  | BLOCK_3_ANALYTICAL_STRESS_MODULES | N244 | has_attribute |
| N248 | Attribute | Control_Description |  | BLOCK_3_ANALYTICAL_STRESS_MODULES | N244 | has_attribute |
| N249 | Attribute | Evidence_Type |  | BLOCK_3_ANALYTICAL_STRESS_MODULES | N244 | has_attribute |
| N250 | Attribute | Coverage_Assessment |  | BLOCK_3_ANALYTICAL_STRESS_MODULES | N244 | has_attribute |
| N251 | Attribute | Gap_Flag |  | BLOCK_3_ANALYTICAL_STRESS_MODULES | N244 | has_attribute |
| N252 | Attribute | Notes |  | BLOCK_3_ANALYTICAL_STRESS_MODULES | N244 | has_attribute |
| N253 | Control | SIRA_Component | scripts/20_dcf.R | SCRIPTS_20_DCF_R |  | references |
| N254 | Attribute | SIRA_Component | scripts/20_dcf.R | SCRIPTS_20_DCF_R | N253 | has_attribute |
| N255 | Attribute | Control_Framework | SR 11-7 | SCRIPTS_20_DCF_R | N253 | maps_to |
| N256 | Attribute | Control_Reference | Outcomes Analysis | SCRIPTS_20_DCF_R | N253 | has_attribute |
| N257 | Attribute | Control_Description | Stress-conditioned DCF engine links scenario recoveries to valuation erosion and impairment signaling for model outcomes analysis | SCRIPTS_20_DCF_R | N253 | has_attribute |
| N258 | Attribute | Evidence_Type | Scenario valuation output + impairment signal evidence | SCRIPTS_20_DCF_R | N253 | has_attribute |
| N259 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_20_DCF_R | N253 | has_attribute |
| N260 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_20_DCF_R | N253 | has_attribute |
| N261 | Attribute | Notes | Threshold ownership and validation cadence require committee governance | SCRIPTS_20_DCF_R | N253 | has_attribute |
| N262 | Control | SIRA_Component | scripts/21_ma.R | SCRIPTS_21_MA_R |  | references |
| N263 | Attribute | SIRA_Component | scripts/21_ma.R | SCRIPTS_21_MA_R | N262 | has_attribute |
| N264 | Attribute | Control_Framework | SOC 2 | SCRIPTS_21_MA_R | N262 | maps_to |
| N265 | Attribute | Control_Reference | CC3 Risk Assessment | SCRIPTS_21_MA_R | N262 | has_attribute |
| N266 | Attribute | Control_Description | M&A screen formalizes acquisition decision thresholds under stress and captures review/pass triggers for near-threshold outcomes | SCRIPTS_21_MA_R | N262 | has_attribute |
| N267 | Attribute | Evidence_Type | Scenario screening output + threshold config evidence | SCRIPTS_21_MA_R | N262 | has_attribute |
| N268 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_21_MA_R | N262 | has_attribute |
| N269 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_21_MA_R | N262 | has_attribute |
| N270 | Attribute | Notes | Acquisition override workflow and approvals remain operator-managed | SCRIPTS_21_MA_R | N262 | has_attribute |
| N271 | Control | SIRA_Component | scripts/23_lbo.R | SCRIPTS_23_LBO_R |  | references |
| N272 | Attribute | SIRA_Component | scripts/23_lbo.R | SCRIPTS_23_LBO_R | N271 | has_attribute |
| N273 | Attribute | Control_Framework | FRTB Article 325 | SCRIPTS_23_LBO_R | N271 | maps_to |
| N274 | Attribute | Control_Reference | Leverage Stress and Tail Resilience | SCRIPTS_23_LBO_R | N271 | has_attribute |
| N275 | Attribute | Control_Description | LBO stress module evaluates DSCR and stressed IRR viability under scenario-conditioned exit values to expose leverage fragility | SCRIPTS_23_LBO_R | N271 | has_attribute |
| N276 | Attribute | Evidence_Type | Scenario DSCR/IRR output + viability states | SCRIPTS_23_LBO_R | N271 | has_attribute |
| N277 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_23_LBO_R | N271 | has_attribute |
| N278 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_23_LBO_R | N271 | has_attribute |
| N279 | Attribute | Notes | Calibration linkage to desk governance and leverage policy remains external | SCRIPTS_23_LBO_R | N271 | has_attribute |
| N280 | Control | SIRA_Component | scripts/24_irr.R | SCRIPTS_24_IRR_R |  | references |
| N281 | Attribute | SIRA_Component | scripts/24_irr.R | SCRIPTS_24_IRR_R | N280 | has_attribute |
| N282 | Attribute | Control_Framework | SR 11-7 | SCRIPTS_24_IRR_R | N280 | maps_to |
| N283 | Attribute | Control_Reference | Ongoing Monitoring | SCRIPTS_24_IRR_R | N280 | has_attribute |
| N284 | Attribute | Control_Description | IRR attribution module decomposes return drivers and recomputes stressed IRR per scenario for monitoring against floor and target thresholds | SCRIPTS_24_IRR_R | N280 | has_attribute |
| N285 | Attribute | Evidence_Type | IRR attribution artifacts + stressed signal evidence | SCRIPTS_24_IRR_R | N280 | has_attribute |
| N286 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_24_IRR_R | N280 | has_attribute |
| N287 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_24_IRR_R | N280 | has_attribute |
| N288 | Attribute | Notes | Target/floor governance and monitoring escalation remain external | SCRIPTS_24_IRR_R | N280 | has_attribute |
| N289 | Control | SIRA_Component | scripts/25_deal_summary.R | SCRIPTS_25_DEAL_SUMMARY_R |  | references |
| N290 | Attribute | SIRA_Component | scripts/25_deal_summary.R | SCRIPTS_25_DEAL_SUMMARY_R | N289 | has_attribute |
| N291 | Attribute | Control_Framework | BCBS 239 Principle 6 | SCRIPTS_25_DEAL_SUMMARY_R | N289 | maps_to |
| N292 | Attribute | Control_Reference | Output Integrity and Aggregation Consistency | SCRIPTS_25_DEAL_SUMMARY_R | N289 | has_attribute |
| N293 | Attribute | Control_Description | Deal intelligence aggregator consolidates lens outputs and capital stack signals into deterministic committee summaries with worst-case identification | SCRIPTS_25_DEAL_SUMMARY_R | N289 | has_attribute |
| N294 | Attribute | Evidence_Type | Consolidated summary artifact + metadata record | SCRIPTS_25_DEAL_SUMMARY_R | N289 | has_attribute |
| N295 | Attribute | Coverage_Assessment | FULL | SCRIPTS_25_DEAL_SUMMARY_R | N289 | has_attribute |
| N296 | Attribute | Gap_Flag | NO | SCRIPTS_25_DEAL_SUMMARY_R | N289 | has_attribute |
| N297 | Attribute | Notes | Unified output integrity is reproducible from governed inputs and fixed seed | SCRIPTS_25_DEAL_SUMMARY_R | N289 | has_attribute |
| N298 | Control | SIRA_Component | scripts/30_bs_core.R | SCRIPTS_30_BS_CORE_R |  | references |
| N299 | Attribute | SIRA_Component | scripts/30_bs_core.R | SCRIPTS_30_BS_CORE_R | N298 | has_attribute |
| N300 | Attribute | Control_Framework | SR 11-7 | SCRIPTS_30_BS_CORE_R | N298 | maps_to |
| N301 | Attribute | Control_Reference | Conceptual Soundness | SCRIPTS_30_BS_CORE_R | N298 | has_attribute |
| N302 | Attribute | Control_Description | Derivation and runtime implementation are documented from replicating-portfolio PDE basis with explicit risk-neutral drift elimination | SCRIPTS_30_BS_CORE_R | N298 | has_attribute |
| N303 | Attribute | Evidence_Type | Script header + preflight halt artifact | SCRIPTS_30_BS_CORE_R | N298 | has_attribute |
| N304 | Attribute | Coverage_Assessment | FULL | SCRIPTS_30_BS_CORE_R | N298 | has_attribute |
| N305 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_30_BS_CORE_R | N298 | has_attribute |
| N306 | Attribute | Notes | Empirical volatility calibration remains operator owned | SCRIPTS_30_BS_CORE_R | N298 | has_attribute |
| N307 | Control | SIRA_Component | scripts/30b_greeks.R | SCRIPTS_30B_GREEKS_R |  | references |
| N308 | Attribute | SIRA_Component | scripts/30b_greeks.R | SCRIPTS_30B_GREEKS_R | N307 | has_attribute |
| N309 | Attribute | Control_Framework | SR 11-7 | SCRIPTS_30B_GREEKS_R | N307 | maps_to |
| N310 | Attribute | Control_Reference | Ongoing Monitoring | SCRIPTS_30B_GREEKS_R | N307 | has_attribute |
| N311 | Attribute | Control_Description | Analytical Greeks and delta-gamma-vega scenario decomposition provide continuous sensitivity monitoring and explainability | SCRIPTS_30B_GREEKS_R | N307 | has_attribute |
| N312 | Attribute | Evidence_Type | Greeks output table | SCRIPTS_30B_GREEKS_R | N307 | has_attribute |
| N313 | Attribute | Coverage_Assessment | FULL | SCRIPTS_30B_GREEKS_R | N307 | has_attribute |
| N314 | Attribute | Gap_Flag | NO | SCRIPTS_30B_GREEKS_R | N307 | has_attribute |
| N315 | Attribute | Notes | Closed-form Greeks are analytical and calibration-independent | SCRIPTS_30B_GREEKS_R | N307 | has_attribute |
| N316 | Control | SIRA_Component | scripts/30b_greeks.R | SCRIPTS_30B_GREEKS_R |  | references |
| N317 | Attribute | SIRA_Component | scripts/30b_greeks.R | SCRIPTS_30B_GREEKS_R | N316 | has_attribute |
| N318 | Attribute | Control_Framework | FRTB | SCRIPTS_30B_GREEKS_R | N316 | maps_to |
| N319 | Attribute | Control_Reference | Greeks-based P&L Attribution | SCRIPTS_30B_GREEKS_R | N316 | has_attribute |
| N320 | Attribute | Control_Description | Scenario P&L decomposition emitted as delta gamma vega totals per option position | SCRIPTS_30B_GREEKS_R | N316 | has_attribute |
| N321 | Attribute | Evidence_Type | Options summary artifact | SCRIPTS_30B_GREEKS_R | N316 | has_attribute |
| N322 | Attribute | Coverage_Assessment | FULL | SCRIPTS_30B_GREEKS_R | N316 | has_attribute |
| N323 | Attribute | Gap_Flag | NO | SCRIPTS_30B_GREEKS_R | N316 | has_attribute |
| N324 | Attribute | Notes | Practitioner-standard attribution implemented | SCRIPTS_30B_GREEKS_R | N316 | has_attribute |
| N325 | Control | SIRA_Component | scripts/36_delta_hedge.R | SCRIPTS_36_DELTA_HEDGE_R |  | references |
| N326 | Attribute | SIRA_Component | scripts/36_delta_hedge.R | SCRIPTS_36_DELTA_HEDGE_R | N325 | has_attribute |
| N327 | Attribute | Control_Framework | SR 11-7 | SCRIPTS_36_DELTA_HEDGE_R | N325 | maps_to |
| N328 | Attribute | Control_Reference | Model Validation | SCRIPTS_36_DELTA_HEDGE_R | N325 | has_attribute |
| N329 | Attribute | Control_Description | Discrete replication error simulation provides internal validation lens for option-adjusted solvency headroom resilience | SCRIPTS_36_DELTA_HEDGE_R | N325 | has_attribute |
| N330 | Attribute | Evidence_Type | Delta-hedge artifact | SCRIPTS_36_DELTA_HEDGE_R | N325 | has_attribute |
| N331 | Attribute | Coverage_Assessment | PARTIAL | SCRIPTS_36_DELTA_HEDGE_R | N325 | has_attribute |
| N332 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | SCRIPTS_36_DELTA_HEDGE_R | N325 | has_attribute |
| N333 | Attribute | Notes | Continuous-trading and liquidity assumptions are not fully valid in private credit | SCRIPTS_36_DELTA_HEDGE_R | N325 | has_attribute |
| N334 | Control | SIRA_Component |  | ROW_38 |  | references |
| N335 | Attribute | SIRA_Component |  | ROW_38 | N334 | has_attribute |
| N336 | Attribute | Control_Framework |  | ROW_38 | N334 | maps_to |
| N337 | Attribute | Control_Reference |  | ROW_38 | N334 | has_attribute |
| N338 | Attribute | Control_Description |  | ROW_38 | N334 | has_attribute |
| N339 | Attribute | Evidence_Type |  | ROW_38 | N334 | has_attribute |
| N340 | Attribute | Coverage_Assessment |  | ROW_38 | N334 | has_attribute |
| N341 | Attribute | Gap_Flag |  | ROW_38 | N334 | has_attribute |
| N342 | Attribute | Notes |  | ROW_38 | N334 | has_attribute |
| N343 | Control | SIRA_Component | Block 4 - Documentation & Governance Artefacts | BLOCK_4_DOCUMENTATION_GOVERNANCE_ARTEFACTS |  | references |
| N344 | Attribute | SIRA_Component | Block 4 - Documentation & Governance Artefacts | BLOCK_4_DOCUMENTATION_GOVERNANCE_ARTEFACTS | N343 | has_attribute |
| N345 | Attribute | Control_Framework |  | BLOCK_4_DOCUMENTATION_GOVERNANCE_ARTEFACTS | N343 | maps_to |
| N346 | Attribute | Control_Reference |  | BLOCK_4_DOCUMENTATION_GOVERNANCE_ARTEFACTS | N343 | has_attribute |
| N347 | Attribute | Control_Description |  | BLOCK_4_DOCUMENTATION_GOVERNANCE_ARTEFACTS | N343 | has_attribute |
| N348 | Attribute | Evidence_Type |  | BLOCK_4_DOCUMENTATION_GOVERNANCE_ARTEFACTS | N343 | has_attribute |
| N349 | Attribute | Coverage_Assessment |  | BLOCK_4_DOCUMENTATION_GOVERNANCE_ARTEFACTS | N343 | has_attribute |
| N350 | Attribute | Gap_Flag |  | BLOCK_4_DOCUMENTATION_GOVERNANCE_ARTEFACTS | N343 | has_attribute |
| N351 | Attribute | Notes |  | BLOCK_4_DOCUMENTATION_GOVERNANCE_ARTEFACTS | N343 | has_attribute |
| N352 | Control | SIRA_Component | notebooks/sira_scenarios.ipynb | NOTEBOOKS_SIRA_SCENARIOS_IPYNB |  | references |
| N353 | Attribute | SIRA_Component | notebooks/sira_scenarios.ipynb | NOTEBOOKS_SIRA_SCENARIOS_IPYNB | N352 | has_attribute |
| N354 | Attribute | Control_Framework | SR 11-7 | NOTEBOOKS_SIRA_SCENARIOS_IPYNB | N352 | maps_to |
| N355 | Attribute | Control_Reference | Outcomes Analysis and Ongoing Monitoring | NOTEBOOKS_SIRA_SCENARIOS_IPYNB | N352 | has_attribute |
| N356 | Attribute | Control_Description | Read-only inspection surface. Deterministic from declared seed. Does not modify governed artefacts. | NOTEBOOKS_SIRA_SCENARIOS_IPYNB | N352 | has_attribute |
| N357 | Attribute | Evidence_Type | Notebook execution evidence | NOTEBOOKS_SIRA_SCENARIOS_IPYNB | N352 | has_attribute |
| N358 | Attribute | Coverage_Assessment | FULL | NOTEBOOKS_SIRA_SCENARIOS_IPYNB | N352 | has_attribute |
| N359 | Attribute | Gap_Flag | NO | NOTEBOOKS_SIRA_SCENARIOS_IPYNB | N352 | has_attribute |
| N360 | Attribute | Notes | Read-only inspection surface. Deterministic from declared seed. Does not modify governed artefacts. | NOTEBOOKS_SIRA_SCENARIOS_IPYNB | N352 | has_attribute |
| N361 | Control | SIRA_Component | notebooks/SIRA_READER_GUIDE.md | NOTEBOOKS_SIRA_READER_GUIDE_MD |  | references |
| N362 | Attribute | SIRA_Component | notebooks/SIRA_READER_GUIDE.md | NOTEBOOKS_SIRA_READER_GUIDE_MD | N361 | has_attribute |
| N363 | Attribute | Control_Framework | SR 11-7 | NOTEBOOKS_SIRA_READER_GUIDE_MD | N361 | maps_to |
| N364 | Attribute | Control_Reference | Model Documentation | NOTEBOOKS_SIRA_READER_GUIDE_MD | N361 | has_attribute |
| N365 | Attribute | Control_Description | Orientation and navigation document that makes notebook governance artefacts discoverable to any reviewer. | NOTEBOOKS_SIRA_READER_GUIDE_MD | N361 | has_attribute |
| N366 | Attribute | Evidence_Type | Documentation artefact | NOTEBOOKS_SIRA_READER_GUIDE_MD | N361 | has_attribute |
| N367 | Attribute | Coverage_Assessment | FULL | NOTEBOOKS_SIRA_READER_GUIDE_MD | N361 | has_attribute |
| N368 | Attribute | Gap_Flag | NO | NOTEBOOKS_SIRA_READER_GUIDE_MD | N361 | has_attribute |
| N369 | Attribute | Notes | Entry-point guide for self-contained review package. | NOTEBOOKS_SIRA_READER_GUIDE_MD | N361 | has_attribute |
| N370 | Control | SIRA_Component | notebooks/SIRA_METHODOLOGY.md | NOTEBOOKS_SIRA_METHODOLOGY_MD |  | references |
| N371 | Attribute | SIRA_Component | notebooks/SIRA_METHODOLOGY.md | NOTEBOOKS_SIRA_METHODOLOGY_MD | N370 | has_attribute |
| N372 | Attribute | Control_Framework | SR 11-7 | NOTEBOOKS_SIRA_METHODOLOGY_MD | N370 | maps_to |
| N373 | Attribute | Control_Reference | Conceptual Soundness | NOTEBOOKS_SIRA_METHODOLOGY_MD | N370 | has_attribute |
| N374 | Attribute | Control_Description | Narrative methodology record linking design choices to governed intent across stress, signal, capital stack, and options layers. | NOTEBOOKS_SIRA_METHODOLOGY_MD | N370 | has_attribute |
| N375 | Attribute | Evidence_Type | Documentation artefact | NOTEBOOKS_SIRA_METHODOLOGY_MD | N370 | has_attribute |
| N376 | Attribute | Coverage_Assessment | FULL | NOTEBOOKS_SIRA_METHODOLOGY_MD | N370 | has_attribute |
| N377 | Attribute | Gap_Flag | NO | NOTEBOOKS_SIRA_METHODOLOGY_MD | N370 | has_attribute |
| N378 | Attribute | Notes | Contextual companion to assumptions registry for senior reviewers. | NOTEBOOKS_SIRA_METHODOLOGY_MD | N370 | has_attribute |
| N379 | Control | SIRA_Component | notebooks/SIRA_PATH_RESOLVER.md | NOTEBOOKS_SIRA_PATH_RESOLVER_MD |  | references |
| N380 | Attribute | SIRA_Component | notebooks/SIRA_PATH_RESOLVER.md | NOTEBOOKS_SIRA_PATH_RESOLVER_MD | N379 | has_attribute |
| N381 | Attribute | Control_Framework | ISM | NOTEBOOKS_SIRA_PATH_RESOLVER_MD | N379 | maps_to |
| N382 | Attribute | Control_Reference | Configuration Management | NOTEBOOKS_SIRA_PATH_RESOLVER_MD | N379 | has_attribute |
| N383 | Attribute | Control_Description | Technical governance record for deterministic TOML path resolution with fail-loud behavior and operator mitigations. | NOTEBOOKS_SIRA_PATH_RESOLVER_MD | N379 | has_attribute |
| N384 | Attribute | Evidence_Type | Operational control documentation | NOTEBOOKS_SIRA_PATH_RESOLVER_MD | N379 | has_attribute |
| N385 | Attribute | Coverage_Assessment | FULL | NOTEBOOKS_SIRA_PATH_RESOLVER_MD | N379 | has_attribute |
| N386 | Attribute | Gap_Flag | NO | NOTEBOOKS_SIRA_PATH_RESOLVER_MD | N379 | has_attribute |
| N387 | Attribute | Notes | Documents strategy order, failure behavior, and audit trail expectations. | NOTEBOOKS_SIRA_PATH_RESOLVER_MD | N379 | has_attribute |
| N388 | Control | SIRA_Component | notebooks/SIRA_RNORM_RATIONALE.md | NOTEBOOKS_SIRA_RNORM_RATIONALE_MD |  | references |
| N389 | Attribute | SIRA_Component | notebooks/SIRA_RNORM_RATIONALE.md | NOTEBOOKS_SIRA_RNORM_RATIONALE_MD | N388 | has_attribute |
| N390 | Attribute | Control_Framework | SR 11-7 | NOTEBOOKS_SIRA_RNORM_RATIONALE_MD | N388 | maps_to |
| N391 | Attribute | Control_Reference | Model Development Documentation | NOTEBOOKS_SIRA_RNORM_RATIONALE_MD | N388 | has_attribute |
| N392 | Attribute | Control_Description | Governance rationale preserving Gaussian reference draws as structural evidence for distribution selection decisions. | NOTEBOOKS_SIRA_RNORM_RATIONALE_MD | N388 | has_attribute |
| N393 | Attribute | Evidence_Type | Documentation artefact | NOTEBOOKS_SIRA_RNORM_RATIONALE_MD | N388 | has_attribute |
| N394 | Attribute | Coverage_Assessment | FULL | NOTEBOOKS_SIRA_RNORM_RATIONALE_MD | N388 | has_attribute |
| N395 | Attribute | Gap_Flag | NO | NOTEBOOKS_SIRA_RNORM_RATIONALE_MD | N388 | has_attribute |
| N396 | Attribute | Notes | Defines removal preconditions and cross-document maintenance obligations. | NOTEBOOKS_SIRA_RNORM_RATIONALE_MD | N388 | has_attribute |
| N397 | Control | SIRA_Component | notebooks/SIRA_REVIEWER_CHECKLIST.md | NOTEBOOKS_SIRA_REVIEWER_CHECKLIST_MD |  | references |
| N398 | Attribute | SIRA_Component | notebooks/SIRA_REVIEWER_CHECKLIST.md | NOTEBOOKS_SIRA_REVIEWER_CHECKLIST_MD | N397 | has_attribute |
| N399 | Attribute | Control_Framework | SR 11-7 | NOTEBOOKS_SIRA_REVIEWER_CHECKLIST_MD | N397 | maps_to |
| N400 | Attribute | Control_Reference | Model Validation | NOTEBOOKS_SIRA_REVIEWER_CHECKLIST_MD | N397 | has_attribute |
| N401 | Attribute | Control_Description | Structured review checklist mapping validation criteria to notebook cells, source documents, and evidence artefacts. | NOTEBOOKS_SIRA_REVIEWER_CHECKLIST_MD | N397 | has_attribute |
| N402 | Attribute | Evidence_Type | Validation checklist | NOTEBOOKS_SIRA_REVIEWER_CHECKLIST_MD | N397 | has_attribute |
| N403 | Attribute | Coverage_Assessment | PARTIAL | NOTEBOOKS_SIRA_REVIEWER_CHECKLIST_MD | N397 | has_attribute |
| N404 | Attribute | Gap_Flag | OPERATOR_DEPENDENT | NOTEBOOKS_SIRA_REVIEWER_CHECKLIST_MD | N397 | has_attribute |
| N405 | Attribute | Notes | Section 8 contains operator-owned evidence requirements outside repository boundary. | NOTEBOOKS_SIRA_REVIEWER_CHECKLIST_MD | N397 | has_attribute |
| N406 | Control | SIRA_Component | LICENSE | LICENSE |  | references |
| N407 | Attribute | SIRA_Component | LICENSE | LICENSE | N406 | has_attribute |
| N408 | Attribute | Control_Framework | Apache 2.0 | LICENSE | N406 | maps_to |
| N409 | Attribute | Control_Reference | Copyright and redistribution | LICENSE | N406 | has_attribute |
| N410 | Attribute | Control_Description | Standard Apache License 2.0 terms at repository root | LICENSE | N406 | has_attribute |
| N411 | Attribute | Evidence_Type | License document | LICENSE | N406 | has_attribute |
| N412 | Attribute | Coverage_Assessment | FULL | LICENSE | N406 | has_attribute |
| N413 | Attribute | Gap_Flag | NO | LICENSE | N406 | has_attribute |
| N414 | Attribute | Notes | License instrument governing redistribution and derivative rights. | LICENSE | N406 | has_attribute |
| N415 | Control | SIRA_Component | NOTICE | NOTICE |  | references |
| N416 | Attribute | SIRA_Component | NOTICE | NOTICE | N415 | has_attribute |
| N417 | Attribute | Control_Framework | Apache 2.0 | NOTICE | N415 | maps_to |
| N418 | Attribute | Control_Reference | Attribution notice | NOTICE | N415 | has_attribute |
| N419 | Attribute | Control_Description | Repository root NOTICE file for required attribution carriage | NOTICE | N415 | has_attribute |
| N420 | Attribute | Evidence_Type | Notice document | NOTICE | N415 | has_attribute |
| N421 | Attribute | Coverage_Assessment | FULL | NOTICE | N415 | has_attribute |
| N422 | Attribute | Gap_Flag | NO | NOTICE | N415 | has_attribute |
| N423 | Attribute | Notes | Supports Apache 2.0 Section 4(d) notice handling. | NOTICE | N415 | has_attribute |
| N424 | Control | SIRA_Component | notebooks/DISCLAIMER.md | NOTEBOOKS_DISCLAIMER_MD |  | references |
| N425 | Attribute | SIRA_Component | notebooks/DISCLAIMER.md | NOTEBOOKS_DISCLAIMER_MD | N424 | has_attribute |
| N426 | Attribute | Control_Framework | Intellectual integrity | NOTEBOOKS_DISCLAIMER_MD | N424 | maps_to |
| N427 | Attribute | Control_Reference | Academic use boundary | NOTEBOOKS_DISCLAIMER_MD | N424 | has_attribute |
| N428 | Attribute | Control_Description | Protective academic-use boundary and scope guidance for notebook literature suite | NOTEBOOKS_DISCLAIMER_MD | N424 | has_attribute |
| N429 | Attribute | Evidence_Type | Disclaimer document | NOTEBOOKS_DISCLAIMER_MD | N424 | has_attribute |
| N430 | Attribute | Coverage_Assessment | FULL | NOTEBOOKS_DISCLAIMER_MD | N424 | has_attribute |
| N431 | Attribute | Gap_Flag | NO | NOTEBOOKS_DISCLAIMER_MD | N424 | has_attribute |
| N432 | Attribute | Notes | Disclaimer is distinct from license terms and does not modify Apache 2.0. | NOTEBOOKS_DISCLAIMER_MD | N424 | has_attribute |
| N433 | Control | SIRA_Component | notebooks/NOTICE_BLOCK.md | NOTEBOOKS_NOTICE_BLOCK_MD |  | references |
| N434 | Attribute | SIRA_Component | notebooks/NOTICE_BLOCK.md | NOTEBOOKS_NOTICE_BLOCK_MD | N433 | has_attribute |
| N435 | Attribute | Control_Framework | Configuration management | NOTEBOOKS_NOTICE_BLOCK_MD | N433 | maps_to |
| N436 | Attribute | Control_Reference | Notice block canonical source | NOTEBOOKS_NOTICE_BLOCK_MD | N433 | has_attribute |
| N437 | Attribute | Control_Description | Single-source canonical notice block with propagation procedure | NOTEBOOKS_NOTICE_BLOCK_MD | N433 | has_attribute |
| N438 | Attribute | Evidence_Type | Canonical notice reference | NOTEBOOKS_NOTICE_BLOCK_MD | N433 | has_attribute |
| N439 | Attribute | Coverage_Assessment | FULL | NOTEBOOKS_NOTICE_BLOCK_MD | N433 | has_attribute |
| N440 | Attribute | Gap_Flag | NO | NOTEBOOKS_NOTICE_BLOCK_MD | N433 | has_attribute |
| N441 | Attribute | Notes | Defines maintenance sequence to prevent notice text drift. | NOTEBOOKS_NOTICE_BLOCK_MD | N433 | has_attribute |
| N442 | Control | SIRA_Component | docs/ETHOS.md | DOCS_ETHOS_MD |  | references |
| N443 | Attribute | SIRA_Component | docs/ETHOS.md | DOCS_ETHOS_MD | N442 | has_attribute |
| N444 | Attribute | Control_Framework | ISM | DOCS_ETHOS_MD | N442 | maps_to |
| N445 | Attribute | Control_Reference | Architecture-level hardening declaration | DOCS_ETHOS_MD | N442 | has_attribute |
| N446 | Attribute | Control_Description | Architecture-level hardening declaration codified as the governing operating model for the IĀTŌ stack | DOCS_ETHOS_MD | N442 | has_attribute |
| N447 | Attribute | Evidence_Type | Governance document | DOCS_ETHOS_MD | N442 | has_attribute |
| N448 | Attribute | Coverage_Assessment | FULL | DOCS_ETHOS_MD | N442 | has_attribute |
| N449 | Attribute | Gap_Flag | NO | DOCS_ETHOS_MD | N442 | has_attribute |
| N450 | Attribute | Notes | Primary architectural control declaration | DOCS_ETHOS_MD | N442 | has_attribute |
| N451 | Control | SIRA_Component | docs/ETHOS.md | DOCS_ETHOS_MD |  | references |
| N452 | Attribute | SIRA_Component | docs/ETHOS.md | DOCS_ETHOS_MD | N451 | has_attribute |
| N453 | Attribute | Control_Framework | Essential Eight ML4 | DOCS_ETHOS_MD | N451 | maps_to |
| N454 | Attribute | Control_Reference | Operating model declaration | DOCS_ETHOS_MD | N451 | has_attribute |
| N455 | Attribute | Control_Description | Operating model declaration maps stack-level execution constraints to E8 ML4 hardening posture | DOCS_ETHOS_MD | N451 | has_attribute |
| N456 | Attribute | Evidence_Type | Governance document | DOCS_ETHOS_MD | N451 | has_attribute |
| N457 | Attribute | Coverage_Assessment | FULL | DOCS_ETHOS_MD | N451 | has_attribute |
| N458 | Attribute | Gap_Flag | NO | DOCS_ETHOS_MD | N451 | has_attribute |
| N459 | Attribute | Notes | Primary operating model declaration | DOCS_ETHOS_MD | N451 | has_attribute |
| N460 | Control | SIRA_Component | docs/DELIVERY.md | DOCS_DELIVERY_MD |  | references |
| N461 | Attribute | SIRA_Component | docs/DELIVERY.md | DOCS_DELIVERY_MD | N460 | has_attribute |
| N462 | Attribute | Control_Framework | SOC 2 | DOCS_DELIVERY_MD | N460 | maps_to |
| N463 | Attribute | Control_Reference | CC3 Risk assessment and gap analysis | DOCS_DELIVERY_MD | N460 | has_attribute |
| N464 | Attribute | Control_Description | Engagement model defines fixed-scope control gap analysis and exception accountability artefacts | DOCS_DELIVERY_MD | N460 | has_attribute |
| N465 | Attribute | Evidence_Type | Governance document | DOCS_DELIVERY_MD | N460 | has_attribute |
| N466 | Attribute | Coverage_Assessment | FULL | DOCS_DELIVERY_MD | N460 | has_attribute |
| N467 | Attribute | Gap_Flag | NO | DOCS_DELIVERY_MD | N460 | has_attribute |
| N468 | Attribute | Notes | Phase 0 control-gap governance | DOCS_DELIVERY_MD | N460 | has_attribute |
| N469 | Control | SIRA_Component | docs/DELIVERY.md | DOCS_DELIVERY_MD |  | references |
| N470 | Attribute | SIRA_Component | docs/DELIVERY.md | DOCS_DELIVERY_MD | N469 | has_attribute |
| N471 | Attribute | Control_Framework | ISM | DOCS_DELIVERY_MD | N469 | maps_to |
| N472 | Attribute | Control_Reference | Evidence artefact production | DOCS_DELIVERY_MD | N469 | has_attribute |
| N473 | Attribute | Control_Description | Delivery framework specifies required evidence artefacts and custody model for control closure verification | DOCS_DELIVERY_MD | N469 | has_attribute |
| N474 | Attribute | Evidence_Type | Governance document | DOCS_DELIVERY_MD | N469 | has_attribute |
| N475 | Attribute | Coverage_Assessment | FULL | DOCS_DELIVERY_MD | N469 | has_attribute |
| N476 | Attribute | Gap_Flag | NO | DOCS_DELIVERY_MD | N469 | has_attribute |
| N477 | Attribute | Notes | Evidence pack production control | DOCS_DELIVERY_MD | N469 | has_attribute |
| N478 | Control | SIRA_Component | docs/DELIVERY.md | DOCS_DELIVERY_MD |  | references |
| N479 | Attribute | SIRA_Component | docs/DELIVERY.md | DOCS_DELIVERY_MD | N478 | has_attribute |
| N480 | Attribute | Control_Framework | Essential Eight ML4 | DOCS_DELIVERY_MD | N478 | maps_to |
| N481 | Attribute | Control_Reference | Audit logging evidence mapping | DOCS_DELIVERY_MD | N478 | has_attribute |
| N482 | Attribute | Control_Description | Delivery artefact mapping binds MCP session logs to ML4 audit logging objectives | DOCS_DELIVERY_MD | N478 | has_attribute |
| N483 | Attribute | Evidence_Type | Governance document | DOCS_DELIVERY_MD | N478 | has_attribute |
| N484 | Attribute | Coverage_Assessment | FULL | DOCS_DELIVERY_MD | N478 | has_attribute |
| N485 | Attribute | Gap_Flag | NO | DOCS_DELIVERY_MD | N478 | has_attribute |
| N486 | Attribute | Notes | Audit artefact mapping for ML4 | DOCS_DELIVERY_MD | N478 | has_attribute |
| N487 | Control | SIRA_Component | Hyperlink audit (this prompt) | HYPERLINK_AUDIT_THIS_PROMPT |  | references |
| N488 | Attribute | SIRA_Component | Hyperlink audit (this prompt) | HYPERLINK_AUDIT_THIS_PROMPT | N487 | has_attribute |
| N489 | Attribute | Control_Framework | ISM | HYPERLINK_AUDIT_THIS_PROMPT | N487 | maps_to |
| N490 | Attribute | Control_Reference | Documentation integrity | HYPERLINK_AUDIT_THIS_PROMPT | N487 | has_attribute |
| N491 | Attribute | Control_Description | Hyperlink audit confirms referenced governance documents resolve and remain navigable for review continuity | HYPERLINK_AUDIT_THIS_PROMPT | N487 | has_attribute |
| N492 | Attribute | Evidence_Type | Hyperlink audit output | HYPERLINK_AUDIT_THIS_PROMPT | N487 | has_attribute |
| N493 | Attribute | Coverage_Assessment | FULL | HYPERLINK_AUDIT_THIS_PROMPT | N487 | has_attribute |
| N494 | Attribute | Gap_Flag | NO | HYPERLINK_AUDIT_THIS_PROMPT | N487 | has_attribute |
| N495 | Attribute | Notes | Control evidence chain integrity verified at documentation layer | HYPERLINK_AUDIT_THIS_PROMPT | N487 | has_attribute |
| N496 | Control | SIRA_Component | Navigation graph | NAVIGATION_GRAPH |  | references |
| N497 | Attribute | SIRA_Component | Navigation graph | NAVIGATION_GRAPH | N496 | has_attribute |
| N498 | Attribute | Control_Framework | ISM | NAVIGATION_GRAPH | N496 | maps_to |
| N499 | Attribute | Control_Reference | Traceability — primary document chain | NAVIGATION_GRAPH | N496 | has_attribute |
| N500 | Attribute | Control_Description | Navigation graph maps primary document chain to preserve deterministic reviewer traversal and control traceability | NAVIGATION_GRAPH | N496 | has_attribute |
| N501 | Attribute | Evidence_Type | Navigation graph artifact | NAVIGATION_GRAPH | N496 | has_attribute |
| N502 | Attribute | Coverage_Assessment | FULL | NAVIGATION_GRAPH | N496 | has_attribute |
| N503 | Attribute | Gap_Flag | NO | NAVIGATION_GRAPH | N496 | has_attribute |
| N504 | Attribute | Notes | Traceability structure maintained for governance walkthroughs | NAVIGATION_GRAPH | N496 | has_attribute |
