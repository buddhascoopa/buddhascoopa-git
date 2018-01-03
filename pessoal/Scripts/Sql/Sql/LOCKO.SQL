col object_name for a30
col R for 99
col L for 99
col username for a11
col osuser for a8 

select k.id1,
       k.request R,
       k.lmode L,
       k.sid,
       s.username,
       s.osuser,
       o.object_name
from v$lock k,
     sys.dba_objects o,
     v$session s,
     v$lock k1
where k.id1 = o.object_id
  and k.sid = s.sid
  and k1.id1 = k.id1
  and k1.request <> 0
  and k1.id1 <> 0
order by k.id1,
         k.request,
         k.lmode       
/
