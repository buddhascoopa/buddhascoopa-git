set serveroutput on
create procedure AnalSchema is begin
declare
   cursor c1 is
      select distinct owner
      from sys.dba_tables
      where owner not in ('SYS','SYSTEM');
begin
   for schema in c1 loop
      dbms_output.put_line('Analisando Schema: '||schema.owner||' EM '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS'));
      dbms_utility.analyze_schema(schema.owner,'COMPUTE');
   end loop;
end;
end AnalSchema;
/


declare
  wjob number;
begin
   dbms_job.submit(job=>wjob,
                   what=>'AnalSchema();',
                   next_date=>sysdate,
                   interval=>'trunc(sysdate+1)+18/24');
   commit;
end;
