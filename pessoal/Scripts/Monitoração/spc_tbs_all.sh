#!/bin/ksh
#
# spc_tbs_all.sh - Monitorar o espaco livre nas tablespaces de TODAS as
#                  instancias do oratab
#                  Eno Klinger
# 
# Intervencao                   Responsavel Data       Hora  Descricao
# ----------------------------- ----------- ---------- ----- -----------------------------------------------------------------
# Criacao                       Eno Klinger 05/04/2002
# Adaptacao para Ctrl-M OI      Erick CB    23/04/2002
# Adaptacao                     Erick CB    26/06/2002       Altercao no envora
# Alteracao                     Erick CB    30/07/2002 11:20 Parametro de Entrada para MINEXT
#
# Paremtros
# $1 = Minimo de Extents para Alerta

MINEXT=$1
export MINEXT

SAIDA_ALL=0
export SAIDA_ALL

shift $#
. $HOME/envora

cd $MON_DIR

for SID in `grep -v "^#" $ORATAB | cut -d: -f1-3 | grep :Y$ | cut -d: -f1`
{
 ./spc_tbs.sh $SID $MINEXT
 export SAIDA_ALL=`expr $SAIDA_ALL + $?`
}
exit $SAIDA_ALL
