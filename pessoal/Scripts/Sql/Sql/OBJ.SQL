col object_name for a30

select o.object_type,
       o.object_name,
       o.created,
       o.last_ddl_time,
       o.status
from user_objects o
where o.object_name = upper('&obj')
order by 2,1
/
