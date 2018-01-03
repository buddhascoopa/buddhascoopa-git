
--Boundary=_0.0_=0012200001496367

Here are the scripts for the Advanced Oracle Tuning & Administration book.
They differ slightly from the scripts on the CD (chapt06.sql and chapt08.sql
have been modified to correct the previously described errors).  All of the
files are just plain ASCII text files.  There is one file for each chapter,
plus a common.sql script to create the most-used tables and indexes.



-Kevin

--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 2
REM
REM Script 1:  Create a fully indexed table named TEMPERATURE_CODES
REM

create table TEMPERATURE_CODES
(Temp_Code  VARCHAR2(1) primary key,
 Description VARCHAR2(25));

create index I_TEMP_CODE$CODE_DESC
on TEMPERATURE_CODES (Temp_Code, Description);

create index I_TEMP_CODE$DESC_CODE
on TEMPERATURE_CODES (Description, Temp_Code);

REM
REM  Script 2:  Make TEMPERATURE_CODES a CACHE table.
REM

alter table TEMPERATURE_CODES cache;



--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 3
REM
REM Script 1:  Make ACCOUNT_CODES a CACHE table.

alter table ACCOUNT_CODES cache;

REM
REM  Script 2: Calculate the hit ratio since startup.
REM

select 
   SUM(DECODE(Name, 'consistent gets',Value,0)) Consistent,
   SUM(DECODE(Name, 'db block gets',Value,0)) Dbblockgets,
   SUM(DECODE(Name, 'physical reads',Value,0)) Physrds,
   ROUND(((SUM(DECODE(Name, 'consistent gets', Value, 0))+
      SUM(DECODE(Name, 'db block gets', Value, 0)) -
      SUM(DECODE(Name, 'physical reads', Value, 0)) )/
       (SUM(DECODE(Name, 'consistent gets',Value,0))+
        SUM(DECODE(Name, 'db block gets', Value, 0)))) 
        *100,2) Hitratio
from V$SYSSTAT;


REM
REM  Script 3:  Hit Ratio by user.
REM

column HitRatio format 999.99
select Username, 
       Consistent_Gets, 
       Block_Gets, 
       Physical_Reads, 
       100*(Consistent_Gets+Block_Gets-Physical_Reads)/
           (Consistent_Gets+Block_Gets) HitRatio 
  from V$SESSION, V$SESS_IO
 where V$SESSION.SID = V$SESS_IO.SID
   and (Consistent_Gets+Block_Gets)>0
   and Username is not null;




--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 4
REM
REM Script 1:  Show the log switch times for the past day (provided there 
REM         have been fewer than 100 log switches in the past day).
REM

select TO_CHAR(TO_DATE(Time, 'MM/DD/YY HH24:MI:SS'),
               'HH24:MI:SS')
  from V$LOG_HISTORY
 where TO_DATE(Time,'MM/DD/YY HH24:MI:SS') > SysDate-1
 order by TO_DATE(Time, 'MM/DD/YY HH24:MI:SS')  desc;

REM
REM  Script 2:  How much time (in days) was required for the last 100
REM          log switches?

select SysDate - MIN(TO_DATE(Time,'MM/DD/YY HH24:MI:SS'))
         Days_for_last_100_switches
  from V$LOG_HISTORY;

REM  
REM  Script 3:  I/O (expressed in database blocks) by datafile
REM

select DF.Name File_Name,
       FS.Phyblkrd Blocks_Read,
       FS.Phyblkwrt Blocks_Written,
       FS.Phyblkrd+FS.Phyblkwrt Total_IOs
  from V$FILESTAT FS, V$DATAFILE DF
 where DF.File#=FS.File#
 order by FS.Phyblkrd+FS.Phyblkwrt desc;

REM
REM  Script 4:  Creating a striped table named TEST.  Two methods are
REM        shown: using MINEXTENTS 2, and forcing the creation of a second
REM        extent via ALTER TABLE.
REM

create tablespace DATA_1
datafile '/db01/oracle/DEV/data_1a.dbf' size 100M,
         '/db02/oracle/DEV/data_1b.dbf' size 100M;

create table TEST
(Column1   VARCHAR2(20))
tablespace DATA_1
storage (initial 98M next 98M pctincrease 0 minextents 2);

drop table TEST;

create table TEST
(Column1   VARCHAR2(20))
tablespace DATA_1
storage (initial 40M next 40M pctincrease 0 minextents 1);

alter table TEST allocate extent
(datafile '/db02/oracle/DEV/data_1b.dbf');

REM
REM  Script 5. I/O (expressed in database blocks) by datafile for datafiles
REM          that have non-zero read I/O totals.
REM

select DF.Name File_Name,
       FS.Phyblkrd Blocks_Read,
       FS.Phyblkwrt Blocks_Written,
       FS.Phyblkrd+FS.Phyblkwrt Total_IOs
  from V$FILESTAT FS, V$DATAFILE DF
 where DF.File#=FS.File#
   and FS.Phyblkrd >0
 order by FS.Phyblkrd+FS.Phyblkwrt desc;




--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 6
REM
REM Script 1:  Get status information on SQL*Net V1 and V2
REM         (UNIX version)
REM

tcpctl stat
lsnrctl status

REM 
REM  Script 2:  Rename the Listener log (UNIX version)
REM

lsnrctl stop
mv listener.log old_list.log
lsnrctl start

REM
REM  Script 3:  Rename the alert log.  (UNIX version)
REM

mv alert_prod.log old_alert.log

REM
REM  Script 4:  Generate the CREATE CONTROLFILE syntax.
REM  (from within Server Manager or SQLDBA)
REM

alter database backup controlfile to trace;

REM
REM  Script 5:  Pin the ADD_CLIENT package in the shared pool.
REM

alter package APPOWNER.ADD_CLIENT compile;
execute DBMS_SHARED_POOL.KEEP('APPOWNER.ADD_CLIENT','P');

REM
REM  Script 6:  Allow the ADD_CLIENT package to be aged out 
REM          of the shared pool.
REM

execute DBMS_SHARED_POOL.UNKEEP('APPOWNER.ADD_CLIENT','P');

REM
REM  Script 7:  List the packages that can be pinned, in order.
REM

select Owner, 
       Name, 
       Type, 
 Source_Size+Code_Size+Parsed_Size+Error_Size  Total_Bytes
  from DBA_OBJECT_SIZE
 where Type = 'PACKAGE BODY'
 order by 4 desc;

REM
REM  Script 8:  Owner-to-tablespace location map
REM

break on Tablespace_Name Skip 1 on Owner
select Tablespace_Name, Owner, Segment_Name, Segment_Type
  from DBA_SEGMENTS 
 order by Tablespace_Name, Owner, Segment_Name;

REM
REM  Script 9:  Tablespace-to-owner location map
REM

break on Owner Skip 1 on Tablespace_Name
select Owner, Tablespace_Name, Segment_Name, Segment_Type
  from DBA_SEGMENTS 
 order by Owner, Tablespace_Name, Segment_Name;

REM
REM  Script 10:  Owner-to-datafile location map
REM

break on Owner on Segment_Name

select DBA_EXTENTS.Owner,
       DBA_EXTENTS.Segment_Name,
       DBA_DATA_FILES.Tablespace_Name,
       DBA_DATA_FILES.File_Name,
       SUM(DBA_EXTENTS.Bytes) Bytes
  from DBA_EXTENTS, DBA_DATA_FILES
 where DBA_EXTENTS.File_ID = DBA_DATA_FILES.File_ID
 group by DBA_EXTENTS.Owner, DBA_EXTENTS.Segment_Name,
  DBA_DATA_FILES.Tablespace_Name, DBA_DATA_FILES.File_Name;

