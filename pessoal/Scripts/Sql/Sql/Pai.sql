col DONO-Filha for a10
col DONO-Pai for a10
col constraint_name for a15
col TAB-Filha for a20
col TAB-Pai for a20
undef own
undef tab
accept tab char prompt 'Entre com a tabela: '
accept own char prompt 'Entre com o dono..: '
select b.owner "DONO-Pai",
       b.table_name "TAB-Pai",
       b.constraint_name,
       a.owner "DONO-Filha",
       a.table_name "TAB-Filha",
       a.constraint_name,
       a.constraint_type
from sys.dba_constraints a,
     sys.dba_constraints b
where b.table_name = upper('&tab')
  and b.owner = upper('&own')
  and b.constraint_type in ('P','U')
  and b.constraint_name = a.r_constraint_name
/
