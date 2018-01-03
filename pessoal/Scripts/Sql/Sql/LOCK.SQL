col object_name for a30
col request for 99
col lmode for 99
col username for a11
select k.id1,
       k.request,
       k.lmode,
       k.sid
from v$lock k
where k.request <> 0
order by k.id1,
         k.request,
         k.lmode       
/
accept wid1 number prompt 'Entre com a identificacao do objeto: '

select k.id1,
       k.request R,
       k.lmode L,
       k.sid,
       s.username,
       s.osuser,
       o.object_name
from v$lock k,
     sys.dba_objects o,
     v$session s
where k.id1 = o.object_id
  and k.sid = s.sid
  and k.id1 = &wid1
order by k.id1,
         k.request,
         k.lmode       
/
