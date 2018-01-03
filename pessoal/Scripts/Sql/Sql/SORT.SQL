col segment_name for a30
col owner for a10
col segment_type for a15
select owner, tablespace_name, segment_name, bytes
from sys.dba_segments
where owner = 'SYS'
  and segment_type = 'TEMPORARY'
order by tablespace_name
/
