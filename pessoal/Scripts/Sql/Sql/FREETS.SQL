col tablespace_name for a10

break on file_id skip 1
compute sum max min of bytes on file_id

undef ts
accept ts char prompt 'Entre com Tablespace: '
select tablespace_name,
       file_id,
       bytes
from sys.dba_free_space
where tablespace_name like upper('&ts%')
order by 1,2 
/
