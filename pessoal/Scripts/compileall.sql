select  'alter '||object_type||' '||owner||'.'||object_name||' compile;'
from    dba_objects
where   status = 'INVALID'
        and
        object_type != 'PACKAGE BODY'
        and
        object_type != 'UNDEFINED'
        and
        owner not in ('SYS','SYSTEM')
union 
select  'alter package '||owner||'.'||object_name||' compile body;'
from    dba_objects
where   status = 'INVALID'
        and
        object_type = 'PACKAGE BODY'
        and
        object_type != 'UNDEFINED'
        and
        owner not in ('SYS','SYSTEM')

