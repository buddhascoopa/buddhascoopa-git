#!/bin/ksh
#
# bkp_ora_all.sh - Coloca todas as inst�ncias do ORATAB em begin/end backup
# 
# Interven��o                   Respons�vel Data
# ----------------------------- ----------- ----------
# Adapta��o                     En� Klinger 09/05/2002
#
# Par�metros:
# $1 = begin | end

function erro {
    if [ -f /tmp/begin_backup.ctl ] ; then
       rm /tmp/begin_backup.ctl
    fi
    echo $1 > /tmp/begin_backup.ctl
    exit $1
}

# Checar par�metros
export MODO=$1
if [ $# -lt 1 ] ; then
   echo "Uso: bkp_ora_all.sh begin|end"
   exit 1
elif [ $MODO != "begin" ] && [ $MODO != "end" ] ; then
   echo "Uso: bkp_ora_all.sh begin|end"
   exit 1
fi

# Setar vari�veis de ambiente
. ./env/bkp_ora.env

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
            bkp_ora.sh $ORACLE_SID $MODO
            reterr=$?
            if test ${reterr} -ne 0 ; then
               erro ${reterr}
            fi
        fi
        ;;
    esac
done
erro 0