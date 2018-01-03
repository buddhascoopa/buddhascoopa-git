SELECT name, child#, sleeps / gets razao
FROM V$LATCH_CHILDREN
WHERE name = 'cache buffers lru chain'
order by 1,2
/
