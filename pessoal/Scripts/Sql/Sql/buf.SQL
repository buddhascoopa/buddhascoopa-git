col owner for a20
col object_type for a25
col object_name for a35
select b.owner,
       b.object_type,
       b.object_name,
       count(*) buffers
from sys.x$bh a,
     dba_objects b
where a.obj=b.object_id
group by b.owner, b.object_type, b.object_name
/
