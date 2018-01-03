
select i.constraint_name,
       i.constraint_type,
       c.column_name,
       c.position
from sys.dba_constraints i,
     sys.dba_cons_columns c
where i.table_name = upper('&1')
  and i.constraint_name = c.constraint_name
  and i.table_name = c.table_name
order by 2,1,4
/
