col Nome for a30
col Dono for a10
spool objinv.lis
ttitle center 'Relatorio de Objetos Invalidos' skip 2
select owner Dono,
       object_type Tipo,
       object_name Nome,
       status
from sys.dba_objects
where status = 'INVALID'
order by 1,2,3
/
ttitle center 'Relatorio de Triggers Invalidas' skip 2
select owner Dono,
       trigger_name Nome,
       status
from sys.dba_triggers
where status = 'DISABLED'
order by 1,2
/
ttitle center 'Relatorio de Constraints Invalidas' skip 2
select owner Dono,
       constraint_type Tipo,
       constraint_name Nome,
       status 
from sys.dba_constraints
where status = 'DISABLED'
order by 1,2,3
/
spool off
exit
