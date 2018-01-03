#!/bin/ksh
#
# spc_tbs.sh - Monitorar o espaco livre nas tablespaces
#              Eno Klinger
# 
# Intervencao                   Responsável Data       Hora  Descricao
# ----------------------------- ----------- ---------- ----- ---------------------------------------------------------------------
# Criacao                       Eno Klinger 16/01/2002
# Adaptacao para OI             Eno Klinger 05/04/2002
# Adaptacao para Ctrl-M OI      Erick CB    23/04/2002
# Adaptacao                     Erick CB    26/06/2002 Alteracao no envora
# Alteracao                     Erick CB    30/07/2002 11:20 Parametro de Entrada para MINEXT
#
# Parametros
# $1 = SID Oracle
# $2 = Minimo de Extents para Alarmar

ORACLE_SID=$1
export ORACLE_SID

MIN_EXTS=$2
export MIN_EXTS

. $HOME/envora $ORACLE_SID

cd $MON_DIR

SAIDA=0
export SAIDA

$ORACLE_HOME/bin/sqlplus -s internal << !EOF > spc_tbs.lst
set echo off feedback off linesize 1000 pagesize 0 heading off trimspool on
set serveroutput on
declare
  W_QTX number := 0;
  W_NXT number;
  W_TBS varchar2(32) := ' ';
  W_MSG varchar2(4000);
  W_MIN number := $MIN_EXTS;
begin
  dbms_output.enable( 999999 );
  for R_TBS in ( select a.TABLESPACE_NAME, a.NEXT, b.BYTES LIVRE
                   from ( select TABLESPACE_NAME, max( NEXT_EXTENT ) NEXT
                            from DBA_SEGMENTS
                           group by TABLESPACE_NAME ) a,
                        DBA_FREE_SPACE b,
                        DBA_TABLESPACES c
                  where c.CONTENTS = 'PERMANENT'
                    and c.TABLESPACE_NAME = a.TABLESPACE_NAME
                    and b.TABLESPACE_NAME = a.TABLESPACE_NAME
                  order by a.TABLESPACE_NAME ) loop
    if W_TBS != R_TBS.TABLESPACE_NAME then
      if W_TBS != ' ' and W_QTX < W_MIN then
        W_MSG := W_MSG || 'A tablespace ' || W_TBS;
        if W_QTX = 0 then
          W_MSG := W_MSG || ' não comporta mais nenhum extent ';
        elsif W_QTX = 1 then
          W_MSG := W_MSG || ' só comporta mais 1 extent ';
        else
          W_MSG := W_MSG || ' só comporta mais ' || W_QTX || ' extents ';
        end if;
        if W_NXT < 1048576 then
          W_MSG := W_MSG || 'de ' || W_NXT / 1024 || 'Kb';
        elsif W_NXT < 1073741824 then
          W_MSG := W_MSG || 'de ' || ltrim( to_char( W_NXT / 1024 / 1024, '999' ) ) || 'Mb';
        else
          W_MSG := W_MSG || 'de ' || ltrim( to_char( W_NXT / 1024 / 1024 / 1024, '9999999999' ) ) || 'Gb';
        end if;
        dbms_output.put_line( W_MSG || chr(10) );                              
      end if;
      W_QTX := 0;
      W_MSG := '';
      W_NXT := R_TBS.NEXT;
      W_TBS := R_TBS.TABLESPACE_NAME;
    end if;
    W_QTX := W_QTX + trunc( R_TBS.LIVRE / R_TBS.NEXT );
  end loop;
end;
/
exit
!EOF
if [ -s spc_tbs.lst ]
then
  echo "To: oracleoi@telemar.com.br" > spc_tbs.msg
  echo Subject: `hostname`: Problemas de espaco em tablespaces da instancia $ORACLE_SID >> spc_tbs.msg
  cat spc_tbs.lst >> spc_tbs.msg
  mail oracleoi@telemar.com.br < spc_tbs.msg
  rm spc_tbs.msg
  banner atencao
  echo "Avise ao Suporte Oracle"
  echo "---------------------------------------------------------------------"
  echo "`hostname`: Problemas de espaco em tablespaces da instancia $ORACLE_SID"
  echo "---------------------------------------------------------------------"
  cat spc_tbs.lst
  echo "---------------------------------------------------------------------"
  SAIDA=1
fi
rm spc_tbs.lst
exit $SAIDA
