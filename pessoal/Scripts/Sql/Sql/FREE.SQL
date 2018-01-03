col tablespace_name for a5
break on tablespace_name skip 1
compute sum of bytes on tablespace_name 
select tablespace_name, file_id, bytes
from sys.dba_free_space
where tablespace_name like upper('&1%')
order by 1,2
/
