undef tab
undef owner
accept sowner char prompt 'Entre com a Dono..: '
accept stab   char prompt 'Entre com a Tabela: '

create table tabela (seq number, comando varchar2(200))
/

declare
   wnext    sys.dba_segments.bytes%type;
   wseq     number(10)   := 0;
   wcont    number(10)   := 0;
   wowner   varchar2(35) := upper('&sowner');
   wtab     varchar2(35) := upper('&stab');
   wcomando varchar2(200);

   cursor c1 (cowner varchar2, ctab varchar2) is
      select t.owner,
             t.table_name,
             t.tablespace_name,
             t.next_extent,
             t.max_extents,
             t.pct_increase,
             t.pct_free,
             t.pct_used,
             s.bytes              
     from sys.dba_tables t,
          sys.dba_segments s
     where t.table_name = s.segment_name
       and t.owner = s.owner
       and t.owner = cowner
       and t.table_name = ctab
     order by t.owner, t.table_name;

   cursor c2 (ctable varchar2, cowner varchar2) is
      select column_name,
             data_type,
             data_length,
             data_precision,
             data_scale,
             nullable
      from   sys.dba_tab_columns
      where  table_name  = ctable
        and  owner = cowner
      order by column_id;

begin
   --
   wcomando := 'spool '||wowner||'.erro';
   wseq := wseq + 1;
   insert into tabela values (wseq, wcomando); 
   for c1rec in c1(wowner, wtab) loop
     --
     wcomando := 'prompt Recriando tabela: '||c1rec.owner||'.'||c1rec.table_name;
     wseq := wseq + 1;
     insert into tabela values (wseq, wcomando);
     -- 
     wcomando := 'create table '||c1rec.owner||'.'||c1rec.table_name;
     wseq := wseq + 1;
     insert into tabela values (wseq, wcomando);
     --
     wcomando := '   (';
     wseq  := wseq + 1;
     wcont := 0;
     insert into tabela values (wseq, wcomando);
     for c2rec in c2(c1rec.table_name,wowner) loop
        if wcont = 0 then
           wcomando := '    '||c2rec.column_name;
        else
           wcomando := '   ,'||c2rec.column_name;
        end if;
        wcomando := wcomando||' '||c2rec.data_type;
        if c2rec.data_type = 'NUMBER' then
           if c2rec.data_precision is not null then
              wcomando := wcomando||'('||c2rec.data_precision||','||c2rec.data_scale||')';
           end if;
        elsif c2rec.data_type = 'VARCHAR2' or c2rec.data_type = 'CHAR' or c2rec.data_type = 'RAW' then
           wcomando := wcomando||'('||c2rec.data_length||')';      
        end if;
        if c2rec.nullable = 'N' then
           wcomando := wcomando||' NOT NULL';
        end if;
        wseq  := wseq + 1;
        wcont := wcont + 1;
        insert into tabela values (wseq, wcomando);    
     end loop;
     wcomando := '   )';
     wseq := wseq + 1;
     insert into tabela values (wseq, wcomando);
     --
     wcomando := '   pctfree '||c1rec.pct_free;
     wseq := wseq + 1;
     insert into tabela values (wseq, wcomando);
     --
     wcomando := '   pctused '||c1rec.pct_used;
     wseq := wseq + 1;
     insert into tabela values (wseq, wcomando);
     --
     wcomando := '   tablespace '||c1rec.tablespace_name;
     wseq := wseq + 1;
     insert into tabela values (wseq, wcomando);
     --
     wnext := floor(c1rec.bytes*0.1);
     if wnext < 10240 then
        wnext := c1rec.bytes;
     end if;
     wcomando := '   storage (initial '||c1rec.bytes||' next '||wnext||' pctincrease 0)';
     wseq := wseq + 1;
     insert into tabela values (wseq, wcomando);
     -- 
     wcomando := '/';
     wseq := wseq + 1;
     insert into tabela values (wseq, wcomando);
     commit;
  end loop;
  --
  wcomando := 'spool off';
  wseq := wseq + 1;
  insert into tabela values (wseq, wcomando); 
end;
/   
set head off
set feed off
set pages 0
spool &sowner
select comando
from tabela
order by seq
/
spool off
set head on
set feed on
set pages 20
