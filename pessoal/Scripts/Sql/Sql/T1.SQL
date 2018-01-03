col tablespace_name for a5
undef tab
select t.owner,
       t.table_name,
       t.tablespace_name,
       t.next_extent,
       t.max_extents,
       t.pct_increase,
       s.extents
from sys.dba_tables t,
     sys.dba_segments s
where 
  t.table_name = s.segment_name
  and t.owner = s.owner
  and segment_type = 'TABLE'
  and t.max_extents = s.extents
/
