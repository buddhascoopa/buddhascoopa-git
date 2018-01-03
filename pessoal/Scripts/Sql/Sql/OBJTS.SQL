col Dono for a15
col Tipo for a20
col Nome for a40
undef ts
accept ts char prompt 'Entre com a Tablespace: '
select owner Dono,
       segment_type Tipo, 
       segment_name Nome
from sys.dba_segments
where tablespace_name like upper('&ts%')
order by 1,2,3
/
