
select nvl(username,'ORACLE') USR,
       block_gets, 
       consistent_gets, 
       physical_reads,
       (1-(physical_reads/(decode(block_gets+consistent_gets,0,1,block_gets+consistent_gets))))*100 HIT
from v$session vs,
     v$sess_io vsio
where vs.sid = vsio.sid
/
