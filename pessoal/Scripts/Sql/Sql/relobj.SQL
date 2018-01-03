
col owner for a15
col object_name for a30
col object_type for a20

break on owner on object_type

spool c:\temp\relobj.lis
select owner, 
       object_type, 
       object_name,  
       status 
from dba_objects
where owner in ('ADM_SEG','IPR_COMUM','JCIVEL','JCRIME','SAP1G','SAP2G','SAPEP')
  and object_type in ('SEQUENCE','VIEW','TRIGGER','INDEX','SYNONYM')
order by 1,2,3
/
spool off
