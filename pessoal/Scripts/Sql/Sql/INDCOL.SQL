col index_name for a30
col column_name for a30
col column_position for 999
undef tab
undef owt
accept tab char prompt 'Entre com a Tabela: '
accept owt char prompt 'Entre com o Owner.: '
select index_name, column_name, column_position
from sys.dba_ind_columns
where table_name  = upper('&tab')
  and table_owner = upper('&owt')
order by 1,3
/
