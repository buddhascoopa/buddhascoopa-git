select substr(a.segment_name,1,60)    Objeto  ,
       a.extents                      Extents ,
       substr(a.segment_type,1,8)     Tipo    ,  
       substr(a.tablespace_name,1,15) Tspace  ,
       substr(a.owner,1,15)           Owner   ,
       a.bytes                        Bytes   ,
       a.next_extent                  Prox_Ext,
       b.bytes                        Contiguo         
from sys.dba_segments   a,
     sys.dba_free_space b 
where a.tablespace_name = b.tablespace_name
  and a.next_extent > (select max(c.bytes)     
                       from sys.dba_free_space c 
                       where c.tablespace_name = a.tablespace_name)
order by a.tablespace_name,
         a.owner          ,
         a.segment_type   ,
         a.segment_name   
/
