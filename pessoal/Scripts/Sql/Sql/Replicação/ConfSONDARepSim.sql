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
spool c:\ConfSONDARepSim.log
prompt ------------------------------------------------------------
prompt Inicio da configuracao da SONDA como SNAPSHOT UPDATABLE SITE
prompt ------------------------------------------------------------
prompt Elimina o usuario administrador dos snapshots na SONDA
connect system/sonda@sonda
drop user snapadmin cascade;
prompt Cria o usuario SNAPADMIN, administrador dos snapshots na SONDA
create user SNAPADMIN identified by SNAPADMIN_SONDA;
prompt Fornece privilegios de administrador para o usuario SNAPADMIN na SONDA
begin
   dbms_repcat_admin.grant_admin_any_schema(username => 'SNAPADMIN');
end;
/
grant comment any table to SNAPADMIN;
grant lock any table to SNAPADMIN;
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
prompt Registra o usuario SNAPADMIN como propagador na SONDA
begin
   dbms_defer_sys.register_propagator(username => 'SNAPADMIN');
end;
/
prompt Cria link entre a SONDA e a UO (MASTER SITE)
drop public database link uo.world;
create public database link uo.world using 'TNS:uo';
connect snapadmin/snapadmin_sonda@sonda
create database link uo.world
   connect to snapadmin identified by snapadmin_uo;
prompt Programando rotinas de administracao para executarem as 22:00h
begin
   dbms_defer_sys.schedule_push(
      destination => 'uo.world',
      interval => '/*1:Hr*/ trunc(sysdate+1)+22/24',
      next_date => sysdate,
      stop_on_error => FALSE,
      delay_seconds => 0,
      parallelism => 1);
end;
/
begin
   dbms_defer_sys.schedule_purge(
    next_date => sysdate,
    interval => '/*1:Day*/ trunc(sysdate+1)+22/24',
    delay_seconds => 0,
    rollback_segment => '');
end;
/
prompt Fornece permissoes necessarias para o SNAPADMIN na SONDA
connect sys/sonda@sonda
grant execute on sys.dbms_defer to snapadmin;
prompt -------------------------------------------------------------
prompt Termino da configuracao da SONDA como SNAPSHOT UPDATABLE SITE
prompt -------------------------------------------------------------
spool off
set echo off