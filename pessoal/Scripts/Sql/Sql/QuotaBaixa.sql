col Objeto for a30
col Tipo for a15
col Tspace for a15
col Dono for a15
col ProxExt for 9999999
col Ocupado for 9999999
col Quota for   9999999

select a.segment_name    Objeto ,
       a.segment_type    Tipo   ,
       a.tablespace_name Tspace ,
       a.owner           Dono   ,
       a.next_extent     ProxExt,
       b.bytes           Ocupado,
       b.max_bytes       Quota
from sys.dba_segments  a,
     sys.dba_ts_quotas b
where a.tablespace_name = b.tablespace_name
  and a.next_extent >= (b.max_bytes-b.bytes)
  and b.max_bytes <> -1
order by a.tablespace_name,
         a.owner          ,
         a.segment_type   ,
         a.segment_name
/
