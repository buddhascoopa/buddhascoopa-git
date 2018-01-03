Rem
Rem Criado em 10:53 02/29/2000
Rem Conta o número de hashed locks ocorrendo no banco de dados
Rem
SELECT COUNT(*)
FROM V$LOCK_ELEMENT
WHERE bitand(flags, 4)!=0
/
