set pages 25
col file_name for a40
col tablespace_name for a10
break on tablespace_name skip 1
compute sum of bytes on tablespace_name
undef ts
accept ts char prompt 'Entre com a Tablespace: '
select tablespace_name,
       file_name,
       file_id,
       bytes
from sys.dba_data_files
where tablespace_name like upper('&ts%')
order by 1,2
/
