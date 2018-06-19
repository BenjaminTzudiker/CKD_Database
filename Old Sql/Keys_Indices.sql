---------------------------------------------------------------
-- Chronic Kidney Disease (CKD) - Create keys and indices
---------------------------------------------------------------

---------------------------------------------------------------
-- Reference Tables
---------------------------------------------------------------
ALTER TABLE site_source ADD CONSTRAINT site_source_pk PRIMARY KEY (site_source);
ALTER TABLE condition_category ADD CONSTRAINT condition_category_pk PRIMARY KEY (condition_category_id);
ALTER TABLE diagnosis_reference ADD CONSTRAINT diagnosis_reference_pk PRIMARY KEY (icd_type, icd_code);
ALTER TABLE diagnosis_criteria ADD CONSTRAINT diagnosis_criteria_pk PRIMARY KEY (condition_category_id, icd_type, icd_code);
ALTER TABLE diagnosis_criteria ADD CONSTRAINT dx_criteria_dx_ref_fk FOREIGN KEY (icd_type, icd_code) REFERENCES diagnosis_reference (icd_type, icd_code);  
ALTER TABLE diagnosis_criteria ADD CONSTRAINT dx_criteria_condcat_fk FOREIGN KEY (condition_category_id) REFERENCES condition_category (condition_category_id);  
ALTER TABLE lab_criteria ADD CONSTRAINT lab_criteria_pk PRIMARY KEY (site_source, condition_category_id, component_id);
ALTER TABLE lab_criteria ADD CONSTRAINT lab_criteria_condcat_fk FOREIGN KEY (condition_category_id) REFERENCES condition_category (condition_category_id);  
CREATE INDEX lab_criteria_idx ON lab_criteria (site_source, component_id);
ALTER TABLE medication_criteria ADD CONSTRAINT medication_criteria_pk PRIMARY KEY (site_source, condition_category_id, epic_medication_id);
ALTER TABLE medication_criteria ADD CONSTRAINT medication_criteria_condcat_fk FOREIGN KEY (condition_category_id) REFERENCES condition_category (condition_category_id);  
CREATE INDEX medication_criteria_idx ON medication_criteria (site_source, epic_medication_id);
ALTER TABLE epic_encounter_type ADD CONSTRAINT epic_encounter_type_pk PRIMARY KEY (site_source, epic_encounter_type_id);
ALTER TABLE provider ADD CONSTRAINT provider_pk PRIMARY KEY (site_source, visit_provider_id);
ALTER TABLE department ADD CONSTRAINT department_pk PRIMARY KEY (site_source, department_id);

---------------------------------------------------------------
-- Core CKD Tables
---------------------------------------------------------------
ALTER TABLE patient ADD CONSTRAINT patient_pk PRIMARY KEY (patient_id);
ALTER TABLE encounter ADD CONSTRAINT encounter_pk PRIMARY KEY (encounter_id);
ALTER TABLE encounter ADD CONSTRAINT enc_patient_fk FOREIGN KEY (patient_id) REFERENCES patient (patient_id);    
ALTER TABLE encounter ADD CONSTRAINT enc_department_fk FOREIGN KEY (site_source, department_id) REFERENCES department (site_source, department_id);               
ALTER TABLE encounter ADD CONSTRAINT enc_encounter_type_fk FOREIGN KEY (site_source, epic_encounter_type_id) REFERENCES epic_encounter_type (site_source, epic_encounter_type_id);  
ALTER TABLE encounter ADD CONSTRAINT enc_provider_fk FOREIGN KEY (site_source, visit_provider_id) REFERENCES provider (site_source, visit_provider_id);  
ALTER TABLE vital_sign ADD CONSTRAINT vital_sign_encounter_fk FOREIGN KEY (site_source, encounter_id) REFERENCES encounter (site_source, encounter_id);    
ALTER TABLE lab ADD CONSTRAINT lab_encounter_fk FOREIGN KEY (encounter_id) REFERENCES encounter (encounter_id);    
ALTER TABLE medication ADD CONSTRAINT medication_encounter_fk FOREIGN KEY (encounter_id) REFERENCES encounter (encounter_id);    
ALTER TABLE diagnosis ADD CONSTRAINT diagnosis_encounter_fk FOREIGN KEY (encounter_id) REFERENCES encounter (encounter_id);    
ALTER TABLE diagnosis ADD CONSTRAINT diagnosis_dx_ref_fk FOREIGN KEY (icd_type, icd_code) REFERENCES diagnosis_reference (icd_type, icd_code);  
ALTER TABLE patient_condition ADD CONSTRAINT patient_condition_patient_fk FOREIGN KEY (patient_id) REFERENCES patient (patient_id);  
ALTER TABLE patient_condition ADD CONSTRAINT patient_condition_condcat_fk FOREIGN KEY (condition_category_id) REFERENCES condition_category (condition_category_id);  

---------------------------------------------------------------
-- End of Script
---------------------------------------------------------------

ALTER TABLE social_history ADD CONSTRAINT social_history_fk FOREIGN KEY (patient_id) REFERENCES patient (patient_id);
ALTER TABLE social_history ADD CONSTRAINT social_history_encounter_fk FOREIGN KEY (encounter_id) REFERENCES encounter (encounter_id); 


