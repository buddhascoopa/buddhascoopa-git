#!/bin/ksh

. $HOME/.profile

export ORACLE_SID=$1
export SAIDA=0
export perc_extents=0.70
export METHOD='estimate'
export PERC=30
export TMPDIR=/tmp
DATA=`date "+%Y%m%d_%H%M"`

cd /usr/monitor/scripts

TESTFILE=${TMPDIR}/analyze_schema_${ORACLE_SID}_${DATA}.log
sqlplus -s << EOF > ${TESTFILE}
system/`psinst $ORACLE_SID`
set echo off feedback off linesize 1000 pagesize 0 heading off trimspool on
set feed off
set head off
set pages 0
begin
for reg in (select owner from dba_tables where owner not in ('sys','system') group by owner) loop
sys.dbms_utility.analyze_schema(reg.owner,$METHOD,null, $PERC,'FOR TABLE');
end loop;
for reg in (select owner from dba_indexes where owner not in ('sys','system') group by owner) loop
sys.dbms_utility.analyze_schema(reg.owner,'COMPUTE',null, null,'FOR ALL INDEXES');
end loop;
end;
exit;
EOF
SAIDA=1
exit $SAIDA