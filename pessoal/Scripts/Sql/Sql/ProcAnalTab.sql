set serveroutput on
create or replace procedure AnalTab is begin
declare
   cursor c1 is
      select owner,
             table_name
      from sys.dba_tables
      where owner not in ('SYS','SYSTEM');
begin
   for tabela in c1 loop
      dbms_output.put_line('Analisando Tabela: '||tabela.owner||'.'||tabela.table_name||' EM '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS'));
      dbms_ddl.analyze_object('TABLE',tabela.owner,tabela.table_name,'COMPUTE');
   end loop;
end;
end AnalTab;
/
declare
  wjob number;
begin
   dbms_job.submit(job=>wjob,
                   what=>'AnalTab();',
                   next_date=>sysdate,
                   interval=>'trunc(sysdate+1)+20/24');
   commit;
end;
/