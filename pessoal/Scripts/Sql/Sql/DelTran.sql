rem
rem Procedure para eliminar transacoes pendentes
rem
declare 
   cursor c1 is
      select dt.deferred_tran_id,
             dtd.dblink
      from sys.deftran dt,
           sys.deftrandest dtd
      where dt.deferred_tran_id = dtd.deferred_tran_id;
   cursor c2 is
      select de.deferred_tran_id,
             de.destination
      from sys.deferror de;
begin
   for c1_rec in c1 loop
      dbms_defer_sys.delete_tran(
         deferred_tran_id => c1_rec.deferred_tran_id,
         destination      => c1_rec.dblink);
   end loop;
   for c2_rec in c2 loop
      dbms_defer_sys.delete_error(
         deferred_tran_id => c2_rec.deferred_tran_id,
         destination      => c2_rec.destination);
   end loop;
end;
/
   