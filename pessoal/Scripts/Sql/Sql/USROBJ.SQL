col sid for 999
col owner for a8
col object for a30
col username for a12
col object_type for a8
col osuser for a8
col S for a1

select a.object,
       o.object_type,
       a.owner,
       s.sid,
       s.username,
       s.osuser,
       substr(s.status,1,1) S
from v$session s,
     v$access a,
     sys.dba_objects o
where s.sid    = a.sid
  and a.owner  = o.owner
  and a.object = o.object_name
  and s.type   = 'USER'
  and a.ob_typ in (1,2,3,4,5,6)
order by a.object,
         s.sid
/
