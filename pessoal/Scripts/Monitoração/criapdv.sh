#!/bin/ksh
#
# criapdv.sh - Executa procedure PROC_CRIA_USUARIO_PDV
# 
# Intervencao                   Responsavel  Data
# ----------------------------- ------------ ----------
# Criacao                       Juliao Cesar 23/06/2002
#

cd $HOME/dbascripts
sqlplus -s execpdv/execpdv@sbpcsprd << !EOF > criapdv.lst 
set serveroutput on size 10000
exec criapdv.PROC_CRIA_USUARIO_PDV;
select ' Usuário PDV : '||username ||' criado automaticamente em : '|| to_char(SYSDATE, 'DD/MM/YYYY  HH24:MM')  "USUARIOS CRIADOS"
FROM ALL_USERS
WHERE trunc(CREATED) = trunc(SYSDATE)
AND USERNAME LIKE 'PDV%';
exit
!EOF

if [ -s criapdv.lst ]
then
  echo "To: oracleoi@telemar.com.br" > criapdv.msg
  echo Subject: `hostname`: Criacao de usuarios PDV - Siebel  $SID >> criapdv.msg
  echo "Pessoal, este eh o historico de criacao automatica de usuarios PDV - Siebel.\n\n" >> criapdv.msg 
  cat criapdv.lst >> criapdv.msg
  mail oracleoi@telemar.com.br < criapdv.msg
  rm criapdv.msg
fi
rm criapdv.lst
