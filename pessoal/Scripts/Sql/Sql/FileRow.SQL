set serveroutput on
declare
   NomeArq varchar(50);
   wfile number;
   cursor c1 is
      select rowid, ano
      from ibge.teste;
begin
   for crowid in c1 loop
      wfile := dbms_rowid.rowid_relative_fno(crowid.rowid);
      /* */
      select Name 
      into NomeArq
      from v$datafile
      where file# = wfile;
      /* */
      dbms_output.put_line('Linha: '||crowid.ano||' Datafile : '||wfile||'-'||NomeArq);
   end loop;
end;            
/