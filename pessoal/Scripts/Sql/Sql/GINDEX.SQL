undef tab
undef owner
accept sowner char prompt 'Entre com a Dono..: '
accept stab   char prompt 'Entre com a Tabela: '

create table indice (seq number, comando varchar2(200))
/

declare
   wnext    number(10);
   wseq     number(10)   := 0;
   wcont    number(10)   := 0;
   wtab     varchar2(35) := upper('&stab');
   wowner   varchar2(35) := upper('&sowner');
   wcomando varchar2(200);

   cursor c1 (cowner varchar2, ctab varchar2) is
      select i.owner,
             i.table_name,
             i.index_name,
             i.tablespace_name,
             i.next_extent,
             i.max_extents,
             i.pct_increase,
             i.uniqueness,
             s.bytes              
     from sys.dba_indexes i,
          sys.dba_segments s
     where i.index_name = s.segment_name
       and i.owner = s.owner
       and i.owner = cowner 
       and i.table_name = ctab
     order by i.index_name;

   cursor c2 (cindice varchar2) is
      select column_name 
      from   sys.dba_ind_columns
      where  index_name = cindice
      order by column_position, column_name;

begin
   --
   wcomando := 'spool '||wtab||'.erro';
   wseq := wseq + 1;
   insert into indice values (wseq, wcomando); 
   for c1rec in c1(wowner, wtab) loop
     --
     wcomando := 'prompt Recriando indice: '||c1rec.owner||'.'||c1rec.index_name;
     wseq := wseq + 1;
     insert into indice values (wseq, wcomando);
     -- 
     wcomando := 'drop index '||c1rec.owner||'.'||c1rec.index_name||';';
     wseq := wseq + 1;
     insert into indice values (wseq, wcomando);
     --
     if c1rec.uniqueness = 'UNIQUE' then
        wcomando := 'create unique index '||c1rec.owner||'.'||c1rec.index_name;
     else
        wcomando := 'create index '||c1rec.owner||'.'||c1rec.index_name;
     end if;
     wseq := wseq + 1;
     insert into indice values (wseq, wcomando);
     --
     wcomando := 'on '||c1rec.owner||'.'||c1rec.table_name;
     wseq := wseq + 1;
     insert into indice values (wseq, wcomando);
     --
     wcomando := '(';
     wseq  := wseq + 1;
     wcont := 0;
     insert into indice values (wseq, wcomando);
     for c2rec in c2(c1rec.index_name) loop
        if wcont = 0 then
           wcomando := ' '||c2rec.column_name;
        else
           wcomando := ','||c2rec.column_name;
        end if;
        wseq  := wseq + 1;
        wcont := wcont + 1;
        insert into indice values (wseq, wcomando);
     end loop;
     wcomando := ')';
     wseq := wseq + 1;
     insert into indice values (wseq, wcomando);
     --
     wcomando := 'tablespace '||c1rec.tablespace_name;
     wseq := wseq + 1;
     insert into indice values (wseq, wcomando);
     --
     wnext := floor(c1rec.bytes*0.1);
     if wnext < 102400 then
        wnext := c1rec.bytes;
     end if;
     wcomando := 'storage (initial '||c1rec.bytes||' next '||wnext||' pctincrease 0)';
     wseq := wseq + 1;
     insert into indice values (wseq, wcomando);
     -- 
     wcomando := '/';
     wseq := wseq + 1;
     insert into indice values (wseq, wcomando);
     commit;
  end loop;
  --
  wcomando := 'spool off';
  wseq := wseq + 1;
  insert into indice values (wseq, wcomando); 
end;
/   
set head off
set feed off
set pages 1000
spool &stab
select comando
from indice
order by seq
/
spool off
set head on
set feed on
set pages 20
