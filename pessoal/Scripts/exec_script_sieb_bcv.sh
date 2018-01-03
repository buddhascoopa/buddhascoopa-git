#!/bin/ksh
#
# exec_script_sieb_bcv.sh - Executar sqls na base BCV do Siebel 
# e enviar arquivo via FTP para maquina RJ06PCS01
#              Juliao Cesar 
# 
# Intervencao                   Responsavel Data
# ----------------------------- ------------ ----------
# Criacao                       Juliao Cesar 06/08/2002
#

. $HOME/.profile

DATA=`date +%Y%m%d`
FILE_DIR="/sblpcsora/sblora100/app/oracle/admin/sbpcsprd/utl_file_dir"

export ORACLE_SID=sbpcsprd

cd $HOME/dbascripts
###########################################################################################

if [ -f $FILE_DIR/S_CONTACT1_*.txt.node ] ; then
rm $FILE_DIR/S_CONTACT1_*.txt.node
fi
mknod $FILE_DIR/S_CONTACT1_$DATA.txt.node p

gzip < $FILE_DIR/S_CONTACT1_$DATA.txt.node > ${FILE_DIR}/S_CONTACT1_$DATA.txt.gz &

sqlplus -s siebel_bcv/siebel_bcv << !EOF > $FILE_DIR/S_CONTACT1_$DATA.txt.node 2>sql01_bcv.err

set linesize 5000;
set pagesize 0;
set echo off;
set feed off;

SELECT
	'CONTATO'||'|'||CC.CREATED||'|'||
	CC.LAST_UPD||'|'||
	CC.ROW_ID||'|'||
	CC.LAST_NAME||'|'||
	CC.BIRTH_DT||'|'||
	CC.SEX_MF||'|'||
	CC.SOC_SECURITY_NUM||'|'||
	CC.EMAIL_ADDR||'|'||
	CC.HOME_PH_NUM||'|'||
	CC.WORK_PH_NUM||'|'||
	CC.X_ORIGEM_CADASTRAMENTO||'|'||
	CC.X_COD_PDV_SAP||'|'||
	CC.X_COD_WEB||'|'||
	CC.X_CONTA_TITULAR_ID||'|'||(SELECT CA.NAME FROM SIEBEL.S_CAMP_CON SC,SIEBEL.S_SRC CA WHERE SC.CON_PER_ID = CC.ROW_ID AND SC.SRC_ID = CA.ROW_ID AND ROWNUM=1)||'|'||
	(SELECT CA.NAME FROM SIEBEL.S_CAMP_CON SC,SIEBEL.S_SRC CA WHERE SC.CON_PER_ID = CC.ROW_ID AND SC.SRC_ID = CA.ROW_ID AND ROWNUM=2)||'|'||AD1.ROW_ID||'|'||
	AD1.X_TIPO_LOGR||'|'||
	AD1.X_LOGR||'|'||
	AD1.X_NUM_PORTA||'|'||
	AD1.X_TIPO_COMPL1||'|'||
	AD1.X_NUM_COMPL1||'|'||
	AD1.X_TIPO_COMPL2||'|'||
	AD1.X_NUM_COMPL2||'|'||
	AD1.X_TIPO_COMPL3||'|'||
	AD1.X_NUM_COMPL3||'|'|| 
	AD1.X_BAIRRO||'|'||
	AD1.CITY||'|'||
	AD1.X_STATE||'|'||
	AD1.X_STATE_D||'|'||
	AD1.X_CEP S_CONTACT1
FROM
	SIEBEL.S_CONTACT CC,
	SIEBEL.S_ADDR_PER AD1
WHERE	
	CC.PR_PER_ADDR_ID = AD1.ROW_ID;

exit
!EOF
###############################################################################################

if [ -f $FILE_DIR/S_CONTACT2_*.txt.node ] ; then 
rm $FILE_DIR/S_CONTACT2_*.txt.node 
fi
mknod $FILE_DIR/S_CONTACT2_$DATA.txt.node p

gzip < $FILE_DIR/S_CONTACT2_$DATA.txt.node > ${FILE_DIR}/S_CONTACT2_$DATA.txt.gz &

sqlplus -s siebel_bcv/siebel_bcv << !EOF > $FILE_DIR/S_CONTACT2_$DATA.txt.node 2>sql02_bcv.err

set linesize 5000;
set pagesize 0;
set echo off;
set feed off;

