-- Before starting mysql, change to the directory with the database csv files. You may need to add the --local-infile flag when connecting.
-- Loading table data can take a long time. Increasing the buffer pool may help.

-- create database ckd;
-- use ckd;

-- Possibly required for correct operation

set @@SQL_MODE = REPLACE(@@SQL_MODE, 'NO_ZERO_IN_DATE', '');
set @@SQL_MODE = REPLACE(@@SQL_MODE, 'NO_ZERO_DATE', '');

-- Optimizations

set foreign_key_checks = 0;
set autocommit = 0;
set unique_checks = 0;
set sql_log_bin = 0;

-- CHANGE THE FOLLOWING LINES TO APPROPRIATE VALUES FOR YOUR COMPUTER

set global innodb_buffer_pool_size = 2048 * 1024 * 1024;
set global innodb_log_buffer_size = 256 * 1024 * 1024;

-- Site Source

drop table site_source cascade;
create table site_source
(site_source                numeric(2)          
,name                        varchar(254)
,constraint site_source_pk primary key (site_source)
);

truncate table site_source;
load data local infile "./Site_Source.csv"
into table site_source
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Provider

drop table provider cascade;
create table provider      
(site_source                numeric(2)     
,visit_provider_id          varchar(20)  
,specialty                  varchar(254) 
,constraint provider_pk primary key (site_source, visit_provider_id)
);

truncate table provider;
load data local infile "./Provider.csv"
into table provider
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Department 

drop table department cascade;
create table department
(site_source              numeric(2)     
,department_id            numeric(18)    
,department_name          varchar(254) 
,specialty                varchar(400)
,location_id              numeric(18)
,location_name            varchar(80)  
,place_of_service_id      numeric(18)
,place_of_service          varchar(80)
,constraint department_pk primary key (site_source, department_id)
);

truncate table department;
load data local infile "./Department.csv"
into table department
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Encounter Type 

drop table epic_encounter_type cascade;
create table epic_encounter_type
(site_source                     numeric(2)     
,epic_encounter_type_id          varchar(66)  
,epic_encounter_type             varchar(254) 
,constraint epic_encounter_type_pk primary key (site_source, epic_encounter_type_id)
);

truncate table epic_encounter_type;
load data local infile "./Encounter_Type.csv"
into table epic_encounter_type
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Diagnosis Reference 

drop table diagnosis_reference cascade;
create table diagnosis_reference      
(icd_type                 numeric(2) 
,icd_code                 varchar(254)
,icd_description          varchar(457) 
,constraint diagnosis_reference_pk primary key (icd_type, icd_code)
);

truncate table diagnosis_reference;
load data local infile "./Diagnosis_Reference.csv"
into table diagnosis_reference
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Diagnosis Criteria 

drop table diagnosis_criteria cascade;
create table diagnosis_criteria
(icd_type                       numeric(2)     
,icd_code                       varchar(254) 
,condition_category_id          varchar(20)  
);

truncate table diagnosis_criteria;
load data local infile "./Diagnosis_Criteria.csv"
into table diagnosis_criteria
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Condition Category 

drop table condition_category cascade;
create table condition_category
(condition_category_id             varchar(20)  
,condition_category_group          varchar(20)  
,condition_category_title          varchar(254) 
-- ,condition_category_source         varchar(20) 
,constraint condition_category_pk primary key (condition_category_id)
);

truncate table condition_category;
load data local infile "./Condition_Category.csv"
into table condition_category
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Lab Criteria

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
CREATE INDEX lab_criteria_idx ON lab_criteria (site_source, component_id);

truncate table lab_criteria;
load data local infile "./Lab_Criteria.csv"
into table lab_criteria
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Medication Criteria 

drop table medication_criteria cascade;
create table medication_criteria      
(site_source                    numeric(2)     
,condition_category_id          varchar(20)  
,epic_medication_id             numeric(38)    
,epic_medication_name           varchar(255) 
,generic_name                   varchar(200) 
,constraint medication_criteria_pk primary key (site_source, condition_category_id, epic_medication_id)
);
CREATE INDEX medication_criteria_idx ON medication_criteria (site_source, epic_medication_id);

truncate table medication_criteria;
load data local infile "./Medication_Criteria.csv"
into table medication_criteria
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- DRG Reference

drop table drg_reference cascade;
create table drg_reference
(site_source                numeric(2)      
,drg_id                     varchar(18)   
,primary_drg_description    varchar(254)
,secondary_drg_description  varchar(254)
,constraint drg_reference_pk primary key (site_source, drg_id)
);

truncate table drg_reference;
load data local infile "./DRG_Reference.csv"
into table drg_reference
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Patient

