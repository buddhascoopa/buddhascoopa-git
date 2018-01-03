#!/bin/ksh
#
# arch_clean_all.sh - Gera lista ou faz limpeza dos Archives de todas instancias do ORATAB
# 
# Intervencao                   Responsavel Data       Descricao
# ----------------------------- ----------- ---------- ---------------------------------------------------------------------
# Criacao                       Erick CB    25/06/2002
# Atualizacao                   Erick CB    02/07/2002
#
# Parametros
# $1 = clean|list

MODO=$1
typeset -l MODO
export MODO
if [ $# -lt 1 ] ; then
   echo "Uso: arch_clean.sh <SID> clean|list"
   exit 1
elif [ $MODO != "clean" ] && [ $MODO != "list" ] ; then
   echo "Uso: arch_clean.sh <SID> clean|list"
   exit 1
fi

# Variaveis de Ambiente Oracle
shift $#
. $HOME/envora

cd $BKP_DIR

SAIDA_ALL=0
export SAIDA_ALL

for SID in `grep -v "^#" $ORATAB | cut -d: -f1-3 | grep :Y$ | cut -d: -f1`
{
  ./arch_clean.sh $SID $MODO
  SAIDA_ALL=`expr $SAIDA_ALL + $?`
}
exit $SAIDA_ALL
