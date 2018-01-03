-- TableSpaceName

alter tablespace TableSpaceName coalesce;

select extent_management, initial_extent/1024/1024 "Init MB", next_extent/1024/1024 "Next MB"
from dba_tablespaces
where tablespace_name='TableSpaceName';

select bytes/1024/1024 "Livre Mb", count(0) Qtde
from dba_free_space
where tablespace_name='TableSpaceName'
group by bytes/1024/1024
order by bytes/1024/1024 desc;

select file_id, bytes/1024/1024 "Livre Mb"
from dba_free_space
where tablespace_name='TableSpaceName'
order by 2;

select file_id, file_name, bytes/1024/1024 "Mb"
from dba_data_files
where tablespace_name='TableSpaceName';

select sum(bytes)/1024/1024 "Total Livre Mb"
from dba_free_space
where tablespace_name='TableSpaceName';

select segment_type, owner, segment_name, partition_name, extents, initial_extent/1024/1024 "Ini Mb", next_extent/1024/1024 "Nxt Mb", pct_increase
from dba_segments
where tablespace_name='TableSpaceName'
order by 7 desc, 6;

