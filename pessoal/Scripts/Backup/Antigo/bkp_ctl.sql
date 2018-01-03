set verify off
set head off
set feed off
set pages 0
set lines 150

alter database backup controlfile to '&1._&2..ctl' reuse
/

exit