drop table patient cascade;
create table patient      
(patient_id             numeric(38) 
,site_source            numeric(2)     
,date_of_birth          datetime           -- This must be a datetime since many patients were born before 1970
,gender                 varchar(254) 
,race1                  varchar(254) 
,race2                  varchar(254) 
,mapped_race            varchar(254) 
,ethnicity              varchar(254) 
,mapped_ethnicity       varchar(254)
,vital_status           varchar(254) 
,vital_status_date      timestamp   
,zip                    varchar(60) 
,country                varchar(66)
,state                    varchar(254)
,ruca_code                varchar(254)
,constraint patient_pk primary key (site_source, patient_id)
);

truncate table patient;
load data local infile "./Patient.csv"
into table patient
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
-- The date is formatted differently in the csv files, so we need to manually parse it
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11, @col12, @col13, @col14, @col15)
set patient_id = @col1,
site_source = @col2,
date_of_birth = STR_TO_DATE(@col3, '%m/%d/%Y %H:%i'),
gender = @col4,
race1 = @col5,
race2 = @col6,
mapped_race = @col7,
ethnicity = @col8,
mapped_ethnicity = @col9,
vital_status = @col10,
vital_status_date = STR_TO_DATE(@col11, '%m/%d/%Y %H:%i'),
zip = @col12,
country = @col13,
state = @col14,
ruca_code = @col15;

-- Encounter

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

truncate table encounter;
load data local infile "./Encounter.csv"
into table encounter
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11, @col12, @col13)
set site_source = @col1,
department_id = @col2,
patient_id = @col3,
encounter_id = @col4,
epic_encounter_type_id = @col5,
encounter_date = STR_TO_DATE(@col6, '%m/%d/%Y %H:%i'),
admit_date = STR_TO_DATE(@col7, '%m/%d/%Y %H:%i'),
discharge_date = STR_TO_DATE(@col8, '%m/%d/%Y %H:%i'),
hospital_discharge_disposition = @col9,
ed_disposition = @col10,
pcornet_visit_type = @col11,
visit_provider_id = @col12,
appointment_status = @col13;

-- Diagnosis

drop table diagnosis cascade;
create table diagnosis      
(encounter_id            numeric(38)    
,site_source             numeric(2)     
,diagnosis_source        varchar(10)   
,diagnosis_timestamp      timestamp      -- Column name is diagnosis_datetime in the csv file 
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

truncate table diagnosis;
load data local infile "./Diagnosis.csv"
into table diagnosis
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
set encounter_id = @col1,
site_source = @col2,
diagnosis_source = @col3,
diagnosis_timestamp = STR_TO_DATE(@col4, '%m/%d/%Y %H:%i'),
icd_type = @col5,
icd_code = @col6,
primary_dx_flag = @col7;

-- Vital Signs

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

truncate table vital_sign;
load data local infile "./Vital_Sign.csv"
into table vital_sign
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@col1, @col2, @col3, @col4, @col5, @col6, @col7)
set encounter_id = @col1,
site_source = @col2,
vital_sign_type = @col3,
vital_sign_value = @col4,
vital_sign_taken_date = STR_TO_DATE(@col5, '%m/%d/%Y %H:%i');

-- Labs

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

truncate table lab;
load data local infile "./Lab.csv"
into table lab
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11, @col12, @col13)
set encounter_id = @col1,
component_id = @col2,
site_source = @col3,
component_name = @col4,
procedure_id = @col5,
procedure_description = @col6,
time_ordered = STR_TO_DATE(@col7, '%m/%d/%Y %H:%i'),
time_taken = STR_TO_DATE(@col8, '%m/%d/%Y %H:%i'),
time_results = STR_TO_DATE(@col9, '%m/%d/%Y %H:%i'),
text_results = @col10,
numeric_results = @col11,
reference_units = @col12,
loinc_id = @col13;

-- Medications

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

truncate table medication;
load data local infile "./Medication.csv"
into table medication
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11, @col12, @col13, @col14, @col15, @col16, @col17, @col18, @col19, @col20)
set encounter_id = @col1,
order_med_id = @col2,
site_source = @col3,
order_date = STR_TO_DATE(@col4, '%m/%d/%Y %H:%i'),
start_date = STR_TO_DATE(@col5, '%m/%d/%Y %H:%i'),
end_date = STR_TO_DATE(@col6, '%m/%d/%Y %H:%i'),
epic_medication_id = @col7,
epic_medication_name = @col8,
generic_name = @col9,
pharm_class = @col10,
pharm_subclass = @col11,
rxnorm_cui_scd = @col12,
rxnorm_name = @col13,
quantity = @col14,
refills = @col15,
dose = @col16,
dose_unit = @col17,
time_taken = STR_TO_DATE(@col18, '%m/%d/%Y %H:%i'),
frequency = @col19,
ordering_mode = @col20;

-- Patient Condition

drop table patient_condition cascade;
create table patient_condition
(site_source               numeric(38)   
,patient_id                numeric(38)   
,condition_category_id     varchar(20) 
,condition_date             timestamp           
,constraint patient_condition_patient_fk 
 foreign key (site_source, patient_id)
 references patient (site_source, patient_id)
 on delete cascade on update cascade
,constraint patient_condition_condcat_fk 
 foreign key (condition_category_id)
 references condition_category (condition_category_id)
 on delete cascade on update cascade
);

