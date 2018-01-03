set scan on
undef owner
accept sowner char prompt 'Entre com a Dono..: '

set head off
set feed off
set pages 0
set long 2000000

spool &sowner

select 'spool '||'&sowner'||'.log' from dual
/
select 'create sequence '||sequence_owner||'.'||sequence_name,
       '   start with '||min_value,
       '   increment by '||increment_by,
       '   maxvalue '||max_value||';'
from dba_sequences
where sequence_owner = upper('&sowner')
order by sequence_owner, sequence_name
/
set head on
set feed on
set pages 20

spool off
