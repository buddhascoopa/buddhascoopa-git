select instancia, to_char(data,'dd/mm/yyyy hh24:mi') data, max_processes, qtd_processes
from monit.monit_processes
order by 1,2
