col tablespace_name for a5
undef tab
accept tab char prompt 'Entre com a tabela: '
select t.table_name,
       t.tablespace_name,
       t.next_extent,
       t.max_extents,
       t.pct_increase,
       s.extents,
       s.bytes
from sys.dba_tables t,
     sys.dba_segments s
where t.table_name like upper('&tab%')
  and t.table_name = s.segment_name
  and t.owner = s.owner
  and segment_type = 'TABLE'
/
