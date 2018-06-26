-- PSQL variables don't work with the local \copy
/*\set path '''/Users/benjamintzudiker/Documents/SQL/'

\set path_site_source :path 'Site_Source.csv'''
\set path_provider :path 'Provider.csv'''
\set path_department :path 'Department.csv'''
\set path_epic_encounter_type :path 'Epic_Encounter_Type.csv'''
\set path_diagnosis_reference :path 'Diagnosis_Reference.csv'''
\set path_diagnosis_criteria :path 'Diagnosis_Criteria.csv'''
\set path_condition_category :path 'Condition_Category.csv'''
\set path_lab_criteria :path 'Lab_Criteria.csv'''
\set path_medication_criteria :path 'Medication_Criteria.csv'''
\set path_drg_reference :path 'DRG_Reference.csv'''
\set path_patient :path 'Patient.csv'''
\set path_encounter :path 'Encounter.csv'''
\set path_diagnosis :path 'Diagnosis.csv'''
\set path_vital_sign :path 'Vital_Sign.csv'''
\set path_lab :path 'Lab.csv'''
\set path_medication :path 'Medication.csv'''
\set path_patient_condition :path 'Patient_Condition.csv'''
\set path_drg :path 'DRG.csv'''
\set path_procedure :path 'Procedure.csv'''
\set path_social_history :path 'Social_History.csv'''*/

drop table site_source cascade;
create table site_source
(site_source                numeric(2)          
,name                        varchar(254)
);

truncate table site_source cascade;
copy site_source
(site_source
,name
)
from :path_site_source
with delimiter as ','  null as '' csv header quote as '"'
;


create table provider      
(site_source                numeric(2)     
,visit_provider_id          varchar(20)  
,specialty                  varchar(254) 
);

truncate table provider cascade;
\copy provider (site_source, visit_provider_id, specialty ) from '/Users/benjamintzudiker/Documents/SQL/Provider.csv' with delimiter as ',' null as '' csv header quote as '"';


create table department
(site_source              numeric(2)     
,department_id            numeric(18)    
,department_name          varchar(254) 
,specialty                varchar(400)
,location_id                varchar(400)
,location_name               varchar(80)  
,place_of_service_id            numeric(18)
,place_of_service                varchar(80)
,constraint department_pk primary key (site_source, department_id)
);

truncate table department cascade;
\copy department (site_source, department_id, department_name, specialty, location_id   , location_name, place_of_service_id, place_of_service) from '/Users/benjamintzudiker/Documents/SQL/Department.csv' with delimiter as ',' null as '' csv header quote as '"';


create table epic_encounter_type
(site_source                     numeric(2)     
,epic_encounter_type_id          varchar(66)  
,epic_encounter_type             varchar(254) 
);

truncate table epic_encounter_type cascade;
\copy epic_encounter_type (site_source, epic_encounter_type_id, epic_encounter_type) from '/Users/benjamintzudiker/Documents/SQL/Epic_Encounter_Type.csv' with delimiter as ',' csv header quote as '"';


create table diagnosis_reference      
(icd_type                 numeric(2) 
,icd_code                 varchar(254)
,icd_description          varchar(457) 
);

truncate table diagnosis_reference cascade;
\copy diagnosis_reference (icd_type, icd_code, icd_description) from '/Users/benjamintzudiker/Documents/SQL/Diagnosis_Reference.csv' with delimiter as ',' csv header quote as '"';


create table diagnosis_criteria
(icd_type                       numeric(2)     
,icd_code                       varchar(254) 
,condition_category_id          varchar(20)  
);

truncate table diagnosis_criteria cascade;
\copy diagnosis_criteria (icd_type, icd_code, condition_category_id) from '/Users/benjamintzudiker/Documents/SQL/Diagnosis_Criteria.csv' with delimiter as ',' csv header quote as '"';


create table condition_category
(condition_category_id             varchar(20)  
,condition_category_group          varchar(20)  
,condition_category_title          varchar(254) 
--, condition_category_source         varchar(20) 
);

truncate table condition_category cascade;
\copy condition_category (condition_category_id, condition_category_group, condition_category_title) from '/Users/benjamintzudiker/Documents/SQL/Condition_Category.csv' with delimiter as ',' csv header quote as '"';



create table lab_criteria
(condition_category_id          varchar(20) 
,component_id                   numeric(18)   
,site_source                    numeric(2)    
,component_name                 varchar(75) 
,threshold_low                  decimal(20,5) 
,threshold_high                 decimal(20,5) 
);

truncate table lab_criteria cascade;
\copy lab_criteria (condition_category_id, component_id, site_source, component_name, threshold_low, threshold_high) from '/Users/benjamintzudiker/Documents/SQL/Lab_Criteria.csv' with delimiter as ',' null as '' csv header quote as '"';



