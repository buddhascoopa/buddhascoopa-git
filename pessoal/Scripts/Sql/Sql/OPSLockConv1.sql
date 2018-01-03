Rem
Rem Criada em 14:43 02/28/2000
Rem Valor deve ficar acima de 95%
Rem 
SELECT ((b1.value-b2.value)/b1.value)*100 OPSLockConv
FROM V$SYSSTAT b1,
     V$SYSSTAT b2
WHERE b1.name = 'consistent gets'
  AND b2.name = 'global lock converts (async)'
/
