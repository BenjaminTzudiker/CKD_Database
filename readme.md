## Creating the Database

### Preparation

#### Installing MySQL

To begin, you will need the csv files that will be imported into the database. Next, install MySQL for your operating system, which is available [here](https://dev.mysql.com/downloads/mysql/). Creating the tables should work in Postgres or other similar database management systems with only small modifications, but importing files might be quite different.

Launch your preferred command line application - most likely Command Prompt in Windows or Terminal in MacOS or Linux. Before starting MySQL, change your working directory to the folder storing your csv files using the `cd [path to folder]` command.

#### Launching MySQL

[Launch the MySQL server](https://dev.mysql.com/doc/refman/8.0/en/windows-start-command-line.html) if it isn't [online already](https://dev.mysql.com/doc/refman/8.0/en/show-status.html), and connect to it using the following command.

```sql
mysql -u <user> [-p] --local-infile
```

If you're unsure of which user to specify, try `root`. If the user has a password associated with it, include the `-p` flag and enter the password when prompted.

Next, you'll need to create the database if one doesn't already exist.

```sql
create database ckd;
use ckd;
```

#### Setting buffer sizes

Before running the Create_Tables_New.sql script, it is reccomended that you change the buffer pool options for InnoDB to something appropriate for your computer. The two options are marked as `innodb_buffer_pool_size` and `innodb_log_buffer_size` located near the top of the file. The  values in the script are 2G and 256M, but these are rather conservative. Increasing these values might noticeably speed up the import process. For a computer that is not going to do other intensive work during the import, setting `innodb_buffer_pool_size` to up to 80% of your system's RAM will likely be close to optimal. Setting `innodb_log_buffer_size` at its original or lower value is fine. Setting them too high can be detrimental, as it might cause unnecessary paging. These options will have no impact if you are using another database storage engine [like MyISAM](https://dev.mysql.com/doc/refman/8.0/en/myisam-key-cache.html).

### Creating/Loading the Tables

#### Running the main script file

Still in SQL, run the Create_Tables_New.sql script. This file will create all the tables according to the CKD data dictionary document (with a handful of small exceptions marked in the file) and load the information from the csv files into them.

```sql
source <path_to_script>;
```

This could easily take days to execute, as there is lots of data that needs to be imported.

#### Progress

By default, the import command does not say how far along it is. If you are using InnoDB, the following command can be used to check how many rows have been imported from the current file. Connect to MySQL in another command line window and enter it.

```sql
show engine innodb status;
```

Look for "undo log entries", which should be followed by the number of rows. Some examples of commands to find the total number of lines in a file are `wc -l <path_to_file>` for Unix systems or `find /c /v ""` for Winodws - the proportion of completed rows to total rows should give a rough estimate of progress. Note that an import will likely slow down once the buffer pool runs out.

Other information - for example, the number of seconds spent executing the current query or how much of the buffer is in use - can be found elsewhere in the status.

### (Optional) Normalizing/Indexing the Database

#### Normalizing

There is another script called Normalize_Tables.sql that will separate a handful of tables to remove some (but not all - notable exceptions include the ICD codes from the diagnosis table, although removing more duplicates is fairly striaghtforward) of the duplicate strings. While entirely optional, it might significantly recude the storage space required for some tables. The script is meant to be called after creating the original tables as per the previous instructions - if you know you'll want to normalize them, it might be more efficient to modify the import script to load the csv files directly into separte tables.

Running this script will mean that the database is no longer structured internally according to the CKD data dictionary document. However, the script creates a view for each table that joins the information automatically to get the original setup.

#### Indexing

If you anticipate the need to perform lots of intensive queries, it might be smart to index parts of the database. The main script doesn't index in order to speed up the import.

### Querying the Database

#### Quick Examples

You can now query the database to get all kinds of useful and/or interesting information. For example, this query shows what percentage of providers fall under each listed specialty, ignoring unspecified entries.

Unnormalized:

```sql
select specialty as Specialty, count(visit_provider_id) as Providers, count(visit_provider_id)/(select count(visit_provider_id) from provider where not specialty = 'Unspecified Primary Specialty')*100 as Percent from provider where not specialty = 'Unspecified Primary Specialty' group by specialty order by count(visit_provider_id) desc;
```

Normalized, using the view as a stand-in for the original table:

```sql
select specialty as Specialty, count(visit_provider_id) as Providers, count(visit_provider_id)/(select count(visit_provider_id) from provider_view where not specialty = 'Unspecified Primary Specialty')*100 as Percent from provider_view where not specialty = 'Unspecified Primary Specialty' group by specialty order by count(visit_provider_id) desc;
```

Normalized, comparing IDs instead of full strings:

```sql
select provider_specialty.specialty as Specialty, count(visit_provider_id) as Providers, count(visit_provider_id)/(select count(visit_provider_id) from provider where not provider.specialty_id = (select provider_specialty.specialty_id from provider_specialty where specialty = 'Unspecified Primary Specialty'))*100 as Percent from provider inner join provider_specialty on provider.specialty_id = provider_specialty.specialty_id where not provider.specialty_id = (select provider_specialty.specialty_id from provider_specialty where specialty = 'Unspecified Primary Specialty') group by specialty order by count(visit_provider_id) desc;
```

Since columns like specialty_id might show up in multiple tables, it can be important to specify where they come from. In this case, comparing by IDs in the normalized table produces a more complicated SQL statement (although much of the complexity is removed if we know the ID of "Unspecified Primary Specialty" beforehand), but comparing integers is generally faster than comparing strings.

#### CKD/More Complicated Queries

Using the power of our new database, we can start to find relevant information across multiple tables. Say we want information on Chronic Kidney Disease. Information on who is affected by CKD would likely be found in the diagnosis table - and indeed, there is a column that lists the ICD codes for every diagnosis. [Using the internet](https://icdcodelookup.com/icd-10/codes/Chronic%20Kidney%20Disease), we can start to narrow down which codes we're actually interested in. While the diagnosis table doesn't contain all the information we need directly, every row does contain an encounter ID. Using this ID, we can find the corresponding row in the encounter table, and from there find the patient ID to link us to the patient table.

How would these queries look? Let's start out by selecting all the diagnoses related to CKD. For this example, we'll just get the encounter IDs for every instance of the "N18" ICD code. Note that with large tables, these queries are probably going to take a bit of time.

```sql
select diagnosis.encounter_id from diagnosis where diagnosis.icd_code = 'N18';
```

We could add in/replace that with other codes depending on what we want to find out about. If we wanted a look at every encounter related to CKD, we could add in codes like E08.22 - E13.22, O10.2 - O10.3, and so on. There are plenty of ways to refine your queries to get exactly the information you need.

This is neat, but a list of numbers isn't directly helpful. We'll need more complicated queries to get actually useful information. To start out, let's see how many diagnosis records there are with the "N18" code.

```sql
select count(*) from diagnosis where diagnosis.icd_code = 'N18';
```

Potentially interesting, but there's still a lot more we can do. Next, we'll use a nested select statement to pull up all the patient IDs associated with the "N18" ICD code.

```sql
select encounter.patient_id from encounter where encounter.encounter_id in (select diagnosis.encounter_id from diagnosis where diagnosis.icd_code = 'N18');
```

We could even go the other direction and find all the encounter IDs for every patient associated with CKD.

```sql
select encounter.encounter_id from encounter where encounter.patient_id in (select encounter.patient_id from encounter where encounter.encounter_id in (select diagnosis.encounter_id from diagnosis where diagnosis.icd_code = 'N18'));
```

If we want to use a quadruple select statement, we could even get all the diagnoses for every patient with the "N18" code.

```sql
select diagnosis.diagnosis_id from diagnosis where diagnosis.encounter_id in (select encounter.encounter_id from encounter where encounter.patient_id in (select encounter.patient_id from encounter where encounter.encounter_id in (select diagnosis.encounter_id from diagnosis where diagnosis.icd_code = 'N18')));
```

Again, that's neat, but this still hasn't helped us gain much of an understanding about CKD. What if we combined the last two sections and queried for the 50 most common diagnoses for people with CKD?

```sql
select a.icd_code as 'ICD Code', count(a.icd_code) as 'Number of Diagnoses' from (select diagnosis.diagnosis_id from diagnosis where diagnosis.encounter_id in (select encounter.encounter_id from encounter where encounter.patient_id in (select encounter.patient_id from encounter where encounter.encounter_id in (select diagnosis.encounter_id from diagnosis where diagnosis.icd_code = 'N18')))) a group by a.icd_code order by count(a.icd_code) desc limit 50;
```

We can compare this to the overall numbers for all diagnoses.

```sql
select icd_code as 'ICD Code', count(icd_code) as 'Number of Diagnoses' from diagnosis group by icd_code order by count(icd_code) desc limit 50;
```

This is only a taste - there are all sorts of useful queries you can perform with an understanding of the data and a bit of thought.

### Common Problems

#### MySQL won't start - `mysql` gives a "command not found" or similar error

Assuming you installed MySQL properly, this is most likely because MySQL is not added to your system's PATH variable. To fix this, either [add MySQL to the PATH](https://dev.mysql.com/doc/mysql-windows-excerpt/5.7/en/mysql-installation-windows-path.html) or specify the path to the MySQL executable manually. For the second option, you will need to find the location of the MySQL executable, which varies between installations and operating systems. Some possible locations are listed below.

Windows:

```
C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe
```

Mac:

```
/usr/local/mysql/bin/mysql
```

Version numbers may be different, and the /usr folder on Mac (most likely located in the root "/" directory, not the "~" user directory) might be hidden by default. Logging into the database should now look something like this.

Windows:

```
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u <user> [-p] --local-infile
```

Mac:

```
/usr/local/mysql/bin/mysql -u <user> [-p] --local-infile
```

#### MySQL error on load data local infile - "The used command is not allowed with this MySQL version"

You most likely omitted the `--local-infile` flag when connecting to MySQL. For security reasons, `load data local infile` is restricted by default. You can enable local file loading globally with the following command in MySQL.

```sql
set global local_infile = 1;
```

#### MySQL error on load data local infile - "File './filename' not found"

MySQL couldn't locate one or more of the csv files. Make sure you changed the working directory to the location of all the files that need to be imported, and that all the files are named properly.