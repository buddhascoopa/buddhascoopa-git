col Buffer for 999.9
col Lib for 999.9
col Dict for 999.9
col TPS for 99999.99
col NUsr for 9999
col CPU for 99999.99
col "%CPU" for 999.99
col LATCH for 999.9
col MEM for 999999
col MAXMEM for 9999999
col LOCK for 9999
col SORT for 999.9
undef data
accept data char prompt 'Entre com a Data (dd/mm/yyyy): '
select to_char(data_coleta,'MM') Mes,
       to_char(data_coleta,'DD') Dia,
       to_char(data_coleta,'HH24') Hora,
       avg(bc) Buffer,
       avg(lc) Lib,
       avg(ddc) Dict,
       avg(sort) Sort,
       avg(tps) TPS,
       avg(nusr) NUsr,
       avg(latch) LATCH,
       avg(mem)/1024/1024 MEM,
       avg(maxmem)/1024/1024 MAXMEM,
       avg(ulock) "LOCK"
from tabmonitperf
where data_coleta > trunc(to_date('&data','dd/mm/yyyy'))
group by to_char(data_coleta,'MM'),
         to_char(data_coleta,'DD'),
         to_char(data_coleta,'HH24')
order by to_char(data_coleta,'MM'),
         to_char(data_coleta,'DD'),
         to_char(data_coleta,'HH24')
/
