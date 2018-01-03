select 'alter user '||username||' account unlock;'
from dba_users
where (username like 'ID%' or username like 'CON%' or username like 'OGS%' or username like 'FRAUDE%')
  and username not in ('CONFFIN','CONFFINUSU','CONTROLM','CON10412','CON10663','CON10062','CON11776','CON10661','CON12349','CON7263','ID208','ID67432','FRAUDE27','FRAUDE23','FRAUDE16','FRAUDE11','FRAUDE21')
order by username;

alter user Elensilva account unlock;
alter user Bibezerra account unlock;
alter user Rj5039 account unlock;
alter user RJF016 account unlock;
alter user ID80456 account unlock;
alter user CON11351 account unlock;
alter user PE4550005 account unlock;
alter user PE6266975 account unlock;

