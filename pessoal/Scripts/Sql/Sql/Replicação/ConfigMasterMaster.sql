
/*-- Connection to: SYS@JECH.WORLD --*/


/*-- Connection to: SYSTEM@JECH.WORLD --*/


/*---
Creating user 'REPADMIN' at site 'plutao.WORLD'
---*/

create user REPADMIN identified by REPADMIN;

/*---
Granting admin privileges to user 'REPADMIN' at site 'plutao.WORLD'
---*/

begin
	dbms_repcat_admin.grant_admin_any_schema(
	username => 'REPADMIN');
end;
/

/*---
Granting admin privileges to user 'REPADMIN' at site 'plutao.WORLD'
---*/

grant comment any table to REPADMIN;

/*---
Granting admin privileges to user 'REPADMIN' at site 'plutao.WORLD'
---*/

grant lock any table to REPADMIN;

/*---
Registering user 'REPADMIN' as propagator at site 'PLUTAO.WORLD'
---*/

begin
   dbms_defer_sys.register_propagator(username => 'REPADMIN');
end;
/

/*---
Granting privileges to user 'REPADMIN'
---*/

grant execute any procedure to REPADMIN;

/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*---
Scheduling purge at site 'PLUTAO.WORLD'
---*/

begin
   dbms_defer_sys.schedule_purge(
    next_date => sysdate,
    interval => '/*1:Day*/ sysdate + 1',
    delay_seconds => 500000,
    rollback_segment => '');
end;
/

/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*-- Connection to: REPADMIN@JECH.WORLD --*/


/*-- Connection to: SYSTEM@HMLG.WORLD --*/


/*---
Creating user 'REPADMIN' at site 'urano.world'
---*/

create user REPADMIN identified by REPADMIN;

/*---
Granting admin privileges to user 'REPADMIN' at site 'urano.world'
---*/

begin
	dbms_repcat_admin.grant_admin_any_schema(
	username => 'REPADMIN');
end;
/
/******** Error:
ORA-06550: line 2, column 2:
PLS-00201: identifier 'DBMS_REPCAT_ADMIN.GRANT_ADMIN_ANY_SCHEMA' must be declared
ORA-06550: line 2, column 2:
PL/SQL: Statement ignored
********/

/*---
Registering user 'REPADMIN' as propagator at site 'URANO.WORLD'
---*/

begin
   dbms_defer_sys.register_propagator(username => 'REPADMIN');
end;
/
/******** Error:
ORA-06550: line 2, column 4:
PLS-00201: identifier 'DBMS_DEFER_SYS.REGISTER_PROPAGATOR' must be declared
ORA-06550: line 2, column 4:
PL/SQL: Statement ignored
********/

/*---
Granting privileges to user 'REPADMIN'
---*/

grant execute any procedure to REPADMIN;

/*---
Creating user 'REPADMIN' at site 'urano.world'
---*/

create user REPADMIN identified by REPADMIN;

/*---
Granting admin privileges to user 'REPADMIN' at site 'urano.world'
---*/

begin
	dbms_repcat_admin.grant_admin_any_schema(
	username => 'REPADMIN');
end;
/

/*---
Granting admin privileges to user 'REPADMIN' at site 'urano.world'
---*/

grant comment any table to REPADMIN;

/*---
Granting admin privileges to user 'REPADMIN' at site 'urano.world'
---*/

grant lock any table to REPADMIN;

/*---
Registering user 'REPADMIN' as propagator at site 'URANO.WORLD'
---*/

begin
   dbms_defer_sys.register_propagator(username => 'REPADMIN');
end;
/

/*---
Granting privileges to user 'REPADMIN'
---*/

grant execute any procedure to REPADMIN;

/*-- Connection to: REPADMIN@HMLG.WORLD --*/


/*---
Scheduling purge at site 'URANO.WORLD'
---*/

begin
   dbms_defer_sys.schedule_purge(
    next_date => sysdate,
    interval => '/*1:Day*/ sysdate + 1',
    delay_seconds => 500000,
    rollback_segment => '');
end;
/

/*-- Connection to: REPADMIN@HMLG.WORLD --*/

