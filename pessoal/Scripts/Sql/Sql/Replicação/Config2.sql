spool c:\config2.log

rem Connection to: REPADMIN@DB1.WORLD

connect repadmin/repadmin@ardosia

rem creating master group 'Teste'

begin
   dbms_repcat.create_master_repgroup(
      gname => 'Teste',
	  qualifier => '',
	  group_comment => '');
end;
/

rem adding 'TAB1' to master group 'TESTE'

begin
   dbms_repcat.create_master_repobject(
      gname => '"TESTE"',
      type => 'TABLE',
      oname => '"T1"',
      sname => '"REPTESTE"',
      use_existing_object => TRUE,
      copy_rows => TRUE);
end;
/

rem generating replication support for table 'TAB1'.

begin 
    dbms_repcat.generate_replication_support(
      sname => '"REPTESTE"',
      oname => '"T1"', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/

rem resuming replication on group 'TESTE'

begin 
   dbms_repcat.resume_master_activity(
      gname => '"TESTE"'); 
end;
/

rem Connection to: SNAPADMIN@DB2.WORLD

connect snapadmin/snapadmin@sonda

rem creating snapshot group 'TESTE'

begin
   dbms_repcat.create_snapshot_repgroup(
      gname => '"TESTE"',
      master => 'orcl',
      propagation_mode => 'ASYNCHRONOUS');
end;
/

rem creating snapshot refresh group '"TESTE"'

begin
   dbms_refresh.make(name => '"SNAPADMIN"."TESTE"',
      list => '', next_date => SYSDATE, interval => '/*24:Hr*/ sysdate + 1/24',
      implicit_destroy => FALSE, rollback_seg => '',
      push_deferred_rpc => TRUE, refresh_after_errors => FALSE);
end;
/

rem creating snapshot TAB1

begin
   dbms_repcat.create_snapshot_repobject(
      gname => '"TESTE"',
      sname => '"REPTESTE"',
      oname => '"T1"',
      type => 'SNAPSHOT',
      ddl_text => 'create snapshot "REPTESTE"."T1"  refresh fast with primary key for update as select * from "REPTESTE"."T1"@orcl',
      min_communication => TRUE);
end;
/

rem adding 'TAB1' to snapshot refresh group 'TESTE'

begin
   dbms_refresh.add(
      name => '"SNAPADMIN"."TESTE"',
      list => '"REPTESTE"."T1"',
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