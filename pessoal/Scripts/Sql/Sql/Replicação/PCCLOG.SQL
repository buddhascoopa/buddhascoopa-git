Rem
Rem Programa: PCCLOG.SQL
Rem Descricao: Script SQL para criacao dos snapshots logs na tabelas
Rem            envolvidas na replicacao
Rem Data Atualizacao	Programador	Modificacao
Rem 5:03 PM 5/8/1998	CHennig		Criacao
Rem
Rem Observacoes:  
Rem 		
Prompt ----------------------------------------
Prompt Configura ambiente de execucao do script
Prompt ----------------------------------------
set echo on
set feed on
spool c:\pcclog.log
Prompt ---------------------------------------------------------
Prompt Solicita a string de conexao com todos os Bancos de Dados
Prompt ---------------------------------------------------------
undef strccenpes
undef strcsonda
undef strcuo
undef strcedise
accept strccenpes prompt 'Entre com a string de conexao com o CENPES: '
accept strcsonda  prompt 'Entre com a string de conexao com o SONDA : '
accept strcuo     prompt 'Entre com a string de conexao com o U.O.  : '
accept strcedise  prompt 'Entre com a string de conexao com o EDISE : '
Prompt ------------------------------------------------------
Prompt Solicita a senha do SYSTEM em todos os bancos de dados
Prompt ------------------------------------------------------
undef pwdcenpes
undef pwdsonda
undef pwduo
undef pwdedise
accept pwdcenpes prompt 'Entre com a senha do SYSTEM no CENPES: '
accept pwdsonda  prompt 'Entre com a senha do SYSTEM no SONDA : '
accept pwduo     prompt 'Entre com a senha do SYSTEM no U.O.  : '
accept pwdedise  prompt 'Entre com a senha do SYSTEM no EDISE : '
Prompt ----------------------------------------------------------------
Prompt Inicio da criacao dos snapshots logs nas master tables do CENPES
Prompt ----------------------------------------------------------------
Rem
Rem Conecta-se ao usuario SYSTEM no CENPES
Rem
connect system/&pwdcenpes@&strccenpes
Prompt Criando snapshot log em PER.CARACTER_GEOM - 18
create snapshot log on per.caracter_geom;
Prompt
Prompt Criando snapshot log em PER.PROPRIEDAD_MEC - 19
create snapshot log on per.propriedad_mec;
Prompt
Prompt Criando snapshot log em PER.LIMIT_GER_FAD - 37
create snapshot log on per.limit_ger_fad;
Prompt
Prompt -----------------------------------------------------------------
Prompt Termino da criacao dos snapshots logs nas master tables do CENPES
Prompt -----------------------------------------------------------------
Prompt ---------------------------------------------------------------
Prompt Inicio da criacao dos snapshots logs nas master tables da SONDA
Prompt ---------------------------------------------------------------
Rem
Rem Conecta-se ao usuario SYSTEM na SONDA
Rem
connect system/&pwdsonda@&strcsonda
Prompt Criando snapshot log em PER.OCORREN_POCO - 1
create snapshot log on per.ocorren_poco;
Prompt Criando snapshot log em PER.OCORREN_PRISAO - 3
create snapshot log on per.ocorren_prisao;
Prompt Criando snapshot log em PER.OCORREN_ELEMEN - 5 
create snapshot log on per.ocorren_elemen;
Prompt Criando snapshot log em PER.REG_ACOMP_ELEM - 23
create snapshot log on per.reg_acomp_elem;
Prompt Criando snapshot log em PER.LIMIT_FAD_PROF - 38
create snapshot log on per.limit_fad_prof;
Prompt Criando snapshot log em ITV.UNID_INTER_POC - 35
create snapshot log on itv.unid_inter_poc;
Prompt
Prompt ----------------------------------------------------------------
Prompt Termino da criacao dos snapshots logs nas master tables da SONDA
Prompt ----------------------------------------------------------------
Prompt --------------------------------------------------------------
Prompt Inicio da criacao dos snapshots logs nas master tables da U.O.
Prompt --------------------------------------------------------------
Rem
Rem Conecta-se ao usuario SYSTEM na U.O.
Rem
connect system/&pwduo@&strcuo
Prompt Criando snapshot log em PER.ELEM_ADQUIR - 2
create snapshot log on per.elem_adquir;
Prompt Criando snapshot log em PER.ORDEM_SERVICO - 5
create snapshot log on per.ordem_servico;
Prompt Criando snapshot log em PER.MOVIMENT_LOTE - 7
create snapshot log on per.moviment_lote;
Prompt Criando snapshot log em PER.AQUIS_LOTE - 8
create snapshot log on per.aquis_lote;
Prompt Criando snapshot log em PER.ELEM_MOVIMENTA - 9
create snapshot log on per.elem_movimenta;
Prompt Criando snapshot log em PER.ELEM_INSPECION - 10
create snapshot log on per.elem_inspecion;
Prompt Criando snapshot log em PER.ELEM_COL_IDENT - 17
create snapshot log on per.elem_col_ident;
Prompt Criando snapshot log em PER.ELEM_GERADO - 22
create snapshot log on per.elem_gerado;
Prompt Criando snapshot log em TBB.TP_DEF_TOOL_TJ - 44
create snapshot log on itv.tbb.tp_def_tool_tj;
Prompt Criando snapshot log em TBB.TP_DEF_CONEXAO - 45
create snapshot log on tbb.tp_def_conexao;
Prompt Criando snapshot log em TBB.TP_DEF_CORPO - 46
create snapshot log on tbb.tp_def_corpo;
Prompt
Prompt ---------------------------------------------------------------
Prompt Termino da criacao dos snapshots logs nas master tables da U.O.
Prompt ---------------------------------------------------------------
Prompt ---------------------------------------------------------------
Prompt Inicio da criacao dos snapshots logs nas master tables do EDISE
Prompt ---------------------------------------------------------------
Rem
Rem Conecta-se ao usuario SYSTEM no EDISE
Rem
connect system/&pwdedise@&strcedise
Prompt Criando snapshot log em TBB.TP_ELEMEN_COLU - 14
create snapshot log on tbb.tp_elemen_colu;
Prompt Criando snapshot log em TBB.RANGE_COMPRIME - 57
create snapshot log on tbb.range_comprime;
Prompt Criando snapshot log em EEP.EMPRESA - 26
create snapshot log on eep.empresa;
Prompt Criando snapshot log em EEP.UNID_OPERATIVA - 29
create snapshot log on eep.unid_operativa;
Prompt Criando snapshot log em EEP.POCO - 39
create snapshot log on eep.poco;
Prompt Criando snapshot log em PER.ELEMENT_COLUNA - 32
create snapshot log on per.element_coluna;
Prompt Criando snapshot log em ITV.GRAU_DE_ACO - 27
create snapshot log on itv.grau_de_aco;
Prompt Criando snapshot log em ENG.SONDA
create snapshot log on eng.sonda;
Prompt
Prompt ----------------------------------------------------------------
Prompt Termino da criacao dos snapshots logs nas master tables do EDISE
Prompt ----------------------------------------------------------------
