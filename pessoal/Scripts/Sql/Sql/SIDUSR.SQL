accept nom char prompt 'Entre com o Chave do usuario: '

select username,
       sid
from v$session
where osuser = lower('&nom')
/
