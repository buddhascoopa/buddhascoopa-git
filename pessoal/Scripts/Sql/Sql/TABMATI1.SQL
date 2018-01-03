set pages 50

col owner for a10
col segment_type for a15
col segment_name for a30

break on owner skip 2 on report

select owner,
       segment_type,
       extents, 
       bytes, 
       segment_name
from sys.dba_segments
order by 1,2,3 desc ,4 desc
/
