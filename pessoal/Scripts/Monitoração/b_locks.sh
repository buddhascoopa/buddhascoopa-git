#!/bin/ksh
#
# b_locks.sh - Monitorar locks bloqueando sessoes
# 
# Intervencao                   Responsavel Data        Hora Descricao
# ----------------------------- ----------- ---------- ----- -----------------------------------------------------------------
# Criacao                       Eno Klinger 04/04/2002
# Alteracao                     Erick CB    30/07/2002 11:15 Uso do envora
#
# Parametros
# $1 = SID

ORACLE_SID=$1
export ORACLE_SID

. $HOME/envora $ORACLE_SID

cd $MON_DIR

sqlplus -s << !EOF > b_locks.lst
system/`psinst $ORACLE_SID`
set echo off verify off pagesize 9999 linesize 9999
set trimout on trimspool on heading off feedback off
select /*+ RULE */
        distinct 'O usuário ' || sess1.USERNAME || ' (SID:' || vl1.SID || ' OS_PID:' || lobj.PROCESS ||
        ' OS_USER: ' || lobj.OS_USER_NAME || ')' ||
        ' está mantendo um lock ' || decode( vl1.LMODE, 0, 'None',      1, 'Null',
                                                        2, 'Row-S(SS)', 3, 'Row-X(SX)',
                                                        4, 'Share',     5, 'S/Row-X(SSX)',
                                                        6, 'Exclusive(X)', 'Unknow' ) ||
        ' em ' || dbao.OWNER || '.' || dbao.OBJECT_NAME || ' há ' || round( vl1.CTIME/60 ) || ' minutos' ||
        ' e está bloqueando o SID ' || dbw.WAITING_SESSION || ':' || sess2.USERNAME ||
        ' há ' || round( vl2.CTIME/60 ) || ' minutos ' " "
        --vl1.TYPE "Tipo",
        --decode( vl1.REQUEST, 0, 'None',  1, 'Null',        2, 'Row-S(SS)', 3, 'Row-X(SX)',
        --                     4, 'Share', 5,'S/Row-X(SSX)', 6, 'Exclusive(X)', 'Unknow' ) "Request"
  from  V\$LOCK vl1,
        SYS.DBA_WAITERS dbw,
        V\$LOCK vl2,
        V\$LOCKED_OBJECT lobj,
        DBA_OBJECTS dbao,
        V\$SESSION sess1,
        V\$SESSION sess2
  where vl1.BLOCK != 0
    and vl1.SID = HOLDING_SESSION
    and vl2.SID = WAITING_SESSION
    and vl1.SID = sess1.SID
    and vl2.SID = sess2.SID
    and vl1.SID = lobj.SESSION_ID
    and lobj.OBJECT_ID = dbao.OBJECT_ID
    and round( vl2.CTIME/60 ) >= 5;
exit
!EOF

if [ -s b_locks.lst ]
then
  echo "To: oracleoi@telemar.com.br" > b_locks.msg
  echo "Subject: Blocking Locks - `hostname` - $ORACLE_SID"     >> b_locks.msg
  cat b_locks.lst >> b_locks.msg
  mail oracleoi@telemar.com.br < b_locks.msg
  rm b_locks.msg
fi
rm b_locks.lst
