set scan on
undef owner
accept sowner char prompt 'Entre com o Agraciado..: '

set head off
set feed off
set pages 0
set long 2000000

spool &sowner

select 'spool '||'&sowner'||'.log' from dual
/
select 'grant '||privilege||' to '||grantee||decode(admin_option,'YES',' with admin option')||';'
from dba_sys_privs
where grantee = upper('&sowner')
/
set head on
set feed on
set pages 20

spool off
