-- Utilizar cd $udump para localizar o arquivo gerado!
-- Rodar TKPROF para modificar o formato para leitura.
declare
  cursor sessao is
    select sid,serial#
    from v$session 
  where username in ('SADMIN');
  w_sid number;
  w_serial number;
begin
  open sessao;
  loop
    fetch sessao into w_sid, w_serial;
    exit when sessao%notfound;
    begin
      sys.dbms_system.set_sql_trace_in_session(w_sid,w_serial,TRUE);
    end;
  end loop;
  close sessao;
end;