accept tab char prompt 'Entre com a Tabela: '
select i.constraint_name,
       i.constraint_type,
       c.column_name,
       c.position
from user_constraints i,
     user_cons_columns c
where i.table_name = upper('&tab')
  and i.constraint_name = c.constraint_name
  and i.table_name = c.table_name
order by 2,1,4
/
