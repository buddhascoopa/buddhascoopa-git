#!/bin/ksh
#
# bkp_ora_all.sh - Coloca todas as inst�ncias do ORATAB em begin/end backup
# 
# Interven��o                   Respons�vel Data
# ----------------------------- ----------- ----------
# Adapta��o                     En� Klinger 09/05/2002
# Altera��o                     Erick CB    26/06/2002
#
# Par�metros:
# $1 = begin | end

erro () 
{
    if [ -f /tmp/begin_backup.ctl ] ; then
       rm /tmp/begin_backup.ctl
    fi
    echo $1 > /tmp/begin_backup.ctl
    exit $1
}

# Checar par�metros

MODO=$1
typeset -l MODO
export MODO
if [ $# -lt 1 ] ; then
   echo "Uso: bkp_ora_all.sh begin|end"
   exit 1
elif [ $MODO != "begin" ] && [ $MODO != "end" ] ; then
   echo "Uso: bkp_ora_all.sh begin|end"
   exit 1
fi

# Setar vari�veis de ambiente
shift $#
. $HOME/envora

cd $BKP_DIR

for SID in `grep -v "^#" $ORATAB | cut -d: -f1-3 | grep :Y$ | cut -d: -f1`
{
 ./bkp_ora.sh $SID $MODO
 reterr=$?
 if test ${reterr} -ne 0 ; then
   erro ${reterr}
 fi
}
erro 0
