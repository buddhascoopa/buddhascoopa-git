Rem
Rem Criado em 14:47 02/28/2000
Rem Quantidade de convers�es de locks em um per�odo de tempo
Rem Verificar manual SO para ver qual a taxa do DLM aceit�vel
Rem
select value
from v$sysstat
where name = 'global lock converts (async)'
/
