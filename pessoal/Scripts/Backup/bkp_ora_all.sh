#!/bin/ksh
#
# bkp_ora_all.sh - Coloca todas as instâncias do ORATAB em begin/end backup
# 
# Intervenção                   Responsável Data
# ----------------------------- ----------- ----------
# Adaptação                     Enô Klinger 09/05/2002
# Alteração                     Erick CB    26/06/2002
#
# Parâmetros:
# $1 = begin | end

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
   echo "Uso: bkp_ora_all.sh begin|end"
   exit 1
elif [ $MODO != "begin" ] && [ $MODO != "end" ] ; then
   echo "Uso: bkp_ora_all.sh begin|end"
   exit 1
fi

# Setar variáveis de ambiente
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
