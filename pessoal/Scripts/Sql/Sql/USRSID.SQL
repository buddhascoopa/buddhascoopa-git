undef id
select osuser,process
from v$session
where sid = &id
/
