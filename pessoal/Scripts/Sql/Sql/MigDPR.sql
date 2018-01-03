declare
   cursor c1 is
      select dpr_seq,
             dpr_pro_num,
             num_seg,
             texto
      from jec.doc_processo_html
      order by dpr_pro_num,
               dpr_seq,
               num_seg;
   v_cnt number := 0;
   v_err number;
begin
   for c1_loop in c1 loop
   begin
      /* */
      insert into jcivel.doc_processo_html
      values (c1_loop.dpr_seq,
              c1_loop.dpr_pro_num,
              c1_loop.num_seg,
              c1_loop.texto);
      /* */
      v_cnt := v_cnt + 1;
      if v_cnt >= 5000 then
         commit;
         v_cnt := 0;
      end if;
   exception
      /* */
      when others then
         v_err := sqlcode;
         insert into tab_erro 
         values (to_char(v_err)||'-'||to_char(c1_loop.dpr_seq)||'-'||c1_loop.dpr_pro_num||'-'||to_char(c1_loop.num_seg));
         commit;
   end;
   end loop;
   commit;
end;
/