rem
rem
rem
drop table temp
/
create table temp
   (c1 varchar2(2000))
/
declare 
   num number(2) := 0;
   t_o     dba_cons_columns.owner%type;
   t_tn    dba_cons_columns.table_name%type;
   t_cn    dba_cons_columns.constraint_name%type;
   t_coln  dba_cons_columns.column_name%type;
   t_cnaux dba_cons_columns.constraint_name%type;
   cursor c1 is
      select a.owner, a.constraint_name, a.table_name, a.column_name 
      from dba_cons_columns a, dba_constraints b
      where  b.constraint_name = a.constraint_name and
             b.constraint_type = 'R' and
             a.owner = 'CI_ADM' 
      order by a.owner, a.constraint_name, a.table_name, a.position;
begin
   open c1;
   fetch c1 into t_o, t_cn, t_tn, t_coln;
   loop
      exit when c1%notfound;
      t_cnaux := t_cn;
      insert into temp values ('create index '||t_o||'.'||t_cn||'_test');
      insert into temp values ('on '||t_o||'.'||t_tn||'('||t_coln);
      loop
         fetch c1 into t_o, t_cn, t_tn, t_coln;
         if c1%notfound or t_cn != t_cnaux then
            insert into temp values (')');
            if t_o = 'CI_ADM' then
               insert into temp values ('tablespace cib101ti;');
            else
               insert into temp values ('tablespace chb101ti;');
            end if;
            exit;
         end if;
         insert into temp values (','||t_coln);
      end loop;
   end loop;
   close c1;
   commit;
end;
/