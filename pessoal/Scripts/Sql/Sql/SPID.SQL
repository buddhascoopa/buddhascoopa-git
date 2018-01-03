select p.spid
from v$session s,
     v$process p
where s.sid = &1
  and s.paddr = p.addr
/
