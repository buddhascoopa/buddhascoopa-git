col owner for a10
col object_name for a30
col comp for a15
undef obj
accept obj char prompt 'Entre com o Objeto: '
select owner,
       object_type, 
       object_name, 
       status, 
       to_char(last_ddl_time,'ddmmyy hh24:mi:ss') Comp
from dba_objects
where object_name like upper('&obj%')
order by 1,2,3
/
