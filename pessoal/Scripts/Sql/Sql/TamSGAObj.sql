Rem 
Rem Tamanho dos objetos na SGA
Rem
undef own
accept own char prompt 'Entre com o Dono: '
select type,
       sum(SOURCE_SIZE),
       sum(PARSED_SIZE), 
       sum(CODE_SIZE) 
from  sys.dba_object_size
where owner=upper('&own')
group by type
/ 