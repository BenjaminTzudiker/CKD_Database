-- Provider - Specialty

drop table provider_specialty;
create table provider_specialty
(specialty_id int auto_increment not null primary key
,specialty varchar(254)
);

insert into provider_specialty (specialty)
select distinct specialty
from provider;

alter table provider
add column specialty_id int;

alter table provider
add constraint provider_specialty_fk 
foreign key (specialty_id) 
references provider_specialty (specialty_id) 
on delete cascade on update cascade;

update provider
left join provider_specialty
on provider.specialty = provider_specialty.specialty
set provider.specialty_id = provider_specialty.specialty_id;

alter table provider
drop column specialty;

-- Patient - Gender

drop table patient_gender;
create table patient_gender
(gender_id int auto_increment not null primary key
,gender varchar(254)
);

insert into patient_gender (gender)
select distinct gender
from patient;

alter table patient
add column gender_id int;

alter table patient
add constraint patient_gender_fk 
foreign key (gender_id) 
references patient_gender (gender_id) 
on delete cascade on update cascade;

update patient
left join patient_gender
on patient.gender = patient_gender.gender
set patient.gender_id = patient_gender.gender_id;

alter table patient
drop column gender;

-- Patient - Mapped_Race

drop table patient_race;
create table patient_race
(race_id int auto_increment not null primary key
,race varchar(254)
);

insert into patient_race (race)
select distinct mapped_race
from patient;

alter table patient
add column mapped_race_id int;

alter table patient
add constraint patient_mapped_race_fk 
foreign key (mapped_race_id) 
references patient_race (race_id) 
on delete cascade on update cascade;

update patient
left join patient_race
on patient.mapped_race = patient_race.race
set patient.mapped_race_id = patient_race.race_id;

alter table patient
drop column mapped_race;

-- Patient - Race1

alter table patient
add column race1_id int;

alter table patient
add constraint patient_race1_fk 
foreign key (race1_id) 
references patient_race (race_id) 
on delete cascade on update cascade;

update patient
left join patient_race
on patient.race1 = patient_race1.race1
set patient.race1_id = patient_race1.race1_id;

alter table patient
drop column race1;

-- Patient - Race2

alter table patient
add column race2_id int;

alter table patient
add constraint patient_race2_fk 
foreign key (race2_id) 
references patient_race (race_id) 
on delete cascade on update cascade;

update patient
left join patient_race
on patient.race2 = patient_race.race
set patient.race2_id = patient_race.race_id;

alter table patient
drop column race2;

-- Patient - Mapped_Ethnicity

drop table patient_ethnicity;
create table patient_ethnicity
(ethnicity_id int auto_increment not null primary key
,ethnicity varchar(254)
);

insert into patient_ethnicity (ethnicity)
select distinct mapped_ethnicity
from patient;

alter table patient
add column mapped_ethnicity_id int;

alter table patient
add constraint patient_mapped_ethnicity_fk 
foreign key (mapped_ethnicity_id) 
references patient_ethnicity (ethnicity_id) 
on delete cascade on update cascade;

update patient
left join patient_ethnicity
on patient.mapped_ethnicity = patient_ethnicity.ethnicity
set patient.mapped_ethnicity_id = patient_ethnicity.ethnicity_id;

alter table patient
drop column mapped_ethnicity;

-- Patient - Ethnicity

alter table patient
add column ethnicity_id int;

alter table patient
add constraint patient_ethnicity_fk 
foreign key (ethnicity_id) 
references patient_ethnicity (ethnicity_id) 
on delete cascade on update cascade;

update patient
left join patient_ethnicity
on patient.ethnicity = patient_ethnicity.ethnicity
set patient.ethnicity_id = patient_ethnicity.ethnicity_id;

alter table patient
drop column ethnicity;

-- Patient - Vital_Status

drop table patient_vital_status;
create table patient_vital_status
(vital_status_id int auto_increment not null primary key
,vital_status varchar(60)
);

insert into patient_vital_status (vital_status)
select distinct vital_status
from patient;

alter table patient
add column vital_status_id int;

alter table patient
add constraint patient_vital_status_fk 
foreign key (vital_status_id) 
references patient_vital_status (vital_status_id) 
on delete cascade on update cascade;

