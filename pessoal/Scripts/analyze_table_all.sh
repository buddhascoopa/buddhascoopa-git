#!/bin/ksh
#
# analyze_table_all.sh - Realiza o analyze de tabelas e indices dos bancos Dw e UI
# 
# Intervencao                   Responsável Data
# ----------------------------- ----------- ----------
# Criacao                       Ana Paula   15/04/2002
# Adaptacao para Ctrl-M OI      Ana Paula   15/04/2002
#

. $HOME/.profile

SO=`uname -s`
case $SO in
        SunOS) export ORATAB=/var/opt/oracle/oratab;;
        HP-UX) export ORATAB=/etc/oratab;; 
        AIX)   export ORATAB=/etc/oratab;;
        OSF1)  export ORATAB=/etc/oratab;;
esac
export SAIDA_ALL=0

cd /usr/monitor/scripts

for SID in `grep -v "^#" $ORATAB | grep :Y$ | cut -d : -f 1`
{
 ./analyze_table.sh $SID 
 
 SAIDA_ALL=`expr $SAIDA_ALL + $?`
 export SAIDA_ALL
}
exit $SAIDA_ALL

