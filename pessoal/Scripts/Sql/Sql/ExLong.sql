declare
   cursor c1 is
      select r1 
      from system.jec_doc_processo_html_rowid;
   v_dpr_seq     jec.doc_processo_html.dpr_seq%type;
   v_dpr_pro_num jec.doc_processo_html.dpr_pro_num%type;
   v_num_seg     jec.doc_processo_html.num_seg%type;
   v_texto       jec.doc_processo_html.texto%type;
begin
   for c1_loop in c1 loop
      if c1_loop.r1 <> 'AAAAeVAAFAAA///AAA' then
         select dph.dpr_seq,
                dph.dpr_pro_num,
                dph.num_seg,
                dph.texto
         into v_dpr_seq,
              v_dpr_pro_num,
              v_num_seg,
              v_texto
         from jec.doc_processo_html dph
         where rowid = c1_loop.r1;
         /* */
         insert into system.jec_doc_processo_html_temp
         values (v_dpr_seq,v_dpr_pro_num,v_num_seg,v_texto);
         commit;
      end if;
   end loop;
end;