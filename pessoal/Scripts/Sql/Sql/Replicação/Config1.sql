spool c:\config1.log

set echo on

rem Eliminando os usuários usados neste teste de replicação 'uo'

rem Connection to: SYSTEM@UO

connect system/uo@uo

drop user repadmin cascade;
drop user snapadmin_sonda cascade;
drop user snapadmin_edise cascade;

rem Connection to: SYSTEM@SONDA

connect system/sonda@sonda

rem drop user repteste cascade;
rem create user repteste identified by repteste
rem    default tablespace user_data
rem    temporary tablespace temporary_data
rem    quota unlimited on user_data;
rem grant connect, resource to repteste;
rem grant create snapshot to repteste;

drop user snapadmin cascade;

rem Connection to: SYSTEM@UO

connect system/uo@uo

rem Creating user 'REPADMIN' at site 'uo'

create user REPADMIN identified by REPADMIN_UO;

rem Granting admin privileges to user 'REPADMIN' at site 'uo'

begin
	dbms_repcat_admin.grant_admin_any_schema(
	username => 'REPADMIN');
end;
/

rem Granting admin privileges to user 'REPADMIN' at site 'uo'

grant comment any table to REPADMIN;

grant lock any table to REPADMIN;

rem Registering user 'REPADMIN' as propagator at site 'uo'

begin
   dbms_defer_sys.register_propagator(username => 'REPADMIN');
end;
/

rem Granting privileges to user 'REPADMIN'

grant execute any procedure to REPADMIN;

rem Cria os database links entre UO e SONDA ou EDISE

create public database link pb01.world
   using 'TNS:sonda';

create public database link oracle.world
   using 'TNS:edise';

conn sys/uo@uo

begin
   dbms_repcat_auth.grant_surrogate_repcat(userid => 'repadmin');
end;
/

rem Connection to: REPADMIN@UO

conn repadmin/repadmin_uo@uo

rem Scheduling purge at site 'uo'

begin
   dbms_defer_sys.schedule_purge(
    next_date => sysdate,
    interval => '/*1:Day*/ sysdate + 1',
    delay_seconds => 0,
    rollback_segment => '');
end;
/

rem Cria os database links entre a UO e a SONDA ou o EDISE

create database link pb01.world
   connect to snapadmin identified by snapadmin;

create database link oracle.world
   connect to snapadmin identified by snapadmin;

rem Connection to: SYSTEM@SONDA

connect system/sonda@sonda

rem Creating user 'SNAPADMIN' at site 'sonda'

create user SNAPADMIN identified by SNAPADMIN;

rem Granting admin privileges to user 'SNAPADMIN' at site 'sonda'

begin
	dbms_repcat_admin.grant_admin_any_schema(
	username => 'SNAPADMIN');
end;
/

rem Granting admin privileges to user 'SNAPADMIN' at site 'sonda'

grant comment any table to SNAPADMIN;

grant lock any table to SNAPADMIN;

rem Registering user 'SNAPADMIN' as propagator at site 'SONDA'

begin
   dbms_defer_sys.register_propagator(username => 'SNAPADMIN');
end;
/

rem Connection to: SYSTEM@UO

connect system/uo@uo

rem Creating user 'SNAPADMIN_SONDA' at site 'SONDA'
rem Creating user 'SNAPADMIN_EDISE' at site 'EDISE'

create user SNAPADMIN_SONDA identified by SNAPADMIN_SONDA;
create user SNAPADMIN_EDISE identified by SNAPADMIN_EDISE;

rem Granting privileges to user 'SNAPADMIN_SONDA'

begin
	dbms_repcat_admin.grant_snapadmin_proxy(username => 'SNAPADMIN_SONDA');
end;
/

begin
	dbms_repcat_admin.grant_snapadmin_proxy(username => 'SNAPADMIN_EDISE');
end;
/

rem Granting privileges to user 'SNAPADMIN_SONDA'
rem Granting privileges to user 'SNAPADMIN_EDISE'

grant alter session to SNAPADMIN_SONDA;
grant create cluster to SNAPADMIN_SONDA;
grant create database link to SNAPADMIN_SONDA;
grant create sequence to SNAPADMIN_SONDA;
grant create session to SNAPADMIN_SONDA;
grant create synonym to SNAPADMIN_SONDA;
grant create table to SNAPADMIN_SONDA;
grant create view to SNAPADMIN_SONDA;
grant create procedure to SNAPADMIN_SONDA;
grant create trigger to SNAPADMIN_SONDA;
grant unlimited tablespace to SNAPADMIN_SONDA;
grant create type to  SNAPADMIN_SONDA;
grant execute any procedure to SNAPADMIN_SONDA;
grant create any trigger to SNAPADMIN_SONDA;
grant create any procedure to SNAPADMIN_SONDA;
grant select any table to SNAPADMIN_SONDA;

grant alter session to SNAPADMIN_EDISE;
grant create cluster to SNAPADMIN_EDISE;
grant create database link to SNAPADMIN_EDISE;
grant create sequence to SNAPADMIN_EDISE;
grant create session to SNAPADMIN_EDISE;
grant create synonym to SNAPADMIN_EDISE;
grant create table to SNAPADMIN_EDISE;
grant create view to SNAPADMIN_EDISE;
grant create procedure to SNAPADMIN_EDISE;
grant create trigger to SNAPADMIN_EDISE;
grant unlimited tablespace to SNAPADMIN_EDISE;
grant create type to  SNAPADMIN_EDISE;
grant execute any procedure to SNAPADMIN_EDISE;
grant create any trigger to SNAPADMIN_EDISE;
grant create any procedure to SNAPADMIN_EDISE;
grant select any table to SNAPADMIN_EDISE;

