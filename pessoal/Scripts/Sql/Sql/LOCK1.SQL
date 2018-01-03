col object_name for a30
col request for 99
col lmode for 99
col username for a11
select k.id2,
       k.request,
       k.lmode,
       k.sid
from v$lock k
where k.request <> 0
order by k.id2,
         k.request,
         k.lmode       
/
accept wid2 number prompt 'Entre com a identificacao do objeto: '

select k.id2,
       k.request,
       k.lmode,
       k.sid,
       s.username,
       s.osuser
from v$lock k,
     v$session s
where k.sid = s.sid
  and k.id2 = &wid2
order by k.id2,
         k.request,
         k.lmode       
/
