Rem
Rem Criado em 15:15 02/28/2000
Rem Tempo gasto para convers�o dos locks
Rem
SELECT average_wait
FROM V$SYSTEM_EVENT
WHERE EVENT = 'lock element cleanup' 
/
