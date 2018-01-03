--
--Monitor Session Idle Time
--
col sid      format 999
col username format a10 truncated
col status   format a1  truncated
col logon    format a17
col idle     format a9
col program  format a30 truncated
col machine  format a30 truncated

select
   sid,username,status,
   to_char(logon_time,'dd-mm-yy hh:mi:ss') "LOGON",
   floor(last_call_et/3600)||':'||
   floor(mod(last_call_et,3600)/60)||':'||
   mod(mod(last_call_et,3600),60) "IDLE",
   program,
   machine
from
   v$session
where
   type='USER'
order by last_call_et, machine, program
/
