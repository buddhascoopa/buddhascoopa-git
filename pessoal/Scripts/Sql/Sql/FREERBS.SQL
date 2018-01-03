select tablespace_name, file_id, bytes                    
from sys.dba_free_space                                   
where tablespace_name like upper('RBS') and bytes > 2048000
order by 1,2                                              
/
