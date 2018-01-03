#!/bin/ksh
#
# total_files.sh - Monitorar o total de datafiles de uma instância especificada
#
# Intervencao                   Responsável Data       Hora  Descricao
# ----------------------------- ----------- ---------- ----- ---------------------------------------------------------------------
# Criacao                       Ana Paula   07/05/2002
# Adaptacao para OI             Ana Paula   07/05/2002
# Adaptacao para Ctrl-M OI      Ana Paula   ?
# Atualizacao                   Erick CB    06/06/2002
# Atualizacao                   Erick CB    26/06/2002       Alterado o envora
# Atualizacao                   Erick CB    30/07/2002 11:25 Parametro para PERCENTUAL
# Atualizacao                   Erick CB    07/11/2002 08:45 Pata nao alarmar no Control-M

# Parametros
# $1 = SID
# $2 = Percentual de Datafiles em relacao ao DB_FILES

if [ $# -lt 2 ]
then
  echo "usage: total_files.sh <SID> <PERCDATAFILES>"
  exit 1
fi

ORACLE_SID=$1
export ORACLE_SID

perc_files=$2
export perc_files

# Setar variáveis de ambiente
. $HOME/envora $ORACLE_SID

SAIDA=0
export SAIDA

# Arquivo de mensagem para email
MSG=total_files.msg
export MSG

# Arquivo de Alerta
ALERTA=total_files.txt
export ALERTA

cd $MON_DIR

sqlplus -s internal << EOF > $ALERTA
set echo off feedback off linesize 1000 pagesize 1000 heading off trimspool on
set serveroutput on 
declare 
  tot_files_perm number:=0;
  tot_files number:=0; 
begin 
  select value into tot_files_perm from v\$parameter where name = 'db_files';
  select count(0) into tot_files from v\$datafile;
  if (tot_files/tot_files_perm)*100 > $perc_files  then
    dbms_output.put_line('O total de datafiles ('||tot_files||') está maior que '||$perc_files||'% do total de db_files ('||tot_files_perm||')');
 end if;
end;
/
exit
EOF

if [ -s $ALERTA ]
then
  echo "To: oracleoi@telemar.com.br" > $MSG
  echo Subject: `hostname` - $ORACLE_SID - Total de Datafiles chegando ao DB_FILES >> $MSG
  cat $ALERTA >> $MSG
  mail oracleoi@telemar.com.br < $MSG
  banner Atencao
  echo ---------------------------------------------------------------------
  echo Envie email ao OI-TI Infra Suporte Banco de Dados
  echo `hostname` : $ORACLE_SID : Total de Datafiles chegando ao DB_FILES
  echo ---------------------------------------------------------------------
  cat $ALERTA
  echo ---------------------------------------------------------------------
  # Alterado por ECBezerra para nao alarmar no Control-M
  SAIDA=0
  rm $MSG
fi
rm $ALERTA

exit $SAIDA