REM
REM  Script 11:  Compute statistics on the ORDERS table.
REM

analyze table ORDERS compute statistics;

REM
REM  Script 12:  Anayze all objects in the APPOWNER schema.
REM

execute DBMS_UTILITY.ANALYZE_SCHEMA('APPOWNER','COMPUTE');

REM
REM  Script 13:  Shrink the R1 rollback segment by forcing it to go past
REM          its OPTIMAL size (see text) (for pre-7.2 databases)
REM

REM  Force the R1 rollback segment to be used 
REM
REM  Ensure the SET TRANSACTION command is used by the 
REM    DELETE command.
REM
rollback;
set transaction use rollback segment R1
REM
REM  Delete from the 12M table; DO NOT COMMIT!
REM
delete from TEMP_TABLE;
REM
REM  Rollback the deletion
REM
rollback;


REM
REM  Script 14:  Shrink the R1 rollback segment to 15M and then 
REM          to its OPTIMAL setting.
REM

alter rollback segment R1 shrink to 15M;
alter rollback segment R1 shrink;




--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 7
REM
REM Script 1:  Analyze the COMPANY table and all of its indexes and columns.
REM        

analyze table COMPANY compute statistics;

REM
REM Script 2:  Analyze the COMPANY table and its indexed columns (7.3)
REM        

analyze table COMPANY compute statistics for table 
    for all indexed columns;

REM 
REM Script 3:  Analyze all objects in the APPOWNER schema.
REM

execute DBMS_UTILITY.ANALYZE_SCHEMA('APPOWNER','COMPUTE');




--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 8
REM
REM Script 1: Run utlbstat.sql (from within Server Manager or SQLDBA).
REM        

connect internal;
@$ORACLE_HOME/rdbms/admin/utlbstat

REM
REM Script 2: Run utlestat.sql (from within Server Manager or SQLDBA).
REM        

connect internal;
@$ORACLE_HOME/rdbms/admin/utlestat

REM
REM  Script 3:  Query V$SYSSTAT for all cumulative system-level statistics.

select Name,
       Value 
  from V$SYSSTAT
 order by Name;

REM
REM  Script 4:  Query V$PARAMETER for current parameter settings.  The 
REM          script specifically queries for the size of the log buffer.
REM

select Name, 
       Value
  from V$PARAMETER
 where Name = 'log_buffer';

REM
REM  Script 5:  Query V$WAITSTAT for resource wait statistics.
REM

select Class,
       Count
  from V$WAITSTAT;


REM
REM  Script 6: Calculate the time that the database started.
REM

select TO_CHAR(TO_DATE(D.Value,'J'),'MM/DD/YYYY')||' '||
       TO_CHAR(TO_DATE(S.Value,'SSSSS'),'HH24:MI:SS') 
          Startup_Time
  from V$INSTANCE D, V$INSTANCE S
 where D.Key = 'STARTUP TIME - JULIAN'
   and S.Key = 'STARTUP TIME - SECONDS';

REM
REM Script 7:  If TIMED_STATISTICS is set to TRUE (see V$PARAMETER), 
REM       this script will show when the current user connected to the system
REM       (not available on all platforms).
REM

select SID,TO_CHAR(SysDate - (Hsecs-S.Value)/(24*3600*100) 
           ,'MM/DD/YYYY HH24:MI:SS')  Connection_Time
  from V$SESSTAT S, V$STATNAME N, V$TIMER
 where N.Name = 'session connect time'
   and N.Statistic# = S.Statistic#
   and S.Value != 0;

REM 
REM  Script 8:  If TIMED_STATISTICS is set to TRUE (see V$PARAMETER), 
REM       this script will show when the current user was last active.
REM

select SID,TO_CHAR(SysDate - (Hsecs-S.Value)/(24*3600*100) 
            ,'MM/DD/YYYY HH24:MI:SS')  Last_Non_Idle_Time
from V$SESSTAT S, V$STATNAME N, V$TIMER
where N.Name = 'process last non-idle time'
and N.Statistic# = S.Statistic#
and S.Value != 0;






--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 9
REM
REM Script 1:  Display SGA area sizes.
REM        

select Name, Value
  from V$SGA;

REM
REM  alternative to Script 1:  from within Server Manager or SQLDBA
REM

connect internal;
show sga;



--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 10.
REM
REM  Script 1:  Create the PLAN_TABLE table in your account.
REM          (UNIX version)
REM

@$ORACLE_HOME/rdbms/admin/utlxplan

REM
REM   Script 2:  Create the PLAN_TABLE table in your account (7.3 version)
REM

rem
Rem Copyright (c) 1988 by Oracle Corporation
Rem NAME
Rem UTLXPLAN.SQL
Rem FUNCTION
Rem This is the format for the table that is used by the 
Rem EXPLAIN PLAN statement.  The explain statement requires
Rem the presence of this table in order to store the 
Rem descriptions of the row sources.

create table PLAN_TABLE (
statement_id    varchar2(30),
timestamp       date,
remarks         varchar2(80),
operation       varchar2(30),
options         varchar2(30),
object_node     varchar2(128),
object_owner    varchar2(30),
object_name     varchar2(30),
object_instance numeric,
object_type     varchar2(30),
optimizer       varchar2(255),
search_columns  numeric,
id              numeric,
parent_id       numeric,
position        numeric,
cost            numeric,
cardinality     numeric,
bytes           numeric,
other_tag       varchar2(255),
other           long);


REM
REM Script 3: Create COMPANY
REM        

create table COMPANY
(Company_ID        NUMBER,
Name               VARCHAR2(10),
Address            VARCHAR2(10),
City               VARCHAR2(10),
State              VARCHAR2(10),
Zip                VARCHAR2(10),
Parent_Company_ID  NUMBER,
Active_Flag        CHAR,
constraint COMPANY_PK primary key (Company_ID),
constraint COMPANY$PARENT_ID foreign key
    (Parent_Company_ID) references COMPANY(Company_ID));

create index COMPANY$CITY on COMPANY(City);
create index COMPANY$STATE on COMPANY(State);
create index COMPANY$PARENT on COMPANY(Parent_Company_ID);

REM
REM  Script 4:  Create SALES
REM

create table SALES
(Company_ID  NUMBER,
Period_ID    NUMBER,
Sales_Total  NUMBER,
constraint SALES_PK primary key (Company_ID, Period_ID),
constraint SALES$COMPANY_FK foreign key (Company_ID)
         references COMPANY(Company_ID));


REM
REM  Script 5:  Create COMPETITOR
REM

create table COMPETITOR
(Company_ID NUMBER,
Product_ID NUMBER,
constraint COMPETITOR_PK primary key (Company_ID,Product_ID),
constraint COMPETITOR$COMPANY_FK foreign key (Company_ID)
references COMPANY(Company_ID));


REM
REM  Script 6:  Sample query, with explain plan
REM

explain plan
set Statement_ID = 'TEST'
for
select Name, City, State 
  from COMPANY
 where City = 'Roanoke'
   and State = 'VA';

REM
REM  Script 7:  Query of PLAN_TABLE; save the query as planqry.sql.
REM

select
  LPAD(' ',2*Level)||Operation||' '||Options
               ||' '||Object_Name   Q_Plan 
