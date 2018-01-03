col Perc for 999.9
select owner, 
       table_name, 
       num_rows, 
       chain_cnt, 
       ((chain_cnt/decode(num_rows,0,1,num_rows))*100) Perc
from dba_tables
where owner = 'IFRDBA2'
order by 1,5 DESC
/
