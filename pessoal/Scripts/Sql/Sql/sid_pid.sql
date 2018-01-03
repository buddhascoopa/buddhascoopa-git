select p.spid, s.sid
from v$session s,
     v$process p
where p.spid = &1
  and s.paddr = p.addr
/
