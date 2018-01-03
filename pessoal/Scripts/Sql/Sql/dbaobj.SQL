select o.owner,
       o.object_type,
       o.object_name,
       o.created,
       o.last_ddl_time,
       o.status
from dba_objects o
where o.object_name like upper('&obj%')
order by 1,3,2
/
