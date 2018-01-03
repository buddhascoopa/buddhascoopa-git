# Sugestoes de uso:
#   1. Existe dois lugares no script onde SQLPLUS deve ser usado
#      porque SQLDBA nao permite certos parametros formatodos.
#      Isto implica que o usuario e a senha estarao prssentes no script.
#      E bom criar um usuario so com privilegio de conexao eselect on
#      SYS.DBA_DATA_FILES.
#
# Descricao das variaveis de ambiente:
#   ORACLE_HOME  - Oracle home
#   ORACLE_SID   - Oracle SID
#   ARCFILE_NAME - Diretorio e nome dos archived logs
#   HOTBACK_HOME - Diretorio deste programa e dos logs de sua execucao
#   HOTBACK_DEST - Destino do backup 
#   CTLFILE_NAME - Nome do control file temporario
#   LOGFILE_NAME - Nome do log file
#   COPY_COMMAND - Comando usado para escrever para o device de backup(ie: cp, cpio)
#
#
# Configura variaveis ORACLE de ambiente
ORACLE_HOME=/oracle/app/oracle/product/7.3.2
ORACLE_SID=i2rj
ARCFILE_NAME=/oraarch5/*.arc

#
# Configura variaveis do HOT BACKUP
HOTBACK_HOME=/oraarch5
HOTBACK_DEST=/dev/nrmt0h
LOGFILE_NAME=$HOTBACK_HOME/hotback.log
COPY_COMMAND="dd if="$DATAFILE" of=$HOTBACK_DEST bs=1024000 conv=sync"
integer NUM_FITA=1
integer ACUM_BYTES_FITA=0
integer CAPAC_FITA=4292967296

#
# Verifica mensagens de erro ORACLE
check_error() {
        if grep "ORA-" < $1 > /dev/null; then
                echo "Error processing tablespace "$TABLESPACE""
                echo $2 ".....Exiting"
                echo "Please check file: "$1" for more information"
                exit 1
        fi
}

#
# Switch logfile e forca um checkpoint, e backup o control file
backup_control() {
	CTLFILE_NAME=$HOTBACK_HOME/CF_$ORACLE_SID`date +"%Y%m%d%H%M%S"`.arc
        echo "Beginning Backup of CONTROL FILE....."
        echo "connect internal" > CTLback
        echo "alter system switch logfile;" >> CTLback
        echo "alter database backup controlfile to '"$CTLFILE_NAME"' reuse;" \
                >> CTLback
        echo "exit" >> CTLback
        svrmgrl < CTLback | tee -a $LOGFILE_NAME > /dev/null
        check_error $LOGFILE_NAME "Could not backup CONTROL FILE"
#        $COPY_COMMAND $CTLFILE_NAME $HOTBACK_DEST >> $LOGFILE_NAME
        rm -f CTLback
        echo "Bacup of CONTROL FILE Successful....."

}

#
# Acha datafiles para a tablespace corrente e coloca em um arquivo
get_tablespaces() {
        echo "Retrieving list of TABLESPACES....."
        echo "system/man_alphas">  GetTspaces.sql
        echo "set echo off"     >> GetTspaces.sql
        echo "set pagesize 0"   >> GetTspaces.sql
        echo "set heading off"  >> GetTspaces.sql
        echo "set feedback off" >> GetTspaces.sql
        echo "spool TSlist"     >> GetTspaces.sql
        echo "select distinct tablespace_name"  >> GetTspaces.sql
        echo "from sys.dba_data_files;"         >> GetTspaces.sql
        echo "spool off"        >> GetTspaces.sql
        echo "exit"             >> GetTspaces.sql
        sqlplus \@GetTspaces | tee -a $LOGFILE_NAME > /dev/null
        check_error $LOGFILE_NAME "Could not get list of tablespaces"
        rm -f GetTspaces.sql
}

#
# Acha datafiles para a tablespace corrente e coloca em um arquivo
get_files() {
        echo "system/man_alphas">  GetFiles.sql
        echo "set echo off"     >> GetFiles.sql
        echo "set pagesize 0"   >> GetFiles.sql
        echo "set heading off"  >> GetFiles.sql
        echo "set feedback off" >> GetFiles.sql
        echo "spool TSfiles"    >> GetFiles.sql
        echo "select file_name||':'||bytes from sys.dba_data_files" >> GetFiles.sql
        echo "where tablespace_name = '"$TABLESPACE"';" >> GetFiles.sql
        echo "spool off"        >> GetFiles.sql
        echo "exit"             >> GetFiles.sql
        sqlplus \@GetFiles | tee -a $LOGFILE_NAME > /dev/null
        check_error $LOGFILE_NAME "Could not get datafiles for tablespace"
        rm -f GetFiles.sql
}

#
# Coloca a tablespace no modo de backup
begin_backup() {
        echo "Beginning Backup of tablespace "$TABLESPACE"....."
        echo "connect internal" > TSbegin
        echo "alter tablespace "$TABLESPACE" begin backup;" >> TSbegin
        echo "exit" >> TSbegin
        svrmgrl < TSbegin | tee -a $LOGFILE_NAME > /dev/null
        check_error $LOGFILE_NAME "Could not place tablespace in backup mode"
        rm -f TSbegin
}

#
# Backup os datafiles da tablespace corrente
backup_datafiles() {
        # Get a list of datafiles for this tablespace
        get_files

        # Make a backup of all datafiles
        for LINHA in `cat TSfiles.lst`
        do
           DATAFILE=`echo $LINHA|cut -d: -f1`
           integer BYTES=`echo $LINHA|cut -d: -f2`
           ACUM_BYTES_FITA=$(($ACUM_BYTES_FITA+$BYTES))
           if (( $ACUM_BYTES_FITA > $CAPAC_FITA ))
           then
              NUM_FITA=$(($NUM_FITA+1))
              echo "Entre com a FITA $NUM_FITA e Tecle <ENTER> para Continuar"
              read
              ACUM_BYTES_FITA=BYTES
           fi
           echo "dd if=$DATAFILE of=/dev/nrmt0h bs=1024000 conv=sync >> $LOGFILE_NAME"
        done
        rm -f TSfiles.lst
}

#
# Tira a tablespace do modo backup
end_backup() {
        echo "connect internal" > TSend
        echo "alter tablespace "$TABLESPACE" end backup;" >> TSend
        echo "exit" >> TSend
        svrmgrl < TSend | tee -a $LOGFILE_NAME > /dev/null
        check_error $LOGFILE_NAME "Could not take tablespace out of backup mode"
        echo "Finished Backup of tablespace  "$TABLESPACE"....."
        rm -f TSend
}

##########################################
#                                        #
#            Main Program                #
#                                        #
##########################################
# Remove antigos log files
rm -f $LOGFILE_NAME > /dev/null

# Backup o CONTROL FILE
backup_control

# Lista as TABLESPACES
get_tablespaces

# Backup as TABLESPACES uma a uma
echo "Entre com a FITA $NUM_FITA e Tecle <ENTER> para Continuar"
read
for TABLESPACE in `cat TSlist.lst`
do
  begin_backup
  backup_datafiles
  end_backup
done
rm -f TSlist.lst

# Backup o CONTROL FILE
backup_control

# Backup os archived redo logs
echo "Entre com a FITA $NUM_FITA e Tecle <ENTER> para Continuar"
read
echo "Beginning Backup of the ARCHIVED REDO LOG files....."
#$COPY_COMMAND $ARCFILE_NAME $HOTBACK_DEST >> $LOGFILE_NAME
