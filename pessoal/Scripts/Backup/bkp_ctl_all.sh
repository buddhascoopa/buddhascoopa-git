#!/bin/ksh
#
# bkp_ctl_all.sh - Executa copia do ControlFile das instancias do ORATAB
# 
# Intervencao                   Responsavel Data       Descricao
# ----------------------------- ----------- ---------- ---------------------------------------------------------------------
# Adaptacao                     Eno Klinger 09/05/2002
# Alteracao                     Erick CB    26/06/2002
# Alteracao                     Erick CB    15/07/2002 Alteracao do script dinamico copia_ctl.sh
# Alteracao                     Erick CB    07/11/2002 Alteracao do script dinamico ftp_ctl.sh
#

erro ()
 {
    if [ -f /tmp/backup_controlfile.ctl ] ; then
       rm /tmp/backup_controlfile.ctl
    fi
    echo $1 > /tmp/backup_controlfile.ctl
    exit $1
}

# Variaveis de Ambiente do Oracle
shift $#
. $HOME/envora

cd $BKP_DIR

# Gera Script Dinamico para o FTP dos ControlFiles
SCR_FTP_CTL=${BKP_DIR}/ftp_ctl.sh
export SCR_FTP_CTL
echo "# Parametros"                                                                           > $SCR_FTP_CTL
echo "# HOSTDEST - Hostname ou IP da maquina destino"                                        >> $SCR_FTP_CTL
echo "# HOSTORIG - Hostname da maquina de origem para compor o diretorio na maquina destino" >> $SCR_FTP_CTL
echo " "                                                                                     >> $SCR_FTP_CTL
echo "HOSTDEST=\$1"                                                                          >> $SCR_FTP_CTL
echo "export HOSTDEST"                                                                       >> $SCR_FTP_CTL
echo " "                                                                                     >> $SCR_FTP_CTL
echo "HOSTORIG=\$2"                                                                          >> $SCR_FTP_CTL
echo "export HOSTORIG"                                                                       >> $SCR_FTP_CTL
echo " "                                                                                     >> $SCR_FTP_CTL
echo "ftp \$HOSTDEST << !EOF"                                                                >> $SCR_FTP_CTL
echo "prompt"                                                                                >> $SCR_FTP_CTL

cat $ORATAB | while read LINE
do
    case $LINE in
        \#*)                ;;        #comment-line in oratab
        *)
        if [ "`echo $LINE | awk -F: '{print $3}' -`" = "Y" ] ; then
            ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
            if [ "$ORACLE_SID" = '*' ] ; then
                ORACLE_SID=""
            fi
            export ORACLE_SID
            $BKP_DIR/bkp_ctl.sh $ORACLE_SID
            reterr=$?
            if test ${reterr} -ne 0 ; then
               erro ${reterr}
            fi
        fi
        ;;
    esac
done

echo "bye"  >> $SCR_FTP_CTL
echo "!EOF" >> $SCR_FTP_CTL
chmod 744 $SCR_FTP_CTL

erro 0
