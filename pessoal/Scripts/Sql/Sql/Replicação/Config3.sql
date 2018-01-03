set echo on

spool c:\config3.log

rem script que adiciona um snapshot updatable ao PO8

rem cria a tabela nova para a replica

connect repteste/repteste@ardosia
drop table t2;
create table t2 (n2 number,banco varchar2(10),d2 date,blob1 blob);
alter table t2 add constraint t2_pk primary key (n2);
create snapshot log on t2;

rem adiciona a tabela 'T2' ao master group TESTE

connect repadmin/repadmin@ardosia
begin
   dbms_repcat.suspend_master_activity(gname => 'TESTE');
end;
/
begin
   dbms_repcat.create_master_repobject(
      gname => 'TESTE',
      type => 'TABLE',
      oname => 'T2',
      sname => 'REPTESTE',
      use_existing_object => TRUE,
      copy_rows => TRUE);
end;
/

rem generating replication support for table 'T2'.

begin 
    dbms_repcat.generate_replication_support(
      sname => 'REPTESTE',
      oname => 'T2', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/

rem resuming replication on group 'TESTE'

begin 
   dbms_repcat.resume_master_activity(
      gname => 'TESTE'); 
end;
/

rem cria snapshot t2

connect repteste/repteste@sonda
create snapshot repteste.t2
   refresh fast
   with primary key 
   for update
   as 
      select * 
      from REPTESTE.T2@orcl.world;

rem cadastrando snapshot T2 como objeto de replicacao

connect snapadmin/snapadmin@sonda

begin
   dbms_repcat.create_snapshot_repobject(
      gname => 'TESTE',
      sname => 'REPTESTE',
      oname => 'T2',
      type => 'SNAPSHOT',
      ddl_text => 'create snapshot REPTESTE.T2 refresh fast with primary key for update as select * from REPTESTE.T2@orcl.world',
      min_communication => TRUE);
end;
/

rem adding 'T2' to snapshot refresh group 'TESTE'

begin
   dbms_refresh.add(
      name => 'SNAPADMIN.TESTE',
      list => 'REPTESTE.T2',
      lax => TRUE);
end;
/

rem verificar se o job esta executando com sucesso

spool off

set echo off