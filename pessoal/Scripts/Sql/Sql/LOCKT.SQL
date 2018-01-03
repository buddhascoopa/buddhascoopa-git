col object_name for a30
col request for 99
col lmode for 99
col username for a11

select k.id2,
       k.request,
       k.lmode,
       k.sid,
       s.username,
       s.osuser
from v$lock k,
     v$session s,
     v$lock k1
where k.sid = s.sid
  and k.id2 = k1.id2
  and k1.request <> 0
  and k1.id2 <> 0
order by k.id2,
         k.request,
         k.lmode
/
