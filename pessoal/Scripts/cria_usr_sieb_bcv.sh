#!/bin/ksh
#
# cria_usr_sieb_bcv.sh - Cria usuario padrao na base siebel - BCV 
#              Juliao Cesar
#
# Intervencao                   Responsavel Data
# ----------------------------- ------------ ----------
# Criacao                       Juliao Cesar 06/08/2002
#
HOME=/kc6ora00

. $HOME/.profile

export ORACLE_SID=sbpcsprd

ORACLE_HOME=/sblpcsora/sblora100/app/oracle/product/8.1.7
export ORACLE_HOME

cd $HOME/dbascripts

sqlplus -s << !EOF > /crmprddb01/oracle/dbascripts/cria_usr_sieb_bcv.lst 
system/`psinst $ORACLE_SID`
set echo on;

create user siebel_bcv
identified by siebel
default tablespace tbs_s_data
temporary tablespace temp3;

grant sse_role_ro to siebel_bcv;
exit
!EOF
saida=`grep "ORA-" /crmprddb01/oracle/dbascripts/cria_usr_sieb_bcv.lst | wc -l`
exit $saida
