rem
rem Descricao: Programa com as DDL de configuracao do ambiente de replicacao simetrica do PROCOL
rem            A UO e o master site no ambiente de replicacao do PROCOL. O EDISE e a SONDA participarao
rem            com SNAPSHOTS UPDATABLE
rem Versao	Data			Autor		Descricao
rem ------	----			-----		---------
rem 1.0	02/06/98 08:25:29	CHennig	Criacao
rem 
rem Configura ambiente da execucao do programa
set echo on
set feed on
rem Liga log da execucao do programa
spool c:\ConfUORepSim.log
prompt -----------------------------------------------------
prompt Inicio configuracao da UO com MASTER REPLICATION SITE
prompt -----------------------------------------------------
prompt Eliminando os usuários usados na replicação na 'UO'
connect system/uo@uo
drop user repadmin cascade;
drop user snapadmin cascade;
prompt Cria o usuario administrador da replicacao e fornece os privilegios necessarios
create user REPADMIN identified by REPADMIN_UO;
begin
   dbms_repcat_admin.grant_admin_any_schema(username => 'REPADMIN');
end;
/
grant comment any table to REPADMIN;
grant lock any table to REPADMIN;
grant execute any procedure to REPADMIN;
prompt Registra o usuario REPADMIN com propagador no site UO
begin
   dbms_defer_sys.register_propagator(username => 'REPADMIN');
end;
/
prompt Cria os database links entre UO a SONDA e o EDISE
drop public database link pb01.world;
create public database link pb01.world
   using 'sonda';
drop public database link es.world;
create public database link es.world
   using 'edise';
prompt Conecta-se ao usuario SYS na UO para dar permissão ao usuario REPADMIN de SYS
connect sys/uo@uo
begin
   dbms_repcat_auth.grant_surrogate_repcat(userid => 'REPADMIN');
end;
/
grant execute on sys.dbms_defer to repadmin;
prompt Programa a "purga" no usuario REPADMIN para as 22:00h todos os dias
connect repadmin/repadmin_uo@uo
begin
   dbms_defer_sys.schedule_purge(
    next_date => sysdate,
    interval => '/*1:Day*/ trunc(sysdate+1)+22/24',
    delay_seconds => 0,
    rollback_segment => '');
end;
/
prompt Cria os database links entre a UO e a SONDA ou o EDISE
drop database link pb01.world;
create database link pb01.world
   connect to snapadmin identified by snapadmin_sonda;
drop database link es.world;
create database link es.world
   connect to snapadmin identified by snapadmin_edise;
prompt Cria o usuario SNAPADMIN, administrador dos snapshots na UO
connect system/uo@uo
create user SNAPADMIN identified by SNAPADMIN_UO;
begin
   dbms_repcat_admin.grant_snapadmin_proxy(username => 'SNAPADMIN');
end;
/
grant alter session to SNAPADMIN;
grant create cluster to SNAPADMIN;
grant create database link to SNAPADMIN;
grant create sequence to SNAPADMIN;
grant create session to SNAPADMIN;
grant create synonym to SNAPADMIN;
grant create table to SNAPADMIN;
grant create view to SNAPADMIN;
grant create procedure to SNAPADMIN;
grant create trigger to SNAPADMIN;
grant unlimited tablespace to SNAPADMIN;
grant create type to  SNAPADMIN;
grant execute any procedure to SNAPADMIN;
grant create any trigger to SNAPADMIN;
grant create any procedure to SNAPADMIN;
grant select any table to SNAPADMIN;
connect sys/uo@uo
grant execute on sys.dbms_defer to SNAPADMIN;
prompt ---------------------------------------------------------
prompt Termino da configuracao da UO com MASTER REPLICATION SITE
prompt ---------------------------------------------------------
spool off
set echo off