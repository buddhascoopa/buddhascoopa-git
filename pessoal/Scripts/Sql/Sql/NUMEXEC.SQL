spool text.lis

col data for a20

undef id
accept id number prompt 'Entre com o id do usuario: '
select to_char(sysdate,'ddmmyy hh24:mi:ss') data,
       a.executions
from v$sqlarea a,
     v$session s
where s.sid = &id
  and s.sql_address = a.address
/
spool off
