#!/bin/ksh
#
# bkp_ora_all.sh - Coloca todas as instâncias do ORATAB em begin/end backup
# 
# Intervenção                   Responsável Data
# ----------------------------- ----------- ----------
# Adaptação                     Enô Klinger 09/05/2002
# Alteração                     Erick CB    18/06/2002
#
# Parâmetros:
# $1 = begin | end
# $2 = hostname

erro () 
{
    if [ -f /tmp/begin_backup.ctl ] ; then
       rm /tmp/begin_backup.ctl
    fi
    echo $1 > /tmp/begin_backup.ctl
    exit $1
}

# Checar parâmetros

MODO=$1
typeset -l MODO
export MODO
if [ $# -lt 1 ] ; then
   echo "Uso: bkp_ora_all.sh begin|end hostname"
   exit 1
elif [ $MODO != "begin" ] && [ $MODO != "end" ] ; then
   echo "Uso: bkp_ora_all.sh begin|end hostname"
   exit 1
fi

HOSTNAME=`hostname`
if [ $# -gt 1 ]
then
  HOSTNAME=$2
fi
export HOSTNAME

# Setar variáveis de ambiente
. $HOME/envora $HOSTNAME

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
            bkp_ora.sh $ORACLE_SID $MODO $HOSTNAME 
            reterr=$?
            if test ${reterr} -ne 0 ; then
               erro ${reterr}
            fi
        fi
        ;;
    esac
done
erro 0
