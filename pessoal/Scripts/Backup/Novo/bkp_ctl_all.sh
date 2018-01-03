#!/bin/ksh
#
# bkp_ctl_all.sh - Executa copia do ControlFile das inst�ncias do ORATAB
# 
# Interven��o                   Respons�vel Data
# ----------------------------- ----------- ----------
# Adapta��o                     En� Klinger 09/05/2002
# Altera��o                     Erick CB    18/06/2002
#
# Par�metros:
# $1 = hostname

erro ()
 {
    if [ -f /tmp/backup_controlfile.ctl ] ; then
       rm /tmp/backup_controlfile.ctl
    fi
    echo $1 > /tmp/backup_controlfile.ctl
    exit $1
}

HOSTNAME=`hostname`
if [ $# -gt 0 ]
then
  HOSTNAME=$1
fi
export HOSTNAME

. $HOME/envora $HOSTNAME

SCR_COPY_CTL=${BKP_DIR}/copia_ctl.sh
export SCR_COPY_CTL

echo "HOSTNAME=\$HOSTNAME" > $SCR_COPY_CTL
echo "export HOSTNAME"    >> $SCR_COPY_CTL

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
            $BKP_DIR/bkp_ctl.sh $HOSTNAME $ORACLE_SID
            reterr=$?
            if test ${reterr} -ne 0 ; then
               erro ${reterr}
            fi
        fi
        ;;
    esac
done
erro 0
