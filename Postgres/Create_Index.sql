\c ckd;

create index index_site_source on site_source (site_source);
create index index_patient on patient (patient_id);
create index index_encounter on encounter (encounter_id, patient_id);
create index index_diagnosis on diagnosis (encounter_id);
create index index_vital_sign on vital_sign (encounter_id);
create index index_lab on lab (encounter_id);
create index index_medication on medication (encounter_id);
create index index_patient_condition on patient_condition (patient_id);
create index index_procedure on procedure (encounter_id);
create index index_social_history on social_history (encounter_id);