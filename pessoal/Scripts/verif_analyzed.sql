select 'Tabelas sem ANALYZE ou Antigo de Schemas jah Analyzed.' from dual;

select distinct owner
from dba_tables
where last_analyzed is null
  and last_analyzed<sysdate-7
  and owner in (select distinct owner
                  from dba_tables
                 where last_analyzed is not null
               );
