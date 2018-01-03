Rem
Rem Programa: PCDES.SQL 
Rem Descricao: Script SQL para criacao das replicas do projeto PROCOL
Rem            no EDISE
Rem Data Atualizacao	Programador	Modificacao
Rem 10:57 AM 5/8/1998	CHennig	Criacao
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
spool c:\pcdes.log
Prompt ----------------------------------------
Prompt Solicita a string de conexao com o EDISE
Prompt ----------------------------------------
undef strcedise
accept strcedise  char prompt 'Entre com a string de conexao com o EDISE : '
Prompt ---------------------------------------------------------
Prompt Solicita o database link entre o EDISE e os outros bancos
Prompt ---------------------------------------------------------
undef dbluo
undef dblcenpes
accept dbluo     char prompt 'Entre com o DBL com a U.O.  : '
accept dblcenpes char prompt 'Entre com o DBL com a CENPES: '
Prompt ----------------------------------------------------
Prompt Comeca a criacao das replicas no EDISE no schema PER
Prompt ----------------------------------------------------
Rem
Rem Conecta-se ao usuario PER no EDISE
Rem
undef pwd
accept pwd       char prompt 'Entre com a senha do schema PER: '
connect system/&pwd@&strcedise
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema PER
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema PER: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema PER: '
Prompt
Prompt Criando snapshot PER.OCORREN_POCO - 1
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
      from per.snap$_ocorren_poco@&dbluo;
Prompt Termino da criacao do snapshot PER.OCORREN_POCO - 1
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
Prompt Criando snapshot PER.OCORREN_PRISAO - 3
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
      from per.snap$_ocorren_prisao@&dbluo;
Prompt Termino da criacao do snapshot PER.OCORREN_PRISAO - 3
Prompt
Prompt Criando snapshot PER.OCORREN_ELEMEN - 5
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
      from per.snap$_ocorren_elemen@&dbluo;
Prompt Termino da criacao do snapshot PER.OCORREN_ELEMEN - 5
Prompt
Prompt Criando snapshot PER.ORDEM_SERVICO - 6
drop snapshot per.ordem_servico;
create snapshot per.ordem_servico
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.ordem_servico@&dbluo;
Prompt Termino da criacao do snapshot PER.ORDEM_SERVICO - 6
Prompt
Prompt Criando snapshot PER.MOVIMENT_LOTE - 7
drop snapshot per.moviment_lote;
create snapshot per.moviment_lote
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.moviment_lote@&dbluo;
Prompt Termino da criacao do snapshot PER.MOVIMENT_LOTE - 7
Prompt
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
Prompt Criando snapshot PER.ELEM_MOVIMENTA - 9
drop snapshot per.elem_movimenta;
create snapshot per.elem_movimenta
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.elem_movimenta@&dbluo;
Prompt Termino da criacao do snapshot PER.ELEM_MOVIMENTA - 9
Prompt
Prompt Criando snapshot PER.ELEM_INSPECION - 10
drop snapshot per.elem_inspecion;
create snapshot per.elem_inspecion
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from per.elem_inspecion@&dbluo;
Prompt Termino da criacao do snapshot PER.ELEM_INSPECION - 10
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
      from per.caracter_geom@&dblcenpes;
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
      from per.propriedad_mec@&dblcenpes;
Prompt Termino da criacao do snapshot PER.PROPRIEDAD_MEC - 19
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
      from per.limit_ger_fad@&dblcenpes;
Prompt Termino da criacao do snapshot PER.LIMIT_GER_FAD - 37
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
Prompt ------------------------------------------------------
Prompt Termino da criacao das replicas no EDISE no schema PER
Prompt ------------------------------------------------------
Prompt ----------------------------------------------------
Prompt Comeca a criacao das replicas no EDISE no schema ITV
Prompt ----------------------------------------------------
Rem
Rem Conecta-se ao usuario ITV na EDISE
Rem
undef pwd
accept pwd       char prompt 'Entre com a senha do schema ITV: '
connect system/&pwd@&strcedise
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema ITV
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema ITV: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema ITV: '
Prompt
Prompt Criando snapshot ITV.UNID_INTER_POC - 35
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
      from itv.snap$_unid_inter_poc@&dbluo;
Prompt Termino da criacao do snapshot ITV.UNID_INTER_POC - 35
Prompt
Prompt ------------------------------------------------------
Prompt Termino da criacao das replicas no EDISE no schema ITV
Prompt ------------------------------------------------------
Prompt ----------------------------------------------------
Prompt Comeca a criacao das replicas no EDISE no schema TBB
Prompt ----------------------------------------------------
Rem
Rem Conecta-se ao usuario TBB na EDISE
Rem
undef pwd
accept pwd       char prompt 'Entre com a senha do schema TBB: '
connect system/&pwd@&strcedise
Rem
Rem Solicita a tablespace de gravacao das replicas recebidas pelo schema TBB
Rem
undef tsd
undef tsi
accept tsd char prompt 'Entre com a TableSpace de dados   do schema TBB: '
accept tsi char prompt 'Entre com a TableSpace de indices do schema TBB: '
Prompt
Prompt Criando snapshot TBB.TP_DEF_TOOL_TJ - 44
drop snapshot tbb.tp_def_tool_tj;
create snapshot tbb.tp_def_tool_tj
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from tbb.tp_def_tool_tj@&dbluo;
Prompt Termino da criacao do snapshot TBB.TP_DEF_TOOL_TJ - 44
Prompt
Prompt Criando snapshot TBB.TP_DEF_CONEXAO - 45
drop snapshot tbb.tp_def_conexao;
create snapshot tbb.tp_def_conexao
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from tbb.tp_def_conexao@&dbluo;
Prompt Termino da criacao do snapshot TBB.TP_DEF_CONEXAO - 46
Prompt
Prompt Criando snapshot TBB.TP_DEF_CORPO - 46
drop snapshot tbb.tp_def_corpo;
create snapshot tbb.tp_def_corpo
   tablespace &tsd
   storage (initial <>M next <>K pctincrease 0)
   using index
      tablespace &tsi
      storage (initial <>M next <>K pctincrease 0)
   refresh fast
   with primary key
   as
      select * 
      from tbb.tp_def_corpo@&dbluo;
Prompt Termino da criacao do snapshot TBB.TP_DEF_CORPO - 46
Prompt
Prompt ------------------------------------------------------
Prompt Termino da criacao das replicas no EDISE no schema TBB
Prompt ------------------------------------------------------