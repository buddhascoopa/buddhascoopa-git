#!/bin/ksh
#
# total_files_all.sh - Monitorar o total de datafiles das instancias em ORATAB
# 
# Intervencao                   Responsavel Data       Hora  Descricao
# ----------------------------- ----------- ---------- ----- -----------------------------------------------------------------
# Criacao                       Ana Paula   05/04/2002
# Adaptacao para Ctrl-M OI      Ana Paula   05/04/2002
# Atualizacao                   Erick CB    06/06/2002
# Atualizacao                   Erick CB    26/06/2002       Alterado o envora
# Atualizacao                   Erick CB    30/07/2002 11:25 Parametro para PERCENTUAL
# Atualizacao                   Erick CB    07/11/2002 09:00 Teste de Parametro

# Parametro
# $1 = Percentual de DataFiles para alarmar

if [ $# -lt 1 ]
then
  echo "usage: total_files_all.sh <PERCDATAFILES>"
  exit 1
fi

# Percentual de Datafiles em Relacao ao DB_FILES
PERCENTUAL=$1
export PERCENTUAL

# Setar variáveis de ambiente
shift $#
. $HOME/envora

cd $MON_DIR

SAIDA_ALL=0
export SAIDA_ALL

for SID in `grep -v "^#" $ORATAB | cut -d: -f1-3 | grep :Y$ | cut -d: -f1`
{
  ./total_files.sh $SID $PERCENTUAL
  SAIDA_ALL=`expr $SAIDA_ALL + $?`
}
exit $SAIDA_ALL
