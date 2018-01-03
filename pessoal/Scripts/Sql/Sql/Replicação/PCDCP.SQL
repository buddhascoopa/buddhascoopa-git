Rem
Rem Programa: PCDCP.SQL 
Rem Descricao: Script SQL para criacao das replicas do projeto PROCOL
Rem            no CENPES
Rem Data Atualizacao	Programador	Modificacao
Rem 14:39:23-5/8/1998	CHennig	Criacao
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
spool c:\pcdcp.log
Prompt -----------------------------------------
Prompt Solicita a string de conexao com o CENPES
Prompt -----------------------------------------
undef strccenpes
accept strccenpes prompt 'Entre com a string de conexao com o CENPES : '
Prompt ----------------------------------------------------------
Prompt Solicita o database link entre o CENPES e os outros bancos
Prompt ----------------------------------------------------------
undef dbluo
undef dbledise
accept dbluo    char prompt 'Entre com o DBL com a U.O. : '
accept dbledise char prompt 'Entre com o DBL com a EDISE: '
Prompt -----------------------------------------------------
Prompt Comeca a criacao das replicas no CENPES no schema PER
Prompt -----------------------------------------------------
Rem
Rem Conecta-se ao usuario PER no CENPES
Rem
undef pwd
accept pwd       char prompt 'Entre com a senha do schema PER: '
connect system/&pwd@&strccenpes
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema PER
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema PER: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema PER: '
Prompt
Prompt Criando snapshot PER.ELEM_ADQUIR - 2
drop snapshot per.elem_adquir;
create snapshot per.elem_adquir
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.elem_adquir@&dbluo;
Prompt Termino da criacao do snapshot PER.ELEM_ADQUIR - 2
Prompt
Prompt Criando snapshot PER.ELEM_COL_IDENT - 17
drop snapshot per.elem_col_ident;
create snapshot per.elem_col_ident
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.elem_col_ident@&dbluo;
Prompt Termino da criacao do snapshot PER.ELEM_COL_IDENT - 17
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
Prompt Criando snapshot PER.REG_ACOMP_ELEM - 23
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
      from per.snap$_reg_acomp_elem@&dbluo;
Prompt Termino da criacao do snapshot PER.REG_ACOMP_ELEM - 23
Prompt
Prompt Criando snapshot PER.ELEMENT_COLUNA - 32
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
Prompt Termino da criacao do snapshot PER.ELEMENT_COLUNA - 32
Prompt
Prompt Criando snapshot PER.LIMIT_FAD_PROF - 38
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
      from per.snap$_limit_fad_prof@&dbluo;
Prompt Termino da criacao do snapshot PER.LIMIT_FAD_PROF - 38
Prompt
Prompt -------------------------------------------------------
Prompt Termino da criacao das replicas no CENPES no schema PER
Prompt -------------------------------------------------------
Prompt -----------------------------------------------------
Prompt Comeca a criacao das replicas no CENPES no schema TBB
Prompt -----------------------------------------------------
Rem
Rem Conecta-se ao usuario TBB no CENPES
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema TBB: '
connect system/&pwd@&strccenpes
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema TBB
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema TBB: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema TBB: '
Prompt
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
      from tbb.tp_elemen_colu@&dbledise;
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
      from tbb.range_comprime@&dbledise;
Prompt Termino da criacao snapshot TBB.RANGE_COMPRIME - 57
Prompt
Prompt -------------------------------------------------------
Prompt Termino da criacao das replicas no CENPES no schema TBB
Prompt -------------------------------------------------------
Prompt -----------------------------------------------------
Prompt Comeca a criacao das replicas no CENPES no schema EEP
Prompt -----------------------------------------------------
Rem
Rem Conecta-se ao usuario EEP no CENPES
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema EEP: '
connect system/&pwd@&strccenpes
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
      from eep.empresa@&dbledise;
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
      from eep.unid_operativa@&dbledise;
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
      from eep.poco@&dbledise;
Prompt Termino da criacao snapshot EEP.POCO - 39
Prompt
Prompt -------------------------------------------------------
Prompt Termino da criacao das replicas no CENPES no schema EEP
Prompt -------------------------------------------------------
Prompt -----------------------------------------------------
Prompt Comeca a criacao das replicas no CENPES no schema ITV
Prompt -----------------------------------------------------
Rem
Rem Conecta-se ao usuario ITV no CENPES
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema ITV: '
connect system/&pwd@&strccenpes
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
      from itv.grau_de_aco@&dbledise;
Prompt Termino da criacao snapshot ITV.GRAU_DE_ACO - 27
Prompt
Prompt -------------------------------------------------------
Prompt Termino da criacao das replicas no CENPES no schema ITV
Prompt -------------------------------------------------------
Prompt -----------------------------------------------------
Prompt Comeca a criacao das replicas no CENPES no schema ENG
Prompt -----------------------------------------------------
Rem
Rem Conecta-se ao usuario ENG no CENPES
Rem
undef pwd
accept pwd char prompt 'Entre com a senha do schema ENG: '
connect system/&pwd@&strccenpes
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
      from eng.sonda@&strcedise;
Prompt Termino da criacao snapshot ENG.SONDA - 34
Prompt
Prompt -------------------------------------------------------
Prompt Termino da criacao das replicas no CENPES no schema ENG
Prompt -------------------------------------------------------