rem Connection to: SYSTEM@SONDA

connect system/sonda@sonda

rem Creating link from SONDA to UO

create public database link orcl.world using 'TNS:uo';

rem Connection to: SNAPADMIN@SONDA

connect snapadmin/snapadmin@sonda

rem Creating link from SONDA ou EDISE to UO

create database link orcl.world
   connect to snapadmin_sonda identified by snapadmin_sonda;

create database link orcl.world
   connect to snapadmin_edise identified by snapadmin_edise;

rem Scheduling database link 'ORCL.WORLD'.

begin
   dbms_defer_sys.schedule_push(
      destination => 'orcl.world',
      interval => '/*1:Hr*/ sysdate + 1/24',
      next_date => sysdate,
      stop_on_error => FALSE,
      delay_seconds => 0,
      parallelism => 1);
end;
/

rem Scheduling purge at site 'SONDA'

begin
   dbms_defer_sys.schedule_purge(
    next_date => sysdate,
    interval => '/*1:Day*/ sysdate + 1',
    delay_seconds => 0,
    rollback_segment => '');
end;
/

rem grants necessarios para o owner 'repteste' das tabelas

conn sys/uo@uo

grant execute on sys.dbms_defer to per;

grant execute on sys.dbms_defer to repadmin;

grant execute on sys.dbms_defer to snapadmin_sonda;
grant execute on sys.dbms_defer to snapadmin_edise;

conn sys/sonda@sonda

grant execute on sys.dbms_defer to per;

grant execute on sys.dbms_defer to snapadmin;

rem Connection to: REPADMIN@UO

connect repadmin/repadmin_uo@uo

rem creating master group 'Teste'

begin
   dbms_repcat.drop_master_repgroup(gname => 'G01_PER');
end;
/

begin
   dbms_repcat.create_master_repgroup(
      gname => 'G01_PER',
      qualifier => '',
      group_comment => '');
end;
/

rem adding 'T1' to master group 'G01_PER'

begin
   dbms_repcat.suspend_master_activity(gname => 'G01_PER');
end;
/

begin
   dbms_repcat.create_master_repobject(
      gname => 'G01_PER',
      type => 'TABLE',
      oname => 'AQUIS_LOTE',
      sname => 'PER',
      use_existing_object => TRUE,
      copy_rows => TRUE);
end;
/

rem generating replication support for table 'AQUIS_LOTE'.

begin 
    dbms_repcat.generate_replication_support(
      sname => 'PER',
      oname => 'AQUIS_LOTE', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/

rem resuming replication on group 'G01_PER'

begin 
   dbms_repcat.resume_master_activity(
      gname => 'G01_PER'); 
end;
/

rem Connection to: SNAPADMIN@SONDA

connect snapadmin/snapadmin@sonda

rem creating snapshot group 'G01_PER'

begin
   dbms_repcat.drop_snapshot_repgroup(gname => 'G01_PER');
end;
/

begin
   dbms_repcat.create_snapshot_repgroup(
      gname => 'G01_PER',
      master => 'orcl.world',
      propagation_mode => 'ASYNCHRONOUS');
end;
/

rem creating snapshot refresh group 'G01_PER'

begin
   dbms_refresh.make(name => 'SNAPADMIN.G01_PER',
      list => '', next_date => SYSDATE, interval => '/*24:Hr*/ sysdate + 6/24',
      implicit_destroy => FALSE, rollback_seg => '',
      push_deferred_rpc => TRUE, refresh_after_errors => FALSE);
end;
/

rem creating snapshot PER.AQUIS_LOTE

connect per/per@edise

create database link orcl.world
   connect to snapadmin_sonda identified by snapadmin_sonda;

create database link orcl.world
   connect to snapadmin_edise identified by snapadmin_edise;

create snapshot per.aquis_lote
   refresh fast
   start with sysdate
   next trunc(sysdate+1) + 6/24
   with primary key 
   for update
   as 
      select * 
      from per.aquis_lote@orcl.world;

rem cadastrando snapshot AQUIS_LOTE como objeto de replicacao

connect snapadmin/snapadmin@sonda

begin
   dbms_repcat.create_snapshot_repobject(
      gname => 'G01_PER',
      sname => 'PER',
      oname => 'AQUIS_LOTE',
      type => 'SNAPSHOT',
      ddl_text => 'create snapshot PER.AQUIS_LOTE refresh fast start with sysdate next trunc(sysdate+1)+6/24 with primary key for update as select * from REPTESTE.T1@orcl.world',
      min_communication => TRUE);
end;
/

rem adding 'AQUIS_LOTE' to snapshot refresh group 'G01_PER'

begin
   dbms_refresh.add(
      name => 'SNAPADMIN.G01_PER',
      list => 'PER.AQUIS_LOTE',
      lax => TRUE);
end;
/

rem updating job '3'
rem begin
rem    dbms_job.change(job => 3,
rem       next_date => NULL,
rem       interval => '/*10:Mins*/ sysdate + 10/(60*24)',
rem       what => NULL);
rem end;
rem /

spool off

set echo off