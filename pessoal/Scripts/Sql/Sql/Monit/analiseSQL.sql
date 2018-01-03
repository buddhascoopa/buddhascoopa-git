select to_char(data_coleta,'MM') Mes,
       to_char(data_coleta,'DD') Dia,
       to_char(data_coleta,'HH24') Hora,
       avg(dr) "Disk Read",
       avg(bg) "Buffer Gets",
       avg(mem) "Cons Mem",
       avg(linhas) Linhas,
       avg(exec) Execucao,
       avg(parse) PARSE,
       sql_text SQL
from tabmonitsql
where data_coleta > trunc(to_date('&data','dd/mm/yyyy'))
  and bg > 1000
group by to_char(data_coleta,'MM'),
         to_char(data_coleta,'DD'),
         to_char(data_coleta,'HH24'),
         sql_text
order by to_char(data_coleta,'MM'),
         to_char(data_coleta,'DD'),
         to_char(data_coleta,'HH24'),
         avg(bg) desc
/
