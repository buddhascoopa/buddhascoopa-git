#!/bin/ksh

function erro {
    if [ -f /tmp/begin_backup.ctl ] ; then
       rm /tmp/begin_backup.ctl
    fi
    echo $1 > /tmp/begin_backup.ctl
    exit $1
}

ORATAB=/var/opt/oracle/oratabarb
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
            bkp_begin_backup.sh $ORACLE_SID
            reterr=$?
            if test ${reterr} -ne 0 ; then
               erro ${reterr}
            fi
        fi
        ;;
    esac
done
erro 0