truncate table patient_condition;
load data local infile "./Patient_Condition.csv"
into table patient_condition
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@col1, @col2, @col3, @col4)
set site_source = @col1,
patient_id = @col2,
condition_category_id = @col3,
condition_date = STR_TO_DATE(@col4, '%m/%d/%Y %H:%i');

-- DRG

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

truncate table drg;
load data local infile "./DRG.csv"
into table drg
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- Procedures

drop table procedures cascade;
create table procedures
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

truncate table procedures;
load data local infile "./Procedures.csv"
into table procedures
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@col1, @col2, @col3, @col4, @col5, @col6)
set encounter_id = @col1,
site_source = @col2,
code = @col3,
code_type = @col4,
description = @col5,
procedure_date = STR_TO_DATE(@col6, '%m/%d/%Y %H:%i');

-- Social History

drop table social_history cascade;
create table social_history
(patient_id 		    numeric(38)
,encounter_id           numeric(38)    
,encounter_date         timestamp          
,SEXUALLY_ACTIVE        varchar(254)          
,FEMALE_PARTNER         varchar(254) 
,MALE_PARTNER           varchar(254) 
,SMOKING_STATUS         varchar(254) 
,TOBACCO_PACK_PER_DAY   varchar(254) 
,TOBACCO_USE_YEARS      varchar(254) 
,TOBACCO_USER           varchar(254)          
,CIGARETTES             varchar(254) 
,PIPES                  varchar(254) 
,CIGARS                 varchar(254) 
,SNUFF                  varchar(254) 
,CHEW                   varchar(254) 
,SMOKE_START_DATE       varchar(254) 
,SMOKE_END_DATE         varchar(254) 
,ALCOHOL_USER           varchar(254)          
,ALCOHOL_OUNCE_PER_WEEK varchar(254) 
,ALCOHOL_COMMENT        varchar(254) 
,ALCOHOL_TYPE           varchar(254) 
,IV_DRUG_USER           varchar(254) 
,ILLICIT_DRUG_FREQUENCY varchar(254) 
,ILLICIT_DRUG_COMMENT   varchar(254)
,ICD_Type               numeric(2)     
,icd_code               varchar(254)
,site_source            numeric(2)     
,date_of_birth          datetime          -- Changed to datetime to allow dates of birth before 1970
,gender                 varchar(254) 
,race1                  varchar(254) 
,race2                  varchar(254) 
,mapped_race            varchar(254) 
,ethnicity              varchar(254) 
,mapped_ethnicity       varchar(254)
,vital_status           varchar(254) 
,vital_status_date      timestamp   
,zip                    varchar(60) 
,country                varchar(66)
,state                  varchar(254)
,constraint social_history_encounter_fk 
 foreign key (site_source, encounter_id)
 references encounter (site_source, encounter_id)
 on delete cascade on update cascade
,constraint social_history_patient_fk 
 foreign key (site_source, patient_id)
 references patient (site_source, patient_id)
 on delete cascade on update cascade
);

truncate table social_history;
load data local infile "./Social_History.csv"
into table social_history
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(@col1, @col2, @col3, @col4, @col5, @col6, @col7, @col8, @col9, @col10, @col11, @col12, @col13, @col14, @col15, @col16, @col17, @col18, @col19, @col20, @col21, @col22, @col23, @col24, @col25, @col26, @col27, @col28, @col29, @col30, @col31, @col32, @col33, @col34, @col35, @col36, @col37, @col38, @col39)
patient_id = @col1,
encounter_id = @col2,
encounter_date = STR_TO_DATE(@col3, '%m/%d/%Y %H:%i'),
sexually_active = @col4,
female_partner = @col5,
male_partner = @col6,
smoking_status = @col7,
tobacco_pack_per_day = @col8,
tobacco_use_years = @col9,
tobacco_user = @col10,
cigarettes = @col11,
pipes = @col12,
cigars = @col13,
snuff = @col14,
chew = @col15,
smoke_start_date = @col16,
smoke_end_date = @col17,
alcohol_user = @col18,
alcohol_ounce_per_week = @col19,
alcohol_comment = @col20,
alcohol_type = @col21,
iv_drug_user = @col22,
illicit_drug_frequency = @col23,
illicit_drug_comment = @col24,
icd_type = @col25,
icd_code = @col26,
site_source = @col27,
date_of_birth = STR_TO_DATE(@col28, '%m/%d/%Y %H:%i'),
gender = @col29,
race1 = @col30,
race2 = @col31,
mapped_race = @col32,
ethnicity = @col33,
mapped_ethnicity = @col34,
vital_status = @col35,
vital_status = STR_TO_DATE(@col36, '%m/%d/%Y %H:%i'),
zip = @col37,
country = @col38,
state = @col39;

set foreign_key_checks = 1;
set autocommit = 1;
set unique_checks = 1;
set sql_log_bin = 1;
