select s.sid SID,
       s.username USUARIO,
       r.segment_name ROLLBACK,
       p.extents ,
       p.bytes
from v$session s,
     v$transaction t,
     sys.dba_rollback_segs r,
     sys.dba_segments p
where t.addr = s.taddr
  and t.xidusn = r.segment_id
  and p.segment_name = r.segment_name
order by s.username, r.segment_name
/
