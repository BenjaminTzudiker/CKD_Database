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

create view provider_view
as select provider.site_source, provider.visit_provider_id, provider_specialty.specialty
from provider inner join provider_specialty on provider.specialty_id = provider_specialty.specialty_id;
