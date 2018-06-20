## Creating the Database

### Preparation

To begin, you will need the csv files that will be imported into the database. Next, install MySQL for your operating system, which is available [here](https://dev.mysql.com/downloads/mysql/). The scripts should work in Postgres or other similar database management systems with some small modifications.

Launch your preferred command line application - most likely Command Prompt in Windows or Terminal in MacOS or Linux. Before starting MySQL, change your working directory to the folder storing your csv files using the `cd [path to folder]` command. Next, launch the MySQL server, and connect to it using the following command.

```sql
mysql -u <user> [-p] --local-infile
```

If you're unsure which user to specify, try `root`. If the user has a password associated with it, include the `-p` flag and enter the password when prompted.

Next, you'll need to create the database if one doesn't already exist.

```sql
create database ckd;
use ckd;
```

Before running the Create_Tables_New.sql script, it is reccomended that you change the buffer pool options for InnoDB to something appropriate for your computer. The two options are marked as `innodb_buffer_pool_size` and `innodb_log_buffer_size` located near the top of the file. The  values in the script are 2G and 256M, but these are rather conservative. Increasing these values might noticeably speed up the import process. For a computer that is not going to do other intensive work during the import, setting `innodb_buffer_pool_size` to up to 80% of your system's RAM will likely be close to optimal. Setting `innodb_log_buffer_size` at its original or lower value is fine. Setting them too high can be detrimental, as it might cause unnecessary paging. These options will have no impact if you are using another database storage engine [like MyISAM](https://dev.mysql.com/doc/refman/8.0/en/myisam-key-cache.html).

### Creating/Loading the Tables

Still in SQL, run the Create_Tables_New.sql script.

```sql
source <path_to_script>;
```

This could easily take days to execute, as there are lots of data that need to be imported.

By default, the import command does not say how far along it is. If you are using InnoDB, the following command can be used to check how many rows have been imported from the current file. Connect to MySQL in another command line window and enter it.

```sql
show engine innodb status;
```

Look for "undo log entries", which should be followed by the number of rows. Other information - for example, the number of seconds spent executing the current query or how much of the buffer is in use - can be found elsewhere.

### (Optional) Normalizing the Database

There is another script called Normalize_Tables.sql that will separate a handful of tables to remove duplicate strings. While entirely optional, it might significantly recude the storage space required for some tables. The script is meant to be called after creating the original tables as per the previous instructions - if you know you'll want to normalize them, it might be more efficient to modify the abov script to load the csv files directly into separte tables.

Running this script will mean that the database is no longer structured internally according to the CKD data dictionary document. However, the script creates a view for each table that joins the information automatically to get the original setup.

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

MySQL couldn't locate one or more of the csv files that need to be imported. Make sure you changed the working directory to the location of all the files that need to be imported, and that all the files are named properly.