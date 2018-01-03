select tablespace_name, owner, segment_type, segment_name, bytes/1024/1024, extents
from dba_segments
where tablespace_name in (
'ICS_T2'
)
order by 1,2,3;


select tablespace_name, owner, segment_type, segment_name, bytes/1024/1024, extents
from dba_segments
where extents>500
order by extents;

GROUP BY tablespace_name, owner, segment_type


--'ICS_I1'
'ICS_T1'
--,'ICS_T2'
--,'USERS'
)
order by 1,2,3,4;

select file_name, bytes/1024/1024
from dba_data_files
where tablespace_name='TEMPBKP';

select username from dba_ts_quotas where tablespace_name='TEMPBKP'

select distinct ''''||tablespace_name||''',' from dba_segments

select ''''||tablespace_name||''','
from dba_tablespaces
order by tablespace_name;

select owner, table_name
from dba_tables
order by 1,2;

select OWNER, TABLE_NAME
from dba_tab_columns
where DATA_TYPE like 'LONG%';

select owner, object_type, object_name, status
from dba_objects
where status<>'VALID'
order by 1,2,3;
