
--------------------------------------------------------------------------------
-- Encounter
--------------------------------------------------------------------------------
truncate table encounter cascade;
copy encounter
(site_source
,department_id
,patient_id
,encounter_id
,epic_encounter_type_id
,encounter_date
,admit_date
,discharge_date
,hospital_discharge_disposition
,ed_disposition
,pcornet_visit_type
,visit_provider_id
,appointment_status
)
from '/home/ppetousis/Downloads/ckd/Encounter.csv'
with delimiter as ',' null as '' csv header quote as '"' force null
hospital_discharge_disposition
,ed_disposition
,visit_provider_id
,department_id
,appointment_status
;
--------------------------------------------------------------------------------
-- Site Source
--------------------------------------------------------------------------------
truncate table site_source cascade;
copy site_source
(site_source
,name
)
from '/home/ppetousis/Downloads/ckd/Site_Source.csv'
with delimiter as ','  null as '' csv header quote as '"'
;
--------------------------------------------------------------------------------
-- Provider
--------------------------------------------------------------------------------
truncate table provider cascade;
copy provider
(site_source
,visit_provider_id
,specialty
)
from '/home/ppetousis/Downloads/ckd/Provider.csv'
with delimiter as ',' null as '' csv header quote as '"' force null specialty
;
--------------------------------------------------------------------------------
-- Department
--------------------------------------------------------------------------------
truncate table department cascade;
copy department
(site_source
,department_id
,department_name
,location
,specialty
)
from '/home/ppetousis/Downloads/ckd/Department.csv'
with delimiter as ',' null as '' csv header quote as '"' force null location, specialty
;
--------------------------------------------------------------------------------
-- Encounter Type
--------------------------------------------------------------------------------
truncate table epic_encounter_type cascade;
copy epic_encounter_type
(site_source
,epic_encounter_type_id
,epic_encounter_type
)
from '/home/ppetousis/Downloads/ckd/Encounter_Type.csv'
with delimiter as ',' csv header quote as '"'
;
--------------------------------------------------------------------------------
-- Diagnosis Reference
--------------------------------------------------------------------------------
truncate table diagnosis_reference cascade;
copy diagnosis_reference
(icd_type
,icd_code
,icd_description
)
from '/home/ppetousis/Downloads/ckd/Diagnosis_Reference.csv'
with delimiter as ',' csv header quote as '"'
;
--------------------------------------------------------------------------------
-- Diagnosis Criteria
--------------------------------------------------------------------------------
truncate table diagnosis_criteria cascade;
copy diagnosis_criteria
(icd_type
,icd_code
,condition_category_id
)
from '/home/ppetousis/Downloads/ckd/Diagnosis_Criteria.csv'
with delimiter as ',' csv header quote as '"'
;
--------------------------------------------------------------------------------
-- Condition Category
--------------------------------------------------------------------------------
truncate table condition_category cascade;
copy condition_category
(condition_category_id
,condition_category_group
,condition_category_title
,condition_category_source
)
from '/home/ppetousis/Downloads/ckd/Condition_Category.csv'
with delimiter as ',' csv header quote as '"'
;
--------------------------------------------------------------------------------
-- Lab Criteria
--------------------------------------------------------------------------------
truncate table lab_criteria cascade;
copy lab_criteria
(condition_category_id
,component_id
,site_source
,component_name
,threshold_low
,threshold_high
)
from '/home/ppetousis/Downloads/ckd/Lab_Criteria.csv'
with delimiter as ',' null as '' csv header quote as '"' force null threshold_low, threshold_high
;
--------------------------------------------------------------------------------
-- Medication Criteria
--------------------------------------------------------------------------------

truncate table medication_criteria cascade;
copy medication_criteria
(site_source
,condition_category_id
,epic_medication_id
,epic_medication_name
,generic_name
)
from '/home/ppetousis/Downloads/ckd/Medication_Criteria.csv'
with delimiter as ',' null as '' csv header quote as '"' force null generic_name
;

