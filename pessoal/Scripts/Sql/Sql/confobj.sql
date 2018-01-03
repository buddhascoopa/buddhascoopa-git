select segment_name, segment_type, tablespace_name
from user_segments
where tablespace_name like 'PNAD%'
order by 1,2,3
/
