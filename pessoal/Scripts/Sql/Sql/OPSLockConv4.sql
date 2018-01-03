Rem
Rem Criado em 16:51 02/28/2000
Rem Verifica a conversão de locks (< 5000/minuto)
Rem
select sum(counter)
from v$lock_activity
/
