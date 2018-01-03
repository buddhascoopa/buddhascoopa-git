set scan on
undef trig
undef owner
accept sowner char prompt 'Entre com a Dono..: '

set head off
set feed off
set pages 0

spool &sowner

select 'spool '||'&sowner'||'.log' from dual
/
select 'CREATE OR REPLACE TRIGGER '||owner||'.'||description,
       trigger_body
from dba_triggers
where owner = upper('&sowner')
/

spool off

set head on
set feed on
set pages 20

