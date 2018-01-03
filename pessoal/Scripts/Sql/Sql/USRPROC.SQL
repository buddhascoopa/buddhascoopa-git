accept pid char prompt 'Entre com o Processo do usuario: '

select username,
       sid
from v$session
where process = '&pid'
/