SELECT
	'PROSPECT'||'|'||
	PP.CREATED||'|'||
	PP.LAST_UPD||'|'||
	PP.ROW_ID||'|'||
	PP.LAST_NAME||'|'||
	PP.BIRTH_DT||'|'||
	PP.SEX_MF||'|'||
	PP.SOC_SECURITY_NUM||'|'||
	PP.EMAIL_ADDR||'|'||
	PP.HOME_PH_NUM||'|'||
	PP.WORK_PH_NUM||'|'||
	''||'|'||
	''||'|'||
	PP.X_COD_WEB||'|'||
	''||'|'||
	'Pioneiros Mala Direta Fixa'||'|'||
	''||'|'||
	''||'|'||
	PP.X_TIPO_LOGR||'|'||
	PP.X_NOME_LOGR||'|'||
	PP.X_NUM_PORTA||'|'||
	PP.X_TIPO_COMPL1||'|'||
	PP.X_NUM_COMPL1||'|'||
	PP.X_TIPO_COMPL2||'|'||
	PP.X_NUM_COMPL2||'|'||
	PP.X_TIPO_COMPL3||'|'||
	PP.X_NUM_COMPL3||'|'||
	PP.COUNTY||'|'||
	PP.CITY||'|'||
	PP.STATE||'|'||
	PP.X_NOME_UF||'|'||
	PP.ZIPCODE
FROM
	SIEBEL.S_PRSP_CONTACT PP,
	SIEBEL.S_CAMP_CON SC
WHERE	
	SC.PRSP_CON_PER_ID = PP.ROW_ID	AND
	SC.SRC_ID = '1-FNB2';

exit
!EOF	

###############################################################################################
if [ -f $FILE_DIR/S_QUOTE_SOLN_*.txt.node ] ; then
rm $FILE_DIR/S_QUOTE_SOLN_*.txt.node
fi

mknod $FILE_DIR/S_QUOTE_SOLN_$DATA.txt.node p

gzip < $FILE_DIR/S_QUOTE_SOLN_$DATA.txt.node > ${FILE_DIR}/S_QUOTE_SOLN_$DATA.txt.gz &

sqlplus -s siebel_bcv/siebel_bcv << !EOF > $FILE_DIR/S_QUOTE_SOLN_$DATA.txt.node  2>sql03_bcv.err

set linesize 5000;
set pagesize 0;
set echo off;
set feed off;

SELECT
	SQ.CREATED||'|'||
	SQ.LAST_UPD||'|'||
	SQ.ROW_ID||'|'||
	SQ.ASSET_NUM||'|'||
	SQ.X_DATA_ATIVACAO||'|'||
	SQ.SERV_ACCNT_ID||'|'||
	SQ.INV_ACCNT_ID||'|'||
	SQ.X_CONTATO_ID||'|'||
	SQ.X_OPORTUNIDADE_ID
FROM
	SIEBEL.S_QUOTE_SOLN SQ
WHERE
	SQ.COPIED_FLG = 'N'	AND
	SQ.STATUS_CD IN('Ativo','Pendente','Suspenso','Em Provisionamento','Erro no Provisionamento')	AND
	(SQ.INV_ACCNT_ID IS NOT NULL OR X_CONTATO_ID IS NOT NULL);

exit
!EOF

###############################################################################################
if [ -f $FILE_DIR/S_OPTY_*.txt.node ] ; then
rm $FILE_DIR/S_OPTY_*.txt.node
fi

mknod $FILE_DIR/S_OPTY_$DATA.txt.node p

gzip < $FILE_DIR/S_OPTY_$DATA.txt.node > ${FILE_DIR}/S_OPTY_$DATA.txt.gz &

sqlplus -s siebel_bcv/siebel_bcv << !EOF > $FILE_DIR/S_OPTY_$DATA.txt.node 2>sql04_bcv.err

set linesize 5000;
set pagesize 0;
set echo off;
set feed off;

SELECT
	OP.CREATED||'|'||
	OP.LAST_UPD||'|'||
	OP.ROW_ID||'|'||
	OP.X_CONTATO_CAMPANHA_ID||'|'||
	OP.X_CONTATO_VENDA_ID||'|'||
	OP.X_NUM_MSISDN_RESERVADO||'|'||
	OP.X_STATUS||'|'||
	(SELECT CA.NAME FROM SIEBEL.S_SRC CA WHERE OP.PR_SRC_ID = CA.ROW_ID) CAMPANHA
FROM
	SIEBEL.S_OPTY OP;

exit
!EOF

cd $FILE_DIR
if [ -s $FILE_DIR/S_OPTY_$DATA.txt ] && [ -s $FILE_DIR/S_CONTACT1_$DATA.txt ] && [ -s $FILE_DIR/S_CONTACT2_$DATA.txt ] && [ -s $FILE_DIR/S_QUOTE_SOLN_$DATA.txt ] 
then
   saida=0 
else
   saida=1
fi
echo $saida
exit $saida

## ftp ???

## rm $FILE_DIR/S_CONTACT1_$DATA.txt
## rm $FILE_DIR/S_CONTACT2_$DATA.txt
## rm $FILE_DIR/S_QUOTE_SOLN_$DATA.txt
## rm $FILE_DIR/S_OPTY_$DATA.txt

