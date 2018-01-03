#!/bin/ksh
#
# bkp_ora.sh - Coloca a instância especificada em begin/end backup
# 
# Intervenção                   Responsável Data
# ----------------------------- ----------- ----------
# Criação                       Enô Klinger 09/05/2002
# Alteração                     Erick CB    18/06/2002
#
# Parâmetros:
# $1 = SID
# $2 = begin | end
# $3 = hostname
	
# Checar parâmetros

export SID=$1

MODO=$2
typeset -l MODO
export MODO
if [ $# -lt 2 ] ; then
   echo "Uso: bkp_ora.sh <SID> begin|end hostname"
   exit 1
elif [ $MODO != "begin" ] && [ $MODO != "end" ] ; then
   echo "Uso: bkp_ora.sh <SID> begin|end hostname"
   exit 1
fi

HOSTNAME=`hostname`
if [ $# -gt 2 ]
then
  HOSTNAME=$3
fi
export HOSTNAME


# Setar variáveis de ambiente
. $HOME/envora $HOSTNAME $SID

BKP_LOG=$BKP_DIR/${SID}_${DATAHORA}_${MODO}_bkp.log


# Checar processos Oracle
ps -ef | grep -v grep | grep "pmon_${SID} " >> /dev/null
if [ $? -ne 0 ] ; then
   echo "Instância [$SID] OFFLINE !!!"
   exit 1
fi

# Checar se a base está em archive log mode
TESTARCH=${TMPDIR}/testarch_${SID}_${DATAHORA}.log
${ORACLE_HOME}/bin/sqlplus -s internal << !EOF >>${TESTARCH} 2>>${TESTARCH}
set feed off
set head off
set verify off
set pages 0
select log_mode from v\$database;
!EOF
reterr=`grep "ORA-" ${TESTARCH} | wc -l`
if [ $reterr -ne 0 ] ; then
   echo "[$SID] não responde !!!"
   exit $reterr
fi
STATINST=`cat ${TESTARCH}`
rm $TESTARCH
if [ ! "${STATINST}" = "ARCHIVELOG" ] ; then
   echo "[$SID] em modo ${STATINST} !!!"
   exit 0
fi

# Pôr a base em Begin Backup
echo "$SID - $MODO backup iniciado em : " `date +%d/%m/%Y_%H:%M` >> $BKP_LOG
echo "" >> $BKP_LOG
${ORACLE_HOME}/bin/sqlplus -s internal << !EOF >>$BKP_LOG 2>>$BKP_LOG
set serveroutput on feedback off
declare
  W_STAT varchar2(20);
begin
  dbms_output.enable( 99999 );
  if '${MODO}' = 'begin' then
    W_STAT := 'NOT ACTIVE';
  else
    W_STAT := 'ACTIVE';
  end if;
  for R_TBS in ( select distinct vt.NAME
                   from V\$TABLESPACE vt,
                        V\$DATAFILE vd,
                        V\$BACKUP vb
                  where vt.TS#     = vd.TS#
                    and vd.STATUS != 'OFFLINE'
                    and vd.FILE#   = vb.FILE#
                    and vb.STATUS  = W_STAT ) loop
    dbms_output.put_line( 'alter tablespace ' || R_TBS.NAME || ' ${MODO} backup;' );
    execute immediate 'alter tablespace ' || R_TBS.NAME || ' ${MODO} backup';
    dbms_output.put_line( '- Alteração feita com sucesso!' );
  end loop;
    exception
      when others then
        dbms_output.put_line( ' ' || SQLERRM );
end;
/
exit;
!EOF

reterr=`grep "ORA-" $BKP_LOG | wc -l`
echo "" >> $BKP_LOG
echo "${SID} - $reterr erro(s)." >> $BKP_LOG
echo "$SID - $MODO backup concluído em : " `date +%d/%m/%Y_%H:%M` >> $BKP_LOG
echo "" >> $BKP_LOG
exit $reterr
