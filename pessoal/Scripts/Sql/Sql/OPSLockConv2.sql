Rem
Rem Criada em 14:44 02/28/2000
Rem Valor deve ficar acima de 95%
Rem
select (b1.value/b2.value)*100 OPSLockConv1
from v$sysstat b1,
     v$sysstat b2
where b1.name = 'DBWR cross instance writes'
  and b2.name = 'physical writes'
/
