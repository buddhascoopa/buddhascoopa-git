select tbs.tablespace_name,
       (select sum(bytes)/1024/1024
          from dba_data_files
         where tablespace_name=tbs.tablespace_name
       ) TAM_MB,
       (select sum(bytes)/1024/1024
          from dba_free_space
         where tablespace_name=tbs.tablespace_name
       ) FREE_MB
  from dba_tablespaces tbs
  order by tbs.tablespace_name;

select tablespace_name, owner, sum(bytes)/1024/1024 MB
from dba_segments
group by tablespace_name, owner;

select owner, tablespace_name, sum(bytes)/1024/1024 MB
from dba_segments
group by owner, tablespace_name;


select owner, sum(bytes)/1024/1024 MB
from dba_segments
group by owner;
