delete from mlog$_pessoa
where m_row$$ in (select m_row$$
from mlog$_pessoa
minus
select rowidtochar(rowid)
from pessoa)
/
