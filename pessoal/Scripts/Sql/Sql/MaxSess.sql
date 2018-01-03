col "Maximo Permitido" for a20
col "Sessoes Abertas" for 9999
select decode(value,0,'ILIMITADO',value) "Maximo Permitido", a "Sessoes Abertas"

from v$parameter,
     (select count(*) a
     from v$session
     where username is not null)
where name = 'license_max_sessions'
/
