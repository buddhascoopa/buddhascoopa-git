#!/bin/ksh
#
# clean_log_trc.sh - Faz limpeza de LOGS e TRCs
#                    da BD especificada
# 
# Intervencao                   Responsavel Data       Descicao
# ----------------------------- ----------- ---------- ---------------------------------------------------------------------
# Criacao                       Erick CB    23/08/2002
#
# Parametros
# $1 = SID
# $2 = Numero de Dias para #ECB Parei aqui

# Checar Parametros

export ORACLE_SID=$1

MODO=$2
typeset -l MODO
export MODO
if [ $# -lt 2 ] ; then
   echo "Uso: arch_clean.sh <SID> clean|list"
   exit 1
elif [ $MODO != "clean" ] && [ $MODO != "list" ] ; then
   echo "Uso: arch_clean.sh <SID> clean|list"
   exit 1
fi

# Setar Variaveis de Ambiente
. $HOME/envora $ORACLE_SID

# Script que gera lista dos Archives
ARCH_SCR=$BKP_DIR/${ORACLE_SID}_arch_scr.sh
export ARCH_SCR

# Arquivo que contem a lista dos Archives
ARCH_LIST=$BKP_DIR/${ORACLE_SID}_arch_list.txt
export ARCH_LIST

# Checar processos Oracle
ps -ef | grep -v grep | grep pmon_${ORACLE_SID}$ >> /dev/null
if [ $? -ne 0 ] ; then
   echo "Instância [$ORACLE_SID] OFFLINE !!!"
   exit 1
fi

# Checar se a base está em archive log mode
TESTARCH=${BKP_DIR}/testarch_${ORACLE_SID}.log
${ORACLE_HOME}/bin/sqlplus -s internal << !EOF >> ${TESTARCH} 2>> ${TESTARCH}
set feed off
set head off
set verify off
set pages 0
select log_mode from v\$database;
!EOF
reterr=`grep "ORA-" ${TESTARCH} | wc -l`
if [ $reterr -ne 0 ] ; then
   echo "[$ORACLE_SID] não responde !!!"
   exit $reterr
fi
STATINST=`cat ${TESTARCH}`
rm $TESTARCH
if [ ! "${STATINST}" = "ARCHIVELOG" ] ; then
   echo "[$ORACLE_SID] em modo ${STATINST} !!!"
   exit 0
fi

RETERR=0

# ---------------------------------------------------------------------
# Limpa Archives
# ---------------------------------------------------------------------
if [ $MODO = "clean" ]
then
  if [ ! -f $ARCH_LIST ]
  then
    echo Arquivo da Lista de Archives nao existe
    exit 1
  fi
  for arch in `cat ${ARCH_LIST}`
  do
    rm -f ${arch}* 2>/dev/null
    RETERR=`expr $RETERR + $?`
  done
fi

# ---------------------------------------------------------------------
# Lista Archives
# ---------------------------------------------------------------------
if [ $MODO = "list" ]
then

${ORACLE_HOME}/bin/sqlplus -s internal << !EOF > $ARCH_SCR
set serveroutput on feedback off
declare
  arch_dest v\$parameter.value%type;
begin
  dbms_output.enable( 99999 );
  select value into arch_dest from v\$parameter where name='log_archive_dest';
  if substr(arch_dest,1,1)='?' then
     arch_dest:='$ORACLE_HOME'||substr(arch_dest,2);
  end if;
  dbms_output.put_line('find '||arch_dest||' -type f');
end;
/
!EOF
RETERR=`grep "ORA-" $ARCH_SCR | wc -l`
if [ $RETERR -ne 0 ]
then
  echo Erro ao gerar Lista de Archives
else
  ksh $ARCH_SCR > $ARCH_LIST
fi

fi

exit $RETERR
