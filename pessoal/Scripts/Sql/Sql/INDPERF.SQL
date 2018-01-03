set feed off
drop table db_perform;

create table db_perform (
query 	varchar2(20),
inicio  date,
fim     date,
diferenca number,
linhas  number(10))
tablespace users
storage (initial 500k next 100k pctincrease 0)
;

declare

  ws_inicio date;
  ws_linhas number;

begin
   
   select sysdate 
   into ws_inicio
   from dual;

   select count(*) 
   into ws_linhas
   from sys.dba_tables;

   insert into db_perform values ('QUERY A (DD)',ws_inicio,sysdate,(sysdate - ws_inicio)*86400,ws_linhas);

   select sysdate 
   into ws_inicio
   from dual;

   select count(*) 
   into ws_linhas
   from sys.dba_tables t,
        sys.dba_indexes i
   where t.owner = i.table_owner
     and t.table_name = i.table_name;

   insert into db_perform values ('QUERY B (DD)',ws_inicio,sysdate,(sysdate - ws_inicio)*86400,ws_linhas);

   select count(*)
   into ws_linhas
   from sys.dba_objects;

   insert into db_perform values ('QUERY C (DD)',ws_inicio,sysdate,(sysdate - ws_inicio)*86400,ws_linhas);

   select count(*)
   into ws_linhas
   from inv.mtl_system_items;

   insert into db_perform values ('QUERY D (APP)',ws_inicio,sysdate,(sysdate - ws_inicio)*86400,ws_linhas);

   select count(*)
   into ws_linhas
   from po.po_vendors;

   insert into db_perform values ('QUERY E (APP)',ws_inicio,sysdate,(sysdate - ws_inicio)*86400,ws_linhas);

   commit;
end;
/
col INICIO for a17
col FIM for a17
select query,
       to_char(inicio,'yyyymmdd hh24:mi:ss') INICIO,
       to_char(fim,'yyyymmdd hh24:mi:ss') FIM,
       diferenca TEMPO,
       linhas
from db_perform
order by 1
/ 
exit
