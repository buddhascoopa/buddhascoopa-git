#!/bin/ksh
#
# ocup_extents_all.sh - Qtde de extends ocupado por objeto em percentual daas intancias em ORATAB
# 
# Intervencao                   Responsavel Data       Hora  Descricao
# ----------------------------- ----------- ---------- ----- -----------------------------------------------------------------
# Criacao                       Ana Paula   05/04/2002
# Adaptacao para Ctrl-M OI      Ana Paula   23/04/2002
# Atualizacao                   Erick CB    11/06/2002
# Atualizacao                   Erick CB    26/06/2002       Alteracao no $HOME/envora
# Atualizacao                   Erick CB    30/07/2002 11:20 Parametro para PERCENTUAL
# Atualizacao                   Erick CB    07/11/2002 09:00 Teste de Parametro

# Parametro
# $1 = Percentual de Extents para alarmar

if [ $# -lt 1 ]
then
  echo "usage: ocup_extents_all.sh <PERCEXTENTS>"
  exit 1
fi

# Percentual de Extents em Relacao ao Max Extents
PERCENTUAL=$1
export PERCENTUAL

# Setar variaveis de ambiente
shift $#
. $HOME/envora

cd $MON_DIR

SAIDA_ALL=0
export SAIDA_ALL

for SID in `grep -v "^#" $ORATAB | cut -d: -f1-3 | grep :Y$ | cut -d: -f1`
{
  ./ocup_extents.sh $SID $PERCENTUAL
  SAIDA_ALL=`expr $SAIDA_ALL + $?`
}
exit $SAIDA_ALL
