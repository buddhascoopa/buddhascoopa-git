Prompt Atualizando dg3.mlog$_PRODUT_GENERC
update dg3.mlog$_PRODUT_GENERC a
   set a.m_row$$ = ( select rowid from PRODUT_GENERC b
                     where b.COD_PRODUT_GENERC =
                           a.COD_PRODUT_GENERC )
/
commit
/
exit
