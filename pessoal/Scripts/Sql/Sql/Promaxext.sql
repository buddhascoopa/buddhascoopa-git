col Nome for a30
col Tipo for a15
col Schema for a15
col Ext for 999
col Max for 999
col % for 999

select owner         Schema,
       segment_type  Tipo  ,
       segment_name  Nome  ,
       extents       Ext   ,
       max_extents   Max   ,
       ((extents/decode(max_extents,0,1,max_extents))*100) "%"
from sys.dba_segments
where (decode(max_extents,0,0,extents)/decode(max_extents,0,1,max_extents))*100 >= 90
order by 1,2,3,6
/