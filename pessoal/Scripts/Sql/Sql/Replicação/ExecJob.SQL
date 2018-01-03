set serveroutput on
set feed off
declare
   cursor c1 is
      select job,what
      from user_jobs
      where what like 'dbms_refresh.refresh%'
         or what like 'dbms_snapshot.refresh%';
begin
   for cjob in c1 loop
      dbms_output.put_line('Executando Job No.: '||cjob.job||'-'||cjob.what);
      dbms_job.run(cjob.job);
   end loop;
end;
/
set serveroutput off
set feed on