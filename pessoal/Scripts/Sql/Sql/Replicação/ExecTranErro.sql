rem
rem Procedure para executar transacoes pendentes com erro
rem
set serveroutput on
declare 
   cursor c1 is
      select de.deferred_tran_id,
             de.destination
      from sys.deferror de;
begin
   for c1_rec in c1 loop
      dbms_output.put_line('Executando transacao com Erro: '||c1_rec.deferred_tran_id);
      dbms_defer_sys.execute_error_as_user(
         deferred_tran_id => c1_rec.deferred_tran_id,
         destination      => c1_rec.destination);
   end loop;
end;
/
set serveroutput off   