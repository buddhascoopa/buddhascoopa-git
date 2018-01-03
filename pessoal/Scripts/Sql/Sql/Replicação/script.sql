
/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
resuming replication on group 'G_SCOTT'.
---*/

begin 
   dbms_repcat.resume_master_activity(
      gname => '"G_SCOTT"'); 
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
Applying Admin Requests for group 'G_SCOTT'
---*/

begin
   dbms_repcat.do_deferred_repcat_admin(
      gname => '"G_SCOTT"',
      all_sites => TRUE);
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
resuming replication on group 'G_SCOTT'.
---*/

begin 
   dbms_repcat.resume_master_activity(
      gname => '"G_SCOTT"'); 
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
running job '6'.
---*/

begin
   dbms_job.run(job => 6);
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*---
Applying Admin Requests for group 'G_SCOTT'
---*/

begin
   dbms_repcat.do_deferred_repcat_admin(
      gname => '"G_SCOTT"',
      all_sites => FALSE);
end;
/

/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
Applying Admin Requests for group 'G_SCOTT'
---*/

begin
   dbms_repcat.do_deferred_repcat_admin(
      gname => '"G_SCOTT"',
      all_sites => FALSE);
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
Applying Admin Requests for group 'G_SCOTT'
---*/

begin
   dbms_repcat.do_deferred_repcat_admin(
      gname => '"G_SCOTT"',
      all_sites => FALSE);
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
resuming replication on group 'G_SCOTT'.
---*/

begin 
   dbms_repcat.resume_master_activity(
      gname => '"G_SCOTT"'); 
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
generating replication support for table 'BONUS'.
---*/

begin 
    dbms_repcat.generate_replication_support(
      sname => '"SCOTT"',
      oname => '"BONUS"', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/

/*---
generating replication support for table 'DEPT'.
---*/

begin 
    dbms_repcat.generate_replication_support(
      sname => '"SCOTT"',
      oname => '"DEPT"', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/

/*---
generating replication support for table 'EMP'.
---*/

begin 
    dbms_repcat.generate_replication_support(
      sname => '"SCOTT"',
      oname => '"EMP"', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/

/*---
generating replication support for table 'SALGRADE'.
---*/

begin 
    dbms_repcat.generate_replication_support(
      sname => '"SCOTT"',
      oname => '"SALGRADE"', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/

/*---
resuming replication on group 'G_SCOTT'.
---*/

begin 
   dbms_repcat.resume_master_activity(
      gname => '"G_SCOTT"'); 
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
Applying Admin Requests for group 'G_SCOTT'
---*/

begin
   dbms_repcat.do_deferred_repcat_admin(
      gname => '"G_SCOTT"',
      all_sites => FALSE);
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
deleting master group 'G_SCOTT'.
---*/

begin
   dbms_repcat.drop_master_repgroup(
      gname => '"G_SCOTT"',
	  drop_contents => FALSE,
      all_sites => TRUE);
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*---
deleting master group 'G_SCOTT'.
---*/

begin
   dbms_repcat.drop_master_repgroup(
      gname => '"G_SCOTT"',
	  drop_contents => FALSE,
      all_sites => FALSE);
end;
/

/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
creating master group 'G_SCOTT'.
---*/

begin
   dbms_repcat.create_master_repgroup(
      gname => 'G_SCOTT',
	  qualifier => '',
	  group_comment => '');
end;
/

/*---
adding 'BONUS' to master group 'G_SCOTT'.
---*/

begin
   dbms_repcat.create_master_repobject(
      gname => '"G_SCOTT"',
      type => 'TABLE',
      oname => '"BONUS"',
      sname => '"SCOTT"',
      use_existing_object => TRUE,
      copy_rows => TRUE);
end;
/

/*---
setting alternate key columns for 'BONUS'.
---*/

begin
   dbms_repcat.set_columns(
      sname => '"SCOTT"', oname => '"BONUS"',
      column_list => '"JOB"');
end;
/

/*---
adding master database 'HMLG' to master group 'G_SCOTT'.
---*/

begin
   dbms_repcat.add_master_database(
      gname => '"G_SCOTT"',
      master => 'HMLG.WORLD',
      use_existing_objects => TRUE,
      copy_rows => TRUE,
      propagation_mode => 'ASYNCHRONOUS');
end;
/

/*---
generating replication support for table 'BONUS'.
---*/

begin 
    dbms_repcat.generate_replication_support(
      sname => '"SCOTT"',
      oname => '"BONUS"', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/

/*---
resuming replication on group 'G_SCOTT'.
---*/

begin 
   dbms_repcat.resume_master_activity(
      gname => '"G_SCOTT"'); 
end;
/

/*---
resuming replication on group 'G_SCOTT'.
---*/

begin 
   dbms_repcat.resume_master_activity(
      gname => '"G_SCOTT"'); 
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*---
Applying Admin Requests for group 'G_SCOTT'
---*/

begin
   dbms_repcat.do_deferred_repcat_admin(
      gname => '"G_SCOTT"',
      all_sites => FALSE);
end;
/

/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*---
running job '23'.
---*/

begin
   dbms_job.run(job => 23);
end;
/

/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/

