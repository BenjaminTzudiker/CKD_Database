create table SHistEncounter
(patient_id 		 numeric(38)
,encounter_id                        numeric(38)    
,encounter_date                      timestamp          
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
,ILLICIT_DRUG_COMMENT		TEXT
);


truncate table SHistEncounter;
INSERT INTO SHistEncounter ( patient_id, encounter_id, encounter_date,
sexually_active, female_partner, male_partner, 
smoking_status, tobacco_pack_per_day, tobacco_use_years, 
tobacco_user, CIGARETTES, PIPES, CIGARS, SNUFF, 
CHEW, smoke_Start_date, smoke_end_date, alcohol_user, 
alcohol_ounce_per_week, alcohol_comment, alcohol_type,
iv_drug_user, illicit_drug_frequency,illicit_drug_comment )
select encounter.patient_id, encounter.encounter_id, encounter.encounter_date,
social_history.sexually_active, social_history.female_partner, social_history.male_partner, 
social_history.smoking_status, social_history.tobacco_pack_per_day, social_history.tobacco_use_years, 
social_history.tobacco_user, social_history.CIGARETTES, social_history.PIPES, social_history.CIGARS, social_history.SNUFF, 
social_history.CHEW, social_history.smoke_Start_date, social_history.smoke_end_date, social_history.alcohol_user, 
social_history.alcohol_ounce_per_week, social_history.alcohol_comment, social_history.alcohol_type,
social_history.iv_drug_user, social_history.illicit_drug_frequency, social_history.illicit_drug_comment
from encounter 
inner join social_history on social_history.encounter_id=encounter.encounter_id;

ALTER TABLE SHistEncounter ADD CONSTRAINT SHistEncounter_pk PRIMARY KEY (patient_id, encounter_id);


create table SHistEncounterDiagn
(id 		SERIAL
,patient_id 		 numeric(38)
,encounter_id                        numeric(38)    
,encounter_date                      timestamp          
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
,ILLICIT_DRUG_COMMENT		TEXT
,ICD_Type                numeric(2)     
,icd_code                varchar(254)
);

truncate table SHistEncounterDiagn;
INSERT INTO SHistEncounterDiagn ( patient_id, encounter_id, encounter_date,
sexually_active, female_partner, male_partner, 
smoking_status, tobacco_pack_per_day, tobacco_use_years, 
tobacco_user, CIGARETTES, PIPES, CIGARS, SNUFF, 
CHEW, smoke_Start_date, smoke_end_date, alcohol_user, 
alcohol_ounce_per_week, alcohol_comment, alcohol_type,
iv_drug_user, illicit_drug_frequency,illicit_drug_comment, ICD_Type, icd_code )
select SHistEncounter.patient_id, SHistEncounter.encounter_id, SHistEncounter.encounter_date,
SHistEncounter.sexually_active, SHistEncounter.female_partner, SHistEncounter.male_partner, 
SHistEncounter.smoking_status, SHistEncounter.tobacco_pack_per_day, SHistEncounter.tobacco_use_years, 
SHistEncounter.tobacco_user, SHistEncounter.CIGARETTES, SHistEncounter.PIPES, SHistEncounter.CIGARS, SHistEncounter.SNUFF, 
SHistEncounter.CHEW, SHistEncounter.smoke_Start_date, SHistEncounter.smoke_end_date, SHistEncounter.alcohol_user, 
SHistEncounter.alcohol_ounce_per_week, SHistEncounter.alcohol_comment, SHistEncounter.alcohol_type,
SHistEncounter.iv_drug_user, SHistEncounter.illicit_drug_frequency, SHistEncounter.illicit_drug_comment, diagnosis.icd_type, diagnosis.icd_code
from SHistEncounter 
inner join diagnosis on diagnosis.encounter_id=SHistEncounter.encounter_id;


ALTER TABLE SHistEncounterDiagn ADD CONSTRAINT SHistEncounterDiagn_pk PRIMARY KEY (id, patient_id, encounter_id, icd_code);


create table SHistEncounterDiagnPatient
(id 		SERIAL
,patient_id 		 numeric(38)
,encounter_id                        numeric(38)    
,encounter_date                      timestamp          
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
,ILLICIT_DRUG_COMMENT		TEXT
,ICD_Type                numeric(2)     
,icd_code                varchar(254)
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
);

truncate table SHistEncounterDiagnPatient;
INSERT INTO SHistEncounterDiagnPatient ( patient_id, encounter_id, encounter_date,
sexually_active, female_partner, male_partner, 
smoking_status, tobacco_pack_per_day, tobacco_use_years, 
tobacco_user, CIGARETTES, PIPES, CIGARS, SNUFF, 
CHEW, smoke_Start_date, smoke_end_date, alcohol_user, 
alcohol_ounce_per_week, alcohol_comment, alcohol_type,
iv_drug_user, illicit_drug_frequency,illicit_drug_comment, ICD_Type, icd_code,
site_source,date_of_birth, gender,
race1, race2, mapped_race, ethnicity, 
mapped_ethnicity, vital_status,vital_status_date, zip,country, state)
select SHistEncounterDiagn.patient_id, SHistEncounterDiagn.encounter_id, SHistEncounterDiagn.encounter_date,
SHistEncounterDiagn.sexually_active, SHistEncounterDiagn.female_partner, SHistEncounterDiagn.male_partner, 
SHistEncounterDiagn.smoking_status, SHistEncounterDiagn.tobacco_pack_per_day, SHistEncounterDiagn.tobacco_use_years, 
SHistEncounterDiagn.tobacco_user, SHistEncounterDiagn.CIGARETTES, SHistEncounterDiagn.PIPES, SHistEncounterDiagn.CIGARS, SHistEncounterDiagn.SNUFF, 
SHistEncounterDiagn.CHEW, SHistEncounterDiagn.smoke_Start_date, SHistEncounterDiagn.smoke_end_date, SHistEncounterDiagn.alcohol_user, 
SHistEncounterDiagn.alcohol_ounce_per_week, SHistEncounterDiagn.alcohol_comment, SHistEncounterDiagn.alcohol_type,
SHistEncounterDiagn.iv_drug_user, SHistEncounterDiagn.illicit_drug_frequency, SHistEncounterDiagn.illicit_drug_comment, SHistEncounterDiagn.icd_type, SHistEncounterDiagn.icd_code,
patient.site_source, patient.date_of_birth, patient.gender,
patient.race1, patient.race2, patient.mapped_race, patient.ethnicity, 
patient.mapped_ethnicity, patient.vital_status, patient.vital_status_date, patient.zip, patient.country, patient.state
from SHistEncounterDiagn 
inner join patient on patient.patient_id=SHistEncounterDiagn.patient_id;


ALTER TABLE SHistEncounterDiagnPatient ADD CONSTRAINT SHistEncounterDiagnPatient_pk PRIMARY KEY (id, patient_id, encounter_id);
