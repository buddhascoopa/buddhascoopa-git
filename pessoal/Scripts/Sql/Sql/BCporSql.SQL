col sql_text for a45
select sql_text, 
       disk_reads DR, 
       buffer_gets BG,
       executions E,
       parse_calls PC,
       (SHARABLE_MEM+PERSISTENT_MEM+RUNTIME_MEM) MEM,
       ROWS_PROCESSED Linhas
from v$sqlarea
where disk_reads > 250
order by disk_reads desc
/
