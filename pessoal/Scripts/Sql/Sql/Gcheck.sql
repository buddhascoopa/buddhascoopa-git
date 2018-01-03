undef tab
undef owner
accept sowner char prompt 'Entre com a Dono..: '
accept stab   char prompt 'Entre com a Tabela: '

create table checko (seq number, comando long)
/

declare
   wnext    number(10);
   wseq     number(10)   := 0;
   wcont    number(10)   := 0;
   wtab     varchar2(35) := upper('&stab');
   wowner   varchar2(35) := upper('&sowner');
   wcomando long;
   wrtable  sys.dba_constraints.table_name%type;
   
   cursor c1 (cowner varchar2, ctab varchar2) is
      select c.owner,
             c.table_name,
             c.constraint_name,
             c.constraint_type,
             c.search_condition
      from sys.dba_constraints c
      where c.owner = cowner 
        and c.table_name = ctab
        and c.constraint_type in ('C')
      order by c.constraint_type, c.constraint_name;

begin
   --
   wcomando := 'spool '||wowner||'.erro';
   wseq := wseq + 1;
   insert into checko values (wseq, wcomando); 
   for c1rec in c1(wowner, wtab) loop
     --
     wcomando := 'prompt Recriando constraint: '||c1rec.constraint_name||' em '||c1rec.owner||'.'||c1rec.table_name;
     wseq := wseq + 1;
     insert into checko values (wseq, wcomando);
     -- 
     wcomando := 'alter table '||c1rec.owner||'.'||c1rec.table_name;
     wseq := wseq + 1;
     insert into checko values (wseq, wcomando);
     -- 
     if substr(c1rec.constraint_name,1,5) = 'SYS_C' then
        wcomando := '   add ';
        wseq := wseq + 1;
        insert into checko values (wseq, wcomando);
     else
        wcomando := '   add constraint '||c1rec.constraint_name;
        wseq  := wseq + 1;
        insert into checko values (wseq, wcomando);
     end if; 
     --       
     wcomando := '   check';
     wseq := wseq + 1;
     insert into checko values (wseq, wcomando);
     --
     wcomando := '   (';
     wseq  := wseq + 1;
     insert into checko values (wseq, wcomando);
     --
     wcomando := c1rec.search_condition;
     wseq  := wseq + 1;
     insert into checko values (wseq, wcomando);
     --
     wcomando := '   )';
     wseq := wseq + 1;
     insert into checko values (wseq, wcomando);
     --
     wcomando := '/';
     wseq := wseq + 1;
     insert into checko values (wseq, wcomando);
     --
     commit;
  end loop;
  --
  wcomando := 'spool off';
  wseq := wseq + 1;
  insert into checko values (wseq, wcomando); 
end;
/   
set long 200000
set head off
set feed off
set pages 0
spool &sowner
select comando
from checko
order by seq
/
spool off
set head on
set feed on
set pages 20
