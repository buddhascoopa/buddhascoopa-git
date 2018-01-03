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
spool c:\ConfRep1.log
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
create public database link pb01.world
   using 'TNS:sonda';
create public database link oracle.world
   using 'TNS:edise';
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
create database link pb01.world
   connect to snapadmin identified by snapadmin_sonda;
create database link oracle.world
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
prompt ------------------------------------------------------------
prompt Inicio da configuracao do EDISE como SNAPSHOT UPDATABLE SITE
prompt ------------------------------------------------------------
prompt Elimina o usuario administrador dos snapshots no EDISE
connect system/edise@edise
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
create public database link orcl.world using 'TNS:uo';
connect snapadmin/snapadmin@edise
create database link orcl.world
   connect to snapadmin identified by snapadmin_uo;
prompt Programando rotinas de administracao para executarem as 22:00h
begin
   dbms_defer_sys.schedule_push(
      destination => 'orcl.world',
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
connect sys/edise@edise
grant execute on sys.dbms_defer to snapadmin;
prompt -------------------------------------------------------------
prompt Termino da configuracao do EDISE como SNAPSHOT UPDATABLE SITE
prompt -------------------------------------------------------------
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
prompt Registra o usuario SNAPADMIN como propagador na SONDA
begin
   dbms_defer_sys.register_propagator(username => 'SNAPADMIN');
end;
/
prompt Cria link entre a SONDA e a UO (MASTER SITE)
create public database link orcl.world using 'TNS:uo';
connect snapadmin/snapadmin@sonda
create database link orcl.world
   connect to snapadmin identified by snapadmin_uo;
prompt Programando rotinas de administracao para executarem as 22:00h
begin
   dbms_defer_sys.schedule_push(
      destination => 'orcl.world',
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
prompt -------------------------------------------------
prompt Inicio da configuracao da replicacao UO <-> EDISE
prompt -------------------------------------------------
prompt Fornecendo as permissoes necessarias ao schema das tabelas nos dois SITES
connect sys/uo@uo
grant execute on sys.dbms_defer to per;
connect sys/edise@edise
grant execute on sys.dbms_defer to per;
prompt Criando o MASTER GROUP de replicacao da UO para o EDISE
connect repadmin/repadmin_uo@uo
begin
   dbms_repcat.drop_master_repgroup(gname => 'G01_PER_EDISE');
end;
/
begin
   dbms_repcat.create_master_repgroup(
      gname => 'G01_PER_EDISE',
      qualifier => '',
      group_comment => '');
end;
/
prompt Adicionando as tabelas envolvidas na replica ao grupo de replicacao 'G01_PER_EDISE'
begin
   dbms_repcat.suspend_master_activity(gname => 'G01_PER_EDISE');
end;
/
begin
   dbms_repcat.create_master_repobject(
      gname => 'G01_PER_EDISE',
      type => 'TABLE',
      oname => 'AQUIS_LOTE',
      sname => 'PER',
      use_existing_object => TRUE,
      copy_rows => TRUE);
end;
/
prompt Gerando rotinas de suporte a replicacao para a tabela PER.AQUIS_LOTE na UO (MASTER) 
begin 
    dbms_repcat.generate_replication_support(
      sname => 'PER',
      oname => 'AQUIS_LOTE', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/
begin 
   dbms_repcat.resume_master_activity(gname => 'G01_PER_EDISE'); 
end;
/
prompt Cria o grupo de replicacao no EDISE para a UO
connect snapadmin/snapadmin@edise
begin
   dbms_repcat.drop_snapshot_repgroup(gname => 'G01_PER_UO');
end;
/
begin
   dbms_repcat.create_snapshot_repgroup(
      gname => 'G01_PER_UO',
      master => 'orcl.world',
      propagation_mode => 'ASYNCHRONOUS');
end;
/
begin
   dbms_refresh.make(name => 'SNAPADMIN.G01_PER_UO',
      list => '', next_date => SYSDATE, interval => '/*24:Hr*/ sysdate + 6/24',
      implicit_destroy => FALSE, rollback_seg => '',
      push_deferred_rpc => TRUE, refresh_after_errors => FALSE);
end;
/
prompt criando o snapshot updatable para a tabela PER.AQUIS_LOTE, da UO, no EDISE
connect per/per@edise
create database link orcl.world
   connect to snapadmin identified by snapadmin_uo;
create snapshot per.aquis_lote
   refresh fast
   start with sysdate
   next trunc(sysdate+1) + 6/24
   with primary key 
   for update
   as 
      select * 
      from per.aquis_lote@orcl.world;
rem cadastrando snapshot PER.AQUIS_LOTE como objeto de replicacao no EDISE
connect snapadmin/snapadmin@edise
begin
   dbms_repcat.create_snapshot_repobject(
      gname => 'G01_PER_UO',
      sname => 'PER',
      oname => 'AQUIS_LOTE',
      type => 'SNAPSHOT',
      ddl_text => 'create snapshot PER.AQUIS_LOTE refresh fast start with sysdate next trunc(sysdate+1)+6/24 with primary key for update as select * from per.aquis_lote@orcl.world',
      min_communication => TRUE);
end;
/
prompt Adicionando PER.AQUIS_LOTE para o refresh group 'G01_PER_UO' no EDISE
begin
   dbms_refresh.add(
      name => 'SNAPADMIN.G01_PER_UO',
      list => 'PER.AQUIS_LOTE',
      lax => TRUE);
end;
/
prompt --------------------------------------------------
prompt Termino da configuracao da replicacao UO <-> EDISE
prompt --------------------------------------------------
prompt -------------------------------------------------
prompt Inicio da configuracao da replicacao UO <-> SONDA
prompt -------------------------------------------------
prompt Fornecendo as permissoes necessarias ao schema das tabelas nos dois SITES
rem Ja fornecido na execucao do modulo configuracao da replicacao UO <-> EDISE
rem connect sys/uo@uo
rem grant execute on sys.dbms_defer to per;
connect sys/sonda@sonda
grant execute on sys.dbms_defer to per;
prompt Criando o MASTER GROUP 'G01_PER_SONDA' de replicacao da UO para a SONDA
connect repadmin/repadmin_uo@uo
begin
   dbms_repcat.drop_master_repgroup(gname => 'G01_PER_SONDA');
end;
/
begin
   dbms_repcat.create_master_repgroup(
      gname => 'G01_PER_SONDA',
      qualifier => '',
      group_comment => '');
end;
/
prompt Criando o MASTER GROUP 'G02_PER_SONDA' de replicacao da UO para a SONDA
begin
   dbms_repcat.drop_master_repgroup(gname => 'G02_PER_SONDA');
end;
/
begin
   dbms_repcat.create_master_repgroup(
      gname => 'G02_PER_SONDA',
      qualifier => '',
      group_comment => '');
end;
/
prompt Adicionando as tabelas envolvidas na replica ao grupo de replicacao 'G01_PER_SONDA'
prompt Suspende atividade do master group 'G01_PER_SONDA' durante adicao de tabelas
begin
   dbms_repcat.suspend_master_activity(gname => 'G01_PER_SONDA');
end;
/
prompt Adicionando tabela PER.MOVIMENT_LOTE ao master group 'G01_PER_SONDA' na UO
begin
   dbms_repcat.create_master_repobject(
      gname => 'G01_PER_SONDA',
      type => 'TABLE',
      oname => 'MOVIMENT_LOTE',
      sname => 'PER',
      use_existing_object => TRUE,
      copy_rows => TRUE);
end;
/
prompt Gerando rotinas de suporte a replicacao para a tabela PER.MOVIMENT_LOTE na UO (MASTER) 
begin 
    dbms_repcat.generate_replication_support(
      sname => 'PER',
      oname => 'MOVIMENT_LOTE', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/
prompt Adicionando tabela PER.ELEM_MOVIMENTA ao master group 'G01_PER_SONDA' na UO
begin
   dbms_repcat.create_master_repobject(
      gname => 'G01_PER_SONDA',
      type => 'TABLE',
      oname => 'ELEM_MOVIMENTA',
      sname => 'PER',
      use_existing_object => TRUE,
      copy_rows => TRUE);
end;
/
prompt Gerando rotinas de suporte a replicacao para a tabela PER.ELEM_MOVIMENTA na UO (MASTER) 
begin 
    dbms_repcat.generate_replication_support(
      sname => 'PER',
      oname => 'ELEM_MOVIMENTA', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/
prompt Libera atividade do master group 'G01_PER_SONDA' apos a adicao das tabelas
begin 
   dbms_repcat.resume_master_activity(gname => 'G01_PER_EDISE'); 
end;
/
prompt Adicionando as tabelas envolvidas na replica ao grupo de replicacao 'G02_PER_SONDA'
prompt Suspende atividade do master group 'G02_PER_SONDA' durante adicao de tabelas
begin
   dbms_repcat.suspend_master_activity(gname => 'G02_PER_SONDA');
end;
/
prompt Adicionando tabela PER.ELEM_COL_IDENT ao master group 'G02_PER_SONDA' na UO
begin
   dbms_repcat.create_master_repobject(
      gname => 'G02_PER_SONDA',
      type => 'TABLE',
      oname => 'ELEM_COL_IDENT',
      sname => 'PER',
      use_existing_object => TRUE,
      copy_rows => TRUE);
end;
/
prompt Gerando rotinas de suporte a replicacao para a tabela PER.ELEM_COL_IDENT na UO (MASTER) 
begin 
    dbms_repcat.generate_replication_support(
      sname => 'PER',
      oname => 'ELEM_COL_IDENT', 
      type => 'TABLE',
      min_communication => TRUE); 
end;
/
prompt Libera atividade do master group 'G02_PER_SONDA' apos a adicao das tabelas
begin 
   dbms_repcat.resume_master_activity(gname => 'G02_PER_EDISE'); 
end;
/
prompt Cria os grupos de replicacao na SONDA para a UO
connect snapadmin/snapadmin@sonda
begin
   dbms_repcat.drop_snapshot_repgroup(gname => 'G01_PER_UO');
end;
/
begin
   dbms_repcat.drop_snapshot_repgroup(gname => 'G02_PER_UO');
end;
/
begin
   dbms_repcat.create_snapshot_repgroup(
      gname => 'G01_PER_UO',
      master => 'orcl.world',
      propagation_mode => 'ASYNCHRONOUS');
end;
/
begin
   dbms_repcat.create_snapshot_repgroup(
      gname => 'G02_PER_UO',
      master => 'orcl.world',
      propagation_mode => 'ASYNCHRONOUS');
end;
/
begin
   dbms_refresh.make(name => 'SNAPADMIN.G01_PER_UO',
      list => '', next_date => SYSDATE, interval => '/*24:Hr*/ sysdate + 2/24',
      implicit_destroy => FALSE, rollback_seg => '',
      push_deferred_rpc => TRUE, refresh_after_errors => FALSE);
end;
/
begin
   dbms_refresh.make(name => 'SNAPADMIN.G02_PER_UO',
      list => '', next_date => SYSDATE, interval => '/*24:Hr*/ sysdate + 2/24',
      implicit_destroy => FALSE, rollback_seg => '',
      push_deferred_rpc => TRUE, refresh_after_errors => FALSE);
end;
/
prompt criando o snapshot updatable para a tabela PER.MOVIMENT_LOTE, da UO, na SONDA
connect per/per@sonda
create database link orcl.world
   connect to snapadmin identified by snapadmin_uo;
create snapshot per.moviment_lote
   refresh fast
   with primary key 
   for update
   as 
      select * 
      from per.moviment_lote@orcl.world;
prompt criando o snapshot updatable para a tabela PER.ELEM_MOVIMENTA, da UO, na SONDA
create snapshot per.elem_movimenta
   refresh fast
   with primary key 
   for update
   as 
      select * 
      from per.elem_movimenta@orcl.world;
prompt criando o snapshot updatable para a tabela PER.ELEM_COL_IDENT, da UO, na SONDA
create snapshot per.elem_col_ident
   refresh fast
   with primary key 
   for update
   as 
      select * 
      from per.elem_col_ident@orcl.world;
prompt cadastrando snapshot PER.MOVIMENT_LOTE como objeto de replicacao na SONDA
connect snapadmin/snapadmin@sonda
begin
   dbms_repcat.create_snapshot_repobject(
      gname => 'G01_PER_UO',
      sname => 'PER',
      oname => 'MOVIMENT_LOTE',
      type => 'SNAPSHOT',
      ddl_text => 'create snapshot PER.MOVIMENT_LOTE refresh fast with primary key for update as select * from per.moviment_lote@orcl.world',
      min_communication => TRUE);
end;
/
prompt Adicionando PER.MOVIMENT_LOTE para o refresh group 'G01_PER_UO' na SONDA
begin
   dbms_refresh.add(
      name => 'SNAPADMIN.G01_PER_UO',
      list => 'PER.MOVIMENT_LOTE',
      lax => TRUE);
end;
/
prompt cadastrando snapshot PER.ELEM_MOVIMENTA como objeto de replicacao na SONDA
begin
   dbms_repcat.create_snapshot_repobject(
      gname => 'G01_PER_UO',
      sname => 'PER',
      oname => 'ELEM_MOVIMENTA',
      type => 'SNAPSHOT',
      ddl_text => 'create snapshot PER.ELEM_MOVIMENTA refresh fast with primary key for update as select * from per.elem_movimenta@orcl.world',
      min_communication => TRUE);
end;
/
prompt Adicionando PER.ELEM_MOVIMENTA para o refresh group 'G01_PER_UO' na SONDA
begin
   dbms_refresh.add(
      name => 'SNAPADMIN.G01_PER_UO',
      list => 'PER.ELEM_MOVIMENTA',
      lax => TRUE);
end;
/
prompt cadastrando snapshot PER.ELEM_COL_IDENT como objeto de replicacao na SONDA
begin
   dbms_repcat.create_snapshot_repobject(
      gname => 'G02_PER_UO',
      sname => 'PER',
      oname => 'ELEM_COL_IDENT',
      type => 'SNAPSHOT',
      ddl_text => 'create snapshot PER.ELEM_COL_IDENT refresh fast with primary key for update as select * from per.elem_col_ident@orcl.world',
      min_communication => TRUE);
end;
/
prompt Adicionando PER.ELEM_COL_IDENT para o refresh group 'G02_PER_UO' na SONDA
begin
   dbms_refresh.add(
      name => 'SNAPADMIN.G02_PER_UO',
      list => 'PER.ELEM_COL_IDENT',
      lax => TRUE);
end;
/
prompt --------------------------------------------------
prompt Termino da configuracao da replicacao UO <-> SONDA
prompt --------------------------------------------------
