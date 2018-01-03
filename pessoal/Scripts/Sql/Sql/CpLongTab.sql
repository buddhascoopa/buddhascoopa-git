declare
   cursor c1 is
      select dph.dpr_seq,
             dph.dpr_pro_num,
             dph.num_seg,
             dph.texto
      from jec.jec_doc_processo_html@jec dph;
      wcom number := 0;
begin
   for c1_loop in c1 loop
      /* */
      insert into jec_doc_processo_html
         values (c1_loop.dpr_seq,c1_loop.dpr_pro_num,c1_loop.num_seg,c1_loop.texto);
      /* */
      if wcom > 5000 then
         commit;
         wcom := 0;
      else
         wcom := wcom + 1;
      end if;
   end loop;
end;