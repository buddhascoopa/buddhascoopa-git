#!/bin/ksh

DATA=`date "+%Y%m%d_%H%M"`

# $1 = SID

SID=$1
ORATAB=/var/opt/oracle/oratabarb
BKP_END_DIR=/oraprd05/dbascripts
BKP_END_LOG=$BKP_END_DIR/${SID}_${DATA}_endbkp.log

if [ -z $SID ] ; then
   echo "Sintax: bkp_end_backup.sh <SID>"
   exit 1
fi


unset ORACLE_HOME
export ORACLE_HOME=`cat $ORATAB | grep "^${SID}:" | awk -F: '{print $2}'`
if [ -z $ORACLE_HOME ] ; then
   echo "Invalid SID : [$SID] !!!"
   exit 1
fi

ps -ef | grep -v grep | grep pmon_${SID} >> /dev/null
if [ $? -ne 0 ] ; then
   echo "Instance [$SID] OFFLINE !!!"
   exit 1
fi

echo "$SID - end backup started at : " `date +%d/%m/%Y_%H:%M` >> $BKP_END_LOG
export NLS_LANG=american_america.we8iso8859p1
export ORA_NLS32=$ORACLE_HOME/ocommon/nls/admin/data
export LD_LIBRARY_PATH=/usr/ucblib:$ORACLE_HOME/lib
export ORACLE_PATH=.:$ORACLE_HOME/bin:$ORACLE_HOME/obackup/bin:/bin:/usr/bin:/usr/ccs/bin
export PATH=/usr/ccs/bin:/usr/ucb/bin:/usr/bin:/etc:/usr/sbin:/usr/ucb:$HOME/bin:/usr/bin/X11:/sbin:$ORACLE_HOME/bin:/opt/bin:/bin:/usr/bin:/GNU/bin/make:$SCRIPTS:
export TMPDIR=/var/tmp
export ORACLE_SID=$SID
export ORACLE_TERM=dtterm
export TERM=dtterm
export SHLIB_PATH=${ORACLE_HOME}/lib

TESTARCH=${TMPDIR}/testarch_${SID}_${DATA}.log
${ORACLE_HOME}/bin/sqlplus -s system/`cat $HOME/.systempw` << EOF>>${TESTARCH} 2>>${TESTARCH}
set feed off
set head off
set verify off
set pages 0
select log_mode from v\$database;
exit;
EOF

reterr=`grep "ORA-" ${TESTARCH} | wc -l`

if [ $reterr -ne 0 ] ; then
   echo "[$SID] not responding !!!"
   exit $reterr
fi

STATINST=`cat ${TESTARCH}`
rm $TESTARCH
if [ ! "${STATINST}" = "ARCHIVELOG" ] ; then
   echo "[$SID] in ${STATINST} mode !!!"
   exit 0
fi

${ORACLE_HOME}/bin/sqlplus -s internal << EOF>>$BKP_END_LOG 2>>$BKP_END_LOG
set feed off
set head off
set verify off
set pages 0
spool $BKP_END_DIR/${SID}_${DATA}_endbkp_sql.sql
select 'spool $BKP_END_DIR/${SID}_${DATA}_endbkp_sql.log' from dual;
select DISTINCT 'ALTER TABLESPACE '||vt.name||' END BACKUP;' 
from  v\$tablespace vt,
      v\$datafile vd,
      v\$backup vb
where 
      vt.ts#=vd.ts# and
      vd.status!='OFFLINE' and
      vd.file#=vb.file# and
      vb.status='ACTIVE';
select 'spool off' from dual;
spool off
@$BKP_END_DIR/${SID}_${DATA}_endbkp_sql.sql
exit;
EOF
rm $BKP_END_DIR/${SID}_${DATA}_endbkp_sql.sql
rm $BKP_END_DIR/${SID}_${DATA}_endbkp_sql.log
reterr=`grep "ORA-" $BKP_END_LOG | wc -l`
echo "${SID} - $reterr errors found." >> $BKP_END_LOG
echo "$SID - end backup finished at : " `date +%d/%m/%Y_%H:%M` >> $BKP_END_LOG
exit $reterr
