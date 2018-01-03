Prompt Atualizando dg3.mlog$_PESSOA
update dg3.mlog$_PESSOA a
   set a.m_row$$ = ( select rowid from PESSOA b
                     where b.COD_PESSOA =
                           a.COD_PESSOA )
/
commit
/
exit
