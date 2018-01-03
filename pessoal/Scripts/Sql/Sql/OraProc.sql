col machine for a25
col program for a40
select s.machine,
       s.program,
       s.process,
       s.sid,
       p.spid
from v$session s,
     v$process p
where s.paddr = p.addr
  and p.spid = '&1'
order by 1,2,3
/