create table medication_criteria      
(site_source                    numeric(2)     
,condition_category_id          varchar(20)  
,epic_medication_id             numeric(38)    
,epic_medication_name           varchar(255) 
,generic_name                   varchar(200) 
);

truncate table medication_criteria cascade;
\copy medication_criteria (site_source, condition_category_id, epic_medication_id, epic_medication_name, generic_name) from '/Users/benjamintzudiker/Documents/SQL/Medication_Criteria.csv' with delimiter as ',' null as '' csv header quote as '"';




create table drg_reference
(site_source                numeric(2)      
,drg_id                     varchar(18)   
,primary_drg_description    varchar(254)
,secondary_drg_description  varchar(254)
);

truncate table drg_reference cascade;
\copy drg_reference (site_source, drg_id, primary_drg_description, secondary_drg_description) from '/Users/benjamintzudiker/Documents/SQL/DRG_Reference.csv' with delimiter as ',' null as '' csv header quote as '"';


create table patient      
(patient_id             numeric(38) 
,site_source            numeric(2)     
,date_of_birth          timestamp          
,gender                 varchar(254) 
,race1                  varchar(254) 
,race2                  varchar(254) 
,mapped_race            varchar(254) 
,ethnicity              varchar(254) 
,mapped_ethnicity        varchar(254)
,vital_status           varchar(254) 
,vital_status_date      timestamp   
,zip                    varchar(60) 
,country                varchar(66)
,state                    varchar(254)
,ruca_code                varchar(254)
);

truncate table patient cascade;
\copy patient (patient_id, site_source, date_of_birth, gender, race1, race2, mapped_race, ethnicity, mapped_ethnicity, vital_status, vital_status_date, zip, country, state, ruca_code) from '/Users/benjamintzudiker/Documents/SQL/Patient.csv' with delimiter as ',' null as '' csv header quote as '"';




create table encounter      
(site_source                         numeric(2)     
,department_id                       numeric(18)
,patient_id                          numeric(38)    
,encounter_id                        numeric(38)    
,epic_encounter_type_id              varchar(66)  
,encounter_date                      timestamp          
,admit_date                          timestamp          
,discharge_date                      timestamp          
,hospital_discharge_disposition      varchar(254) 
,ed_disposition                      varchar(254) 
,pcornet_visit_type                  varchar(2)   
,visit_provider_id                   varchar(20)  
,appointment_status                  varchar(254)
);


truncate table encounter cascade;
\copy encounter (site_source, department_id, patient_id, encounter_id, epic_encounter_type_id, encounter_date, admit_date, discharge_date, hospital_discharge_disposition, ed_disposition, pcornet_visit_type, visit_provider_id, appointment_status) from '/Users/benjamintzudiker/Documents/SQL/Encounter.csv' with delimiter as ',' null as '' csv header quote as '"';


create table diagnosis      
(encounter_id            numeric(38)    
,site_source             numeric(2)     
,diagnosis_source        varchar(10)   
,diagnosis_timestamp     timestamp          
,icd_type                numeric(2)     
,icd_code                varchar(254) 
,primary_dx_flag         numeric(1)  
);

truncate table diagnosis cascade;
\copy diagnosis (encounter_id, site_source, diagnosis_source, diagnosis_timestamp, icd_type, icd_code, primary_dx_flag) from '/Users/benjamintzudiker/Documents/SQL/Diagnosis.csv' with delimiter as ',' null as '' csv header quote as '"';


drop table vital_sign cascade;
create table vital_sign
(encounter_id               numeric(38)     
,site_source                numeric(2)      
,vital_sign_type            varchar(254)  
,vital_sign_value           varchar(2500) 
,vital_sign_taken_date      timestamp     
);

truncate table vital_sign cascade;
\copy vital_sign (encounter_id, site_source, vital_sign_type, vital_sign_value, vital_sign_taken_date) from '/Users/benjamintzudiker/Documents/SQL/Vital_Sign.csv' with delimiter as ',' null as '' csv header quote as '"';



create table lab      
(encounter_id               numeric(38)    
,component_id               numeric(18)    
,site_source                numeric(2)     
,component_name             varchar(75)  
,procedure_id               numeric(18)    
,procedure_description      varchar(254) 
,time_ordered               timestamp          
,time_taken                 timestamp          
,time_results               timestamp          
,text_results               varchar(254) 
,numeric_results            numeric(38,20)   
,reference_units            varchar(100) 
,loinc_id                   varchar(254) 
);


truncate table lab cascade;
\copy lab (encounter_id, component_id, site_source, component_name, procedure_id, procedure_description, time_ordered, time_taken, time_results, text_results, numeric_results, reference_units, loinc_id) from '/Users/benjamintzudiker/Documents/SQL/Lab.csv' with delimiter as ',' null as '' csv header quote as '"';



