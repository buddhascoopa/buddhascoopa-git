select to_char(sysdate, 'dd/mm/yyyy hh24:mi') AGORA from dual;

select 'dba_registered_snapshots' from dual where rownum<1;
select owner, name, snapshot_site, refresh_method, snapshot_id
from dba_registered_snapshots
-- where owner='ECB' --name like '%S_QUOTE_SOLN'
order by name;

select 'sys.slog$' from dual where rownum<1;
select master, snapid, to_char(snaptime, 'dd/mm/yyyy hh24:mi') snaptime
from sys.slog$
-- where snapid in (2514,2515,2534,2554,2555) --master='S_QUOTE_SOLN'
order by snaptime;

select 'sys.mlog$' from dual where rownum<1;
select master,
       to_char(oldest, 'dd/mm/yyyy hh24:mi:ss') oldest,
       to_char(oldest_pk, 'dd/mm/yyyy hh24:mi:ss') oldest_pk,
       to_char(youngest, 'dd/mm/yyyy hh24:mi:ss') youngest,
       log,
       to_char(mtime, 'dd/mm/yyyy hh24:mi:ss') mtime,
       temp_log
from sys.mlog$
-- where master='S_QUOTE_SOLN'
order by oldest, oldest_pk;

select '(LIXO) sys.slog$ minus dba_registered_snapshots' from dual where rownum<1;
select master, snapid, to_char(snaptime, 'dd/mm/yyyy hh24:mi:ss') snaptime
from sys.slog$
where snapid not in (select snapshot_id from dba_registered_snapshots)
order by snaptime;
