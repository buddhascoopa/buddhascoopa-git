select instance_name,
       host_name,
       to_char(startup_time, 'dd/mm/yyyy hh24:mi') startup,
       status,
       archiver,
       logins,
       database_status
from v$instance;

select segment_name, status
from dba_rollback_segs
where status<>'OFFLINE'
order by 1;

select * from global_name;