create table medication      
(encounter_id              numeric(38)     
,order_med_id              numeric(18)
,site_source               numeric(2)      
,order_date                timestamp           
,start_date                timestamp           
,end_date                  timestamp           
,epic_medication_id        numeric(18)     
,epic_medication_name      varchar(255)  
,generic_name              varchar(200)  
,pharm_class               varchar(254)  
,pharm_subclass            varchar(254)  
,rxnorm_cui_scd            varchar(8)    
,rxnorm_name               varchar(3000) 
,quantity                  varchar(50)   
,refills                   varchar(20)   
,dose                      varchar(254)  
,dose_unit                 varchar(254)  
,time_taken                timestamp           
,frequency                 varchar(70)   
,ordering_mode             numeric(1)    
);

truncate table medication cascade;
\copy medication (encounter_id, order_med_id, site_source, order_date, start_date, end_date, epic_medication_id, epic_medication_name, generic_name, pharm_class, pharm_subclass, rxnorm_cui_scd, rxnorm_name, quantity, refills, dose, dose_unit, time_taken, frequency, ordering_mode) from '/Users/benjamintzudiker/Documents/SQL/Medication.csv' with delimiter as ',' null as '' csv header quote as '"';


create table patient_condition
(site_source               numeric(38)   
,patient_id                numeric(38)   
,condition_category_id     varchar(20) 
,condition_date             timestamp           
);

truncate table patient_condition cascade;
\copy patient_condition (site_source, patient_id, condition_category_id, condition_date) from '/Users/benjamintzudiker/Documents/SQL/Patient_Condition.csv' with delimiter as ',' null as '' csv header quote as '"';


create table drg
(encounter_id             numeric(38)     
,site_source              numeric(2)      
,drg_id                   varchar(18)   
);

truncate table drg cascade;
\copy drg (encounter_id, site_source, drg_id) from '/Users/benjamintzudiker/Documents/SQL/DRG.csv' with delimiter as ',' null as '' csv header quote as '"';



create table procedure
(encounter_id             numeric(38)     
,site_source              numeric(2)      
,code                     varchar(254)
,code_type                varchar(254)
,description              varchar(254)
,procedure_date           timestamp
);

truncate table procedure cascade;
\copy procedure (encounter_id, site_source, code, code_type, description, procedure_date) from '/Users/benjamintzudiker/Documents/SQL/Procedure.csv' with delimiter as ',' null as '' csv header quote as '"';


create table social_history      
(SITE_SOURCE            numeric(2)
,encounter_id           numeric(38)     
,PATIENT_ID             numeric(38) 
,SEXUALLY_ACTIVE          varchar(254)          
,FEMALE_PARTNER                 varchar(254) 
,MALE_PARTNER                  varchar(254) 
,SMOKING_STATUS                  varchar(254) 
,TOBACCO_PACK_PER_DAY            varchar(254) 
,TOBACCO_USE_YEARS              varchar(254) 
,TOBACCO_USER          varchar(254)          
,CIGARETTES                 varchar(254) 
,PIPES                  varchar(254) 
,CIGARS                  varchar(254) 
,SNUFF            varchar(254) 
,CHEW              varchar(254) 
,SMOKE_START_DATE            varchar(254) 
,SMOKE_END_DATE              varchar(254) 
,ALCOHOL_USER          varchar(254)          
,ALCOHOL_OUNCE_PER_WEEK                 varchar(254) 
,ALCOHOL_COMMENT                  varchar(254) 
,ALCOHOL_TYPE                  varchar(254) 
,IV_DRUG_USER            varchar(254) 
,ILLICIT_DRUG_FREQUENCY              varchar(254) 
,ILLICIT_DRUG_COMMENT        TEXT
);

truncate table social_history cascade;
\copy social_history (SITE_SOURCE, encounter_id, PATIENT_ID, SEXUALLY_ACTIVE, FEMALE_PARTNER, MALE_PARTNER, SMOKING_STATUS, TOBACCO_PACK_PER_DAY, TOBACCO_USE_YEARS, TOBACCO_USER, CIGARETTES, PIPES, CIGARS, SNUFF, CHEW, SMOKE_START_DATE, SMOKE_END_DATE, ALCOHOL_USER, ALCOHOL_OUNCE_PER_WEEK, ALCOHOL_CO MENT, ALCOHOL_TYPE, IV_DRUG_USER, ILLICIT_DRUG_FREQUENCY, ILLICIT_DRUG_COMMENT) from '/Users/benjamintzudiker/Documents/SQL/Social_History.csv' with delimiter as ',' null as '' csv header quote as '"';
