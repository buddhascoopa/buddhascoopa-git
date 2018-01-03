#!/bin/ksh
#
# bkp_ctl.sh - Executa copia do ControlFile da instancia especificada
# 
# Intervencao                   Responsavel Data       Descricao
# ----------------------------- ----------- ---------- ---------------------------------------------------------------------
# Adaptacao                     Eno Klinger 09/05/2002
# Alteracao                     Erick CB    26/06/2002
# Alteracao                     Erick CB    15/07/2002 Alteracao do script dinamico copia_ctl.sh
# Alteracao                     Erick CB    07/11/2002 Alteracao do script dinamico ftp_ctl.sh
#
# Parametros:
# $1 = SID

ORACLE_SID=$1

# Variavweis de Ambiente Oracle
. $HOME/envora $ORACLE_SID

cd $BKP_DIR

BKP_LOG=$BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_ctl.log

if [ -z $ORACLE_SID ] ; then
   echo "Sintax: bkp_ctl.sh <SID>"
   exit 1
fi

unset ORACLE_HOME
export ORACLE_HOME=`cat $ORATAB | grep "^${ORACLE_SID}:" | awk -F: '{print $2}'`
if [ -z $ORACLE_HOME ] ; then
   echo "Invalid SID : [$ORACLE_SID] !!!"
   exit 1
fi

ps -ef | grep -v grep | grep pmon_${ORACLE_SID}$ >> /dev/null
if [ $? -ne 0 ] ; then
   echo "Instance [$ORACLE_SID] OFFLINE !!!"
   exit 1
fi

echo "$ORACLE_SID - backup controlfile started at : " `date +%d/%m/%Y_%H:%M` >> $BKP_LOG

TESTARCH=${BKP_DIR}/log/testarch_${ORACLE_SID}_${DATAHORA}.log
${ORACLE_HOME}/bin/sqlplus -s internal << EOF >>${TESTARCH} 2>>${TESTARCH}
set feed off
set head off
set verify off
set pages 0
select log_mode from v\$database;
exit;
EOF

reterr=`grep "ORA-" ${TESTARCH} | wc -l`

if [ $reterr -ne 0 ] ; then
   echo "[$ORACLE_SID] not responding !!!"
   exit $reterr
fi

STATINST=`cat ${TESTARCH}`
rm $TESTARCH
if [ ! "${STATINST}" = "ARCHIVELOG" ] ; then
   echo "[$ORACLE_SID] in ${STATINST} mode !!!"
   exit 0
fi

${ORACLE_HOME}/bin/sqlplus -s internal << EOF >>$BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_cfile_dest.log 2>>$BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_cfile_dest.log
set feed off
set head off
set verify off
set pages 0
select value from v\$parameter where name='log_archive_dest';
exit;
EOF

reterr=`grep "ORA-" $BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_cfile_dest.log | wc -l`

if [ $reterr -ne 0 ] ; then
   echo "$ORACLE_SID - $reterr errors found fetching log_archive_dest information." >> $BKP_LOG
   exit $reterr
fi

BKP_CTL_SOURCE=$BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_cfile_dest.log
BKP_CTL_DEST=`cat ${BKP_CTL_SOURCE}`"/ctl/"

if [ ! -d $BKP_CTL_DEST ] ; then
   echo echo "Destination directory ${BKP_CTL_DEST} not found." >> $BKP_LOG
   exit 1
fi

${ORACLE_HOME}/bin/sqlplus -s internal << EOF >>$BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_udump_dest.log 2>>$BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_udump_dest.log
set feed off
set head off
set verify off
set pages 0
select value from v\$parameter where name='user_dump_dest';
exit;
EOF

reterr=`grep "ORA-" $BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_udump_dest.log | wc -l`

if [ $reterr -ne 0 ] ; then
   echo "$ORACLE_SID - $reterr errors found fetching background_dump_dest information." >> $BKP_LOG
   exit $reterr
fi

UDUMP_DEST=`cat $BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_udump_dest.log`

if [ ! -d $UDUMP_DEST ] ; then
   echo echo "Trace directory ${UDUMP_DEST} not found." >> $BKP_LOG
   exit 1
fi

${ORACLE_HOME}/bin/sqlplus -s internal << EOF>>$BKP_LOG 2>>$BKP_LOG
set feed off
set head off
set verify off
set pages 0
prompt Switching logfile...
alter system switch logfile;
prompt Archiving all...
alter system archive log all;
prompt Archiving current...
alter system archive log current;
prompt Backing up controlfile 01...
alter database backup controlfile to '$BKP_CTL_DEST/${ORACLE_SID}_${DATAHORA}_control01.ctl';
prompt Backing up controlfile 02...
alter database backup controlfile to '$BKP_CTL_DEST/${ORACLE_SID}_${DATAHORA}_control02.ctl';
prompt Backing up controlfile to trace...
alter database backup controlfile to trace;
prompt Switching logfile...
alter system switch logfile;
prompt Backup Controlfile Done.
exit;
EOF
reterr=`grep "ORA-" $BKP_LOG | grep -v "ORA-00271" | wc -l`
BKP_CTL_TRC=`ls -tr ${UDUMP_DEST} | tail -1`
cp ${UDUMP_DEST}/${BKP_CTL_TRC} ${BKP_CTL_DEST}/${ORACLE_SID}_${DATAHORA}_cfile.trc

FTP_FILE1=$BKP_CTL_DEST/${ORACLE_SID}_${DATAHORA}_control01.ctl
FTP_FILE2=$BKP_CTL_DEST/${ORACLE_SID}_${DATAHORA}_control02.ctl
FTP_FILE3=${UDUMP_DEST}/${BKP_CTL_TRC}

# Gera script dinamico que faz a FTP dos CTLs
echo "bin"                                                       >> $SCR_FTP_CTL
echo "put $FTP_FILE1 \$HOSTDEST:/\$HOSTORIG/$FTP_FILE1"          >> $SCR_FTP_CTL
echo "put $FTP_FILE2 \$HOSTDEST:/\$HOSTORIG/$FTP_FILE2"          >> $SCR_FTP_CTL
echo "asc"                                                       >> $SCR_FTP_CTL
echo "put $FTP_FILE3 \$HOSTDEST:/\$HOSTORIG/$FTP_FILE3"          >> $SCR_FTP_CTL

rm $BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_cfile_dest.log
rm $BKP_DIR/log/${ORACLE_SID}_${DATAHORA}_udump_dest.log
echo "${ORACLE_SID} - $reterr errors found copying control trace file." >> $BKP_LOG
echo "$ORACLE_SID - backup controlfile finished at : " `date +%d/%m/%Y_%H:%M` >> $BKP_LOG
exit $reterr
