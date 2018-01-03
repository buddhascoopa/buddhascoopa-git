# mknod ibge.dmp p

ORACLE_HOME=/produtos/app/oracle/product/8.0.5 ; export ORACLE_HOME
ORACLE_SID=ibge ; export ORACLE_SID
PATH=.:$PATH:/produtos/app/oracle/product/8.0.5/bin:/usr/bin:/usr/ccs/bin:/usr/sbin:/etc:/sbin ; export PATH
compress < $1.dmp > $1.dmp.Z &
sleep 5
exp proto_ibge/proto_ibge file=$1.dmp feedback=5000 buffer=10485760 indexes=y parfile=tabs_$1 &
exit
