#!/bin/ksh
#
# total_extents.sh - Monitorar o total de extents ocupados pelos objetos
#
# Intervencao                   Responsável Data       Hora  Descricao
# ----------------------------- ----------- ---------- ----- ---------------------------------------------------------------------
# Criacao                       Ana Paula   07/05/2002
# Adaptacao para OI             Ana Paula   07/05/2002
# Adaptacao para Ctrl-M OI      Ana Paula   ?
# Atualizacao                   Erick CB    05/06/2002
# Atualizacao                   Erick CB    26/06/2002       Alterado o envora
# Atualizacao                   Erick CB    26/06/2002 11:25 Parametro para TOTEXT
# Atualizacao                   Erick CB    07/11/2002 08:45 Pata nao alarmar no Control-M

# Parametros
# $1 = SID
# $2 = Numero de Extents para Alarmar

if [ $# -lt 2 ]
then
  echo "usage: total_extents.sh <SID> <TOTALEXTENTS>"
  exit 1
fi

ORACLE_SID=$1
export ORACLE_SID

numextents=$2
export numextents

# Setar variáveis de ambiente
. $HOME/envora $ORACLE_SID

cd $MON_DIR

SAIDA=0
export SAIDA

# Arquivo de mensagem para email
MSG=total_extents.msg
export MSG

# Arquivo de Alerta
ALERTA=total_extents.txt
export ALERTA

sqlplus -s internal << EOF > $ALERTA
set echo off feedback off linesize 1000 pagesize 1000 heading on trimspool on
col owner format a15
col segment_type format a15
col segment_name format a30
col extents format 9999
select owner, segment_type, segment_name, extents
 from dba_segments
  where extents > $numextents
    and owner not in ('SYS', 'SYSTEM')
    and segment_type in ('TABLE', 'TABLE PARTITION', 'INDEX', 'INDEX_PARTITION')
/
exit
EOF

if [ -s $ALERTA ]
then
  echo "To: oracleoi@telemar.com.br" > $MSG
  echo Subject: `hostname` - $ORACLE_SID - Qtde de Extents maior que $numextents >> $MSG
  cat $ALERTA >> $MSG
  mail oracleoi@telemar.com.br < $MSG
  banner Atencao
  echo ---------------------------------------------------------------------
  echo Envie email ao OI-TI Infra Suporte Banco de Dados
  echo `hostname` : $ORACLE_SID : Qtde de Extents maior que $numextents
  echo ---------------------------------------------------------------------
  cat $ALERTA
  echo ---------------------------------------------------------------------
  # Alterado por ECBezerra para nao alarmar no Control-M
  SAIDA=0
  rm $MSG
fi
rm $ALERTA

exit $SAIDA
