function ORAERR
{
grep "ORA-" $1
if [ $? -eq 0 ]
then
  clear
  echo "ERRO, VERIFIQUE ARQUIVO $1"
  echo `date '+[%d/%m/%Y - %T]'`" ERRO, VERIFIQUE ARQUIVO $1" >> ${LOG_FILE}
  echo "--------------------------------------------------------------------------------" >> ${LOG_FILE}
  exit
fi
}

SCRIPT_DIR=/home/operpcs
export SCRIPT_DIR

LOG_FILE=${SCRIPT_DIR}/log/bkp_online.log
export LOG_FILE

DATA=`date '+%Y%m%d'`
export DATA

DEVICE=/dev/rmt/0m
export DEVICE

LISTA_TAR=${SCRIPT_DIR}/lista.tar
export LISTA_TAR

LOG_TAR=${SCRIPT_DIR}/tar.log
export LOG_TAR

OS=`uname -a|cut -c1-1`                #  Sistema Operacional
export OS
case $OS in
   S) ORATAB=/var/opt/oracle/oratab;;  #  End. Maq. SUN
   A) ORATAB=/etc/oratab;;             #  End. Maq. AIX
   H) ORATAB=/etc/oratab;;             #  End. Maq. HP
   O) ORATAB=/etc/oratab;;             #  End. Maq. Compaq
esac
export ORATAB

> ${LISTA_TAR}

echo "--------------------------------------------------------------------------------" >> ${LOG_FILE}
echo `date '+[%d/%m/%Y - %T]'`" INICIO DO BACKUP" >> ${LOG_FILE}

