--------------------------------------------------------------------------------
-- Site Source
--------------------------------------------------------------------------------
drop table site_source cascade;
create table site_source
(site_source                numeric(2) 		 
,name			    		varchar(254)
,constraint site_source_pk primary key (site_source)
);
--------------------------------------------------------------------------------
-- Provider
--------------------------------------------------------------------------------
drop table provider cascade;
create table provider      
(site_source                numeric(2)     
,visit_provider_id          varchar(20)  
,specialty                  varchar(254) 
,constraint provider_pk primary key (site_source, visit_provider_id)
);
--------------------------------------------------------------------------------
-- Department 
--------------------------------------------------------------------------------
drop table department cascade;
create table department
(site_source              numeric(2)     
,department_id            numeric(18)    
,department_name          varchar(254) 
,specialty                varchar(400)
,location_id				numeric(18)
,location_name               varchar(80)  
,place_of_service_id			numeric(18)
,place_of_service				varchar(80)
,constraint department_pk primary key (site_source, department_id)
);
--------------------------------------------------------------------------------
-- Encounter Type 
--------------------------------------------------------------------------------
drop table epic_encounter_type cascade;
create table epic_encounter_type
(site_source                     numeric(2)     
,epic_encounter_type_id          varchar(66)  
,epic_encounter_type             varchar(254) 
,constraint epic_encounter_type_pk primary key (site_source, epic_encounter_type_id)
);
--------------------------------------------------------------------------------
-- Diagnosis Reference 
--------------------------------------------------------------------------------
drop table diagnosis_reference cascade;
create table diagnosis_reference      
(icd_type                 numeric(2) 
,icd_code                 varchar(254)
,icd_description          varchar(457) 
,constraint diagnosis_reference_pk primary key (icd_type, icd_code)
);
--------------------------------------------------------------------------------
-- Diagnosis Criteria 
--------------------------------------------------------------------------------
drop table diagnosis_criteria cascade;
create table diagnosis_criteria
(icd_type                       numeric(2)     
,icd_code                       varchar(254) 
,condition_category_id          varchar(20)  
);
--------------------------------------------------------------------------------
-- Condition Category 
--------------------------------------------------------------------------------
drop table condition_category cascade;
create table condition_category
(condition_category_id             varchar(20)  
,condition_category_group          varchar(20)  
,condition_category_title          varchar(254) 
,condition_category_source         varchar(20) 
,constraint condition_category_pk primary key (condition_category_id)
);
--------------------------------------------------------------------------------
-- Lab Criteria
--------------------------------------------------------------------------------
drop table lab_criteria cascade;
create table lab_criteria
(condition_category_id          varchar(20) 
,component_id                   numeric(18)   
,site_source                    numeric(2)    
,component_name                 varchar(75) 
,threshold_low                  decimal(20,5) 
,threshold_high                 decimal(20,5) 
,constraint lab_criteria_pk primary key (site_source, condition_category_id, component_id)
);
--------------------------------------------------------------------------------
-- Medication Criteria 
--------------------------------------------------------------------------------
drop table medication_criteria cascade;
create table medication_criteria      
(site_source                    numeric(2)     
,condition_category_id          varchar(20)  
,epic_medication_id             numeric(38)    
,epic_medication_name           varchar(255) 
,generic_name                   varchar(200) 
,constraint medication_criteria_pk primary key (site_source, condition_category_id, epic_medication_id)
);
--------------------------------------------------------------------------------
-- DRG Reference
--------------------------------------------------------------------------------
drop table drg_reference cascade;
create table drg_reference
(site_source                numeric(2)      
,drg_id                     varchar(18)   
,primary_drg_description    varchar(254)
,secondary_drg_description  varchar(254)
,constraint drg_reference_pk primary key (site_source, drg_id)
);
--------------------------------------------------------------------------------
-- Patient
--------------------------------------------------------------------------------
drop table patient cascade;
create table patient      
(patient_id             numeric(38) 
,site_source            numeric(2)     
,date_of_birth          timestamp          
,gender                 varchar(254) 
,race1                  varchar(254) 
,race2                  varchar(254) 
,mapped_race            varchar(254) 
,ethnicity              varchar(254) 
,mapped_ethnicity		varchar(254)
,vital_status           varchar(254) 
,vital_status_date      timestamp   
,zip					varchar(60) 
,country				varchar(66)
,state					varchar(254)
,ruca_code				varchar(254)
,constraint patient_pk primary key (site_source, patient_id)
);
--------------------------------------------------------------------------------
-- Encounter
--------------------------------------------------------------------------------
drop table encounter cascade;
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
,constraint encounter_pk primary key (site_source, encounter_id)
,constraint enc_patient_fk 
 foreign key (site_source, patient_id) 
 references patient (site_source, patient_id) 
 on delete cascade on update cascade
