select owner,
       object_type,
       count(*)
from dba_objects
where status = 'INVALID'
group by owner,object_type
/
set head off
set pages 0
set feed off
spool comp.lis
select 'spool comp.erro' from dual
/
select 'Prompt Compilando View '||owner||'.'||object_name,
       'alter view '||owner||'.'||object_name||' compile;'
from sys.dba_objects
where status = 'INVALID'
  and object_type = 'VIEW'
order by owner, object_name
/
select 'Prompt Compilando Procedure '||owner||'.'||object_name,
       'alter procedure '||owner||'.'||object_name||' compile;'
from sys.dba_objects
where status = 'INVALID'
  and object_type = 'PROCEDURE'
order by owner, object_name
/
select 'Prompt Compilando Function '||owner||'.'||object_name,
       'alter function '||owner||'.'||object_name||' compile;'
from sys.dba_objects
where status = 'INVALID'
  and object_type = 'FUNCTION'
order by owner, object_name
/
select 'Prompt Compilando Package '||owner||'.'||object_name,
       'alter package '||owner||'.'||object_name||' compile;'
from sys.dba_objects
where status = 'INVALID'
  and object_type = 'PACKAGE'
order by owner, object_name
/
select 'Prompt Compilando Package Body '||owner||'.'||object_name,
       'alter package '||owner||'.'||object_name||' compile body;'
from sys.dba_objects
where status = 'INVALID'
  and object_type = 'PACKAGE BODY'
order by owner, object_name
/
select 'Prompt Compilando Trigger '||owner||'.'||object_name,
       'alter trigger '||owner||'.'||object_name||' compile;'
from sys.dba_objects
where status = 'INVALID'
  and object_type = 'TRIGGER'
order by owner, object_name
/
select 'spool off' from dual
/
spool off
@comp.lis
set head on
set pages 20
set feed on

select owner,
       object_type,
       count(*)
from dba_objects
where status = 'INVALID'
group by owner,object_type
/
