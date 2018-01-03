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
select 'grant '||privilege||' on '||owner||'.'||table_name||' to '||grantee||decode(grantable,'YES',' with grant option')||';'
from dba_tab_privs
where grantee = upper('&sowner')
order by owner, table_name, privilege
/
set head on
set feed on
set pages 20

spool off
