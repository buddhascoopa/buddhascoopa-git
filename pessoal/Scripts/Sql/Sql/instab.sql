set scan on
undef tab
accept tab char prompt 'Entre com a tabela: '

insert into &tab
select * from &tab@hmlg
/
