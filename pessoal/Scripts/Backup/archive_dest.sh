#!/bin/ksh
DATA=`date "+%Y%m%d_%H%M"`
ORATAB=/var/opt/oracle/oratabarb
export TMPDIR=/tmp
cat $ORATAB | while read LINE
do
    case $LINE in
        \#*)                ;;        #comment-line in oratab
        *)
        if [ "`echo $LINE | awk -F: '{print $3}' -`" = "Y" ] ; then
            ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
            if [ "$ORACLE_SID" = '*' ] ; then
                ORACLE_SID=""
            fi
            export ORACLE_SID

            unset ORACLE_HOME
            export ORACLE_HOME=`cat $ORATAB | grep "^${ORACLE_SID}:" | awk -F: '{print $2}'`
            if [ -z $ORACLE_HOME ] ; then
               echo "Invalid SID : [${ORACLE_SID}] !!!"
               exit 1
            fi
            
            ps -ef | grep -v grep | grep pmon_${ORACLE_SID} >> /dev/null
            if [ $? -ne 0 ] ; then
               echo "Instance [${ORACLE_SID}] OFFLINE !!!"
               exit 1
            fi
            export NLS_LANG=american_america.we8iso8859p1
            export ORA_NLS32=$ORACLE_HOME/ocommon/nls/admin/data
            export LD_LIBRARY_PATH=/usr/ucblib:$ORACLE_HOME/lib
            export ORACLE_PATH=.:$ORACLE_HOME/bin:$ORACLE_HOME/obackup/bin:/bin:/usr/bin:/usr/ccs/bin
            export PATH=/usr/ccs/bin:/usr/ucb/bin:/usr/bin:/etc:/usr/sbin:/usr/ucb:$HOME/bin:/usr/bin/X11:/sbin:$ORACLE_HOME/bin:/opt/bin:/bin:/usr/bin:/GNU/bin/make:$SCRIPTS:
            export ORACLE_TERM=dtterm
            export TERM=dtterm
            export SHLIB_PATH=${ORACLE_HOME}/lib
            
            TESTARCH=${TMPDIR}/testarch_${ORACLE_SID}_${DATA}.log
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
               echo "[${ORACLE_SID}] not responding !!!"
               exit $reterr
            fi
            
            STATINST=`cat ${TESTARCH}`
            rm $TESTARCH
            if [ ! "${STATINST}" = "ARCHIVELOG" ] ; then
               echo "[${ORACLE_SID}] in ${STATINST} mode !!!"
               exit 0
            fi
            
            LOGARCHDEST=${TMPDIR}/logdestarch_${ORACLE_SID}_${DATA}.log
            ${ORACLE_HOME}/bin/sqlplus -s internal << EOF>>${LOGARCHDEST} 2>>${LOGARCHDEST}
set feed off
set head off
set verify off
set pages 0
select value from v\$parameter where name='log_archive_dest';
exit;
EOF
            
            reterr=`grep "ORA-" ${LOGARCHDEST} | wc -l`
             
            if [ $reterr -ne 0 ] ; then
               echo "${ORACLE_SID} - $reterr errors found fetching log_archive_dest information."
               exit $reterr
            fi
             
            BKP_CTL_DEST=`cat ${LOGARCHDEST}`"/ctl/"
             
            if [ ! -d $BKP_CTL_DEST ] ; then
               echo "Destination directory ${BKP_CTL_DEST} not found."
               exit 1
            fi
            echo `cat ${LOGARCHDEST}`"/ctl/"
            rm ${LOGARCHDEST}
        fi
        ;;
    esac
done


exit 0
