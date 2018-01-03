rem
rem Procedure para executar transacoes pendentes
rem
declare 
   ret binary_integer;
   cursor c1 is
      select dt.deferred_tran_id,
             dtd.dblink
      from sys.deftran dt,
           sys.deftrandest dtd
      where dt.deferred_tran_id = dtd.deferred_tran_id;
   
begin
   for c1_rec in c1 loop
      ret := dbms_defer_sys.push(
                destination   => c1_rec.dblink,
                parallelism   => 0,
                delay_seconds => 0,
                stop_on_error => FALSE);
   end loop;
end;
/
   