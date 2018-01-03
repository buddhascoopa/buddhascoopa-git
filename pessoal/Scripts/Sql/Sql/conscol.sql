col column_name for a20
col column_position for 999
undef tab
undef owt
accept tab char prompt 'Entre com a Tabela: '
accept owt char prompt 'Entre com o Owner.: '
select constraint_name, column_name, position
from sys.dba_cons_columns
where table_name  = upper('&tab')
  and owner       = upper('&owt')
order by 1,3
/
