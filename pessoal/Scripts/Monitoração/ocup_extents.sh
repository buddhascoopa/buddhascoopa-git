#!/bin/ksh
#
# ocup_extents.sh - Qtde de extends ocupado por objeto em percentual da intancia especificada
#
# Intervencao                   Responsavel Data       Hora  Descricao
# ----------------------------- ----------- ---------- ----- ---------------------------------------------------------------------
# Criacao                       Ana Paula   07/05/2002
# Adaptacao para OI             Ana Paula   07/05/2002
# Adaptacao para Ctrl-M OI      Ana Paula   ?
# Atualizacao                   Erick CB    11/06/2002
# Atualizacao                   Erick CB    26/06/2002       Alteracao no $HOME/envora
# Atualizacao                   Erick CB    30/07/2002 11:20 Parametro para PERCENTUAL
# Atualizacao                   Erick CB    07/11/2002 08:45 Pata nao alarmar no Control-M

# Parametros
# $1 = SID
# $2 = Percentual para Alarmar

if [ $# -lt 2 ]
then
  echo "usage: ocup_extents.sh <SID> <PERCENTUAL>"
  exit 1
fi

ORACLE_SID=$1
export ORACLE_SID

perc_extents=$2
export perc_extents

# Setar variaveis de ambiente
. $HOME/envora $ORACLE_SID

cd $MON_DIR

SAIDA=0
export SAIDA

# Arquivo de mensagem para email
MSG=ocup_extents.msg
export MSG

# Arquivo de Alerta
ALERTA=ocup_extents.txt
export ALERTA

sqlplus -s internal << EOF > $ALERTA
col segment_name format a30
set echo off feedback off linesize 1000 pagesize 1000 heading off trimspool on
select owner, segment_name, extents, max_extents
from dba_segments
where (extents/max_extents)*100 > $perc_extents
  and (segment_type='TABLE' or segment_type='INDEX') 
order by (extents/max_extents)*100
/
exit
EOF

if [ -s $ALERTA ]
then
  echo "To: oracleoi@telemar.com.br" > $MSG
  echo Subject: `hostname` - $ORACLE_SID - Qtde Extents com $perc_extents do MAX >> $MSG
  cat $ALERTA >> $MSG
  mail oracleoi@telemar.com.br < $MSG
  banner Atencao
  echo ---------------------------------------------------------------------
  echo Envie email ao OI-TI Infra Suporte Banco de Dados
  echo `hostname` : $ORACLE_SID : Qtde de Extents com $perc_extents'%' do MAX
  echo ---------------------------------------------------------------------
  cat $ALERTA
  echo ---------------------------------------------------------------------
  # Alterado por ECBezerra para nao alarmar no Control-M
  SAIDA=0
  rm $MSG
fi
rm $ALERTA

exit $SAIDA
