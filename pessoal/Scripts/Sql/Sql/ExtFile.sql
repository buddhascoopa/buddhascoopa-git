col file_name for a35
col tablespace_name for a10
col segment_name for a20
col segment_type for a10
col TAM for a10

undef tab
undef own
accept own char prompt 'Entre com o owner : '
accept tab char prompt 'Entre com a tabela: '

select a.tablespace_name,
       a.segment_name,
       b.file_name,
       a.extent_id,
       a.bytes/1024/1024||'M' TAM
from dba_extents a,
     dba_data_files b
where a.file_id = b.file_id
  and a.segment_name = upper('&tab')
  and a.owner        = upper('&own')
order by 1,2,3,4
/
