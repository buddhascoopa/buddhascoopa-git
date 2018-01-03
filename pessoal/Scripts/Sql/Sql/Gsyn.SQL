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
select 'create synonym '||owner||'.'||synonym_name||' for '||table_owner||'.'||table_name||';'
from dba_synonyms
where owner = upper('&sowner')
order by table_owner, table_name
/
set head on
set feed on
set pages 20

spool off
