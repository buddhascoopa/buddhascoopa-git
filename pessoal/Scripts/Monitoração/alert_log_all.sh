#!/bin/ksh
#
# alert_log_all.sh - monitora o alert_<sid>.log
#                    dos DBs em ORATAB
# usage: alert_log_all.sh
#
# Intervencao                   Responsavel Data       Hora  Descricao
# ----------------------------- ----------- ---------- ----- -----------------------------------------------------------------
# Criacao                       Erick CB    08/05/2002
# Alteracao                     Erick CB    09/05/2002 17:34
# Alteracao                     Erick CB    30/07/2002 11:05 Utilizacao do envora

. $HOME/envora

cd $MON_DIR

SAIDA_ALL=0

for SID in `grep -v "^#" $ORATAB | cut -d: -f1-3 | grep :Y$ | cut -d: -f1`
{
 ./alert_log.sh $SID
 SAIDA_ALL=`expr $SAIDA_ALL + $?`
}
exit $SAIDA_ALL
