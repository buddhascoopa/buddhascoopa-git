Rem
Rem Programa: PCDUO.SQL 
Rem Descricao: Script SQL para criacao das replicas do projeto PROCOL
Rem            na UO
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
spool c:\pcduo.log
Prompt ---------------------------------------
Prompt Solicita a string de conexao com a U.O.
Prompt ---------------------------------------
undef strcuo
accept strcuo char prompt 'Entre com a string de conexao com a U.O.: '
Prompt --------------------------------------------------------
Prompt Solicita o database link entre a U.O. e os outros bancos
Prompt --------------------------------------------------------
undef dblsonda
undef dbledise
undef dblcenpes
accept dblsonda   char prompt 'Entre com o DBL com a SONDA : '
accept dbledise   char prompt 'Entre com o DBL com o EDISE : '
accept ebdlcenpes char prompt 'Entre com o DBL com o CENPES: '
Prompt ---------------------------------------------------
Prompt Comeca a criacao das replicas na U.O. no schema PER
Prompt ---------------------------------------------------
Rem
Rem Conecta-se ao usuario PER na UO
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema PER: '
connect system/&pwd@&strcuo
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema PER
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema PER: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema PER: '
Prompt Criando snapshot PER.OCORREN_POCO - 1
drop snapshot log on per.snap$_ocorren_poco;
drop snapshot per.ocorren_poco;
create snapshot per.ocorren_poco
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.ocorren_poco@&dblsonda;
Prompt Criando snapshot log em PER.OCORREN_POCO - 1 para alimentar as outras unidades
create snapshot log on per.snap$_ocorren_poco;
Prompt Termino da criacao do snapshot PER.OCORREN_POCO - 1
Prompt
Prompt Criando snapshot PER.OCORREN_PRISAO - 3
drop snapshot log on per.snap$_ocorren_prisao;
drop snapshot per.ocorren_prisao;
create snapshot per.ocorren_prisao
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.ocorren_prisao@&dblsonda;
Prompt Criando snapshot log em PER.OCORREN_PRISAO - 3 para alimentar as outras unidades
create snapshot log on per.snap$_ocorren_prisao;
Prompt Termino da criacao do snapshot PER.OCORREN_PRISAO - 3
Prompt
Prompt Criando snapshot PER.OCORREN_ELEMEN - 5
drop snapshot log on per.snap$_ocorren_elemen;
drop snapshot per.ocorren_elemen;
create snapshot per.ocorren_elemen
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.ocorren_elemen@&dblsonda;
Prompt Criando snapshot log em PER.OCORREN_ELEMEN - 5 para alimentar as outras unidades
create snapshot log on per.snap$_ocorren_elemen;
Prompt Termino da criacao do snapshot PER.OCORREN_ELEMEN - 5
Prompt
Prompt Criando snapshot PER.CARACTER_GEOM - 18
drop snapshot log on per.snap$_caracter_geom;
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
      from per.caracter_geom@&dblcenpes;
Prompt Criando snapshot log em PER.CARACTER_GEOM - 18 para alimentar a SONDA
create snapshot log on per.snap$_caracter_geom;
Prompt Termino da criacao do snapshot PER.CARACTER_GEOM - 18
Prompt
Prompt Criando snapshot PER.PROPRIEDAD_MEC - 19
drop snapshot log on per.snap$_propriedad_mec;
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
      from per.propriedad_mec@&dblcenpes;
Prompt Criando snapshot log em PER.PROPRIEDAD - 19 para alimentar a SONDA
create snapshot log on per.snap$_propriedad_mec;
Prompt Termino da criacao do snapshot PER.PROPRIEDAD - 19
Prompt
Prompt Criando snapshot PER.REG_ACOMP_ELEM - 23
drop snapshot log on per.snap$_reg_acomp_elem;
drop snapshot per.reg_acomp_elem;
create snapshot per.reg_acomp_elem
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.reg_acomp_elem@&dblsonda;
Prompt Criando snapshot log em PER.REG_ACOMP_ELEM - 23 para alimentar as outras unidades
create snapshot log on per.snap$_reg_acomp_elem;
Prompt Termino da criacao do snapshot PER.REG_ACOMP_ELEM - 23
Prompt
Prompt Criando snapshot PER.ELEMENT_COLUNA - 32
drop snapshot log on per.snap$_element_coluna;
drop snapshot per.element_coluna;
create snapshot per.element_coluna
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.element_coluna@&dbledise;
Prompt Criando snapshot log em PER.ELEMENT_COLUNA - 32 para alimentar a SONDA
create snapshot log on per.snap$_reg_acomp_elem;
Prompt Termino da criacao do snapshot PER.ELEMENT_COLUNA - 32
Prompt
Prompt Criando snapshot PER.LIMIT_GER_FAD - 37
drop snapshot log on per.snap$_limit_ger_fad;
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
      from per.limit_ger_fad@&dblcenpes;
