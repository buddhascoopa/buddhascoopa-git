spool text.lis
undef id                                              
accept id number prompt 'Entre com o id da conexao: ' 
select a.sql_text,q.executions
from v$sqltext_with_newlines a,                                     
     v$session s,
     sys.V_$SQLarea q
where s.sql_address = a.address
  and q.address = a.address
  and s.sid = &id                                     
order by a.piece                                      
/        
spool off
