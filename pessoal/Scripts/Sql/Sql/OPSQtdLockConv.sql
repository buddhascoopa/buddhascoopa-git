Rem
Rem Criado em 14:47 02/28/2000
Rem Quantidade de conversões de locks em um período de tempo
Rem Verificar manual SO para ver qual a taxa do DLM aceitável
Rem
select value
from v$sysstat
where name = 'global lock converts (async)'
/
