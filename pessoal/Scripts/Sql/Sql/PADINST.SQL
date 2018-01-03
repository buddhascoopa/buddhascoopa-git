rem
rem Script de criacao dos padroes da SC em um banco de dados de producao
rem Devera ser rodado como SYSTEM
rem
rem 14:44  6/11/96
rem
rem Última atualização : Carlos Christiano
rem 09:05 08/01/98
rem
spool c:\padinst.lis
rem
accept instance  char prompt 'Entre com o nome da instance: '
accept datafile  char prompt 'Entre com o datafile da Tablespace dut1d: '
accept datafile1 char prompt 'Entre com o datafile da Tablespace rep1d: '
Prompt
Prompt Criando roles padrao
Prompt
create role acesso
/
grant create session, alter session to acesso;
grant create table, create view     to acesso
/
create role sistem
/
grant alter user          to sistem;
grant create any sequence to sistem;
grant select any sequence to sistem;
grant alter any snapshot  to sistem
/
create role consulta
/
create role admin_usuar
/
grant create user, drop user, alter user to admin_usuar;
grant sistem, acesso, consulta           to admin_usuar with admin option
/
create role adm
/
grant connect, resource                          to adm;
grant create public synonym, drop public synonym to adm;
grant create snapshot                            to adm
/
create role odbc
/
grant odbc to acesso
/
Prompt 
Prompt Criando tabelas do Forms 40
Prompt
@m:\cde12\forms40\frm4bild.sql
rem @m:\software\oracle\cde12\forms40\frm4grnt.sql
Prompt
Prompt Forncendo os grants nas tabelas do Forms 40 para o dut
Prompt
grant select on frm40_mnugrp        to acesso;
grant select on frm40_mnuuser       to acesso
/
Prompt
Prompt Criando profile submissao
Prompt
create profile submissao
limit
sessions_per_user unlimited
idle_time         unlimited
/
Prompt 
Prompt Alterando profile default
Prompt
alter profile default
limit
sessions_per_user 2
idle_time         20
/
Prompt
Prompt Criar usuários ops$
Prompt
create user ops$oracle identified externally
default tablespace users
temporary tablespace temp
profile submissao
/
grant connect, resource, dba to ops$oracle
/
create user ops$&instance identified externally
default tablespace users
temporary tablespace temp
profile submissao
/
grant acesso, sistem to ops$&instance
/
create user ops$root identified externally
default tablespace users
temporary tablespace temp
profile submissao
/
grant connect, resource, sistem to ops$root
/
create user ops$daemon identified externally
default tablespace users
temporary tablespace temp
profile submissao
/
grant connect, resource, sistem to ops$daemon
/
Prompt
Prompt Criar usuario de conexao entre bancos de producao
Prompt
create user dblu$&instance identified by dblu$&instance
default tablespace users
temporary tablespace temp
profile submissao
/
grant acesso, sistem, create any sequence to dblu$&instance
/
Prompt
Prompt Criacao de usuarios e tablespace para DUS, DUT, DDD e DG3
Prompt
create tablespace dut1d
datafile '&datafile'
size 20m
autoextend on next 2m maxsize 40m
/
create user ddd identified by ddd
default tablespace dut1d
temporary tablespace temp
quota unlimited on dut1d
/
grant acesso, sistem, admin_usuar, adm, consulta             to ddd;
grant create public database link, drop public database link to ddd;
grant create public synonym, drop public synonym             to ddd;
grant create any sequence, drop any sequence                 to ddd;
grant create snapshot, create trigger                        to ddd;
grant select on sys.dba_tab_privs                            to ddd with admin option;
grant select on sys.dba_role_privs                           to ddd with admin option
/
create user dut identified by dut
default tablespace dut1d
temporary tablespace temp
quota unlimited on dut1d
/
grant acesso, sistem, admin_usuar, adm, consulta             to dut;
grant create public database link, drop public database link to dut;
grant create public synonym, drop public synonym             to dut;
grant create any sequence, drop any sequence                 to dut;
grant create snapshot, create trigger                        to dut
/
create user dus identified by dus
default tablespace dut1d
temporary tablespace temp
quota unlimited on dut1d
/
grant acesso, sistem, admin_usuar, adm, consulta             to dus with admin option;
grant create public database link, drop public database link to dus;
grant create public synonym, drop public synonym             to dus;
grant create any sequence, drop any sequence                 to dus;
grant select on sys.dba_role_privs                           to dus with admin option;
grant select on sys.dba_users				     to dus;
grant select on sys.dba_views				     to dus;
grant select on sys.dba_tables				     to dus;
grant select on sys.dba_synonyms			     to dus;
grant select on sys.dba_sequences			     to dus;
grant create user, drop user, alter user		     to dus;
grant create snapshot, create trigger                        to dus
/
Prompt
Prompt Criacao de usuarios e tablespace para Replicação
Prompt
create tablespace rep1d
datafile '&datafile1'
size 50m autoextend on next 5m maxsize 100m
/
create user dg3 identified by dg3
default tablespace rep1d
temporary tablespace temp
quota unlimited on rep1d
/
grant acesso, sistem, admin_usuar, adm, consulta             to dg3;
grant create public database link, drop public database link to dg3;
grant create public synonym, drop public synonym             to dg3;
grant create any sequence, drop any sequence                 to dg3;
grant create snapshot, create trigger                        to dg3
/
create user cg2 identified by cg2
default tablespace rep1d
temporary tablespace temp
quota unlimited on rep1d
/
grant acesso, sistem, admin_usuar, adm, consulta             to cg2;
grant create public database link, drop public database link to cg2;
grant create public synonym, drop public synonym             to cg2;
grant create any sequence, drop any sequence                 to cg2;
grant create snapshot, create trigger                        to cg2
/
create user ig2 identified by ig2
default tablespace rep1d
temporary tablespace temp
quota unlimited on rep1d
/
grant acesso, sistem, admin_usuar, adm, consulta             to ig2;
grant create public database link, drop public database link to ig2;
grant create public synonym, drop public synonym             to ig2;
grant create any sequence, drop any sequence                 to ig2;
grant create snapshot, create trigger                        to ig2
/
create user mg2 identified by mg2
default tablespace rep1d
temporary tablespace temp
quota unlimited on rep1d
/
grant acesso, sistem, admin_usuar, adm, consulta             to mg2;
grant create public database link, drop public database link to mg2;
grant create public synonym, drop public synonym             to mg2;
grant create any sequence, drop any sequence                 to mg2;
grant create snapshot, create trigger                        to mg2
/
create user pg2 identified by pg2
default tablespace rep1d
temporary tablespace temp
quota unlimited on rep1d
/
grant acesso, sistem, admin_usuar, adm, consulta             to pg2;
grant create public database link, drop public database link to pg2;
grant create public synonym, drop public synonym             to pg2;
grant create any sequence, drop any sequence                 to pg2;
grant create snapshot, create trigger                        to pg2
/
create user fg2 identified by fg2
default tablespace rep1d
temporary tablespace temp
quota unlimited on rep1d
/
grant acesso, sistem, admin_usuar, adm, consulta             to fg2;
grant create public database link, drop public database link to fg2;
grant create public synonym, drop public synonym             to fg2;
grant create any sequence, drop any sequence                 to fg2;
grant create snapshot, create trigger                        to fg2
/

Prompt
Prompt Criacao do usuario dbac
Prompt
create user dbac identified by &instance
default tablespace users
temporary tablespace temp
/
grant connect, resource, dba to dbac
/
Prompt
Prompt Inibe o comando set role all
Prompt
@m:\cde12\plus31\v7pup.sql
commit
/
insert into product_user_profile
values ('SQL*PLUS','%','SET ROLE',NULL,NULL,'DISABLED',NULL,NULL)
/
commit
/
spool off