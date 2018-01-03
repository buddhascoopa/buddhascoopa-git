select b.name,
       a.gets,
       a.misses
from v$latch a,
     v$latchname b
where a.latch# = b.latch#
/
