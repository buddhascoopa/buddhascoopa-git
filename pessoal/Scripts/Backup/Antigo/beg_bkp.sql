set head off
set feed off
set pages 0
set lines 150

select distinct 'alter tablespace '||ts.tablespace_name||' begin backup;'
  from dba_data_files df, dba_tablespaces ts
  where df.tablespace_name=ts.tablespace_name
    and ts.status='ONLINE'
/

select 'exit' from dual
/

exit
