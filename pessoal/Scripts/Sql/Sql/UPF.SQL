Prompt Atualizando dg3.mlog$_FORNEC
update dg3.mlog$_FORNEC a
   set a.m_row$$ = ( select rowid from FORNEC b
                     where b.COD_FORNEC =
                           a.COD_FORNEC )
/
commit
/
exit
