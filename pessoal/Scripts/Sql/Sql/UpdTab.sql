--
-- Programa: UpdDomiRenda
-- Data At.: 11 de Maio de 2000
-- Chamada.: UpdDomiRenda('<Nome arquivo ascii>','<Nome tabela Oracle>','<Nome do campo>')
--
create or replace procedure UpdDomiRenda (NomeArq varchar2, NomeTab varchar2, NomeCampo varchar2) is
   fin1        utl_file.file_type;
   buffer      varchar2(1023);
   Ano         number;
   Reg         number;
   UF          number;
   Metro       number;
   Ctrl        number;
   Serie       number;
   Renda       number;
   RendaTmp    varchar2(9);
   Cl          number;
   Cont        number := 0;
   SqlId       integer;
   Ret         number;
   NumLinha    number := 0;
   HInicio     date := sysdate;
begin
   dbms_output.enable(1000000);
   fin1 := utl_file.fopen('/u140/PNAD80UPD',NomeArq,'r');
   while true loop
      utl_file.get_line(fin1,buffer);
      Ano      := to_number(substr(buffer,1,4));
      Reg      := to_number(substr(buffer,5,1));
      UF       := to_number(substr(buffer,6,2));
      Metro    := to_number(substr(buffer,8,2));
      Ctrl     := to_number(substr(buffer,10,6));
      Serie    := to_number(substr(buffer,16,3));
      RendaTmp := substr(buffer,19,9);
      Cl       := to_number(substr(buffer,28,2));
      --
      if RendaTmp = '         ' then
         Renda := null;
      else
         Renda := to_number(RendaTmp);
      end if;
      if Cl = 99 then
         Cl := -1;
      end if;
      --
      SqlId := dbms_sql.open_cursor;
      dbms_sql.parse(SqlId,'UPDATE '||NomeTab||' set '||NomeCampo||'=:u1, codcldomi=:u2 '||
                           'WHERE CODANOPESQ=:w1'||
                           '  AND CODREGEOGR=:w2'||
                           '  AND CODUFCENSO=:w3'||
                           '  AND CODARMETRO=:w4'||
                           '  AND NRCTRL=:w5'||
                           '  AND NRSERIE=:w6',dbms_sql.native);
      dbms_sql.bind_variable(SqlId, 'u1', Renda);
      dbms_sql.bind_variable(SqlId, 'u2', Cl);
      dbms_sql.bind_variable(SqlId, 'w1', Ano);
      dbms_sql.bind_variable(SqlId, 'w2', Reg);
      dbms_sql.bind_variable(SqlId, 'w3', UF);
      dbms_sql.bind_variable(SqlId, 'w4', Metro);
      dbms_sql.bind_variable(SqlId, 'w5', Ctrl);
      dbms_sql.bind_variable(SqlId, 'w6', Serie);
      Ret := dbms_sql.execute(SqlId);
      dbms_sql.close_cursor(SqlId);
      if Ret <> 1 then
         rollback;
         raise_application_error(-20001,'Erro: Atualizacao de mais de uma linha na Linha No.: '||to_char(NumLinha));
      end if;
      --
      NumLinha := NumLinha + 1;
      Cont     := Cont     + 1;         
      if Cont = 5000 then
         commit;
         dbms_output.put_line('Atualizados ate o momento '||NumLinha||' linha(s) em '||trunc(((sysdate-HInicio)*86400),0)||' segundos');
         Cont := 0;
      end if;
   end loop;
   exception
      when no_data_found then
        utl_file.fclose(fin1);
        commit;
        dbms_output.put_line('Total atualizado de '||NumLinha||' linha(s) em '||trunc(((sysdate-HInicio)*86400),0)||' segundos');
      when others then
        utl_file.fclose(fin1);
        rollback;
        raise_application_error(-20002,'Erro GENERICO: Verifique PILHA DE ERROS ABAIXO PARA MAIORES DETALHES-'||to_char(NumLinha),true);
end;
/
