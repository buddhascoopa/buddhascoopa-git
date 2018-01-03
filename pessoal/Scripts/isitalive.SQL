select instancia, to_char(data,'dd/mm/yyyy hh24:mi') data, erro
from monit.is_it_alive
where erro is not null
order by instancia, data
