undef data
accept data char prompt 'Entre com a Data (dd/mm/yyyy): '
col Mes for a3
col Dia for a3
col Hora for a4
col IOPS for 999
col EPS for 999
col LPS for 999
col Nome for a50
break on Dia skip 1 on Mes skip 1 on Hora skip 1
compute avg LABEL 'Hora' of IOPS EPS LPS on Hora
compute avg LABEL 'Dia'  of IOPS EPS LPS on Dia
select to_char(mio.data_coleta,'MM') Mes,
       to_char(mio.data_coleta,'DD') Dia,
       to_char(mio.data_coleta,'HH24') Hora,
       vdf.name Nome,
       avg(mio.iops) IOPS,
       avg(mio.eps) EPS,
       avg(mio.lps) LPS
from tabmonitio mio,
     v$datafile vdf
where mio.file# = vdf.file#
  and data_coleta > trunc(to_date('&data','dd/mm/yyyy'))
group by to_char(data_coleta,'MM'),
         to_char(data_coleta,'DD'),
         to_char(data_coleta,'HH24'),
         vdf.name
order by to_char(data_coleta,'MM'),
         to_char(data_coleta,'DD'),
         to_char(data_coleta,'HH24'),
         vdf.name
/
