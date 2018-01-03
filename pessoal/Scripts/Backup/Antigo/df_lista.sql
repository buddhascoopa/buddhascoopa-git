set head off
set feed off
set pages 0
set lines 150

select '.'||name from v$controlfile
union
select '.'||name from v$datafile
union
select '.'||member from v$logfile
/

exit
