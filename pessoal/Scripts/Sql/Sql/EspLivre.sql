select a.tablespace_name Tspace,
       a.file_id         FileId,
       sum(a.bytes)      "Livres < 10%"
from sys.dba_free_space a,
     sys.dba_data_files b
where a.tablespace_name = b.tablespace_name
  and a.file_id         = b.file_id
  and 10 > (select (sum(c.bytes)/b.bytes)*100
            from sys.dba_free_space c
            where b.tablespace_name = c.tablespace_name
              and b.file_id         = c.file_id
            group by c.tablespace_name,
                     c.file_id)
group by a.tablespace_name,
         a.file_id
