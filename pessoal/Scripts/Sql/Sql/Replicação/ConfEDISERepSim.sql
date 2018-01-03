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
spool c:\ConfEDISERepSim.log
prompt ------------------------------------------------------------
prompt Inicio da configuracao do EDISE como SNAPSHOT UPDATABLE SITE
prompt ------------------------------------------------------------
prompt Elimina o usuario administrador dos snapshots no EDISE
connect system/es@edise
drop user snapadmin cascade;
prompt Cria o usuario SNAPADMIN, administrador dos snapshots no EDISE
create user SNAPADMIN identified by SNAPADMIN_EDISE;
prompt Fornece privilegios de administrador para o usuario SNAPADMIN no EDISE
begin
   dbms_repcat_admin.grant_admin_any_schema(username => 'SNAPADMIN');
end;
/
grant comment any table to SNAPADMIN;
grant lock any table to SNAPADMIN;
prompt Registra o usuario SNAPADMIN como propagador no EDISE
begin
   dbms_defer_sys.register_propagator(username => 'SNAPADMIN');
end;
/
prompt Cria link entre o EDISE e a UO (MASTER SITE)
create public database link uo.world using 'TNS:uo';
connect snapadmin/snapadmin_edise@edise
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
prompt Fornece permissoes necessarias para o SNAPADMIN no EDISE
connect sys/es@edise
grant execute on sys.dbms_defer to snapadmin;
prompt -------------------------------------------------------------
prompt Termino da configuracao do EDISE como SNAPSHOT UPDATABLE SITE
prompt -------------------------------------------------------------
set echo off
spool off