Prompt Criando snapshot log em PER.LIMIT_GER_FAD - 37 para alimentar a SONDA
create snapshot log on per.snap$_limit_ger_fad;
Prompt Termino da criacao do snapshot PER.LIMIT_GER_FAD - 37
Prompt
Prompt Criando snapshot PER.LIMIT_FAD_PROF - 38
drop snapshot log on per.snap$_limit_fad_prof;
drop snapshot per.limit_fad_prof;
create snapshot per.limit_fad_prof
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.limit_fad_prof@&dblsonda;
Prompt Criando snapshot log em PER.LIMIT_FAD_PROF - 38 para alimentar as outras unidades
create snapshot log on per.snap$_limit_fad_prof;
Prompt Termino da criacao do snapshot PER.LIMIT_FAD_PROF - 38
Prompt
Prompt -----------------------------------------------------
Prompt Termino da criacao das replicas na U.O. no schema PER
Prompt -----------------------------------------------------
Prompt ---------------------------------------------------
Prompt Comeca a criacao das replicas na U.O. no schema TBB
Prompt ---------------------------------------------------
Rem
Rem Conecta-se ao usuario TBB na UO
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema TBB: '
connect system/&pwd@&strcuo
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema TBB
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema TBB: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema TBB: '
Prompt Criando snapshot TBB.TP_ELEMEN_COLU - 14
drop snapshot log on tbb.snap$_tp_elemen_colu;
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
      from tbb.tp_elemen_colu@&dbledise;
Prompt Criando snapshot log em TBB.TP_ELEMEN_COLU - 14 para alimentar a SONDA
create snapshot log on tbb.snap$_tp_elemen_colu;
Prompt Termino da criacao snapshot TBB.TP_ELEMEN_COLU - 14
Prompt
Prompt Criando snapshot TBB.RANGE_COMPRIME - 57
drop snapshot log on tbb.snap$_range_comprime;
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
      from tbb.range_comprime@&dbledise;
Prompt Criando snapshot log em TBB.RANGE_COMPRIME - 57 para alimentar a SONDA
create snapshot log on tbb.snap$_range_comprime;
Prompt Termino da criacao snapshot TBB.RANGE_COMPRIME - 57
Prompt
Prompt -----------------------------------------------------
Prompt Termino da criacao das replicas na U.O. no schema TBB
Prompt -----------------------------------------------------
Prompt ---------------------------------------------------
Prompt Comeca a criacao das replicas na U.O. no schema EEP
Prompt ---------------------------------------------------
Rem
Rem Conecta-se ao usuario EEP na UO
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema EEP: '
connect system/&pwd@&strcuo
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema EEP
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema EEP: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema EEP: ' 
Prompt Criando snapshot EEP.EMPRESA - 26
drop snapshot log on eep.snap$_empresa;
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
      from eep.empresa@&dbledise;
Prompt Criando snapshot log em EEP.EMPRESA - 26 para alimentar a SONDA
create snapshot log on eep.snap$_empresa;
Prompt Termino da criacao snapshot EEP.EMPRESA - 26
Prompt
Prompt Criando snapshot EEP.UNID_OPERATIVA - 29
drop snapshot log on eep.snap$_unid_operativa;
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
      from eep.unid_operativa@&dbledise;
Prompt Criando snapshot log em EEP.UNID_OPERATIVA - 29 para alimentar a SONDA
create snapshot log on eep.snap$_unid_operativa;
Prompt Termino da criacao snapshot EEP.UNID_OPERATIVA - 29
Prompt
Prompt Criando snapshot EEP.POCO - 39
drop snapshot log on eep.snap$_poco;
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
      from eep.poco@&dbledise;
Prompt Criando snapshot log em EEP.POCO - 39 para alimentar a SONDA
create snapshot log on eep.snap$_poco;
Prompt Termino da criacao snapshot EEP.POCO - 39
Prompt
Prompt -----------------------------------------------------
Prompt Termino da criacao das replicas na U.O. no schema EEP
Prompt -----------------------------------------------------
Prompt ---------------------------------------------------
Prompt Comeca a criacao das replicas na U.O. no schema ITV
Prompt ---------------------------------------------------
Rem
Rem Conecta-se ao usuario ITV na UO
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema ITV: '
connect system/&pwd@&strcuo
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema ITV
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema ITV: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema ITV: ' 
Prompt Criando snapshot ITV.GRAU_DE_ACO - 27
drop snapshot log on itv.snap$_grau_de_aco;
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
      from itv.grau_de_aco@&dbledise;
Prompt Criando snapshot log em ITV.GRAU_DE_ACO - 27 para alimentar a SONDA
create snapshot log on itv.snap$_grau_de_aco;
Prompt Termino da criacao snapshot ITV.GRAU_DE_ACO - 27
Prompt
Prompt Criando snapshot ITV.UNID_INTER_POC - 35
drop snapshot log on itv.snap$_unid_inter_poc;
drop snapshot itv.unid_inter_poc;
create snapshot itv.unid_inter_poc
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from itv.unid_inter_poc@&dblsonda;
Prompt Criando snapshot log em ITV.UNID_INTER_POC - 35 para alimentar as outras unidades
create snapshot log on itv.snap$_unid_inter_poc;
Prompt Termino da criacao snapshot ITV.UNID_INTER_POC - 35
Prompt
Prompt -----------------------------------------------------
Prompt Termino da criacao das replicas na U.O. no schema ITV
Prompt -----------------------------------------------------
Prompt ---------------------------------------------------
Prompt Comeca a criacao das replicas na U.O. no schema ENG
Prompt ---------------------------------------------------
Rem
Rem Conecta-se ao usuario ENG na UO
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema ENG: '
connect system/&pwd@&strcuo
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema ENG
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema ENG: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema ENG: ' 
Prompt Criando snapshot ENG.SONDA - 34
drop snapshot log on eng.snap$_sonda;
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
      from eng.sonda@&dbledise;
Prompt Criando snapshot log em ENG.SONDA - 34 para alimentar a SONDA
create snapshot log on eng.snap$_sonda;
Prompt Termino da criacao snapshot ENG.SONDA - 34
Prompt
Prompt -----------------------------------------------------
Prompt Termino da criacao das replicas na U.O. no schema ENG
Prompt -----------------------------------------------------
