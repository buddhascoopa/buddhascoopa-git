Rem
Rem Criado em 16:51 02/28/2000
Rem Verifica a convers�o de locks (< 5000/minuto)
Rem
select sum(counter)
from v$lock_activity
/
