undef tab
undef dono
accept tab char prompt 'Entre com a tabela: '
accept dono char prompt 'Entre com o Owner da Tabela: '
select sum(data_length), count(data_length) from dba_tab_columns 
where table_name like upper('&tab%') and 
owner like upper('&dono%') group by table_name;
/