update patient
left join patient_vital_status
on patient.vital_status = patient_vital_status.vital_status
set patient.vital_status_id = patient_vital_status.vital_status_id;

alter table patient
drop column vital_status;

-- Patient - Country

drop table patient_country;
create table patient_country
(country_id int auto_increment not null primary key
,country varchar(66)
);

insert into patient_country (country)
select distinct country
from patient;

alter table patient
add column country_id int;

alter table patient
add constraint patient_country_fk 
foreign key (country_id) 
references patient_country (country_id) 
on delete cascade on update cascade;

update patient
left join patient_country
on patient.country = patient_country.country
set patient.country_id = patient_country.country_id;

alter table patient
drop column country;

-- Patient - State

drop table patient_state;
create table patient_state
(state_id int auto_increment not null primary key
,state varchar(254)
);

insert into patient_state (state)
select distinct state
from patient;

alter table patient
add column state_id int;

alter table patient
add constraint patient_state_fk 
foreign key (state_id) 
references patient_state (state_id) 
on delete cascade on update cascade;

update patient
left join patient_state
on patient.state = patient_state.state
set patient.state_id = patient_state.state_id;

alter table patient
drop column state;

-- Patient - RUCA_Code

drop table patient_ruca_code;
create table patient_ruca_code
(ruca_code_id int auto_increment not null primary key
,ruca_code varchar(254)
);

insert into patient_ruca_code (ruca_code)
select distinct ruca_code
from patient;

alter table patient
add column ruca_code_id int;

alter table patient
add constraint patient_ruca_code_fk 
foreign key (ruca_code_id) 
references patient_ruca_code (ruca_code_id) 
on delete cascade on update cascade;

update patient
left join patient_ruca_code
on patient.ruca_code = patient_ruca_code.ruca_code
set patient.ruca_code_id = patient_ruca_code.ruca_code_id;

alter table patient
drop column ruca_code;

-- Diagnosis - Diagnosis_Source

drop table diagnosis_diagnosis_source;
create table diagnosis_diagnosis_source
(diagnosis_source_id int auto_increment not null primary key
,diagnosis_source varchar(10)
);

insert into diagnosis_diagnosis_source (diagnosis_source)
select distinct diagnosis_source
from diagnosis;

alter table diagnosis
add column diagnosis_source_id int;

alter table diagnosis
add constraint diagnosis_diagnosis_source_fk 
foreign key (diagnosis_source_id) 
references diagnosis_diagnosis_source (diagnosis_source_id) 
on delete cascade on update cascade;

update diagnosis
left join diagnosis_diagnosis_source
on diagnosis.diagnosis_source = diagnosis_diagnosis_source.diagnosis_source
set diagnosis.diagnosis_source_id = diagnosis_diagnosis_source.diagnosis_source_id;

alter table diagnosis
drop column diagnosis_source;

-- Vital_Sign - Vital_Sign_Type

drop table vital_sign_vital_sign_type;
create table vital_sign_vital_sign_type
(vital_sign_type_id int auto_increment not null primary key
,vital_sign_type varchar(254)
);

insert into vital_sign_vital_sign_type (vital_sign_type)
select distinct vital_sign_type
from vital_sign;

alter table vital_sign
add column vital_sign_type_id int;

alter table vital_sign
add constraint vital_sign_vital_sign_type_fk 
foreign key (vital_sign_type_id) 
references vital_sign_vital_sign_type (vital_sign_type_id) 
on delete cascade on update cascade;

update vital_sign
left join vital_sign_vital_sign_type
on vital_sign.vital_sign_type = vital_sign_vital_sign_type.vital_sign_type
set vital_sign.vital_sign_type_id = vital_sign_vital_sign_type.vital_sign_type_id;

alter table vital_sign
drop column vital_sign_type;

-- Labs - Component_Name

drop table lab_component_name;
create table lab_component_name
(component_name_id int auto_increment not null primary key
,component_name varchar(75)
);

insert into lab_component_name (component_name)
select distinct component_name
from lab;

alter table lab
add column component_name_id int;

alter table lab
add constraint lab_component_name_fk 
foreign key (component_name_id) 
references lab_component_name (component_name_id) 
on delete cascade on update cascade;

