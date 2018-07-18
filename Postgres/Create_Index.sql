\c ckd;

create unique index index_site_source on site_source (site_source);
create unique index index_patient on patient (patient_id);
create unique index index_encounter on encounter (encounter_id);
create index index_encounter_secondary on encounter(patient_id);
create index index_diagnosis_secondary on diagnosis (encounter_id);
create index index_vital_sign_secondary on vital_sign (encounter_id);
create index index_lab_secondary on lab (encounter_id);
create index index_medication_secondary on medication (encounter_id);
create index index_patient_condition_secondary on patient_condition (patient_id);
create index index_procedure_secondary on procedure (encounter_id);
create index index_social_history_secondary on social_history (encounter_id);