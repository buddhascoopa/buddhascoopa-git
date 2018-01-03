select object_type,
       count(*)
from user_objects
where status = 'INVALID'
group by object_type
/
set head off
set pages 0
set feed off
spool c:\temp\comp.lis
select 'spool c:\temp\comp.erro' from dual
/
select 'Prompt Compilando View '||object_name,
       'alter view '||object_name||' compile;'
from user_objects
where status = 'INVALID'
  and object_type = 'VIEW'
order by object_name
/
select 'Prompt Compilando Procedure '||object_name,
       'alter procedure '||object_name||' compile;'
from user_objects
where status = 'INVALID'
  and object_type = 'PROCEDURE'
order by object_name
/
select 'Prompt Compilando Function '||object_name,
       'alter function '||object_name||' compile;'
from user_objects
where status = 'INVALID'
  and object_type = 'FUNCTION'
order by object_name
/
select 'Prompt Compilando Package '||object_name,
       'alter package '||object_name||' compile;'
from user_objects
where status = 'INVALID'
  and object_type = 'PACKAGE'
order by object_name
/
select 'Prompt Compilando Package Body '||object_name,
       'alter package '||object_name||' compile body;'
from user_objects
where status = 'INVALID'
  and object_type = 'PACKAGE BODY'
order by object_name
/
select 'Prompt Compilando Trigger '||object_name,
       'alter trigger '||object_name||' compile;'
from user_objects
where status = 'INVALID'
  and object_type = 'TRIGGER'
order by object_name
/
select 'spool off' from dual
/
spool off
set feed on
set echo on
@c:\temp\comp.lis
set echo off
set head on
set pages 20
select object_type,
       count(*)
from user_objects
where status = 'INVALID'
group by object_type
/