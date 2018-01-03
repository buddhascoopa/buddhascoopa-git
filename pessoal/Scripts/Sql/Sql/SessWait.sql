col event for a35
select a.sid,b.username,a.event,a.seconds_in_wait
from v$session_wait a,
     v$session b
where a.sid=b.sid
order by a.sid
/
