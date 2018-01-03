NETRC=$HOME/.netrc
LIXO=$HOME/lixo
read arq?"Entre com nome do relatorio: "   
read sist?"Entre com o nome do sistema: "  

echo "machine 10.10.2.3 login anonymous password 1111" >$NETRC
echo "macdef teste" >>$NETRC
echo "binary" >>$NETRC
echo "get /temp/$arq /tmp/$arq" >>$NETRC
echo "\n" >>$NETRC

echo '$'"teste" >$LIXO

ftp -v 10.10.2.3 <$LIXO >/tmp/log

