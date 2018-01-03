#!/bin/ksh
#
# alert_log.sh - monitora o alert_<sid>.log
# usage: alert_log.sh <sid>
#
# Intervencao                   Responsavel Data       Hora  Descricao
# ----------------------------- ----------- ---------- ----- -----------------------------------------------------------------
# Criacao                       Erick CB    30/04/2002
# Alteracao                     Erick CB    09/05/2002 17:34
# Alteracao                     Erick CB    30/07/2002 11:05 Utilizacao do envora
# Alteracao                     Erick CB    17/09/2002 16:20 Ocorrencia Critica

if [ $# -eq 0 ]
then
  clear
  echo "usage:  alert_log.sh <sid>"
  echo " onde: <sid> eh a instance"
  echo
  exit 1
fi
ORACLE_SID=$1
export ORACLE_SID

. $HOME/envora $ORACLE_SID

cd $MON_DIR

# ORA- Erros Criticos no ALERT.LOG
ORAERR=""
ORAERR=$ORAERR"|ORA-00018" # maximum number of sessions exceeded
ORAERR=$ORAERR"|ORA-01653" # unable to extend ________ by ____ in tablespace ________
ORAERR=$ORAERR"|ORA-16014" # log _ sequence# _____ not archived, no available destinations
ORAERR=$ORAERR"|ORA-16038" # log __ sequence# _____ cannot be archived
ORAERR=$ORAERR"|ORA-19502" # write error on file
ORAERR=$ORAERR"|ORA-27063" # number of bytes read/written is incorrect

# Arquivo de mensagem para email
MSG=alert_log.msg
export MSG

# Arquivo com erros do Alert.Log
ALERT_ERR=alert_log.err
export ALERT_ERR

# Arquivo que contem os diretorios do Alert.Log
DIR_ALERT=dir_alert.txt
export DIR_ALERT


ps -ef | grep "ora_pmon_${ORACLE_SID}" | grep -v grep >/dev/null 2>/dev/null 
if [ $?  -ne 0 ]
then
  clear
  echo "Instance $ORACLE_SID naum estah ativa"
  echo
  exit 1
fi

ORACLE_HOME=`grep "^${ORACLE_SID}:" $ORATAB | cut -d: -f1-3 | grep ":Y$" | cut -d: -f2`
export ORACLE_HOME

$ORACLE_HOME/bin/sqlplus -s <<EOF > $DIR_ALERT
internal
set head off
set pages 0
set feed off
select value from v\$parameter where name='background_dump_dest';
EOF

if [ "`cut -c1 $DIR_ALERT" = "?" ]
then
  ALERT_FILE=$ORACLE_HOME`cut -c2- $DIR_ALERT`
else
  ALERT_FILE=`cat ${DIR_ALERT}`
fi
ALERT_FILE=${ALERT_FILE}/alert_${ORACLE_SID}.log
export ALERT_FILE
ALERT_FILE_DIA=${ALERT_FILE}_DIA_`date +%Y-%m-%d`
export ALERT_FILE_DIA
ALERT_FILE_ERR=${ALERT_FILE}_ERR_`date +%Y-%m-%d_%H-%M`
export ALERT_FILE_ERR

if [ ! -f $ALERT_FILE ]
then
  exit 0
fi

echo "To: oracleoi@telemar.com.br" > ${MSG}
echo Subject: `hostname` : $ORACLE_SID : Erro no ALERT.LOG >> ${MSG}

ERR=0
cat -n $ALERT_FILE | grep "ORA-" | sed "s/      / /g" | sed "s/^/LINHA = "/g > ${ALERT_ERR}
if [ -s ${ALERT_ERR} ]
then
  cp $ALERT_FILE $ALERT_FILE_ERR
  >  $ALERT_FILE
  cat ${ALERT_ERR} >> ${MSG}
  mail oracleoi@telemar.com.br < ${MSG}
  egrep $ORAERR $ALERT_ERR 1>/dev/null 2>/dev/null
  if [ $? -eq 0 ]
  then
    banner Atencao
    echo ---------------------------------------------------------------------
    echo Informe a Equipe de Oracle
    echo `hostname` : $ORACLE_SID : Erro em $ALERT_FILE_ERR
    echo ---------------------------------------------------------------------
    cat ${ALERT_ERR}
    echo ---------------------------------------------------------------------
    ERR=1
  fi
else
  if [ ! -f $ALERT_FILE_DIA ]
  then
    cp $ALERT_FILE $ALERT_FILE_DIA
    >  $ALERT_FILE
  fi
  for dir in `cat $DIR_ALERT`
  do
    find $dir -name "alert_${ORACLE_SID}*" -mtime +30 -exec rm -f {} \;
  done
fi
exit $ERR