for instance in `grep -v "^\#" $ORATAB | grep -v "^\*" | cut -f1,3 -d: | grep ":Y" | cut -f1 -d:`
do
  ORACLE_SID=$instance ; export ORACLE_SID
  ORACLE_HOME=`grep "^${ORACLE_SID}:" $ORATAB | cut -f2 -d:` ; export ORACLE_HOME
  LD_LIBRARY_PATH=$ORACLE_HOME/lib ; export LD_LIBRARY_PATH
  NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1 ; export NLS_LANG

  # Gera script de BEGIN BACKUP nas TS
  echo `date '+[%d/%m/%Y - %T]'`" $ORACLE_SID - Gera script de BEGIN BACKUP nas TS" >> ${LOG_FILE}
  $ORACLE_HOME/bin/sqlplus -s internal @${SCRIPT_DIR}/beg_bkp.sql > ${SCRIPT_DIR}/${ORACLE_SID}_beg_bkp.sql
  ORAERR ${SCRIPT_DIR}/${ORACLE_SID}_beg_bkp.sql

  # Gera script de END BACKUP nas TS
  echo `date '+[%d/%m/%Y - %T]'`" $ORACLE_SID - Gera script de END BACKUP nas TS" >> ${LOG_FILE}
  $ORACLE_HOME/bin/sqlplus -s internal @${SCRIPT_DIR}/end_bkp.sql > ${SCRIPT_DIR}/${ORACLE_SID}_end_bkp.sql
  ORAERR ${SCRIPT_DIR}/${ORACLE_SID}_end_bkp.sql

  # Gera Lista dos DataFiles para fazer Backup
  echo `date '+[%d/%m/%Y - %T]'`" $ORACLE_SID - Gera Lista dos DataFiles para fazer Backup" >> ${LOG_FILE}
  $ORACLE_HOME/bin/sqlplus -s internal @${SCRIPT_DIR}/df_lista.sql >> ${LISTA_TAR}
  ORAERR ${LISTA_TAR}

  # Backup do Controlfile
  echo `date '+[%d/%m/%Y - %T]'`" $ORACLE_SID - Backup do Controlfile" >> ${LOG_FILE}
  $ORACLE_HOME/bin/sqlplus -s internal @${SCRIPT_DIR}/bkp_ctl.sql $ORACLE_SID $DATA > ${SCRIPT_DIR}/${ORACLE_SID}_bkp_ctl.log
  ORAERR ${SCRIPT_DIR}/${ORACLE_SID}_bkp_ctl.log

  # Acrescenta o Backup do Controlfile na Lista
  echo `date '+[%d/%m/%Y - %T]'`" $ORACLE_SID - Acrescenta o Backup do Controlfile na Lista" >> ${LOG_FILE}
  echo .${ORACLE_HOME}/dbs/${ORACLE_SID}_${DATA}.ctl >> ${LISTA_TAR}

  # Obtem INIT_FILE
  echo `date '+[%d/%m/%Y - %T]'`" $ORACLE_SID - Obtem INIT_FILE" >> ${LOG_FILE}
  INIT_FILE=${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora
  if [ -h $INIT_FILE ]
  then
    INIT_FILE=`ls -l $INIT_FILE | awk '{print $11}'`
  fi
  export INIT_FILE

  # Acrescenta o INIT_FILE na Lista
  echo `date '+[%d/%m/%Y - %T]'`" $ORACLE_SID - Acrescenta o INIT_FILE na Lista" >> ${LOG_FILE}
  echo .${INIT_FILE} >> ${LISTA_TAR}
done

for instance in `grep -v "^\#" $ORATAB | grep -v "^\*" | cut -f1,3 -d: | grep ":Y" | cut -f1 -d:`
do
  ORACLE_SID=$instance ; export ORACLE_SID
  ORACLE_HOME=`grep "^${ORACLE_SID}:" $ORATAB | cut -f2 -d:` ; export ORACLE_HOME
  LD_LIBRARY_PATH=$ORACLE_HOME/lib64 ; export LD_LIBRARY_PATH
  NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1 ; export NLS_LANG

  # Coloca as TS em BEGIN BACKUP
  echo `date '+[%d/%m/%Y - %T]'`" $ORACLE_SID - Coloca as TS em BEGIN BACKUP" >> ${LOG_FILE}
  $ORACLE_HOME/bin/sqlplus -s internal @${SCRIPT_DIR}/${ORACLE_SID}_beg_bkp.sql > ${SCRIPT_DIR}/${ORACLE_SID}_beg_bkp.log
  ORAERR ${SCRIPT_DIR}/${ORACLE_SID}_beg_bkp.log
done

# Executa o TAR baseado na LISTA
echo `date '+[%d/%m/%Y - %T]'`" Executa o TAR baseado na LISTA" >> ${LOG_FILE}
cd /
tar cvhf $DEVICE `cat ${LISTA_TAR}` 2>${LOG_TAR}
cd $SCRIPT_DIR

for instance in `grep -v "^\#" $ORATAB | grep -v "^\*" | cut -f1,3 -d: | grep ":Y" | cut -f1 -d:`
do
  ORACLE_SID=$instance ; export ORACLE_SID
  ORACLE_HOME=`grep "^${ORACLE_SID}:" $ORATAB | cut -f2 -d:` ; export ORACLE_HOME
  LD_LIBRARY_PATH=$ORACLE_HOME/lib64 ; export LD_LIBRARY_PATH
  NLS_LANG=AMERICAN_AMERICA.WE8ISO8859P1 ; export NLS_LANG

  # Coloca as TS em END BACKUP
  echo `date '+[%d/%m/%Y - %T]'`" $ORACLE_SID - Coloca as TS em END BACKUP" >> ${LOG_FILE}
  $ORACLE_HOME/bin/sqlplus -s internal @${SCRIPT_DIR}/${ORACLE_SID}_end_bkp.sql > ${SCRIPT_DIR}/${ORACLE_SID}_end_bkp.log
  ORAERR ${SCRIPT_DIR}/${ORACLE_SID}_end_bkp.log

done
echo `date '+[%d/%m/%Y - %T]'`" FIM DO BACKUP" >> ${LOG_FILE}
echo "--------------------------------------------------------------------------------" >> ${LOG_FILE}
