col "Maximo Permitido" for a20
col "Processos Abertos" for 9999
select decode(value,0,'ILIMITADO',value) "Maximo Permitido", a "Processos Aberto
s"
from v$parameter,
     (select count(*) a
     from v$process)
where name = 'processes'
/
