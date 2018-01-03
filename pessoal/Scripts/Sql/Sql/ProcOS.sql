accept cpid char prompt 'Entre com o Numero do Job: '
select fr.request_id
from applsys.fnd_concurrent_processes fp,
     applsys.fnd_concurrent_requests fr
where fr.controlling_manager = fp.concurrent_process_id
  and fp.os_process_id = '&cpid'
/
