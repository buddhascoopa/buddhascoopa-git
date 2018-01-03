#!/bin/ksh
#
# bkp_ctl_all.sh - Executa copia do ControlFile das instâncias do ORATAB
# 
# Intervenção                   Responsável Data       Descricao
# ----------------------------- ----------- ---------- ---------------------------------------------------------------------
# Adaptação                     Enô Klinger 09/05/2002
# Alteração                     Erick CB    26/06/2002
# Alteração                     Erick CB    15/07/2002 Alteracao do script dinamico copia_ctl.sh
#

erro ()
 {
    if [ -f /tmp/backup_controlfile.ctl ] ; then
       rm /tmp/backup_controlfile.ctl
    fi
    echo $1 > /tmp/backup_controlfile.ctl
    exit $1
}

. $HOME/envora

cd $BKP_DIR

# Gera Script Dinamico para a Copia dos ControlFiles
SCR_COPY_CTL=${BKP_DIR}/copia_ctl.sh
export SCR_COPY_CTL
echo "BKPHOST=\$1"         > $SCR_COPY_CTL
echo "export BKPHOST"     >> $SCR_COPY_CTL
echo "HOSTNAME=\$2"       >> $SCR_COPY_CTL
echo "export HOSTNAME"    >> $SCR_COPY_CTL

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
erro 0