from PLAN_TABLE
where Statement_ID = 'TEST'
connect by prior ID = Parent_ID and Statement_ID = 'TEST'
start with ID=1;

save planqry.sql repl

REM
REM  Script 8:  Delete records from PLAN_TABLE.
REM

delete from PLAN_TABLE;


REM
REM Script 9:  AND-EQUAL example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Name, City, State 
  from COMPANY
 where City = 'Roanoke'
   and State = 'VA';

@planqry

REM
REM  Script 10:  CONCATENATION example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Name, City, State 
  from COMPANY
 where State = 'TX'
  and City in ('Houston', 'Austin', 'Dallas');

@planqry


REM 
REM  Script 11:  CONNECT BY example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Company_ID, Name
  from COMPANY
 where State = 'VA'
connect by Parent_Company_ID = prior Company_ID
 start with Company_ID = 1;

@planqry

REM
REM  Script 12:  COUNT example
REM


delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Name, City, State, RowNum
  from COMPANY
 where City > 'Roanoke'
 order by Zip;

@planqry

REM
REM  Script 13:  COUNT STOPKEY example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Name, City, State 
  from COMPANY
 where City > 'Roanoke'
   and RowNum <= 100;

@planqry

REM
REM  Script 14:  FILTER example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Company_ID, Name
  from COMPANY
 where State = 'VA'
connect by Parent_Company_ID = prior Company_ID
 start with Company_ID = 1;

@planqry

REM
REM  Script 15:  FOR UPDATE example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Name, City, State
  from COMPANY
 where City > 'Roanoke'
   and Active_Flag = 'Y'
   for update of Name;

@planqry

