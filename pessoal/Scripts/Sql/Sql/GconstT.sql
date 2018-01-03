undef tab
undef owner
accept sowner char prompt 'Entre com a Dono..: '
accept stab   char prompt 'Entre com a Tabela: '

create table const (seq number, comando varchar2(200))
/

declare
   wnext    number(10);
   wseq     number(10)   := 0;
   wcont    number(10)   := 0;
   wtab     varchar2(35) := upper('&stab');
   wowner   varchar2(35) := upper('&sowner');
   wcomando varchar2(200);
   wrtable  sys.dba_constraints.table_name%type;
   
   cursor c1 (cowner varchar2, ctab varchar2) is
      select c.owner,
             c.table_name,
             c.constraint_name,
             c.constraint_type,
             c.r_owner,
             c.r_constraint_name
      from sys.dba_constraints c
      where c.owner = cowner 
        and c.table_name = ctab
        and c.constraint_type in ('U','P','R')
        and c.r_constraint_name = '
      order by c.constraint_type, c.constraint_name;

   cursor c2 (cowner varchar2, ctab varchar2, cconst varchar2) is
      select cc.column_name
      from   sys.dba_cons_columns cc
      where cc.owner = cowner
        and cc.table_name = ctab
        and cc.constraint_name = cconst
      order by cc.position;

  cursor c3 (cowner varchar2, cindice varchar2) is
      select column_name
      from   sys.dba_ind_columns
      where  index_name  = cindice
        and  index_owner = cowner
      order by column_position;

begin
   --
   wcomando := 'spool '||wtab||'.erro';
   wseq := wseq + 1;
   insert into const values (wseq, wcomando); 
   for c1rec in c1(wowner, wtab) loop
     --
     wcomando := 'prompt Recriando constraint: '||c1rec.constraint_name||' em '||c1rec.owner||'.'||c1rec.table_name;
     wseq := wseq + 1;
     insert into const values (wseq, wcomando);
     -- 
     wcomando := 'alter table '||c1rec.owner||'.'||c1rec.table_name;
     wseq := wseq + 1;
     insert into const values (wseq, wcomando);
     -- 
     wcomando := '   add constraint '||c1rec.constraint_name;
     wseq := wseq + 1;
     insert into const values (wseq, wcomando);
     -- 
     if c1rec.constraint_type = 'P' then
        wcomando := '   primary key';
     elsif c1rec.constraint_type = 'U' then
        wcomando := '   unique';
     elsif c1rec.constraint_type = 'R' then
        wcomando := '   foreign key';
     end if;
     wseq := wseq + 1;
     insert into const values (wseq, wcomando);
     --
     wcomando := '   (';
     wseq  := wseq + 1;
     wcont := 0;
     insert into const values (wseq, wcomando);
     --
     for c2rec in c2(wowner, wtab, c1rec.constraint_name) loop
        if wcont = 0 then
           wcomando := '    '||c2rec.column_name;
        else
           wcomando := '   ,'||c2rec.column_name;
        end if;
        wseq  := wseq + 1;
        wcont := wcont + 1;
        insert into const values (wseq, wcomando);
     end loop;
     wcomando := '   )';
     wseq := wseq + 1;
     insert into const values (wseq, wcomando);
     --
     if c1rec.constraint_type = 'R' then
        select table_name
        into wrtable
        from sys.dba_constraints 
        where owner = c1rec.r_owner
          and constraint_name = c1rec.r_constraint_name;
        wcomando := '   references '||c1rec.r_owner||'.'||wrtable;
        wseq := wseq + 1;
        insert into const values (wseq, wcomando);
        --
        wcomando := '   (';
        wseq  := wseq + 1;
        wcont := 0;
        insert into const values (wseq, wcomando);
        for c3rec in c3(c1rec.r_owner, c1rec.r_constraint_name) loop
           if wcont = 0 then
              wcomando := '    '||c3rec.column_name;
           else
              wcomando := '   ,'||c3rec.column_name;
           end if;
           wseq  := wseq + 1;
           wcont := wcont + 1;
           insert into const values (wseq, wcomando);
        end loop;
        wcomando := '   )';
        wseq := wseq + 1;
        insert into const values (wseq, wcomando);
        --
     end if;
     --
     wcomando := '/';
     wseq := wseq + 1;
     insert into const values (wseq, wcomando);
     --
     commit;
  end loop;
  --
  wcomando := 'spool off';
  wseq := wseq + 1;
  insert into const values (wseq, wcomando); 
end;
/   
set head off
set feed off
set pages 0
spool &stab
select rtrim(ltrim(comando))
from const
order by seq
/
spool off
set head on
set feed on
set pages 20
