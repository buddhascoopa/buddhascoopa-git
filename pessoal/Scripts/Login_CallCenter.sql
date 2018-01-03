select username, to_char(logon_time,'dd/mm/yyyy hh24:mi') logon, status, last_call_et seg
from v$session
where username in
  (
  'CTX53794'
  )
/


select 'alter system kill session '''||sid||','||serial#||''';' KILL_SESSION
from v$session
where username in
  (
  'CTX53794'
  )
/

