select substr(segment_name,1,30),segment_type,max(extent_id) 
from   sys.dba_extents 
where  extent_id > 200
group  by segment_name,segment_type
