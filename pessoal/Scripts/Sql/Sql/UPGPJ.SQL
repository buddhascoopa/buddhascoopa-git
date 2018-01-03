Prompt Atualizando dg3.mlog$_GERAL_PESSOA_JURID
update dg3.mlog$_GERAL_PESSOA_JURID a
   set a.m_row$$ = ( select rowid from GERAL_PESSOA_JURID b
                     where b.COD_GERAL_PESSOA_JURID =
                           a.COD_GERAL_PESSOA_JURID )
/
commit
/
exit
