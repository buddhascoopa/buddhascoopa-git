rem
rem
rem
drop table temp
/
create table temp
   (c1 varchar2(2000))
/
declare 
   num number(2)  := 0;
   next  number   := 0;
   t_bytes number := 0;
   t_o      sys.dba_ind_columns.index_owner%type;
   t_tn     sys.dba_ind_columns.table_name%type;
   t_cn     sys.dba_ind_columns.index_name%type;
   t_cnaux  sys.dba_ind_columns.index_name%type;
   t_coln   sys.dba_ind_columns.column_name%type;
   t_tsn    sys.dba_indexes.tablespace_name%type;
   cursor c1 is
      select a.index_name, a.table_name, a.column_name
      from sys.dba_ind_columns a
      where a.index_owner = 'MCL' and
            a.table_owner = 'MCL' 
      order by a.index_name, a.column_position;
begin
   open c1;
   fetch c1 into t_cn, t_tn, t_coln;
   loop
      exit when c1%notfound;
      select bytes 
         into t_bytes
         from sys.dba_segments
         where segment_name = t_cn  and
               owner        = 'MCL' and
               segment_type = 'INDEX';
      select tablespace_name
         into t_tsn
         from sys.dba_indexes
         where index_name  = t_cn  and
               owner       = 'MCL' and
               table_owner = 'MCL';
      t_cnaux  := t_cn;
      next     := round(t_bytes * 0.2);
      insert into temp values ('drop index mcl.'||t_cn||';');
      insert into temp values ('create index mcl.'||t_cn);
      insert into temp values ('on mcl.'||t_tn||'('||t_coln);
      loop
         fetch c1 into t_cn, t_tn, t_coln;
         if c1%notfound or t_cn != t_cnaux then
            insert into temp values (')');
            insert into temp values ('storage (initial '||t_bytes);
            insert into temp values ('next '||next||' pctincrease 0)');
            insert into temp values ('tablespace '||t_tsn);
            insert into temp values ('/');
            exit;
         end if;
         insert into temp values (','||t_coln);
      end loop;
   end loop;
   close c1;
   commit;
end;
/
