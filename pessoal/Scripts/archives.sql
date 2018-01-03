---------------------------------------------------------------------
-- POR DIA ----------------------------------------------------------
---------------------------------------------------------------------
select avg(sum(BLOCKS*BLOCK_SIZE)/1024/1024) MEDIAMB
from v$archived_log
group by trunc(COMPLETION_TIME)
/

select min(COMPLETION_TIME) DATAMIN
from v$archived_log
/
select max(COMPLETION_TIME) DATAMAX
from v$archived_log
/
select max(sum(BLOCKS*BLOCK_SIZE)/1024/1024) MAXMB
from v$archived_log
group by trunc(COMPLETION_TIME)
/
select max(sum(BLOCKS*BLOCK_SIZE)/1024/1024) MAXMB
from v$archived_log
group by trunc(COMPLETION_TIME)
/

select trunc(COMPLETION_TIME), sum(BLOCKS*BLOCK_SIZE)/1024/1024 MB
from v$archived_log
group by trunc(COMPLETION_TIME)
/

---------------------------------------------------------------------
-- POR HORA ---------------------------------------------------------
---------------------------------------------------------------------
select avg(sum(BLOCKS*BLOCK_SIZE)/1024/1024) MEDIAMB
from v$archived_log
group by to_char(COMPLETION_TIME,'dd/mm/yyyy hh24')
/

select max(sum(BLOCKS*BLOCK_SIZE)/1024/1024) MAXMB
from v$archived_log
group by to_char(COMPLETION_TIME,'dd/mm/yyyy hh24')
/

select to_char(COMPLETION_TIME,'dd/mm/yyyy hh24'), sum(BLOCKS*BLOCK_SIZE)/1024/1024 MB
from v$archived_log
group by to_char(COMPLETION_TIME,'dd/mm/yyyy hh24')
/

select *
from v$log_history
where first_time between to_date('2004-04-26 12
order by FIRST_TIME