--------------------------------------------------------------------------------
-- DRG Reference
--------------------------------------------------------------------------------
truncate table drg_reference cascade;
copy drg_reference
(site_source
,drg_id
,primary_drg_description
,secondary_drg_description
)
from '/home/ppetousis/Downloads/ckd/DRG_Reference.csv'
with delimiter as ',' null as '' csv header quote as '"' force null
secondary_drg_description
;
--------------------------------------------------------------------------------
-- Patient
--------------------------------------------------------------------------------
truncate table patient cascade;
copy patient
(patient_id
,site_source
,date_of_birth
,gender
,race1
,race2
,mapped_race
,ethnicity
,mapped_ethnicity
,vital_status
,vital_status_date
,zip
,country
,state
,ruca_code
)
from '/home/ppetousis/Downloads/ckd/Patient.csv'
with delimiter as ',' null as '' csv header quote as '"' force null
date_of_birth
,gender
,race1
,race2
,mapped_race
,ethnicity
,mapped_ethnicity
,vital_status
,vital_status_date
,zip
,country
,state
,ruca_code
;

--------------------------------------------------------------------------------
-- Diagnosis
--------------------------------------------------------------------------------
truncate table diagnosis cascade;
copy diagnosis
(encounter_id
,site_source
,diagnosis_source
,diagnosis_timestamp
,icd_type
,icd_code
,primary_dx_flag
)
from '/home/ppetousis/Downloads/ckd/Diagnosis.csv'
with delimiter as ',' null as '' csv header quote as '"'
;
--------------------------------------------------------------------------------
-- Vital Signs
--------------------------------------------------------------------------------
truncate table vital_sign cascade;
copy vital_sign
(encounter_id
,site_source
,vital_sign_type
,vital_sign_value
,vital_sign_taken_date
)
from '/home/ppetousis/Downloads/ckd/Vital_Sign.csv'
with delimiter as ',' null as '' csv header quote as '"'
;
--------------------------------------------------------------------------------
-- Labs
--------------------------------------------------------------------------------
truncate table lab cascade;
copy lab
(encounter_id
,component_id
,site_source
,component_name
,procedure_id
,procedure_description
,time_ordered
,time_taken
,time_results
,text_results
,numeric_results
,reference_units
,loinc_id
)
from '/home/ppetousis/Downloads/ckd/Lab.csv'
with delimiter as ',' null as '' csv header quote as '"' force null
text_results
,numeric_results
,reference_units
,loinc_id
;
--------------------------------------------------------------------------------
-- Medications
--------------------------------------------------------------------------------
truncate table medication cascade;
copy medication
(encounter_id
,order_med_id
,site_source
,order_date
,start_date
,end_date
,epic_medication_id
,epic_medication_name
,generic_name
,pharm_class
,pharm_subclass
,rxnorm_cui_scd
,rxnorm_name
,quantity
,refills
,dose
,dose_unit
,time_taken
,frequency
,ordering_mode
)
from '/home/ppetousis/Downloads/ckd/Medication.csv'
with delimiter as ',' null as '' csv header quote as '"' force null
refills
;
--------------------------------------------------------------------------------
-- Patient Condition
--------------------------------------------------------------------------------
truncate table patient_condition cascade;
copy patient_condition
(site_source
,patient_id
,condition_category_id
,condition_date
)
from '/home/ppetousis/Downloads/ckd/Patient_Condition.csv'
with delimiter as ',' null as '' csv header quote as '"'
;
--------------------------------------------------------------------------------
-- DRG
--------------------------------------------------------------------------------
truncate table drg cascade;
copy drg
(encounter_id
,site_source
,drg_id
)
from '/home/ppetousis/Downloads/ckd/DRG.csv'
with delimiter as ',' null as '' csv header quote as '"'
;
--------------------------------------------------------------------------------
-- Procedures
--------------------------------------------------------------------------------
truncate table procedure cascade;
copy procedure
(encounter_id
,site_source
,code
,code_type
,description
,procedure_date
)
from '/home/ppetousis/Downloads/ckd/Procedure.csv'
with delimiter as ',' null as '' csv header quote as '"'
;
