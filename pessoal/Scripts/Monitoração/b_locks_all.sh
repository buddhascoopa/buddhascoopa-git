#!/bin/ksh
#
# b_locks_all.sh - Monitorar locks bloqueando sessoes
#                  em TODAS as instancias do oratab
# 
# Intervencao                   Responsavel Data        Hora Descricao
# ----------------------------- ----------- ---------- ----- -----------------------------------------------------------------
# Criacao                       Eno Klinger 05/04/2002
# Alteracao                     Erick CB    30/07/2002 11:15 Uso do envora

. $HOME/envora

cd $MON_DIR

SAIDA_ALL=0

for SID in `grep -v "^#" $ORATAB | cut -d: -f1-3 | grep :Y$ | cut -d: -f1`
{
 ./b_locks.sh $SID
 SAIDA_ALL=`expr $SAIDA_ALL + $?`
}
exit $SAIDA_ALL
