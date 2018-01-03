col data for a17
col owner for a6
col master_link for a17
select owner,
       name,
       to_char(start_with,'ddmmyy hh24:mi:ss') data,
       master_link
from sys.dba_snapshots                                   
where sysdate > start_with                               
order by owner, data;                                     
