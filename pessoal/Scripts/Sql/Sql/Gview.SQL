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
select 'create or replace view '||owner||'.'||view_name||' as ',
       text
from dba_views
where owner = upper('&sowner')
order by view_name
/
set head on
set feed on
set pages 20

spool off
