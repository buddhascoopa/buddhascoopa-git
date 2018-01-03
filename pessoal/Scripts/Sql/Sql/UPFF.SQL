Prompt Atualizando dg3.mlog$_FILIAL_FORNEC 
update dg3.mlog$_FILIAL_FORNEC a
   set a.m_row$$ = ( select rowid from FILIAL_FORNEC b
                     where b.COD_FORNEC =
                           a.COD_FORNEC
                     and   b.NUM_SEQ_FILIAL_FORNEC =
                           a.NUM_SEQ_FILIAL_FORNEC )
/
commit
/
exit
