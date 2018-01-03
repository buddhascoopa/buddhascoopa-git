#
# Shell de manutencao Oracle para Operadores
# Data Atualizacao: 08/12/1998
# Desenvolvido: Carlos Christiano Hennig
#
ARCHDIR=/oraarch4
resp=9
fonte_negrito=`tput smso`
fonte_normal=`tput rmso`
rm $LOGARQ 2>/dev/null >/dev/null
while true $resp != 9
do
   clear
   echo "${fonte_negrito}Menu Principal${fonte_normal}"
   echo \\n
   echo "1 - Parar a instancia $ORACLE_SID"
   echo "2 - Ativar a instancia $ORACLE_SID"
   echo "3 - Iniciar Backup do Banco de Dados"
   echo "4 - Exportacao Antes do Faturamento"
   echo "5 - Impressao do Demonstrativo de Faturas"
   echo "6 - Backup LOGS para fita"
   echo "7 - Excluir LOGS"
   echo "9 - Sair do Menu"
   echo \\n
   read resp

   case $resp in
9 ) clear 
    break ;;
1 ) echo "Tirando a instancia $ORACLE_SID...."
    svrmgrl <<EOF
connect internal
shutdown immediate
exit
EOF
    echo "Tecle <ENTER> para continuar...."
    read  ;;
2 ) echo "Ativando a instancia $ORACLE_SID...." 
    svrmgrl <<EOF
connect internal
startup parallel
exit
EOF
    echo "Tecle <ENTER> para continuar...."
    read  ;;
3 ) echo "Iniciando Backup OFFLINE...."
    echo "${fonte_negrito}CERTIFIQUE-SE QUE OS BANCOS DE ALPHA1 E ALPHA2 ESTAO DESATIVADOS${fonte_normal}"
    echo "Tecle <ENTER> para iniciar o BACKUP OFFLINE...."
    read
    ickp=1
    for cloop in `cat hosts.txt`
    do
       no_cluster=`echo $cloop|cut -d: -f1`
       string1_cmp=`echo $cloop|cut -d: -f2`
       string2_cmp=`rsh $no_cluster ps -ef|grep $string1_cmp|grep -v grep|tr -s " " ":"|cut -d: -f10`
       if [ -n "$string2_cmp" ]
       then
          echo "Banco de Dados ATIVO no ALPHA $no_cluster"
          echo "Retire o OUTRO Banco de Dados e execute novamente a opcao"
          echo "Tecle <ENTER> para continuar...."
          read
          ickp=0
          break
       fi
    done
    if [ $ickp -eq 1 ]
    then
       for pgm in `cat /usr/users/operacao/pgm.txt`
       do
          numfita=`expr substr $pgm 4 10`
          echo "Entre com a $numfita e tecle <ENTER>...."
          read
          echo "Realizando backup para a $numfita...."
          cd backup/offline
          ./$pgm 
          cd
          clear
       done
       cd
    fi
    ;; 
4 ) echo "Tecle <ENTER> para Exportar Dados Antes do Faturamento..." 
    read
    echo "Iniciando Exportacao de Dados Antes do Faturamento..."
    exp parfile=expfat.sql
    echo "Tecle <ENTER> para Continuar..."
    read
    ;;
5 ) vrel=''
    vimp=''
    clear
    echo "Entre com o nome do Relatorio Gerado..."
    read vrel
    echo "Entre com o nome da Impressora..."      
    read vimp
    vrel=`echo $vrel|tr '[a-z]' '[A-Z]'`
    vimp=`echo $vimp|tr '[a-z]' '[A-Z]'`
    if [ -f /oracle/temp/$vrel ]
    then
       lpr -P$vimp -n /oracle/temp/$vrel
       echo "Relatorio enviado para impressora $vimp. Tecle <ENTER> para Continuar..."
       read
    else
       echo "Relatorio INEXISTENTE. Tecle <ENTER> para Continuar..."
       read
    fi
    ;;
6 ) echo "Coloque a Fita do Backup dos LOGS e Tecle <ENTER>..."
    read
    sqlplus -s system/man_alphas @arch.sql
    ls $ARCHDIR/*.arc >/tmp/listaarch.txt
    echo "Aguarde..."
    for arch in `cat /tmp/listaarch.txt`
    do
#       tar -cvf /dev/nrmt0h $arch
       ls $arch 
    done
    echo "Backup dos LOGS Terminado. Tecle <ENTER> para Continuar..."
    read
    ;;
7 ) echo "Confirma Exclusao dos LOGS da instancia $ORACLE_SID (S/N)"
    read vconf
    vconf=`echo $vconf|tr '[a-z]' '[A-Z]'`
    echo $vconf
    read
    if [ "$vconf" = "S" ]
    then
       if [ -f /tmp/listaarch.txt ]
       then
          for arch in `cat /tmp/listaarch.txt`
          do
#             rm $arch >/dev/null
              ls $arch
          done
          echo "Exclusao dos LOGS Terminada. Tecle <ENTER> para Continuar..."
          read
       else
          echo "Arquivo gerado na OPCAO 6 nao EXISTE. Tecle <ENTER> para Continuar..."
          read
       fi
    fi
    ;;
esac
done
