col tablespace_name for a5
undef tab
accept tab char prompt 'Entre com a Tabela: '
select i.table_name,
       i.index_name,
       i.tablespace_name,
       i.next_extent,
       i.max_extents,
       i.pct_increase,
       s.extents,
       s.bytes
from sys.dba_indexes i,
     sys.dba_segments s
where i.table_name like upper('&tab%')
  and s.segment_name = i.index_name
/