update lab
left join lab_component_name
on lab.component_name = lab_component_name.component_name
set lab.component_name_id = lab_component_name.component_name_id;

alter table lab
drop column component_name;

-- Labs - Reference_Units

drop table lab_reference_units;
create table lab_reference_units
(reference_units_id int auto_increment not null primary key
,reference_units varchar(100)
);

insert into lab_reference_units (reference_units)
select distinct reference_units
from lab;

alter table lab
add column reference_units_id int;

alter table lab
add constraint lab_reference_units_fk 
foreign key (reference_units_id) 
references lab_reference_units (reference_units_id) 
on delete cascade on update cascade;

update lab
left join lab_reference_units
on lab.reference_units = lab_reference_units.reference_units
set lab.reference_units_id = lab_reference_units.reference_units_id;

alter table lab
drop column reference_units;

-- Medication - Epic_Medication_Name

drop table medication_epic_medication_name;
create table medication_epic_medication_name
(epic_medication_name_id int auto_increment not null primary key
,epic_medication_name varchar(255)
);

insert into medication_epic_medication_name (epic_medication_name)
select distinct epic_medication_name
from medication;

alter table medication
add column epic_medication_name_id int;

alter table medication
add constraint medication_epic_medication_name_fk 
foreign key (epic_medication_name_id) 
references medication_epic_medication_name (epic_medication_name_id) 
on delete cascade on update cascade;

update medication
left join medication_epic_medication_name
on medication.epic_medication_name = medication_epic_medication_name.epic_medication_name
set medication.epic_medication_name_id = medication_epic_medication_name.epic_medication_name_id;

alter table medication
drop column epic_medication_name;

-- Medication - Generic_Name

drop table medication_generic_name;
create table medication_generic_name
(generic_name_id int auto_increment not null primary key
,generic_name varchar(200)
);

insert into medication_generic_name (generic_name)
select distinct generic_name
from medication;

alter table medication
add column generic_name_id int;

alter table medication
add constraint medication_generic_name_fk 
foreign key (generic_name_id) 
references medication_generic_name (generic_name_id) 
on delete cascade on update cascade;

update medication
left join medication_generic_name
on medication.generic_name = medication_generic_name.generic_name
set medication.generic_name_id = medication_generic_name.generic_name_id;

alter table medication
drop column generic_name;

-- Medication - Pharm_Class

drop table medication_pharm_class;
create table medication_pharm_class
(pharm_class_id int auto_increment not null primary key
,pharm_class varchar(254)
);

insert into medication_pharm_class (pharm_class)
select distinct pharm_class
from medication;

alter table medication
add column pharm_class_id int;

alter table medication
add constraint medication_pharm_class_fk 
foreign key (pharm_class_id) 
references medication_pharm_class (pharm_class_id) 
on delete cascade on update cascade;

update medication
left join medication_pharm_class
on medication.pharm_class = medication_pharm_class.pharm_class
set medication.pharm_class_id = medication_pharm_class.pharm_class_id;

alter table medication
drop column pharm_class;

-- Medication - Pharm_SubClass

drop table medication_pharm_subclass;
create table medication_pharm_subclass
(pharm_subclass_id int auto_increment not null primary key
,pharm_subclass varchar(254)
);

insert into medication_pharm_subclass (pharm_subclass)
select distinct pharm_subclass
from medication;

alter table medication
add column pharm_subclass_id int;

alter table medication
add constraint medication_pharm_subclass_fk 
foreign key (pharm_subclass_id) 
references medication_pharm_subclass (pharm_subclass_id) 
on delete cascade on update cascade;

update medication
left join medication_pharm_subclass
on medication.pharm_subclass = medication_pharm_subclass.pharm_subclass
set medication.pharm_subclass_id = medication_pharm_subclass.pharm_subclass_id;

alter table medication
drop column pharm_subclass;

-- Procedure - Code_Type

drop table procedure_code_type;
create table procedure_code_type
(code_type_id int auto_increment not null primary key
,code_type varchar(254)
);

insert into procedure_code_type (code_type)
select distinct code_type
from procedure;

alter table procedure
add column code_type_id int;

alter table procedure
add constraint procedure_code_type_fk 
foreign key (code_type_id) 
references procedure_code_type (code_type_id) 
on delete cascade on update cascade;

