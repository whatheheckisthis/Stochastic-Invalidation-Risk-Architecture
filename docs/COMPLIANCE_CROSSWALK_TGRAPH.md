| Node_ID | Node_Type | Source_Field | Field_Value | Control_Tag | Linked_To | Relationship_Type |
| --- | --- | --- | --- | --- | --- | --- |
| N1 | Control | SIRA_Component | config/sira.toml | Model_Development_Change_Control | - | references |
| N2 | Framework | Control_Framework | SR 11-7 | Model_Development_Change_Control | N1 | references |
| N3 | Mapping | Control_Reference | Model Development-Change Control | Model_Development_Change_Control | N1 | maps_to |
| N4 | Mapping | Control_Description | Centralized declaration of scenario/distribution/signal parameters with controlled updates and reproducible intent register | Model_Development_Change_Control | N1 | maps_to |
| N5 | Evidence | Evidence_Type | Configuration baseline + git history | Model_Development_Change_Control | N1 | evidences |
| N6 | Mapping | Coverage_Assessment | PARTIAL | Model_Development_Change_Control | N1 | supports |
| N7 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Model_Development_Change_Control | N1 | supports |
| N8 | Evidence | Notes | Architecture centralizes parameter control but approval workflow and signatory controls are operator-managed | Model_Development_Change_Control | N1 | supports |
| N9 | Control | SIRA_Component | config/sira.toml | CC8_1_Change_Management | - | references |
| N10 | Framework | Control_Framework | SOC 2 | CC8_1_Change_Management | N9 | references |
| N11 | Mapping | Control_Reference | CC8.1 Change Management | CC8_1_Change_Management | N9 | maps_to |
| N12 | Mapping | Control_Description | Parameter changes are isolated to TOML and can be reviewed as discrete configuration diffs | CC8_1_Change_Management | N9 | maps_to |
| N13 | Evidence | Evidence_Type | Versioned config diff evidence | CC8_1_Change_Management | N9 | evidences |
| N14 | Mapping | Coverage_Assessment | PARTIAL | CC8_1_Change_Management | N9 | supports |
| N15 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | CC8_1_Change_Management | N9 | supports |
| N16 | Evidence | Notes | Supports traceability; formal change authorization requires external process | CC8_1_Change_Management | N9 | supports |
| N17 | Control | SIRA_Component | scripts/00_env_check.R | Application_Control_Patch_Version_Discipline | - | references |
| N18 | Framework | Control_Framework | Essential Eight ML4 | Application_Control_Patch_Version_Discipline | N17 | references |
| N19 | Mapping | Control_Reference | Application Control + Patch/Version Discipline | Application_Control_Patch_Version_Discipline | N17 | maps_to |
| N20 | Mapping | Control_Description | Preflight enforces runtime prerequisites and config parseability before execution to reduce uncontrolled runtime variance | Application_Control_Patch_Version_Discipline | N17 | maps_to |
| N21 | Evidence | Evidence_Type | Pre-execution check logs | Application_Control_Patch_Version_Discipline | N17 | evidences |
| N22 | Mapping | Coverage_Assessment | PARTIAL | Application_Control_Patch_Version_Discipline | N17 | supports |
| N23 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Application_Control_Patch_Version_Discipline | N17 | supports |
| N24 | Evidence | Notes | No centralized endpoint attestation in-repo | Application_Control_Patch_Version_Discipline | N17 | supports |
| N25 | Control | SIRA_Component | scripts/00_env_check.R | ISM_1486_ISM_1544_System_Hardening_and_Verification | - | references |
| N26 | Framework | Control_Framework | ISM | ISM_1486_ISM_1544_System_Hardening_and_Verification | N25 | references |
| N27 | Mapping | Control_Reference | ISM-1486/ISM-1544 (System Hardening and Verification) | ISM_1486_ISM_1544_System_Hardening_and_Verification | N25 | maps_to |
| N28 | Mapping | Control_Description | Environment and dependency validation prior to analytical execution supports controlled operating baseline | ISM_1486_ISM_1544_System_Hardening_and_Verification | N25 | maps_to |
| N29 | Evidence | Evidence_Type | Runtime validation output | ISM_1486_ISM_1544_System_Hardening_and_Verification | N25 | evidences |
| N30 | Mapping | Coverage_Assessment | FULL | ISM_1486_ISM_1544_System_Hardening_and_Verification | N25 | supports |
| N31 | Mapping | Gap_Flag | NO | ISM_1486_ISM_1544_System_Hardening_and_Verification | N25 | supports |
| N32 | Evidence | Notes | Control objective met within local execution boundary | ISM_1486_ISM_1544_System_Hardening_and_Verification | N25 | supports |
| N33 | Control | SIRA_Component | scripts/02_analysis.R (Beta distribution logic) | LGD_Estimation_Governance | - | references |
| N34 | Framework | Control_Framework | Basel III IRB | LGD_Estimation_Governance | N33 | references |
| N35 | Mapping | Control_Reference | LGD Estimation Governance | LGD_Estimation_Governance | N33 | maps_to |
| N36 | Mapping | Control_Description | Bounded recovery modelling with scenario-specific Beta parameters provides stress-LGD proxy inputs without IRB equivalence claim | LGD_Estimation_Governance | N33 | maps_to |
| N37 | Evidence | Evidence_Type | Model logic review + scenario output evidence | LGD_Estimation_Governance | N33 | evidences |
| N38 | Mapping | Coverage_Assessment | DECLARED_LIMITATION | LGD_Estimation_Governance | N33 | supports |
| N39 | Mapping | Gap_Flag | NO | LGD_Estimation_Governance | N33 | supports |
| N40 | Evidence | Notes | Explicit non-goal prevents misclassification as IRB capital model | LGD_Estimation_Governance | N33 | supports |
| N41 | Control | SIRA_Component | scripts/02_analysis.R (Beta distribution logic) | Outcomes_Analysis_and_Ongoing_Monitoring | - | references |
| N42 | Framework | Control_Framework | SR 11-7 | Outcomes_Analysis_and_Ongoing_Monitoring | N41 | references |
| N43 | Mapping | Control_Reference | Outcomes Analysis and Ongoing Monitoring | Outcomes_Analysis_and_Ongoing_Monitoring | N41 | maps_to |
| N44 | Mapping | Control_Description | Beta parameterized stress engine is deterministic under CFG runtime seed and auditable at run level | Outcomes_Analysis_and_Ongoing_Monitoring | N41 | maps_to |
| N45 | Evidence | Evidence_Type | Reproducible run logs + seeded outputs | Outcomes_Analysis_and_Ongoing_Monitoring | N41 | evidences |
| N46 | Mapping | Coverage_Assessment | PARTIAL | Outcomes_Analysis_and_Ongoing_Monitoring | N41 | supports |
| N47 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Outcomes_Analysis_and_Ongoing_Monitoring | N41 | supports |
| N48 | Evidence | Notes | Formal validation testing and challenger benchmarking not yet codified | Outcomes_Analysis_and_Ongoing_Monitoring | N41 | supports |
| N49 | Control | SIRA_Component | scripts/02_analysis.R (Power Law logic) | Stress_Calibration_and_Tail_Risk_Capture | - | references |
| N50 | Framework | Control_Framework | FRTB Article 325 | Stress_Calibration_and_Tail_Risk_Capture | N49 | references |
| N51 | Mapping | Control_Reference | Stress Calibration and Tail Risk Capture | Stress_Calibration_and_Tail_Risk_Capture | N49 | maps_to |
| N52 | Mapping | Control_Description | Power-law tail construction addresses non-linear jump risk under counterparty and hyperinflation scenarios | Stress_Calibration_and_Tail_Risk_Capture | N49 | maps_to |
| N53 | Evidence | Evidence_Type | Scenario tail-behaviour evidence | Stress_Calibration_and_Tail_Risk_Capture | N49 | evidences |
| N54 | Mapping | Coverage_Assessment | PARTIAL | Stress_Calibration_and_Tail_Risk_Capture | N49 | supports |
| N55 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Stress_Calibration_and_Tail_Risk_Capture | N49 | supports |
| N56 | Evidence | Notes | Requires operator-owned empirical calibration justification | Stress_Calibration_and_Tail_Risk_Capture | N49 | supports |
| N57 | Control | SIRA_Component | scripts/03_visualize.R output | Accuracy_and_Integrity_of_Risk_Data_Aggregation | - | references |
| N58 | Framework | Control_Framework | BCBS 239 Principle 6 | Accuracy_and_Integrity_of_Risk_Data_Aggregation | N57 | references |
| N59 | Mapping | Control_Reference | Accuracy and Integrity of Risk Data Aggregation | Accuracy_and_Integrity_of_Risk_Data_Aggregation | N57 | maps_to |
| N60 | Mapping | Control_Description | Risk signal aggregation by scenario with deterministic ordering and standardized summary table generation | Accuracy_and_Integrity_of_Risk_Data_Aggregation | N57 | maps_to |
| N61 | Evidence | Evidence_Type | Generated chart + terminal summary table | Accuracy_and_Integrity_of_Risk_Data_Aggregation | N57 | evidences |
| N62 | Mapping | Coverage_Assessment | FULL | Accuracy_and_Integrity_of_Risk_Data_Aggregation | N57 | supports |
| N63 | Mapping | Gap_Flag | NO | Accuracy_and_Integrity_of_Risk_Data_Aggregation | N57 | supports |
| N64 | Evidence | Notes | Output integrity is machine reproducible from identical inputs and seed | Accuracy_and_Integrity_of_Risk_Data_Aggregation | N57 | supports |
| N65 | Control | SIRA_Component | run_all.R orchestration | CC7_2_Monitoring_and_Exception_Handling | - | references |
| N66 | Framework | Control_Framework | SOC 2 | CC7_2_Monitoring_and_Exception_Handling | N65 | references |
| N67 | Mapping | Control_Reference | CC7.2 Monitoring and Exception Handling | CC7_2_Monitoring_and_Exception_Handling | N65 | maps_to |
| N68 | Mapping | Control_Description | Ordered stage execution with fail-fast error handling and explicit success/failure runtime emission | CC7_2_Monitoring_and_Exception_Handling | N65 | maps_to |
| N69 | Evidence | Evidence_Type | Pipeline execution logs | CC7_2_Monitoring_and_Exception_Handling | N65 | evidences |
| N70 | Mapping | Coverage_Assessment | FULL | CC7_2_Monitoring_and_Exception_Handling | N65 | supports |
| N71 | Mapping | Gap_Flag | NO | CC7_2_Monitoring_and_Exception_Handling | N65 | supports |
| N72 | Evidence | Notes | Meets pipeline integrity objective for local batch execution | CC7_2_Monitoring_and_Exception_Handling | N65 | supports |
| N73 | Control | SIRA_Component | Synthetic fallback (deterministic seed) | Input_Data_Integrity_and_Lineage_Disclosure | - | references |
| N74 | Framework | Control_Framework | BCBS 239 Principle 6 | Input_Data_Integrity_and_Lineage_Disclosure | N73 | references |
| N75 | Mapping | Control_Reference | Input Data Integrity and Lineage Disclosure | Input_Data_Integrity_and_Lineage_Disclosure | N73 | maps_to |
| N76 | Mapping | Control_Description | Deterministic synthetic fallback ensures continuity while preserving explicit data mode metadata for lineage visibility | Input_Data_Integrity_and_Lineage_Disclosure | N73 | maps_to |
| N77 | Evidence | Evidence_Type | Metadata record + runtime data mode output | Input_Data_Integrity_and_Lineage_Disclosure | N73 | evidences |
| N78 | Mapping | Coverage_Assessment | FULL | Input_Data_Integrity_and_Lineage_Disclosure | N73 | supports |
| N79 | Mapping | Gap_Flag | NO | Input_Data_Integrity_and_Lineage_Disclosure | N73 | supports |
| N80 | Evidence | Notes | Governed manifest, lineage, and hash controls prevent silent synthetic fallback for live data conditions within repository boundary | Input_Data_Integrity_and_Lineage_Disclosure | N73 | supports |
| N81 | Control | SIRA_Component | SELL/HOLD signal output | Use_Test_and_Governance_Boundary | - | references |
| N82 | Framework | Control_Framework | Basel III IRB | Use_Test_and_Governance_Boundary | N81 | references |
| N83 | Mapping | Control_Reference | Use Test and Governance Boundary | Use_Test_and_Governance_Boundary | N81 | maps_to |
| N84 | Mapping | Control_Description | Signal is pre-trade analytical triage output and not an automated execution or regulatory capital decision engine | Use_Test_and_Governance_Boundary | N81 | maps_to |
| N85 | Evidence | Evidence_Type | Signal logic + non-goals register | Use_Test_and_Governance_Boundary | N81 | evidences |
| N86 | Mapping | Coverage_Assessment | DECLARED_LIMITATION | Use_Test_and_Governance_Boundary | N81 | supports |
| N87 | Mapping | Gap_Flag | NO | Use_Test_and_Governance_Boundary | N81 | supports |
| N88 | Evidence | Notes | Must remain subordinate to instrument-level credit analysis and policy controls | Use_Test_and_Governance_Boundary | N81 | supports |
| N89 | Control | SIRA_Component | Non-goals register | Model_Boundary_and_Intended_Use_Documentation | - | references |
| N90 | Framework | Control_Framework | SR 11-7 | Model_Boundary_and_Intended_Use_Documentation | N89 | references |
| N91 | Mapping | Control_Reference | Model Boundary and Intended Use Documentation | Model_Boundary_and_Intended_Use_Documentation | N89 | maps_to |
| N92 | Mapping | Control_Description | Explicit documentation of non-claims constrains misuse and supports inventory classification and governance review | Model_Boundary_and_Intended_Use_Documentation | N89 | maps_to |
| N93 | Evidence | Evidence_Type | README non-goals section | Model_Boundary_and_Intended_Use_Documentation | N89 | evidences |
| N94 | Mapping | Coverage_Assessment | FULL | Model_Boundary_and_Intended_Use_Documentation | N89 | supports |
| N95 | Mapping | Gap_Flag | NO | Model_Boundary_and_Intended_Use_Documentation | N89 | supports |
| N96 | Evidence | Notes | Provides enforceable boundary conditions for model risk committees | Model_Boundary_and_Intended_Use_Documentation | N89 | supports |
| N97 | Control | SIRA_Component | Air-gap compatibility | Operational_Resilience_Recovery_Preparedness | - | references |
| N98 | Framework | Control_Framework | Essential Eight ML4 | Operational_Resilience_Recovery_Preparedness | N97 | references |
| N99 | Mapping | Control_Reference | Operational Resilience/Recovery Preparedness | Operational_Resilience_Recovery_Preparedness | N97 | maps_to |
| N100 | Mapping | Control_Description | No external network dependency at runtime supports continuity in disconnected environments | Operational_Resilience_Recovery_Preparedness | N97 | maps_to |
| N101 | Evidence | Evidence_Type | Runtime dependency manifest + offline execution evidence | Operational_Resilience_Recovery_Preparedness | N97 | evidences |
| N102 | Mapping | Coverage_Assessment | PARTIAL | Operational_Resilience_Recovery_Preparedness | N97 | supports |
| N103 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Operational_Resilience_Recovery_Preparedness | N97 | supports |
| N104 | Evidence | Notes | Validated runtime manifest custody and release governance are external | Operational_Resilience_Recovery_Preparedness | N97 | supports |
| N105 | Control | SIRA_Component | Air-gap compatibility | ISM_0604_ISM_1148_Network_Isolation_and_Continuity | - | references |
| N106 | Framework | Control_Framework | ISM | ISM_0604_ISM_1148_Network_Isolation_and_Continuity | N105 | references |
| N107 | Mapping | Control_Reference | ISM-0604/ISM-1148 (Network Isolation and Continuity) | ISM_0604_ISM_1148_Network_Isolation_and_Continuity | N105 | maps_to |
| N108 | Mapping | Control_Description | Terminal-native offline operation aligns with isolated environment execution requirements | ISM_0604_ISM_1148_Network_Isolation_and_Continuity | N105 | maps_to |
| N109 | Evidence | Evidence_Type | Offline run evidence | ISM_0604_ISM_1148_Network_Isolation_and_Continuity | N105 | evidences |
| N110 | Mapping | Coverage_Assessment | PARTIAL | ISM_0604_ISM_1148_Network_Isolation_and_Continuity | N105 | supports |
| N111 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | ISM_0604_ISM_1148_Network_Isolation_and_Continuity | N105 | supports |
| N112 | Evidence | Notes | Control satisfaction depends on operator enclave configuration | ISM_0604_ISM_1148_Network_Isolation_and_Continuity | N105 | supports |
| N113 | Control | SIRA_Component | run_all.R orchestration | CC6_6_Logical_and_Procedural_Access_to_Change_Execution | - | references |
| N114 | Framework | Control_Framework | SOC 2 | CC6_6_Logical_and_Procedural_Access_to_Change_Execution | N113 | references |
| N115 | Mapping | Control_Reference | CC6.6 Logical and Procedural Access to Change Execution | CC6_6_Logical_and_Procedural_Access_to_Change_Execution | N113 | maps_to |
| N116 | Mapping | Control_Description | Single entry-point run orchestration limits ad hoc stage bypass and supports controlled execution path | CC6_6_Logical_and_Procedural_Access_to_Change_Execution | N113 | maps_to |
| N117 | Evidence | Evidence_Type | Entrypoint script + invocation records | CC6_6_Logical_and_Procedural_Access_to_Change_Execution | N113 | evidences |
| N118 | Mapping | Coverage_Assessment | PARTIAL | CC6_6_Logical_and_Procedural_Access_to_Change_Execution | N113 | supports |
| N119 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | CC6_6_Logical_and_Procedural_Access_to_Change_Execution | N113 | supports |
| N120 | Evidence | Notes | Access controls around execution host are outside repository scope | CC6_6_Logical_and_Procedural_Access_to_Change_Execution | N113 | supports |
| N121 | Control | SIRA_Component | scripts/02_analysis.R (Power Law logic) | Non_Modellable_Risk_Factor_Stress_Capture | - | references |
| N122 | Framework | Control_Framework | FRTB Article 325 | Non_Modellable_Risk_Factor_Stress_Capture | N121 | references |
| N123 | Mapping | Control_Reference | Non-Modellable Risk Factor Stress Capture | Non_Modellable_Risk_Factor_Stress_Capture | N121 | maps_to |
| N124 | Mapping | Control_Description | Jump-risk oriented stress regime supports severe tail scenario evaluation where linear assumptions understate risk | Non_Modellable_Risk_Factor_Stress_Capture | N121 | maps_to |
| N125 | Evidence | Evidence_Type | Scenario-level signal and ruin-flag outputs | Non_Modellable_Risk_Factor_Stress_Capture | N121 | evidences |
| N126 | Mapping | Coverage_Assessment | PARTIAL | Non_Modellable_Risk_Factor_Stress_Capture | N121 | supports |
| N127 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Non_Modellable_Risk_Factor_Stress_Capture | N121 | supports |
| N128 | Evidence | Notes | Formal linkage to desk-level FRTB governance requires operator framework mapping | Non_Modellable_Risk_Factor_Stress_Capture | N121 | supports |
| N129 | Control | SIRA_Component | scripts/10_liability_engine.R | Assumption_Governance_and_Liability_Boundary_Control | - | references |
| N130 | Framework | Control_Framework | SR 11-7 | Assumption_Governance_and_Liability_Boundary_Control | N129 | references |
| N131 | Mapping | Control_Reference | Assumption Governance and Liability Boundary Control | Assumption_Governance_and_Liability_Boundary_Control | N129 | maps_to |
| N132 | Mapping | Control_Description | Liability stack assumptions are TOML-governed and explicitly stress-adjusted under hyperinflation to surface headroom breach risk | Assumption_Governance_and_Liability_Boundary_Control | N129 | maps_to |
| N133 | Evidence | Evidence_Type | Config diffs + deterministic run output | Assumption_Governance_and_Liability_Boundary_Control | N129 | evidences |
| N134 | Mapping | Coverage_Assessment | PARTIAL | Assumption_Governance_and_Liability_Boundary_Control | N129 | supports |
| N135 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Assumption_Governance_and_Liability_Boundary_Control | N129 | supports |
| N136 | Evidence | Notes | Requires documented owner and approval process for payout-rate and inflation assumptions | Assumption_Governance_and_Liability_Boundary_Control | N129 | supports |
| N137 | Control | SIRA_Component | scripts/11_credit_deployment.R | Income_vs_Loss_Stress_Transparency | - | references |
| N138 | Framework | Control_Framework | Basel III IRB | Income_vs_Loss_Stress_Transparency | N137 | references |
| N139 | Mapping | Control_Reference | Income-vs-Loss Stress Transparency | Income_vs_Loss_Stress_Transparency | N137 | maps_to |
| N140 | Mapping | Control_Description | Spread engine computes gross and default-adjusted net income with scenario LGD proxy linkage while preserving non-IRB positioning | Income_vs_Loss_Stress_Transparency | N137 | maps_to |
| N141 | Evidence | Evidence_Type | Scenario-level spread output + seeded reproducibility evidence | Income_vs_Loss_Stress_Transparency | N137 | evidences |
| N142 | Mapping | Coverage_Assessment | DECLARED_LIMITATION | Income_vs_Loss_Stress_Transparency | N137 | supports |
| N143 | Mapping | Gap_Flag | NO | Income_vs_Loss_Stress_Transparency | N137 | supports |
| N144 | Evidence | Notes | Analytical stress layer only and not insurer/regulatory capital output | Income_vs_Loss_Stress_Transparency | N137 | supports |
| N145 | Control | SIRA_Component | scripts/12_spread_stress.R | Risk_Aggregation_and_State_Classification_Integrity | - | references |
| N146 | Framework | Control_Framework | BCBS 239 Principle 6 | Risk_Aggregation_and_State_Classification_Integrity | N145 | references |
| N147 | Mapping | Control_Reference | Risk Aggregation and State Classification Integrity | Risk_Aggregation_and_State_Classification_Integrity | N145 | maps_to |
| N148 | Mapping | Control_Description | Cross-scenario aggregation emits deterministic SOLVENT/WATCH/BREACH states with worst-case identification and headroom summaries | Risk_Aggregation_and_State_Classification_Integrity | N145 | maps_to |
| N149 | Evidence | Evidence_Type | Machine-generated aggregate table + metadata artifact | Risk_Aggregation_and_State_Classification_Integrity | N145 | evidences |
| N150 | Mapping | Coverage_Assessment | FULL | Risk_Aggregation_and_State_Classification_Integrity | N145 | supports |
| N151 | Mapping | Gap_Flag | NO | Risk_Aggregation_and_State_Classification_Integrity | N145 | supports |
| N152 | Evidence | Notes | Aggregation logic and signal counts are reproducible from fixed config+seed | Risk_Aggregation_and_State_Classification_Integrity | N145 | supports |
| N153 | Control | SIRA_Component | scripts/13_capital_stack_viz.R | CC7_2_Monitoring_and_Exception_Visibility | - | references |
| N154 | Framework | Control_Framework | SOC 2 | CC7_2_Monitoring_and_Exception_Visibility | N153 | references |
| N155 | Mapping | Control_Reference | CC7.2 Monitoring and Exception Visibility | CC7_2_Monitoring_and_Exception_Visibility | N153 | maps_to |
| N156 | Mapping | Control_Description | Terminal-native capital stack summary and color-coded chart provide consistent scenario-level operational visibility for escalation decisions | CC7_2_Monitoring_and_Exception_Visibility | N153 | maps_to |
| N157 | Evidence | Evidence_Type | Terminal summary + output artifacts | CC7_2_Monitoring_and_Exception_Visibility | N153 | evidences |
| N158 | Mapping | Coverage_Assessment | PARTIAL | CC7_2_Monitoring_and_Exception_Visibility | N153 | supports |
| N159 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | CC7_2_Monitoring_and_Exception_Visibility | N153 | supports |
| N160 | Evidence | Notes | Escalation ownership and notification workflow remain external governance controls | CC7_2_Monitoring_and_Exception_Visibility | N153 | supports |
| N161 | Control | SIRA_Component | data/manifest/data_manifest.toml | Data_Architecture_and_Infrastructure | - | references |
| N162 | Framework | Control_Framework | BCBS 239 Principle 2 | Data_Architecture_and_Infrastructure | N161 | references |
| N163 | Mapping | Control_Reference | Data Architecture and Infrastructure | Data_Architecture_and_Infrastructure | N161 | maps_to |
| N164 | Mapping | Control_Description | Manifest establishes controlled, versioned dataset registry with mode segregation and approval fields for governed ingestion. | Data_Architecture_and_Infrastructure | N161 | maps_to |
| N165 | Evidence | Evidence_Type | Versioned manifest artifact + preflight summary logs | Data_Architecture_and_Infrastructure | N161 | evidences |
| N166 | Mapping | Coverage_Assessment | FULL | Data_Architecture_and_Infrastructure | N161 | supports |
| N167 | Mapping | Gap_Flag | NO | Data_Architecture_and_Infrastructure | N161 | supports |
| N168 | Evidence | Notes | Repository-embedded data architecture control implemented. | Data_Architecture_and_Infrastructure | N161 | supports |
| N169 | Control | SIRA_Component | data/lineage/*.toml | Accuracy_and_Integrity | - | references |
| N170 | Framework | Control_Framework | BCBS 239 Principle 3 | Accuracy_and_Integrity | N169 | references |
| N171 | Mapping | Control_Reference | Accuracy and Integrity | Accuracy_and_Integrity | N169 | maps_to |
| N172 | Mapping | Control_Description | Per-file lineage records capture dataset origin, generation method, schema version, and approval lifecycle metadata. | Accuracy_and_Integrity | N169 | maps_to |
| N173 | Evidence | Evidence_Type | Lineage TOML records + manifest linkage | Accuracy_and_Integrity | N169 | evidences |
| N174 | Mapping | Coverage_Assessment | FULL | Accuracy_and_Integrity | N169 | supports |
| N175 | Mapping | Gap_Flag | NO | Accuracy_and_Integrity | N169 | supports |
| N176 | Evidence | Notes | Lineage integrity controls enforced for governed datasets. | Accuracy_and_Integrity | N169 | supports |
| N177 | Control | SIRA_Component | scripts/00_env_check.R (SHA-256 verification) | Integrity_Verification_Controls | - | references |
| N178 | Framework | Control_Framework | ISM | Integrity_Verification_Controls | N177 | references |
| N179 | Mapping | Control_Reference | Integrity Verification Controls | Integrity_Verification_Controls | N177 | maps_to |
| N180 | Mapping | Control_Description | Preflight recomputes SHA-256 for active manifest datasets and halts on live hash failure to prevent unverified ingestion. | Integrity_Verification_Controls | N177 | maps_to |
| N181 | Evidence | Evidence_Type | Preflight hash verification output | Integrity_Verification_Controls | N177 | evidences |
| N182 | Mapping | Coverage_Assessment | FULL | Integrity_Verification_Controls | N177 | supports |
| N183 | Mapping | Gap_Flag | NO | Integrity_Verification_Controls | N177 | supports |
| N184 | Evidence | Notes | Integrity verification embedded in runtime gate. | Integrity_Verification_Controls | N177 | supports |
| N185 | Control | SIRA_Component | scripts/20_dcf.R | Outcomes_Analysis | - | references |
| N186 | Framework | Control_Framework | SR 11-7 | Outcomes_Analysis | N185 | references |
| N187 | Mapping | Control_Reference | Outcomes Analysis | Outcomes_Analysis | N185 | maps_to |
| N188 | Mapping | Control_Description | Stress-conditioned DCF engine links scenario recoveries to valuation erosion and impairment signaling for model outcomes analysis | Outcomes_Analysis | N185 | maps_to |
| N189 | Evidence | Evidence_Type | Scenario valuation output + impairment signal evidence | Outcomes_Analysis | N185 | evidences |
| N190 | Mapping | Coverage_Assessment | PARTIAL | Outcomes_Analysis | N185 | supports |
| N191 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Outcomes_Analysis | N185 | supports |
| N192 | Evidence | Notes | Threshold ownership and validation cadence require committee governance | Outcomes_Analysis | N185 | supports |
| N193 | Control | SIRA_Component | scripts/21_ma.R | CC3_Risk_Assessment | - | references |
| N194 | Framework | Control_Framework | SOC 2 | CC3_Risk_Assessment | N193 | references |
| N195 | Mapping | Control_Reference | CC3 Risk Assessment | CC3_Risk_Assessment | N193 | maps_to |
| N196 | Mapping | Control_Description | M&A screen formalizes acquisition decision thresholds under stress and captures review/pass triggers for near-threshold outcomes | CC3_Risk_Assessment | N193 | maps_to |
| N197 | Evidence | Evidence_Type | Scenario screening output + threshold config evidence | CC3_Risk_Assessment | N193 | evidences |
| N198 | Mapping | Coverage_Assessment | PARTIAL | CC3_Risk_Assessment | N193 | supports |
| N199 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | CC3_Risk_Assessment | N193 | supports |
| N200 | Evidence | Notes | Acquisition override workflow and approvals remain operator-managed | CC3_Risk_Assessment | N193 | supports |
| N201 | Control | SIRA_Component | scripts/23_lbo.R | Leverage_Stress_and_Tail_Resilience | - | references |
| N202 | Framework | Control_Framework | FRTB Article 325 | Leverage_Stress_and_Tail_Resilience | N201 | references |
| N203 | Mapping | Control_Reference | Leverage Stress and Tail Resilience | Leverage_Stress_and_Tail_Resilience | N201 | maps_to |
| N204 | Mapping | Control_Description | LBO stress module evaluates DSCR and stressed IRR viability under scenario-conditioned exit values to expose leverage fragility | Leverage_Stress_and_Tail_Resilience | N201 | maps_to |
| N205 | Evidence | Evidence_Type | Scenario DSCR/IRR output + viability states | Leverage_Stress_and_Tail_Resilience | N201 | evidences |
| N206 | Mapping | Coverage_Assessment | PARTIAL | Leverage_Stress_and_Tail_Resilience | N201 | supports |
| N207 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Leverage_Stress_and_Tail_Resilience | N201 | supports |
| N208 | Evidence | Notes | Calibration linkage to desk governance and leverage policy remains external | Leverage_Stress_and_Tail_Resilience | N201 | supports |
| N209 | Control | SIRA_Component | scripts/24_irr.R | Ongoing_Monitoring | - | references |
| N210 | Framework | Control_Framework | SR 11-7 | Ongoing_Monitoring | N209 | references |
| N211 | Mapping | Control_Reference | Ongoing Monitoring | Ongoing_Monitoring | N209 | maps_to |
| N212 | Mapping | Control_Description | IRR attribution module decomposes return drivers and recomputes stressed IRR per scenario for monitoring against floor and target thresholds | Ongoing_Monitoring | N209 | maps_to |
| N213 | Evidence | Evidence_Type | IRR attribution artifacts + stressed signal evidence | Ongoing_Monitoring | N209 | evidences |
| N214 | Mapping | Coverage_Assessment | PARTIAL | Ongoing_Monitoring | N209 | supports |
| N215 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Ongoing_Monitoring | N209 | supports |
| N216 | Evidence | Notes | Target/floor governance and monitoring escalation remain external | Ongoing_Monitoring | N209 | supports |
| N217 | Control | SIRA_Component | scripts/25_deal_summary.R | Output_Integrity_and_Aggregation_Consistency | - | references |
| N218 | Framework | Control_Framework | BCBS 239 Principle 6 | Output_Integrity_and_Aggregation_Consistency | N217 | references |
| N219 | Mapping | Control_Reference | Output Integrity and Aggregation Consistency | Output_Integrity_and_Aggregation_Consistency | N217 | maps_to |
| N220 | Mapping | Control_Description | Deal intelligence aggregator consolidates lens outputs and capital stack signals into deterministic committee summaries with worst-case identification | Output_Integrity_and_Aggregation_Consistency | N217 | maps_to |
| N221 | Evidence | Evidence_Type | Consolidated summary artifact + metadata record | Output_Integrity_and_Aggregation_Consistency | N217 | evidences |
| N222 | Mapping | Coverage_Assessment | FULL | Output_Integrity_and_Aggregation_Consistency | N217 | supports |
| N223 | Mapping | Gap_Flag | NO | Output_Integrity_and_Aggregation_Consistency | N217 | supports |
| N224 | Evidence | Notes | Unified output integrity is reproducible from governed inputs and fixed seed | Output_Integrity_and_Aggregation_Consistency | N217 | supports |
| N225 | Control | SIRA_Component | scripts/30_bs_core.R | Conceptual_Soundness | - | references |
| N226 | Framework | Control_Framework | SR 11-7 | Conceptual_Soundness | N225 | references |
| N227 | Mapping | Control_Reference | Conceptual Soundness | Conceptual_Soundness | N225 | maps_to |
| N228 | Mapping | Control_Description | Derivation and runtime implementation are documented from replicating-portfolio PDE basis with explicit risk-neutral drift elimination | Conceptual_Soundness | N225 | maps_to |
| N229 | Evidence | Evidence_Type | Script header + preflight halt artifact | Conceptual_Soundness | N225 | evidences |
| N230 | Mapping | Coverage_Assessment | FULL | Conceptual_Soundness | N225 | supports |
| N231 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Conceptual_Soundness | N225 | supports |
| N232 | Evidence | Notes | Empirical volatility calibration remains operator owned | Conceptual_Soundness | N225 | supports |
| N233 | Control | SIRA_Component | scripts/30b_greeks.R | Ongoing_Monitoring | - | references |
| N234 | Framework | Control_Framework | SR 11-7 | Ongoing_Monitoring | N233 | references |
| N235 | Mapping | Control_Reference | Ongoing Monitoring | Ongoing_Monitoring | N233 | maps_to |
| N236 | Mapping | Control_Description | Analytical Greeks and delta-gamma-vega scenario decomposition provide continuous sensitivity monitoring and explainability | Ongoing_Monitoring | N233 | maps_to |
| N237 | Evidence | Evidence_Type | Greeks output table | Ongoing_Monitoring | N233 | evidences |
| N238 | Mapping | Coverage_Assessment | FULL | Ongoing_Monitoring | N233 | supports |
| N239 | Mapping | Gap_Flag | NO | Ongoing_Monitoring | N233 | supports |
| N240 | Evidence | Notes | Closed-form Greeks are analytical and calibration-independent | Ongoing_Monitoring | N233 | supports |
| N241 | Control | SIRA_Component | scripts/30b_greeks.R | Greeks_based_P_L_Attribution | - | references |
| N242 | Framework | Control_Framework | FRTB | Greeks_based_P_L_Attribution | N241 | references |
| N243 | Mapping | Control_Reference | Greeks-based P&L Attribution | Greeks_based_P_L_Attribution | N241 | maps_to |
| N244 | Mapping | Control_Description | Scenario P&L decomposition emitted as delta gamma vega totals per option position | Greeks_based_P_L_Attribution | N241 | maps_to |
| N245 | Evidence | Evidence_Type | Options summary artifact | Greeks_based_P_L_Attribution | N241 | evidences |
| N246 | Mapping | Coverage_Assessment | FULL | Greeks_based_P_L_Attribution | N241 | supports |
| N247 | Mapping | Gap_Flag | NO | Greeks_based_P_L_Attribution | N241 | supports |
| N248 | Evidence | Notes | Practitioner-standard attribution implemented | Greeks_based_P_L_Attribution | N241 | supports |
| N249 | Control | SIRA_Component | scripts/36_delta_hedge.R | Model_Validation | - | references |
| N250 | Framework | Control_Framework | SR 11-7 | Model_Validation | N249 | references |
| N251 | Mapping | Control_Reference | Model Validation | Model_Validation | N249 | maps_to |
| N252 | Mapping | Control_Description | Discrete replication error simulation provides internal validation lens for option-adjusted solvency headroom resilience | Model_Validation | N249 | maps_to |
| N253 | Evidence | Evidence_Type | Delta-hedge artifact | Model_Validation | N249 | evidences |
| N254 | Mapping | Coverage_Assessment | PARTIAL | Model_Validation | N249 | supports |
| N255 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Model_Validation | N249 | supports |
| N256 | Evidence | Notes | Continuous-trading and liquidity assumptions are not fully valid in private credit | Model_Validation | N249 | supports |
| N257 | Control | SIRA_Component | notebooks/sira_scenarios.ipynb | Outcomes_Analysis_and_Ongoing_Monitoring | - | references |
| N258 | Framework | Control_Framework | SR 11-7 | Outcomes_Analysis_and_Ongoing_Monitoring | N257 | references |
| N259 | Mapping | Control_Reference | Outcomes Analysis and Ongoing Monitoring | Outcomes_Analysis_and_Ongoing_Monitoring | N257 | maps_to |
| N260 | Mapping | Control_Description | Read-only inspection surface. Deterministic from declared seed. Does not modify governed artefacts. | Outcomes_Analysis_and_Ongoing_Monitoring | N257 | maps_to |
| N261 | Evidence | Evidence_Type | Notebook execution evidence | Outcomes_Analysis_and_Ongoing_Monitoring | N257 | evidences |
| N262 | Mapping | Coverage_Assessment | FULL | Outcomes_Analysis_and_Ongoing_Monitoring | N257 | supports |
| N263 | Mapping | Gap_Flag | NO | Outcomes_Analysis_and_Ongoing_Monitoring | N257 | supports |
| N264 | Evidence | Notes | Read-only inspection surface. Deterministic from declared seed. Does not modify governed artefacts. | Outcomes_Analysis_and_Ongoing_Monitoring | N257 | supports |
| N265 | Control | SIRA_Component | notebooks/SIRA_READER_GUIDE.md | Model_Documentation | - | references |
| N266 | Framework | Control_Framework | SR 11-7 | Model_Documentation | N265 | references |
| N267 | Mapping | Control_Reference | Model Documentation | Model_Documentation | N265 | maps_to |
| N268 | Mapping | Control_Description | Orientation and navigation document that makes notebook governance artefacts discoverable to any reviewer. | Model_Documentation | N265 | maps_to |
| N269 | Evidence | Evidence_Type | Documentation artefact | Model_Documentation | N265 | evidences |
| N270 | Mapping | Coverage_Assessment | FULL | Model_Documentation | N265 | supports |
| N271 | Mapping | Gap_Flag | NO | Model_Documentation | N265 | supports |
| N272 | Evidence | Notes | Entry-point guide for self-contained review package. | Model_Documentation | N265 | supports |
| N273 | Control | SIRA_Component | notebooks/SIRA_METHODOLOGY.md | Conceptual_Soundness | - | references |
| N274 | Framework | Control_Framework | SR 11-7 | Conceptual_Soundness | N273 | references |
| N275 | Mapping | Control_Reference | Conceptual Soundness | Conceptual_Soundness | N273 | maps_to |
| N276 | Mapping | Control_Description | Narrative methodology record linking design choices to governed intent across stress, signal, capital stack, and options layers. | Conceptual_Soundness | N273 | maps_to |
| N277 | Evidence | Evidence_Type | Documentation artefact | Conceptual_Soundness | N273 | evidences |
| N278 | Mapping | Coverage_Assessment | FULL | Conceptual_Soundness | N273 | supports |
| N279 | Mapping | Gap_Flag | NO | Conceptual_Soundness | N273 | supports |
| N280 | Evidence | Notes | Contextual companion to assumptions registry for senior reviewers. | Conceptual_Soundness | N273 | supports |
| N281 | Control | SIRA_Component | notebooks/SIRA_PATH_RESOLVER.md | Configuration_Management | - | references |
| N282 | Framework | Control_Framework | ISM | Configuration_Management | N281 | references |
| N283 | Mapping | Control_Reference | Configuration Management | Configuration_Management | N281 | maps_to |
| N284 | Mapping | Control_Description | Technical governance record for deterministic TOML path resolution with fail-loud behavior and operator mitigations. | Configuration_Management | N281 | maps_to |
| N285 | Evidence | Evidence_Type | Operational control documentation | Configuration_Management | N281 | evidences |
| N286 | Mapping | Coverage_Assessment | FULL | Configuration_Management | N281 | supports |
| N287 | Mapping | Gap_Flag | NO | Configuration_Management | N281 | supports |
| N288 | Evidence | Notes | Documents strategy order, failure behavior, and audit trail expectations. | Configuration_Management | N281 | supports |
| N289 | Control | SIRA_Component | notebooks/SIRA_RNORM_RATIONALE.md | Model_Development_Documentation | - | references |
| N290 | Framework | Control_Framework | SR 11-7 | Model_Development_Documentation | N289 | references |
| N291 | Mapping | Control_Reference | Model Development Documentation | Model_Development_Documentation | N289 | maps_to |
| N292 | Mapping | Control_Description | Governance rationale preserving Gaussian reference draws as structural evidence for distribution selection decisions. | Model_Development_Documentation | N289 | maps_to |
| N293 | Evidence | Evidence_Type | Documentation artefact | Model_Development_Documentation | N289 | evidences |
| N294 | Mapping | Coverage_Assessment | FULL | Model_Development_Documentation | N289 | supports |
| N295 | Mapping | Gap_Flag | NO | Model_Development_Documentation | N289 | supports |
| N296 | Evidence | Notes | Defines removal preconditions and cross-document maintenance obligations. | Model_Development_Documentation | N289 | supports |
| N297 | Control | SIRA_Component | notebooks/SIRA_REVIEWER_CHECKLIST.md | Model_Validation | - | references |
| N298 | Framework | Control_Framework | SR 11-7 | Model_Validation | N297 | references |
| N299 | Mapping | Control_Reference | Model Validation | Model_Validation | N297 | maps_to |
| N300 | Mapping | Control_Description | Structured review checklist mapping validation criteria to notebook cells, source documents, and evidence artefacts. | Model_Validation | N297 | maps_to |
| N301 | Evidence | Evidence_Type | Validation checklist | Model_Validation | N297 | evidences |
| N302 | Mapping | Coverage_Assessment | PARTIAL | Model_Validation | N297 | supports |
| N303 | Mapping | Gap_Flag | OPERATOR_DEPENDENT | Model_Validation | N297 | supports |
| N304 | Evidence | Notes | Section 8 contains operator-owned evidence requirements outside repository boundary. | Model_Validation | N297 | supports |
| N305 | Control | SIRA_Component | LICENSE | Copyright_and_redistribution | - | references |
| N306 | Framework | Control_Framework | Apache 2.0 | Copyright_and_redistribution | N305 | references |
| N307 | Mapping | Control_Reference | Copyright and redistribution | Copyright_and_redistribution | N305 | maps_to |
| N308 | Mapping | Control_Description | Standard Apache License 2.0 terms at repository root | Copyright_and_redistribution | N305 | maps_to |
| N309 | Evidence | Evidence_Type | License document | Copyright_and_redistribution | N305 | evidences |
| N310 | Mapping | Coverage_Assessment | FULL | Copyright_and_redistribution | N305 | supports |
| N311 | Mapping | Gap_Flag | NO | Copyright_and_redistribution | N305 | supports |
| N312 | Evidence | Notes | License instrument governing redistribution and derivative rights. | Copyright_and_redistribution | N305 | supports |
| N313 | Control | SIRA_Component | NOTICE | Attribution_notice | - | references |
| N314 | Framework | Control_Framework | Apache 2.0 | Attribution_notice | N313 | references |
| N315 | Mapping | Control_Reference | Attribution notice | Attribution_notice | N313 | maps_to |
| N316 | Mapping | Control_Description | Repository root NOTICE file for required attribution carriage | Attribution_notice | N313 | maps_to |
| N317 | Evidence | Evidence_Type | Notice document | Attribution_notice | N313 | evidences |
| N318 | Mapping | Coverage_Assessment | FULL | Attribution_notice | N313 | supports |
| N319 | Mapping | Gap_Flag | NO | Attribution_notice | N313 | supports |
| N320 | Evidence | Notes | Supports Apache 2.0 Section 4(d) notice handling. | Attribution_notice | N313 | supports |
| N321 | Control | SIRA_Component | notebooks/DISCLAIMER.md | Academic_use_boundary | - | references |
| N322 | Framework | Control_Framework | Intellectual integrity | Academic_use_boundary | N321 | references |
| N323 | Mapping | Control_Reference | Academic use boundary | Academic_use_boundary | N321 | maps_to |
| N324 | Mapping | Control_Description | Protective academic-use boundary and scope guidance for notebook literature suite | Academic_use_boundary | N321 | maps_to |
| N325 | Evidence | Evidence_Type | Disclaimer document | Academic_use_boundary | N321 | evidences |
| N326 | Mapping | Coverage_Assessment | FULL | Academic_use_boundary | N321 | supports |
| N327 | Mapping | Gap_Flag | NO | Academic_use_boundary | N321 | supports |
| N328 | Evidence | Notes | Disclaimer is distinct from license terms and does not modify Apache 2.0. | Academic_use_boundary | N321 | supports |
| N329 | Control | SIRA_Component | notebooks/NOTICE_BLOCK.md | Notice_block_canonical_source | - | references |
| N330 | Framework | Control_Framework | Configuration management | Notice_block_canonical_source | N329 | references |
| N331 | Mapping | Control_Reference | Notice block canonical source | Notice_block_canonical_source | N329 | maps_to |
| N332 | Mapping | Control_Description | Single-source canonical notice block with propagation procedure | Notice_block_canonical_source | N329 | maps_to |
| N333 | Evidence | Evidence_Type | Canonical notice reference | Notice_block_canonical_source | N329 | evidences |
| N334 | Mapping | Coverage_Assessment | FULL | Notice_block_canonical_source | N329 | supports |
| N335 | Mapping | Gap_Flag | NO | Notice_block_canonical_source | N329 | supports |
| N336 | Evidence | Notes | Defines maintenance sequence to prevent notice text drift. | Notice_block_canonical_source | N329 | supports |
| N337 | Control | SIRA_Component | docs/ETHOS.md | Architecture_level_hardening_declaration | - | references |
| N338 | Framework | Control_Framework | ISM | Architecture_level_hardening_declaration | N337 | references |
| N339 | Mapping | Control_Reference | Architecture-level hardening declaration | Architecture_level_hardening_declaration | N337 | maps_to |
| N340 | Mapping | Control_Description | Architecture-level hardening declaration codified as the governing operating model for the IĀTŌ stack | Architecture_level_hardening_declaration | N337 | maps_to |
| N341 | Evidence | Evidence_Type | Governance document | Architecture_level_hardening_declaration | N337 | evidences |
| N342 | Mapping | Coverage_Assessment | FULL | Architecture_level_hardening_declaration | N337 | supports |
| N343 | Mapping | Gap_Flag | NO | Architecture_level_hardening_declaration | N337 | supports |
| N344 | Evidence | Notes | Primary architectural control declaration | Architecture_level_hardening_declaration | N337 | supports |
| N345 | Control | SIRA_Component | docs/ETHOS.md | Operating_model_declaration | - | references |
| N346 | Framework | Control_Framework | Essential Eight ML4 | Operating_model_declaration | N345 | references |
| N347 | Mapping | Control_Reference | Operating model declaration | Operating_model_declaration | N345 | maps_to |
| N348 | Mapping | Control_Description | Operating model declaration maps stack-level execution constraints to E8 ML4 hardening posture | Operating_model_declaration | N345 | maps_to |
| N349 | Evidence | Evidence_Type | Governance document | Operating_model_declaration | N345 | evidences |
| N350 | Mapping | Coverage_Assessment | FULL | Operating_model_declaration | N345 | supports |
| N351 | Mapping | Gap_Flag | NO | Operating_model_declaration | N345 | supports |
| N352 | Evidence | Notes | Primary operating model declaration | Operating_model_declaration | N345 | supports |
| N353 | Control | SIRA_Component | docs/DELIVERY.md | CC3_Risk_assessment_and_gap_analysis | - | references |
| N354 | Framework | Control_Framework | SOC 2 | CC3_Risk_assessment_and_gap_analysis | N353 | references |
| N355 | Mapping | Control_Reference | CC3 Risk assessment and gap analysis | CC3_Risk_assessment_and_gap_analysis | N353 | maps_to |
| N356 | Mapping | Control_Description | Engagement model defines fixed-scope control gap analysis and exception accountability artefacts | CC3_Risk_assessment_and_gap_analysis | N353 | maps_to |
| N357 | Evidence | Evidence_Type | Governance document | CC3_Risk_assessment_and_gap_analysis | N353 | evidences |
| N358 | Mapping | Coverage_Assessment | FULL | CC3_Risk_assessment_and_gap_analysis | N353 | supports |
| N359 | Mapping | Gap_Flag | NO | CC3_Risk_assessment_and_gap_analysis | N353 | supports |
| N360 | Evidence | Notes | Phase 0 control-gap governance | CC3_Risk_assessment_and_gap_analysis | N353 | supports |
| N361 | Control | SIRA_Component | docs/DELIVERY.md | Evidence_artefact_production | - | references |
| N362 | Framework | Control_Framework | ISM | Evidence_artefact_production | N361 | references |
| N363 | Mapping | Control_Reference | Evidence artefact production | Evidence_artefact_production | N361 | maps_to |
| N364 | Mapping | Control_Description | Delivery framework specifies required evidence artefacts and custody model for control closure verification | Evidence_artefact_production | N361 | maps_to |
| N365 | Evidence | Evidence_Type | Governance document | Evidence_artefact_production | N361 | evidences |
| N366 | Mapping | Coverage_Assessment | FULL | Evidence_artefact_production | N361 | supports |
| N367 | Mapping | Gap_Flag | NO | Evidence_artefact_production | N361 | supports |
| N368 | Evidence | Notes | Evidence pack production control | Evidence_artefact_production | N361 | supports |
| N369 | Control | SIRA_Component | docs/DELIVERY.md | Audit_logging_evidence_mapping | - | references |
| N370 | Framework | Control_Framework | Essential Eight ML4 | Audit_logging_evidence_mapping | N369 | references |
| N371 | Mapping | Control_Reference | Audit logging evidence mapping | Audit_logging_evidence_mapping | N369 | maps_to |
| N372 | Mapping | Control_Description | Delivery artefact mapping binds MCP session logs to ML4 audit logging objectives | Audit_logging_evidence_mapping | N369 | maps_to |
| N373 | Evidence | Evidence_Type | Governance document | Audit_logging_evidence_mapping | N369 | evidences |
| N374 | Mapping | Coverage_Assessment | FULL | Audit_logging_evidence_mapping | N369 | supports |
| N375 | Mapping | Gap_Flag | NO | Audit_logging_evidence_mapping | N369 | supports |
| N376 | Evidence | Notes | Audit artefact mapping for ML4 | Audit_logging_evidence_mapping | N369 | supports |
| N377 | Control | SIRA_Component | Hyperlink audit (this prompt) | Documentation_integrity | - | references |
| N378 | Framework | Control_Framework | ISM | Documentation_integrity | N377 | references |
| N379 | Mapping | Control_Reference | Documentation integrity | Documentation_integrity | N377 | maps_to |
| N380 | Mapping | Control_Description | Hyperlink audit validates referenced internal documents and links remain resolvable for governance traceability | Documentation_integrity | N377 | maps_to |
| N381 | Evidence | Evidence_Type | Documentation QA artefact | Documentation_integrity | N377 | evidences |
| N382 | Mapping | Coverage_Assessment | FULL | Documentation_integrity | N377 | supports |
| N383 | Mapping | Gap_Flag | NO | Documentation_integrity | N377 | supports |
| N384 | Evidence | Notes | Supports documentation integrity and audit readiness | Documentation_integrity | N377 | supports |
| N385 | Control | SIRA_Component | Navigation graph | Traceability_primary_document_chain | - | references |
| N386 | Framework | Control_Framework | ISM | Traceability_primary_document_chain | N385 | references |
| N387 | Mapping | Control_Reference | Traceability — primary document chain | Traceability_primary_document_chain | N385 | maps_to |
| N388 | Mapping | Control_Description | Navigation graph maps primary document chain and dependency traversal for control evidence discoverability | Traceability_primary_document_chain | N385 | maps_to |
| N389 | Evidence | Evidence_Type | Traceability map | Traceability_primary_document_chain | N385 | evidences |
| N390 | Mapping | Coverage_Assessment | FULL | Traceability_primary_document_chain | N385 | supports |
| N391 | Mapping | Gap_Flag | NO | Traceability_primary_document_chain | N385 | supports |
| N392 | Evidence | Notes | Maintains deterministic navigation across governance artefacts | Traceability_primary_document_chain | N385 | supports |
| N393 | Control | SIRA_Component | docs/SIRA_EVIDENCE_GAP_REGISTER.md | Model_Boundary_Documentation | - | references |
| N394 | Framework | Control_Framework | SR 11-7 | Model_Boundary_Documentation | N393 | references |
| N395 | Mapping | Control_Reference | Model Boundary Documentation | Model_Boundary_Documentation | N393 | maps_to |
| N396 | Mapping | Control_Description | Evidence gap register declares bounded pre-data stage limitations and closure paths | Model_Boundary_Documentation | N393 | maps_to |
| N397 | Evidence | Evidence_Type | Governance document | Model_Boundary_Documentation | N393 | evidences |
| N398 | Mapping | Coverage_Assessment | FULL | Model_Boundary_Documentation | N393 | supports |
| N399 | Mapping | Gap_Flag | NO | Model_Boundary_Documentation | N393 | supports |
| N400 | Evidence | Notes | Explicit governance boundary for declared evidence gaps | Model_Boundary_Documentation | N393 | supports |
| N401 | Control | SIRA_Component | docs/SIRA_EVIDENCE_GAP_REGISTER.md | Pre_validation_Stage_Declaration | - | references |
| N402 | Framework | Control_Framework | SR 11-7 | Pre_validation_Stage_Declaration | N401 | references |
| N403 | Mapping | Control_Reference | Pre-validation Stage Declaration | Pre_validation_Stage_Declaration | N401 | maps_to |
| N404 | Mapping | Control_Description | Register classifies stochastic output, calibration, and backtesting as governed pre-validation gaps with operator closure actions | Pre_validation_Stage_Declaration | N401 | maps_to |
| N405 | Evidence | Evidence_Type | Governance document | Pre_validation_Stage_Declaration | N401 | evidences |
| N406 | Mapping | Coverage_Assessment | FULL | Pre_validation_Stage_Declaration | N401 | supports |
| N407 | Mapping | Gap_Flag | NO | Pre_validation_Stage_Declaration | N401 | supports |
| N408 | Evidence | Notes | Stage declaration prevents misclassification as design failure | Pre_validation_Stage_Declaration | N401 | supports |
| N409 | Control | SIRA_Component | notebooks/sira_non_goals_table.md | Model_Boundary_Documentation_canonical_location | - | references |
| N410 | Framework | Control_Framework | SR 11-7 | Model_Boundary_Documentation_canonical_location | N409 | references |
| N411 | Mapping | Control_Reference | Model Boundary Documentation — canonical location | Model_Boundary_Documentation_canonical_location | N409 | maps_to |
| N412 | Mapping | Control_Description | Canonical non-goals register location for runtime boundary declarations | Model_Boundary_Documentation_canonical_location | N409 | maps_to |
| N413 | Evidence | Evidence_Type | Governance document | Model_Boundary_Documentation_canonical_location | N409 | evidences |
| N414 | Mapping | Coverage_Assessment | FULL | Model_Boundary_Documentation_canonical_location | N409 | supports |
| N415 | Mapping | Gap_Flag | NO | Model_Boundary_Documentation_canonical_location | N409 | supports |
| N416 | Evidence | Notes | Single authoritative location replaces inline reproductions | Model_Boundary_Documentation_canonical_location | N409 | supports |
| N417 | Control | SIRA_Component | notebooks/README_QUICKSTART.md (host deps) | Configuration_Management_dependency_scope_declaration | - | references |
| N418 | Framework | Control_Framework | ISM | Configuration_Management_dependency_scope_declaration | N417 | references |
| N419 | Mapping | Control_Reference | Configuration Management — dependency scope declaration | Configuration_Management_dependency_scope_declaration | N417 | maps_to |
| N420 | Mapping | Control_Description | Host-layer dependency scope clearly separated from MCP runtime dependency scope | Configuration_Management_dependency_scope_declaration | N417 | maps_to |
| N421 | Evidence | Evidence_Type | Documentation artefact | Configuration_Management_dependency_scope_declaration | N417 | evidences |
| N422 | Mapping | Coverage_Assessment | FULL | Configuration_Management_dependency_scope_declaration | N417 | supports |
| N423 | Mapping | Gap_Flag | NO | Configuration_Management_dependency_scope_declaration | N417 | supports |
| N424 | Evidence | Notes | Dependency scope declaration aligns operator preflight and runtime boundaries | Configuration_Management_dependency_scope_declaration | N417 | supports |
