Rem
Rem Programa: PCDS.SQL 
Rem Descricao: Script SQL para criacao das replicas do projeto PROCOL
Rem            na SONDA
Rem Data Atualizacao	Programador	Modificacao
Rem 8:28 AM 5/8/1998	CHennig		Criacao
Rem
Rem Observacoes: 
Rem		1.) O usuario PER/TBB/EEP/ITV deve ter os seguintes privilegios para
Rem		    poder criar os snapshots:
Rem		    - CREATE SNAPSHOT
Rem		    - CREATE TABLE
Rem		    - CREATE VIEW
Rem		    - UNLIMITED TABLESPACE na Tablespace onde os snapshots
Rem		      serao gravados
Prompt ----------------------------------------
Prompt Configura ambiente de execucao do script
Prompt ----------------------------------------
set echo on
set feed on
spool c:\pcds.log
Prompt ----------------------------------------
Prompt Solicita a string de conexao com a SONDA
Prompt ----------------------------------------
undef strcsonda
accept strcsonda char prompt 'Entre com a string de conexao com a SONDA: '
Prompt -----------------------------------------------
Prompt Solicita o database link entre a SONDA e a U.O.
Prompt -----------------------------------------------
undef dbluo
accept dbluo char prompt 'Entre com o DBL com a U.O.: '
Prompt ----------------------------------------------------
Prompt Comeca a criacao das replicas na SONDA no schema PER
Prompt ----------------------------------------------------
Rem
Rem Conecta-se ao usuario PER na SONDA
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema PER: '
connect system/&pwd@&strcsonda
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema PER
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema PER: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema PER: '
Prompt Criando snapshot PER.AQUIS_LOTE - 8
drop snapshot per.aquis_lote;
create snapshot per.aquis_lote
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.aquis_lote@&dbluo;
Prompt Termino da criacao do snapshot PER.AQUIS_LOTE - 8
Prompt
Prompt Criando snapshot PER.CARACTER_GEOM - 18
drop snapshot per.caracter_geom;
create snapshot per.caracter_geom
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.snap$_caracter_geom@&dbluo;
Prompt Termino da criacao do snapshot PER.CARACTER_GEOM - 18
Prompt
Prompt Criando snapshot PER.PROPRIEDAD_MEC - 19
drop snapshot per.propriedad_mec;
create snapshot per.propriedad_mec
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.snap$_propriedad_mec@&dbluo;
Prompt Termino da criacao do snapshot PER.PROPRIEDAD - 19
Prompt
Prompt Criando snapshot PER.ELEM_GERADO - 22
drop snapshot per.elem_gerado;
create snapshot per.elem_gerado
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.elem_gerado@&dbluo;
Prompt Termino da criacao do snapshot PER.ELEM_GERADO - 22
Prompt
Prompt Criando snapshot PER.LIMIT_GER_FAD - 37
drop snapshot per.limit_ger_fad;
create snapshot per.limit_ger_fad
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.snap$_limit_ger_fad@&dbluo;
Prompt Termino da criacao do snapshot PER.LIMIT_GER_FAD - 37
Prompt
Prompt ------------------------------------------------------
Prompt Termino da criacao das replicas na SONDA no schema PER
Prompt ------------------------------------------------------
Prompt ----------------------------------------------------
Prompt Comeca a criacao das replicas na SONDA no schema EEP
Prompt ----------------------------------------------------
Rem
Rem Conecta-se ao usuario EEP na SONDA
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema EEP: '
connect system/&pwd@&strcsonda
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema EEP
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema EEP: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema EEP: ' 
Prompt Criando snapshot EEP.EMPRESA - 26
drop snapshot eep.empresa;
create snapshot eep.empresa
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from eep.empresa@&dbluo;
Prompt Termino da criacao snapshot EEP.EMPRESA - 26
Prompt
Prompt Criando snapshot EEP.UNID_OPERATIVA - 29
drop snapshot eep.unid_operativa;
create snapshot eep.unid_operativa
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from eep.snap$_unid_operativa@&dbledise;
Prompt Termino da criacao snapshot EEP.UNID_OPERATIVA - 29
Prompt
Prompt Criando snapshot EEP.POCO - 39
drop snapshot eep.poco;
create snapshot eep.poco
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from eep.snap$_poco@&dbledise;
Prompt Termino da criacao snapshot EEP.POCO - 39
Prompt
Prompt ------------------------------------------------------
Prompt Termino da criacao das replicas na SONDA no schema EEP
Prompt ------------------------------------------------------
Prompt ----------------------------------------------------
Prompt Comeca a criacao das replicas na SONDA no schema TBB
Prompt ----------------------------------------------------
Rem
Rem Conecta-se ao usuario TBB na SONDA
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema TBB: '
connect system/&pwd@&strcsonda
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema TBB
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema TBB: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema TBB: '
Prompt Criando snapshot TBB.TP_ELEMEN_COLU - 14
drop snapshot tbb.tp_elemen_colu;
create snapshot tbb.tp_elemen_colu
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from tbb.snap$_tp_elemen_colu@&dbluo;
Prompt Termino da criacao snapshot TBB.TP_ELEMEN_COLU - 14
Prompt
Prompt Criando snapshot TBB.RANGE_COMPRIME - 57
drop snapshot tbb.range_comprime;
create snapshot tbb.range_comprime
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from tbb.snap$_range_comprime@&dbluo;
Prompt Termino da criacao snapshot TBB.RANGE_COMPRIME - 57
Prompt
Prompt ------------------------------------------------------
Prompt Termino da criacao das replicas na SONDA no schema TBB
Prompt ------------------------------------------------------
Prompt ---------------------------------------------------
Prompt Comeca a criacao das replicas na U.O. no schema ITV
Prompt ---------------------------------------------------
Rem
Rem Conecta-se ao usuario ITV na UO
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema ITV: '
connect system/&pwd@&strcsonda
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema ITV
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema ITV: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema ITV: ' 
Prompt Criando snapshot ITV.GRAU_DE_ACO - 27
drop snapshot itv.grau_de_aco;
create snapshot itv.grau_de_aco
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from itv.snap$_grau_de_aco@&dbluo;
Prompt Termino da criacao snapshot ITV.GRAU_DE_ACO - 27
Prompt
Prompt ---------------------------------------------------
Prompt Termino da criacao das replicas na SONDA schema ITV
Prompt ---------------------------------------------------
Prompt ----------------------------------------------------
Prompt Comeca a criacao das replicas na SONDA no schema ENG
Prompt ----------------------------------------------------
Rem
Rem Conecta-se ao usuario ENG na UO
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema ENG: '
connect system/&pwd@&strcsonda
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema ENG
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema ENG: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema ENG: ' 
Prompt Criando snapshot ENG.SONDA - 34
drop snapshot eng.sonda;
create snapshot eng.sonda
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from eng.snap$_sonda@&dbluo;
Prompt Termino da criacao snapshot ENG.SONDA - 34
Prompt
Prompt ------------------------------------------------------
Prompt Termino da criacao das replicas na SONDA no schema ENG
Prompt ------------------------------------------------------