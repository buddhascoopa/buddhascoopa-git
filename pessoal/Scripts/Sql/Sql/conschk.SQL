select i.constraint_name,
       i.constraint_type,
       c.column_name,
       i.search_condition
from sys.user_constraints i,
     sys.user_cons_columns c
where i.table_name = upper('&1')
  and i.constraint_name = c.constraint_name
  and i.table_name = c.table_name
  and i.constraint_type = 'C'
order by 3
/