update procedure
left join procedure_code_type
on procedure.code_type = procedure_code_type.code_type
set procedure.code_type_id = procedure_code_type.code_type_id;

alter table procedure
drop column code_type;

-- Views

create view provider_view
as select provider.site_source, provider.visit_provider_id, provider_specialty.specialty
from provider inner join provider_specialty on provider.specialty_id = provider_specialty.specialty_id;

create view patient_view
as select patient.patient_id, patient.site_source, patient.date_of_birth, patient_gender.gender,
patient_race1.race as race1, patient_race2.race as race2, patient_mapped_race.race as mapped_race,
patient_ethnicity1.ethnicity as ethnicity, patient_mapped_ethnicity.ethnicity as mapped_ethnicity,
patient_vital_status.vital_status, patient.vital_status_date, patient.zip, patient_country.country,
patient_state.state, patient_ruca_code.ruca_code from patient
inner join patient_gender on patient.gender_id = patient_gender.gender_id
inner join patient_race as patient_race1 on patient.race1_id = patient_race1.race_id
inner join patient_race as patient_race2 on patient.race2_id = patient_race2.race_id
inner join patient_race as patient_mapped_race on patient.mapped_race_id = patient_mapped_race.race_id
inner join patient_ethnicity as patient_ethnicity1 on patient.ethnicity_id = patient_ethnicity1.ethnicity_id
inner join patient_ethnicity as patient_mapped_ethnicity on patient.mapped_ethnicity_id = patient_mapped_ethnicity.ethnicity_id
inner join patient_country on patient.country_id = patient_country.country_id
inner join patient_state on patient.state_id = patient_state.state_id
inner join patient_ruca_code on patient.ruca_code_id = patient_ruca_code.ruca_code_id;

create view diagnosis_view
as select diagnosis.encounter_id, diagnosis.site_source, diagnosis_diagnosis_source.diagnosis_source,
diagnosis.diagnosis_datetime, diagnosis.icd_type, diagnosis.icd_code, diagnosis.promary_dc_flag
from diagnosis inner join diagnosis_diagnosis_source on diagnosis.diagnosis_source_id = diagnosis_diagnosis_source.diagnosis_source_id;

create view vital_sign_view
as select vital_sign.encounter_id, vital_sign.site_source, vital_sign_vital_sign_type.vital_sign_type,
vital_sign.vital_sign_value, vital_sign.vital_sign_taken_date
from vital_sign inner join vital_sign_vital_sign_type on vital_sign.vital_sign_type_id = vital_sign_vital_sign_type.vital_sign_type_id;

create view lab_view
as select lab.encounter_id, lab.component_id, lab.site_source, lab_component_name.component_name, lab.procedure_id,
lab.procedure_description, lab.time_ordered, lab.time_taken, lab.time_results, lab.text_results, lab.numeric_results,
lab_reference_units.reference_units, lab.loinc_id from lab
inner join lab_component_name on lab.component_name_id = lab_component_name.component_name_id
inner join lab_reference_units on lab.reference_units_id = lab_reference_units.reference_units_id;

create view medication_view
as select medication.encounter_id, medication_site_source, medication_order_med_id, medication_order_date, medication_start_date,
medication.end_date, medication.epic_medication_id, medication_epic_medication_name.epic_medication_name, medication_generic_name.generic_name,
medication_pharm_class.pharm_class, medication_pharm_subclass.pharm_subclass, medication.rxnorm_cui_scd, medication.rxnorm_name,
medication.quantity, medication.refills, medication.dose, medication.dose_unit, medication.time_taken from medication
inner join medication_epic_medication_name on medication.epic_medication_name_id = medication_epic_medication_name.epic_medication_name_id
inner join medication_generic_name on medication.generic_name_id = medication_generic_name.generic_name_id
inner join medication_pharm_class on medication.pharm_class_id = medication_pharm_class.pharm_class_id
inner join medication_pharm_subclass on medication.pharm_subclass_id = medication_pharm_subclass.pharm_subclass_id;

create view procedure_view
as select procedure.encounter_id, procedure.site_source, procedure.code, procedure_code_type.code_type,
procedure.description, procedure.procedure_date from procedure
inner join procedure_code_type on procedure.code_type_id = procedure_code_type.code_type_id;