REM
REM  Script 16: HASH JOIN example (only for 7.3-otherwise, it's a NESTED LOOPS)
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;

@planqry


REM
REM  Script 17:  INDEX RANGE SCAN example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Name, City, State
  from COMPANY
 where City > 'Roanoke';

@planqry

REM
REM  Script 18:  INDEX UNIQUE SCAN example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Name, City, State
  from COMPANY
 where Company_ID = 12345;

@planqry

REM
REM  Script 19:  INTERSECTION example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Company_ID 
  from COMPANY
 where State = 'AZ' and Parent_Company_ID is null
INTERSECT
select Company_ID
  from COMPETITOR;

@planqry

REM
REM  Script 20:  An advanced INTERSECTION query example
REM

select Company_ID, Name
  from COMPANY
 where State = 'VA'
connect by Parent_Company_ID 
        = prior Company_ID /*down the tree*/
 start with Company_ID = 10
INTERSECT
select Company_ID, Name
  from COMPANY
 where State = 'VA'
connect by Company_ID
        = prior Parent_Company_ID /*up the tree*/
 start with Company_ID = 5;

REM
REM  Script 21:  MERGE JOIN example (if no hash joins enabled)
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID+0 = SALES.Company_ID+0
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;

@planqry

REM
REM  Script 22:  MINUS example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Company_ID 
  from COMPANY
MINUS
select Company_ID
  from COMPETITOR;

@planqry

REM
REM  Script 23:  NESTED LOOPS (if no hash joins used)
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;

@planqry

REM
REM  Script 24:  OUTER JOIN example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select COMPANY.Name
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID (+)
   and SALES.Period_ID = 3
   and SALES.Sales_Total >1000;

@planqry

REM
REM  Script 25:  PROJECTION example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Company_ID 
  from COMPANY
MINUS
select Company_ID
  from COMPETITOR;

@planqry

REM
REM  Script 26:  REMOTE example - customize the username/password & 
REM          connect string within the database link.
REM

create database link REMOTE1
connect to hobbes identified by tiger
 using 'test';

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select COMPANY.Name
  from COMPANY, SALES@REMOTE1
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID = 3
   and SALES.Sales_Total > 1000;

@planqry

select Other
  from PLAN_TABLE
 where Operation = 'REMOTE';

REM
REM  Script 27:  SEQUENCE example
REM

create sequence COMPANY_ID_SEQ
 start with 1 increment by 1;

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select COMPANY_ID_SEQ.NextVal 
  from DUAL;

@planqry

REM
REM  Script 28:  SORT AGGREGATE example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select SUM(Sales_Total)
  from SALES;

@planqry

REM
REM  Script 29: SORT GROUP BY example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Zip, COUNT(*)
  from COMPANY
 group by Zip;

@planqry


REM
REM  Script 30: SORT JOIN example (if MERGE JOIN is used)
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID+0 = SALES.Company_ID+0
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;

@planqry


REM
REM  Script 31: SORT ORDER BY example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Name
  from COMPANY
 order by Name;

@planqry


REM
REM  Script 32: SORT UNIQUE example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Company_ID 
  from COMPANY
MINUS
select Company_ID
  from COMPETITOR;

@planqry


REM
REM  Script 33: TABLE ACCESS BY ROWID example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Name 
  from COMPANY
 where Company_ID = 12345
   and Active_Flag = 'Y';

@planqry


REM
REM  Script 34: TABLE ACCESS CLUSTER example
REM

rem:  This example assumes that COMPANY is stored in a cluster,
rem:  named COMPANY_CLUSTER, and the cluster key is the Company_ID column.
rem: The name of the cluster key index (on Company_ID) is COMPANY_CLUSTER_NDX.

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select COMPANY.Name
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID = 3
   and SALES.Sales_Total>1000;

@planqry


REM
REM  Script 35: TABLE ACCESS FULL example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select * 
  from COMPANY;

@planqry


REM
REM  Script 36: TABLE ACCESS HASH example
REM

rem:  This example assumes that COMPANY is stored in a hash cluster,
rem:  with the Company_ID as the hash key.

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Name 
  from COMPANY
 where Company_ID = 12345
   and Active_Flag = 'Y';

@planqry


REM
REM  Script 37: UNION example
REM

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Company_ID 
  from COMPANY
UNION
select Company_ID
  from COMPETITOR;

@planqry


REM
REM  Script 38: VIEW example
REM

create view COMPANY_COUNT as
select Zip, COUNT(*) Company_Count
  from COMPANY
 group by Zip;

delete from PLAN_TABLE;

explain plan
set Statement_ID = 'TEST' for
select Zip, Company_Count
  from COMPANY_COUNT
 where Company_Count BETWEEN 10 and 20;

@planqry


REM
REM  Script 39: ALL_ROWS example
REM

select /*+ ALL_ROWS */
       COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;

REM
REM  Script 40:  AND_EQUAL example
REM

select /*+ AND-EQUAL COMPANY$CITY, COMPANY$STATE */
        Name, City, State 
  from COMPANY
 where City = 'Roanoke'
   and State = 'VA';

REM
REM Script 41: CACHE example
REM

select /*+ FULL(competitor) CACHE(competitor) */   *
  from COMPETITOR
 where Company_ID > 5;

REM
REM  Script 42:  FIRST_ROWS example
REM

select /*+ FIRST_ROWS */
       COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;

REM
REM  Script 43:  FULL example
REM

select /*+ FULL(COMPANY) */
        Name, City, State 
  from COMPANY
 where City = 'Roanoke'
   and State = 'VA';

REM
REM  Script 44:  INDEX example
REM

select /*+ INDEX(COMPANY) */
        Name, City, State 
  from COMPANY
 where City = 'Roanoke'
   and State = 'VA';


REM  
REM  Script 45:  NOCACHE example
REM

select /*+ FULL(competitor) NOCACHE(competitor) */   *
  from COMPETITOR
 where Company_ID > 5;

REM
REM  Script 46:  RULE example
REM

select /*+ RULE */
       COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;

REM
REM Script 47:  USE_MERGE example
REM

select /*+ USE_MERGE(COMPANY, SALES) */
       COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;

REM
REM  Script 48:  USE_NL example
REM

select /*+ USE_NL(COMPANY) */
       COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;







--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 11.
REM
REM  Script 1:  Determine the number of distinct combinations of City and State
REM          in the COMPANY table.
REM

select COUNT(distinct City||'%'||State)
  from COMPANY;

REM
REM  Script 2:  Count the number of rows in COMPANY.
REM

select COUNT(*)
  from COMPANY;

REM
REM  Script 3:  Analyze COMPANY
REM

analyze table COMPANY compute statistics;

REM
REM  Script 4:  After analyzing, display the number of distinct keys in the 
REM          concatenated City|State index.
REM

select Distinct_Keys
  from USER_INDEXES
 where Table_Name = 'COMPANY'
   and Index_Name = 'COMPANY$CITY_STATE';

REM
REM  Script 5:  After analyzing, display the number of rows in COMPANY.
REM

select Num_Rows
  from USER_TABLES
 where Table_Name = 'COMPANY';

REM
REM  Script 6:  After analyzing, display the number of distinct values for 
REM          each column (7.2 and above only).
REM

select Column_Name, Num_Distinct
  from USER_TAB_COLUMNS
 where Table_Name = 'COMPANY';


REM
REM  Script 7:  Make TEMP a dedicated temporary tablespace (7.3)
REM

alter tablespace TEMP_1 temporary;

REM
REM  Script 8:  Allow TEMP to store permanent objects as well as 
REM          temporary segments (7.3).
REM

alter tablespace TEMP_1 permanent;

REM
REM  Script 8.  NESTED LOOPS example query
REM

select COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and Period_ID = 2;


REM
REM  Script 9:  Example query of an ACTIVE_FLAG_CODES table.
REM

select * from ACTIVE_FLAG_CODES;

REM
REM  Script 10:  Sample query using ACTIVE_FLAG_CODES and COMPANY.
REM
select Company.Name
  from COMPANY, ACTIVE_FLAG_CODES
 where COMPANY.Active_Flag = ACTIVE_FLAG_CODES.Active_Flag
   and ACTIVE_FLAG_CODES.Description = 'Active';

REM
REM  Script 11:  Sample query after altering COMPANY to include an
REM          ACTIVE_FLAG_DESCRIPTION column.
REM

select Company.Name
  from COMPANY
 where Active_Flag_Description = 'Active';

REM
REM  Script 12:  Sample query of SALES
REM

select Period_ID, Sales_Total
  from SALE
 where Company_ID = 8791
   and Period_ID between 1 and 4;

REM
REM  Script 13:  Sample query from a modified SALES table.
REM

select Period_1_Sales, Period_2_Sales, Period_3_Sales, 
       Period_4_sales
  from SALE
 where Company_ID = 8791;

REM
REM  Script 14:  Create a COMPANY_COUNT view.
REM
create view COMPANY_COUNT as
select State, COUNT(*) Company_Count
  from COMPANY
 group by State;

REM
REM  Script 15:  Create a PERIOD3_NAMES view.
REM

create view PERIOD3_NAMES as
select COMPANY.Name 
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID =3;

REM
REM  Script 16:  Create a SALES_TOTAL_VW
REM

create view SALES_TOTAL_VW as
select Company_ID, SUM(Sales_Total) Sum_Sales_Total
  from SALES
 group by Company_ID;

REM
REM  Script 17:  Join SALES_TOTAL_VW to COMPANY
REM

select COMPANY.Name, Sum_Sales_Total
  from COMPANY, SALES_TOTAL_VW
 where COMPANY.Company_ID = SALES_TOTAL_VW.Company_ID;

REM
REM  Script 18:  Alternative query to get SALES total data by Company
REM
select COMPANY.Name, SUM(Sales_Total)
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
 group by COMPANY.Name;

REM
REM  Script 19:  Query to join SALES and COMPANY
REM

select COMPANY.Name, SUM(Sales_Total)
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
 group by COMPANY.Name;

REM
REM  Script 20:  Create view SALES_TOTAL_VW
REM

create view SALES_TOTAL_VW as
select Company_ID, SUM(Sales_Total) Sum_Sales_Total
  from SALES
 group by Company_ID;

REM
REM  Script 21:  Join SALES_TOTAL_VW to COMPANY
REM

select COMPANY.Name, Sum_Sales_Total
  from COMPANY, SALES_TOTAL_VW
 where COMPANY.Company_ID = SALES_TOTAL_VW.Company_ID;

REM
REM  Script 22:  Join COMPANY to FROM clause version of 
REM          SALES_TOTAL_VW (7.2 and above)
REM

select Name, Sum_Sales_Total
  from COMPANY, 
       (select Company_ID Sales_Co_ID, 
               SUM(Sales_Total) Sum_Sales_Total
         from SALES
        group by Company_ID)
 where COMPANY.Company_ID = Sales_Co_ID;

REM
REM  Script 23:  Sample query with subquery
REM

select COMPANY.Name
  from COMPANY
 where COMPANY.Company_ID in
       (select distinct SALES.Company_ID
          from SALES
         where Period_ID = 4
           and Sales_Total > 10000);

REM
REM  Script 24:  Sample query, revised to be a join
REM

select COMPANY.Name
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID = 4
   and Sales_Total > 10000;

REM
REM  Script 25:  Query using subquery against historical data table.
REM

select *
  from EMPLOYEE, EMPLOYEE_HISTORY EH
 where EMPLOYEE.Employee_ID = EH.Employee_ID
   and EMPLOYEE.Name = 'George Washington'
   and EH.Effective_Date =
       (select MAX(Effective_Date) 
          from EMPLOYEE_HISTORY E2
         where E2.Employee_ID = EH.Employee_ID);


REM
REM  Script 26:  Historical data query, revised to use INDEX_DESC hint.
REM

select /*+ INDEX_DESC(eh employee_history$eff_dt)*/
      *  
 from EMPLOYEE, EMPLOYEE_HISTORY EH
where EMPLOYEE.Employee_ID = EH.Employee_ID
  and EMPLOYEE.Name = 'George Washington'
  and EH.Effective_Date < SysDate
  and RowNum = 1;

REM
REM  Script 27:  Create ACTIVE_CODE and HOURLY_CODE tables, and use
REM          them in an update command.
REM

create table ACTIVE_CODE
(Active_Code NUMBER,
 Description VARCHAR2(20));
create table HOURLY_CODE
(Hourly_Code NUMBER,
 Description VARCHAR2(20));

update EMPLOYEE
   set Active_Code = 1
 where Active_Code in 
       (select Active_Code from ACTIVE_CODE
         where Description = 'HIRED')
   and Hourly_Code in 
       (select Hourly_Code from HOURLY_CODE
         where Description = 'FULLTIME')
   and Start_Date <= SysDate;


REM
REM  Script 28:  Modified version of update, using ANY clause.
REM

update EMPLOYEE
   set Active_Code = 1
 where (Active_Code, Hourly_Code) = ANY  
       (select Active_Code, Hourly_Code
          from ACTIVE_CODE, HOURLY_CODE
         where ACTIVE_CODE.Description = 'HIRED'
           and HOURLY_CODE.Description = 'FULLTIME')
   and Start_Date <= SysDate;


REM
REM  Script 29:  Two equivalent queries, one as a join and one as a subquery.
REM

select COMPANY.Name
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID = 4
   and Sales_Total > 10000;
select COMPANY.Name
  from COMPANY 
 where COMPANY.Company_ID in
       (select SALES.Company_ID
          from SALES
         where SALES.Period_ID = 4
           and Sales_Total > 10000);

REM  
REM  Script 30:  A query that is functionally equivalent to the join and 
REM          subquery method, but using the EXISTS clause instead.
REM

select COMPANY.Name
  from COMPANY
 where EXISTS
   (select 1 from SALES
     where COMPANY.Company_ID = SALES.Company_ID
       and SALES.Period_ID = 4
       and Sales_Total > 10000);

REM
REM  Script 31:  Two functionally equivalent queries.   The first uses 
REM          a NOT IN subquery, the second uses a NOT EXISTS clause.
REM

select Company_ID 
  from COMPANY
 where Company_ID NOT IN
       (select Company_ID from SALES);
select Company_ID 
  from COMPANY
 where NOT EXISTS
       (select 1 from SALES
         where SALES.Company_ID = COMPANY.Company_ID);

REM
REM  Script 32:  Dimension tables for a star schema.
REM

create table PRODUCT 
 (Product_ID   NUMBER,
  Product_Name VARCHAR2(20),
  constraint   PRODUCT_PK primary key (Product_ID));
create table PERIOD
 (Period_ID   NUMBER,
  Period_Name VARCHAR2(20),
  constraint  PERIOD_PK primary key (Period_ID));
create table CUSTOMER
(Customer_ID   NUMBER,
 Customer_Name VARCHAR2(20),
 constraint    CUSTOMER_PK primary key (Customer_ID));

REM
REM  Script 33:  Fact table for a star schema.
REM

create table ORDERS
 (Product_ID   NUMBER,
  Period_ID    NUMBER,
  Customer_ID  NUMBER,
  Order_Amount NUMBER,
  constraint   ORDERS_PK primary key 
                (Product_ID, Period_ID, Customer_ID),
  constraint   ORDERS_PRODUCT_FK foreign key (Product_ID) 
                references PRODUCT(Product_ID),
  constraint   ORDERS_PERIOD_FK foreign key (Period_ID) 
                references PERIOD(Period_ID),
  constraint   ORDERS_CUSTOMER_FK foreign key (Customer_ID) 
                references CUSTOMER(Customer_ID));

REM
REM  Script 34:  Sample query of a star schema.
REM

select  PRODUCT.Product_Name, 
        PERIOD.Period_Name, 
        CUSTOMER.Customer_Name, 
        ORDERS.Order_Amount
  from ORDERS, PERIOD, CUSTOMER, PRODUCT
 where PRODUCT.Product_Name = 'WIDGET'
   and PERIOD.Period_Name = 'Last 3 Months'
   and CUSTOMER.Customer_Name = 'MAGELLAN'
   and ORDERS.Period_ID = PERIOD.Period_ID
   and ORDERS.Customer_ID = CUSTOMER.Customer_ID
   and ORDERS.Product_ID = PRODUCT.Product_ID;


REM
REM  Script 35:  Dimension table indexes for a star query execution path.
REM

create index PRODUCT$PRODUCT_NAME 
    on PRODUCT(Product_Name);
create index PERIOD$PERIOD_NAME 
    on PERIOD(Period_Name);
create index CUSTOMER$CUSTOMER_NAME 
    on CUSTOMER(Customer_Name);

REM
REM  Script 36:  Query using CONNECT BY clause against PLAN_TABLE.
REM

select
  LPAD(' ',2*Level)||Operation||' '||Options
      ||' '||Object_Name  Q_Plan
  from PLAN_TABLE
 where Statement_ID = 'TEST'
connect by prior ID = Parent_ID and Statement_ID = 'TEST'
 start with ID=1;


REM
REM  Script 37:  Explain plan command for CONNECT BY query
REM

explain plan
set Statement_ID = 'TEST' for
select
  LPAD(' ',2*Level)||Operation||' '||Options
      ||' '||Object_Name  Q_Plan
  from PLAN_TABLE
 where Statement_ID = 'TEST'
connect by prior ID = Parent_ID and Statement_ID = 'TEST'
 start with ID=1;

REM
REM  Script 38:  Indexes for the CONNECT BY and START WITH clauses.
REM

create index PLAN_TABLE$ID on PLAN_TABLE(ID);
create index PLAN_TABLE$PARENT_ID on PLAN_TABLE(Parent_ID);

REM
REM  Script 39:  Additional index, on the Statement_ID column.
REM

create index PLAN_TABLE$STATEMENT_ID
    on PLAN_TABLE(Statement_ID);

REM
REM  Script 40:  Modified set of indexes to facilitate queries going both "up"
REM          and "down" the data tree.
REM

drop index PLAN_TABLE$ID;
drop index PLAN_TABLE$PARENT_ID;
drop index PLAN_TABLE$STATEMENT_ID;
create index PLAN_TABLE$ID$PARENT
    on PLAN_TABLE(ID, Parent_ID);
create index PLAN_TABLE$PARENT$ID
    on PLAN_TABLE(Parent_ID, ID);


REM
REM  Script 41:  Sample query using a database link.
REM

select COMPANY.Name 
  from COMPANY, SALES@REMOTE1
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;

REM
REM  Script 42:  Sample query using a database link, modified to use 
REM          a MERGE JOIN operation.
REM

select /*+ USE_MERGE(COMPANY,SALES) */ 
       COMPANY.Name 
  from COMPANY@REMOTE1, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID =3
   and SALES.Sales_Total>1000;

REM
REM  Script 43:  Range query of COMPANY
REM

select * 
  from COMPANY
 where Company_ID between 1 and 1000000;


REM
REM  Script 42:  Create a hash cluster for COMPANY, and create
REM          the COMPANY table within the hash cluster.

create cluster COMPANY_CLUSTER (Company_ID NUMBER(12))
STORAGE (Initial 50M Next 50M)
  HASH IS Company_ID
  SIZE 60 HASHKEYS 10000000;
create table COMPANY
(Company_ID  NUMBER(12),
 Name        VARCHAR2(20),
 Address     VARCHAR2(20))
cluster COMPANY_CLUSTER (Company_ID);


REM
REM  Script 43:  Create one of a set of partitioned SALES tables.
REM

create table SALES_PERIOD_1
(Company_ID, Period_ID, Sales_Total) as 
select Company_ID, Period_ID, Sales_Total
  from SALES
 where Period_ID = 1;
alter table SALES_PERIOD_1 
  add constraint CHECK_SALES_PERIOD_1 
check (Period_ID = 1);
alter table SALES_PERIOD_1
  add constraint SALES_PERIOD_1_PK
primary key (Company_ID, Period_ID);
create index SALES_PERIOD_1$PERIOD_ID
    on SALES_PERIOD_1(Period_ID);



REM  
REM  Script 44:  Create SALES_ALL view to union the data from all of the 
REM          partitioned SALES tables.
REM

create view SALES_ALL as
select * from SALES_PERIOD_1
 union
select * from SALES_PERIOD_2
 union
select * from SALES_PERIOD_3
 union
select * from SALES_PERIOD_4;

REM
REM  Script 45:  Sample query against SALES_ALL that would benefit from
REM          partition elimination (7.3)
REM

select * from SALES_ALL
 where Period_ID = 1
   and Company_ID > 10000;






--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 12.
REM
REM  Script 1:  Sample query of COMPANY, using a full table scan.
REM

select * 
  from COMPANY;


REM
REM  Script 2:  Sample query of COMPANY, using a full table scan and 
REM          a sorting operation.
REM

select *
  from COMPANY
 order by Name;

REM
REM  Script 3:  ALTER PROFILE command to change the default limit
REM          of user sessions.
REM

alter profile default limit sessions_per_user unlimited;

REM  
REM  Script 4:  Sample commands to alter the degree of parallelism 
REM          for COMPANY, or to turn off parallelism.
REM

alter table COMPANY
parallel(degree 4);
alter table COMPANY
parallel(degree 4 instances 5);
alter table COMPANY noparallel;

REM
REM  Script 5:  Sample queries using hints to invoke parallelism 
REM         within the instance and across OPS instances, and to 
REM         turn of parallelism.

select /*+ FULL(company) PARALLEL(company,5) */  *
  from COMPANY;
select /*+ FULL(company) PARALLEL(company,5,4) */  *
  from COMPANY;
select /*+ NOPARALLEL(company) */  *
  from COMPANY;


REM
REM  Script 6:  Query of V$PQ_SYSSTAT for parallel-related statistics.
REM

select Statistic, Value
  from V$PQ_SYSSTAT;


REM
REM  Script 7:  Query of V$PARAMETER for parallel-related settings.
REM

select Name, Value
  from V$PARAMETER
 where Name like 'parallel%';

REM
REM  Script 8:  Create table COMPANY
REM

create table COMPANY
(Company_ID        NUMBER,
Name               VARCHAR2(10),
Address            VARCHAR2(10),
City               VARCHAR2(10),
State              VARCHAR2(10),
Zip                VARCHAR2(10),
Parent_Company_ID  NUMBER,
Active_Flag        CHAR,
constraint COMPANY_PK primary key (Company_ID),
constraint COMPANY$PARENT_ID foreign key
    (Parent_Company_ID) references COMPANY(Company_ID));

create index COMPANY$CITY on COMPANY(City);
create index COMPANY$STATE on COMPANY(State);
create index COMPANY$PARENT on COMPANY(Parent_Company_ID);


REM
REM  Script 9:  Create table SALES
REM

create table SALES
(Company_ID  NUMBER,
Period_ID    NUMBER,
Sales_Total  NUMBER,
constraint SALES_PK primary key (Company_ID, Period_ID),
constraint SALES$COMPANY_FK foreign key (Company_ID)
         references COMPANY(Company_ID));


REM
REM  Script 10:  Set a degree of parallelism for SALES and COMPANY.
REM

alter table SALES
parallel(degree 4);

alter table COMPANY
parallel(degree 4);

REM
REM  Script 11:  Sample join of COMPANY and SALES
REM

select COMPANY.Name, SALES.Sales_Total
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID = 3;

REM
REM  Script 12:  MERGE JOIN of COMPANY and SALES
REM

select 
 /*+ FULL(company) FULL(sales) USE_MERGE(company sales)*/
       COMPANY.Name, Sales.Sales_Total
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and SALES.Period_ID = 3;

REM
REM  Script 13:  Query of PLAN_TABLE, including the Other_Tag column
REM

select
  LPAD(' ',2*Level)||Operation||' '||Options
               ||' '||Object_Name   Q_Plan, Other_Tag
from PLAN_TABLE
where Statement_ID = 'TEST'
connect by prior ID = Parent_ID and Statement_ID = 'TEST'
start with ID=1;


REM
REM  Script 14:  Query of PLAN_TABLE for the parallelized code
REM          for the full table scan of COMPANY.
REM

set long 1000
select Object_Node, Other
  from PLAN_TABLE
 where Operation||' '||Options = 'TABLE ACCESS FULL'
   and Object_Name = 'COMPANY';

REM
REM  Script 15:  MERGE JOIN query, using SET AUTOTRACE ON
REM

set autotrace on

select
 /*+ FULL(company) FULL(sales) USE_MERGE(company sales)*/
      COMPANY.Name, Sales.Sales_Total
 from COMPANY, SALES
where COMPANY.Company_ID = SALES.Company_ID
  and SALES.Period_ID = 3;


REM  
REM  Script 16:  Parallelized CREATE TABLE example.
REM

create table COMPANY2
parallel(degree 4)
as select /*+ PARALLEL(company,4) */ 
          *
  from COMPANY;

REM
REM Script 17:  Parallelized CREATE INDEX example.
REM

create index COMPANY$CITY_STATE
    on COMPANY(City, State)
parallel(degree 6);






--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 13.
REM
REM  Script 1:  Create and index the POPULATION table.
REM

create table POPULATION
(Country      VARCHAR2(200),
Name          VARCHAR2(200));

create index POPULATION$COUNTRY
on POPULATION(Country);

REM
REM  Script 2:  Create and index the COMPANY table.
REM  

create table COMPANY
(Company_ID        NUMBER,
Name               VARCHAR2(10),
Address            VARCHAR2(10),
City               VARCHAR2(10),
State              VARCHAR2(10),
Zip                VARCHAR2(10),
Parent_Company_ID  NUMBER,
Active_Flag        CHAR,
constraint COMPANY_PK primary key (Company_ID),
constraint COMPANY$PARENT_ID foreign key
    (Parent_Company_ID) references COMPANY(Company_ID));

create index COMPANY$CITY on COMPANY(City);
create index COMPANY$STATE on COMPANY(State);
create index COMPANY$PARENT on COMPANY(Parent_Company_ID);


REM
REM  Script 3:  Sample range query of SALES
REM

select * from SALES
where Company_ID < 50;

REM
REM  Script 4:  Analyze SALES, using histograms (7.3)
REM

analyze table SALES compute statistics
for table for all indexed columns size 250;

REM
REM  Script 5:  Determine if there is repetition among histogram bucket 
REM          endpoints.  If the two queries return the same value, each
REM          bucket's endpoint value is unique.
REM

select Num_Buckets
  from USER_TAB_COLUMNS
 where Table_Name = 'SALES'
   and Column_Name = 'COMPANY_ID';
select COUNT(*)
  from USER_HISTOGRAMS
 where Table_Name = 'SALES'
   and Column_Name = 'COMPANY_ID';

REM
REM  Script 6:  Sample join query of SALES and COMPANY.  In 7.3, this
REM          query may use a HASH JOIN operation.
REM  

select COMPANY.Name
  from COMPANY, SALES
 where COMPANY.Company_ID = SALES.Company_ID
   and Period_ID = 2;

REM
REM  Script 7:  Example of setting HASH_MULTIBLOCK_IO_COUNT at the session 
REM           level. (7.3)

alter session set hash_multiblock_io_count=8;

REM
REM  Script 8:  Example of using UNRECOVERABLE for table creation. (7.2)
REM

create table SALES_BY_COMPANY
unrecoverable
as select Company_ID, SUM(Sales_Total) Sum_Sales_Total
 from SALES
group by Company_ID;

REM
REM  Script 9:  Example of using UNRECOVERABLE for index creation. (7.2)
REM

create index SALES_BY_CO$CO_ID
on SALES_BY_COMPANY(Company_ID)
unrecoverable;

REM
REM  Script 10:  Marking the TEMP tablespace as a dedicated temporary
REM          tablespace and then back as a permanent tablespace (7.3)
REM

alter tablespace TEMP temporary;
alter tablespace TEMP permanent;

REM
REM  Script 11:  Examples of using ALTER SESSION and ALTER SYSTEM to
REM          dynamically modify INIT.ORA parameters. (7.3)
REM

alter session set PARTITION_VIEW_ENABLED=TRUE;
alter system set TIMED_STATISTICS=TRUE;

REM
REM  Script 12:  Create table SALES, using MAXEXTENTS UNLIMITED. (7.3)
REM
create table SALES
(Company_ID  NUMBER,
Period_ID    NUMBER,
Sales_Total  NUMBER,
constraint SALES_PK primary key (Company_ID, Period_ID),
constraint SALES$COMPANY_FK foreign key (Company_ID)
         references COMPANY(Company_ID))
tablespace DATA_1
storage (initial 100M next 100M pctincrease 0
         minextents 1
         maxextents unlimited);

REM
REM  Script 13:  Deallocate all but 100K of free space from COMPETITOR. (7.3)
REM

alter table COMPETITOR deallocate unused keep 100K;

REM
REM  Script 14:  Determine space allocation within COMPETITOR segment. (7.3)
REM

declare
        OP1 number;
        OP2 number;
        OP3 number;
        OP4 number;
        OP5 number;
        OP6 number;
        OP7 number;
begin
dbms_space.unused_space('APPOWNER','COMPETITOR','TABLE',
                          OP1,OP2,OP3,OP4,OP5,OP6,OP7);
   dbms_output.put_line('OBJECT_NAME       = COMPETITOR');
   dbms_output.put_line('---------------------------');
   dbms_output.put_line('TOTAL_BLOCKS      = '||OP1);
   dbms_output.put_line('TOTAL_BYTES       = '||OP2);
   dbms_output.put_line('UNUSED_BLOCKS     = '||OP3);
   dbms_output.put_line('UNUSED_BYTES      = '||OP4);
   dbms_output.put_line('LAST_USED_EXTENT_FILE_ID  = '||OP5);
   dbms_output.put_line('LAST_USED_EXTENT_BLOCK_ID = '||OP6);
   dbms_output.put_line('LAST_USED_BLOCK   = '||OP7);

REM
REM  Script 15:  Example of a fast index recreation (7.3).
REM

alter index COMPANY_PK rebuild
storage (initial 100M next 50M pctincrease 0)
tablespace INDX_2;


REM
REM  Script 16:  Sample query that may exploit bitmap indexes.
REM

select *
  from EMPLOYEE
 where Active_Flag = 'Y'
   and Sex = 'F';

REM
REM  Script 17:  Sample bitmap index creation. (7.3)
REM

create bitmap index EMPLOYEE$BITMAP_SEX
    on EMPLOYEE(Sex);

REM
REM  Script 18:  Create a user-defined hash cluster, and put the COMPANY
REM          table in the cluster. (7.2)

create cluster COMPANY_CLUSTER (Company_ID NUMBER(12))
storage (initial 50M next 50M)
  hash is Company_ID
  size 60 hashkeys 10000000;
create table COMPANY
(Company_ID  NUMBER(12),
 Name        VARCHAR2(20),
 Address     VARCHAR2(20))
cluster COMPANY_CLUSTER (Company_ID);

REM
REM  Script 19:  Create partition tables SALES_1 and SALES_2.  SALES_3 
REM          would be created in a similar fashion.
REM

create table SALES_1
(Company_ID, Period_ID, Sales_Total) as
select Company_ID, Period_ID, Sales_Total
  from SALES
 where Period_ID = 1;
alter table SALES_1
  add constraint CHECK_SALES_1
check (Period_ID = 1);
alter table SALES_1
  add constraint SALES_1_PK
primary key (Company_ID, Period_ID);
create index SALES_1$PERIOD_ID
    on SALES_1(Period_ID);
create table SALES_2
(Company_ID, Period_ID, Sales_Total) as
select Company_ID, Period_ID, Sales_Total
  from SALES
 where Period_ID = 2;
alter table SALES_2
  add constraint CHECK_SALES_2
check (Period_ID = 2);
alter table SALES_2
  add constraint SALES_2_PK
primary key (Company_ID, Period_ID);
create index SALES_2$PERIOD_ID
    on SALES_2(Period_ID);

REM
REM  Script 20:  Create SALES_VIEW of SALES_1, SALES_2, & SALES_3.
REM

create or replace view SALES_VIEW as
select * from SALES_1
union all
select * from SALES_2
union all
select * from SALES_3;

REM
REM  Script 21:  Sample query of SALES_VIEW, using only one of the partition
REM          tables.
REM
select * from SALES_VIEW
 where Period_ID = 2
   and Company_ID between 1000 and 2000;

REM 
REM  Script 22:  Remove SALES_3 from SALES_VIEW, then add it back in.
REM

REM  SALES_VIEW without SALES_3:
REM
create or replace view SALES_VIEW as
select * from SALES_1
union all
select * from SALES_2;
REM
REM
REM  Perform maintenance, such as Truncate/build of SALES_3
REM
REM  Then add SALES_3 back into SALES_VIEW:
REM
create or replace view SALES_VIEW as
select * from SALES_1
union all
select * from SALES_2
union all
select * from SALES_3;


REM
REM  Script 23:  Sample trigger compilation. (7.3)
REM  

alter trigger APPOWNER.MY_TRIGGER compile;

REM
REM  Script 24:  Sample creation of a resizable datafile. (7.2)
REM
create tablespace DATA
datafile '/db05/oracle/DEV/data01.dbf' size 200M
autoextend ON
next 10M
maxsize 250M;

REM
REM  Script 25:  Query to determine autoextending datafile settings. (7.2)
REM

select * from SYS.FILEXT$;

REM
REM  Script 26:  Two different commands to make a file autoextendable. (7.2)
REM

alter tablespace DATA
add datafile '/db05/oracle/DEV/data02.dbf'
size 50M
autoextend on
maxsize unlimited;
alter database
datafile '/db05/oracle/DEV/data01.dbf'
autoextend on
maxsize unlimited;

REM
REM  Script 27:  Sample resizing of a datafile. (7.2)
REM

alter database datafile '/db05/oracle/DEV/data01.dbf'
resize 50M;

REM
REM  Script 28:  Sample tablespace free space coalesce.
REM

alter tablespace DATA_1 coalesce;

REM
REM  Script 29:  Query DBA_FREE_SPACE_COALESCED to determine if
REM          tablespace needs its free space coalesced.
REM

select Tablespace_Name,
       Percent_Blocks_Coalesced
  from DBA_FREE_SPACE_COALESCED
 order by Percent_Blocks_Coalesced;

REM
REM  Script 30:  Make the REFERENCE_DATA tablespace READ ONLY, then
REM          convert it back to READ WRITE.
REM

alter tablespace REFERENCE_DATA read only;
alter tablespace REFERENCE_DATA read write;

REM
REM  Script 31:  Shrink the R1 rollback segment, to 15M and then to its 
REM          OPTIMAL setting.
REM

alter rollback segment R1 shrink to 15M;
alter rollback segment R1 shrink;

REM
REM  Script 32:  Sample snapshot creation.
REM

create snapshot COMPANY
tablespace SNAP_1
storage (initial 100K next 100K pctincrease 0)
refresh complete
start with SysDate
next SysDate+7
as select * from COMPANY@link_to_master;


REM
REM  Script 33:  Sample query from COMPANY snapshot.
REM

select *
  from COMPANY
 where State = 'DE';





--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Table Creation Scripts for demo tables used throughout
REM
REM Script 1: Create COMPANY
REM        

create table COMPANY
(Company_ID        NUMBER,
Name               VARCHAR2(10),
Address            VARCHAR2(10),
City               VARCHAR2(10),
State              VARCHAR2(10),
Zip                VARCHAR2(10),
Parent_Company_ID  NUMBER,
Active_Flag        CHAR,
constraint COMPANY_PK primary key (Company_ID),
constraint COMPANY$PARENT_ID foreign key
    (Parent_Company_ID) references COMPANY(Company_ID));

create index COMPANY$CITY on COMPANY(City);
create index COMPANY$STATE on COMPANY(State);
create index COMPANY$PARENT on COMPANY(Parent_Company_ID);

REM
REM  Script 2:  Create SALES
REM

create table SALES
(Company_ID  NUMBER,
Period_ID    NUMBER,
Sales_Total  NUMBER,
constraint SALES_PK primary key (Company_ID, Period_ID),
constraint SALES$COMPANY_FK foreign key (Company_ID)
         references COMPANY(Company_ID));


REM
REM  Script 3:  Create COMPETITOR
REM

create table COMPETITOR
(Company_ID NUMBER,
Product_ID NUMBER,
constraint COMPETITOR_PK primary key (Company_ID,Product_ID),
constraint COMPETITOR$COMPANY_FK foreign key (Company_ID)
references COMPANY(Company_ID));







--Boundary=_0.0_=0012200001496367

REM
REM  Advanced Oracle Tuning & Administration
REM
REM  Scripts for Chapter 5.
REM
REM  Script 1:  Drop and create SALES, using INITIAL 8M NEXT 4M.
REM

drop table SALES;

create table SALES
(Company_ID  NUMBER,
Period_ID    NUMBER,
Sales_Total  NUMBER,
constraint SALES_PK primary key (Company_ID, Period_ID))
storage (initial 8M next 4M pctincrease 0
         minextents 1 maxextents 200)
tablespace APP_DATA;

REM
REM  Script 2:  Display the number of blocks in which rows are stored.
REM

select COUNT(DISTINCT(SUBSTR(Rowid,1,8)||
                      SUBSTR(RowID,15,4)))
from SALES;
REM
REM  Script 3:  Analyze SALES and query DBA_TABLES to determine
REM          the number of blocks used by rows.
REM


analyze table SALES compute statistics;
select BLOCKS  from DBA_TABLES
 where Table_Name = 'SALES';

REM
REM  Script 4:  Sample range scan query of SALES.
REM  

select * 
  from SALES
 where Company_ID > 100;
REM
REM  Script 5:  Analyze SALES
REM


analyze table SALES compute statistics;
REM
REM  Script 6:  Determine the number of blocks allocated to SALES.
REM

select Blocks
  from DBA_SEGMENTS
 where Owner = 'APPOWNER'
   and Segment_Name = 'SALES';
REM
REM  Script 7:  Determine the number of blocks in SALES above the highwatermark
REM

select Empty_Blocks
  from DBA_TABLES
 where Owner = 'APPOWNER'
   and Table_Name = 'SALES';

REM
REM  Script 8:  Executing the DBMS_SPACE package to determine the highwatermark
REM

declare
        OP1 number;
        OP2 number;
        OP3 number;
        OP4 number;
        OP5 number;
        OP6 number;
        OP7 number;
begin
dbms_space.unused_space('APPOWNER','SALES','TABLE',
                          OP1,OP2,OP3,OP4,OP5,OP6,OP7);
   dbms_output.put_line('OBJECT_NAME       = SALES');
   dbms_output.put_line('---------------------------');
   dbms_output.put_line('TOTAL_BLOCKS      = '||OP1);
   dbms_output.put_line('TOTAL_BYTES       = '||OP2);
   dbms_output.put_line('UNUSED_BLOCKS     = '||OP3);
   dbms_output.put_line('UNUSED_BYTES      = '||OP4);
end;
/

REM
REM  Script 9:  Create a view grouping by all columns, for use in ordering rows
REM

create or replace view COMPANY_VIEW as
select Company_ID,
       Name,
       Address,
       City,
       State,
       Zip,
       Parent_Company_ID,
       Active_Flag
  from COMPANY
 group by Company_ID,
          Name,
          Address,
          City,
          State,
          Zip,
          Parent_Company_ID,
          Active_Flag
          RowNum;

REM
REM  Script 10:  Create COMPANY_ORDERED, with all rows sorted
REM          prior to insertion.
REM

create table COMPANY_ORDERED
    as select * from COMPANY_VIEW;

REM
REM   Script 11:  Sample storage parameters for TEMP.
REM

alter tablespace TEMP
default storage (initial 1M next 1M pctincrease 0
        minextents 1 maxextents 249);

REM
REM  Script 12:  View temporary segments in use.
REM

select *
  from DBA_SEGMENTS
 where Segment_Type = 'TEMPORARY';

REM
REM  Script 13:  Manually coalesce the TEMP tablespace (7.3)
REM

alter tablespace TEMP coalesce;


REM
REM  Script 14:  Sample creation scripts for 3 rollback segments.
REM

create rollback segment R1
tablespace RBS
storage (initial 2M next 2M minextents 2 maxextents 249 
         optimal 20M);

create rollback segment R2
tablespace RBS
storage (initial 2M next 2M minextents 2 maxextents 249 
         optimal 20M);

create rollback segment R3
tablespace RBS
storage (initial 2M next 2M minextents 2 maxextents 249 
         optimal 20M);


REM
REM  Script 15:  Query of V$ROLLSTAT to determine the number of 
REM          wraps, extends, and shrinks of each rollback segment.
REM

select Name, 
       OptSize, 
       Shrinks, 
       AveShrink, 
       Wraps, 
       Extends
  from V$ROLLSTAT, V$ROLLNAME
 where V$ROLLSTAT.USN=V$ROLLNAME.USN;


REM
REM  Script 16:  Manual command to shrink a rollback segment (7.2).
REM

alter rollback segment R2 shrink;

REM
REM  Script 17:  Take the R_BIG rollback segment offline and then back 
REM          online.
REM

alter rollback segment R_BIG offline;
alter rollback segment R_BIG online;

REM
REM  Script 18:  Sample tablespace creation.
REM

create tablespace APP_REF
datafile '/db02/oracle/APP/app_ref01.dbf' size 100M,
         '/db03/oracle/APP/app_ref02.dbf' size 50M
default storage (initial 1M next 1M pctincrease 0 
            maxextents 249);

REM
REM  Script 19:  Free space map of the APP_REF tablespace.
REM

select File_ID, 
       Block_ID, 
       Bytes, 
       Blocks
  from DBA_FREE_SPACE
 where Tablespace_Name = 'APP_REF'
 order by File_ID, Block_ID;


REM
REM  Script 20:  Free space coalesce of the APP_REF tablespace.
REM


alter tablespace APP_REF coalesce;

REM
REM  Script 21:  ALTER TABLESPACE command to set PCTINCREASE 1 as the 
REM          default for APP_REF.
REM

alter tablespace APP_REF 
default storage (pctincrease 1);

REM
REM  Script 22:  Sample creation of a table in APP_REF, specifying 
REM          PCTINCREASE 0.
REM

create table TEST_TABLE
(x  VARCHAR2(10))
tablespace APP_REF
storage (initial 1M next 1M pctincrease 0);





--Boundary=_0.0_=0012200001496367--