,constraint enc_department_fk 
 foreign key (site_source, department_id) 
 references department (site_source, department_id) 
 on delete cascade on update cascade
,constraint enc_encounter_type_fk 
 foreign key (site_source, epic_encounter_type_id) 
 references epic_encounter_type (site_source, epic_encounter_type_id) 
 on delete cascade on update cascade
,constraint enc_provider_fk 
 foreign key (site_source, visit_provider_id) 
 references provider (site_source, visit_provider_id) 
 on delete cascade on update cascade
);
--------------------------------------------------------------------------------
-- Diagnosis
--------------------------------------------------------------------------------
drop table diagnosis cascade;
create table diagnosis      
(encounter_id            numeric(38)    
,site_source             numeric(2)     
,diagnosis_source        varchar(10)   
,diagnosis_timestamp     timestamp          
,icd_type                numeric(2)     
,icd_code                varchar(254) 
,primary_dx_flag         numeric(1)  
,constraint diagnosis_encounter_fk 
 foreign key (site_source, encounter_id) 
 references encounter (site_source, encounter_id) 
 on delete cascade on update cascade
,constraint diagnosis_dx_ref_fk 
 foreign key (icd_type, icd_code) 
 references diagnosis_reference (icd_type, icd_code) 
 on delete cascade on update cascade
);
--------------------------------------------------------------------------------
-- Vital Signs
--------------------------------------------------------------------------------
drop table vital_sign cascade;
create table vital_sign
(encounter_id               numeric(38)     
,site_source                numeric(2)      
,vital_sign_type            varchar(254)  
,vital_sign_value           varchar(2500) 
,vital_sign_taken_date      timestamp     
,constraint vital_sign_encounter_fk 
 foreign key (site_source, encounter_id)
 references encounter (site_source, encounter_id)
 on delete cascade on update cascade
);
--------------------------------------------------------------------------------
-- Labs
--------------------------------------------------------------------------------
drop table lab cascade;
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
,constraint lab_encounter_fk 
 foreign key (site_source, encounter_id)
 references encounter (site_source, encounter_id)
 on delete cascade on update cascade
);
--------------------------------------------------------------------------------
-- Medications
--------------------------------------------------------------------------------
drop table medication cascade;
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
,constraint medication_encounter_fk 
 foreign key (site_source, encounter_id)
 references encounter (site_source, encounter_id)
 on delete cascade on update cascade
);
--------------------------------------------------------------------------------
-- Patient Condition
--------------------------------------------------------------------------------
drop table patient_condition cascade;
create table patient_condition
(site_source               numeric(38)   
,patient_id                numeric(38)   
,condition_category_id     varchar(20) 
,condition_date      	   timestamp           
,constraint patient_condition_patient_fk 
 foreign key (site_source, patient_id)
 references patient (site_source, patient_id)
 on delete cascade on update cascade
,constraint patient_condition_condcat_fk 
 foreign key (condition_category_id)
 references condition_category (condition_category_id)
 on delete cascade on update cascade
);
--------------------------------------------------------------------------------
-- DRG
--------------------------------------------------------------------------------
drop table drg cascade;
create table drg
(encounter_id             numeric(38)     
,site_source              numeric(2)      
,drg_id                   varchar(18)   
,constraint drg_encounter_fk 
 foreign key (site_source, encounter_id)
 references encounter (site_source, encounter_id)
 on delete cascade on update cascade
,constraint drg_ref_encounter_fk 
 foreign key (site_source, drg_id)
 references drg_reference (site_source, drg_id)
 on delete cascade on update cascade
);
--------------------------------------------------------------------------------
-- Procedures
--------------------------------------------------------------------------------
drop table procedure cascade;
create table procedure
(encounter_id             numeric(38)     
,site_source              numeric(2)      
,code                     varchar(254)
,code_type                varchar(254)
,description              varchar(254)
,procedure_date           timestamp
,constraint procedure_encounter_fk 
 foreign key (site_source, encounter_id)
 references encounter (site_source, encounter_id)
 on delete cascade on update cascade
);
