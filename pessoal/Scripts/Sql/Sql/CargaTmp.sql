declare
   cursor c1 is
      select modo.codigo,
             modo.tido_codigo,
             modo.doed_codigo,
             modo.descricao,
             modo.idc_etiqueta,
             modo.idc_relatorio,
             modo.juiz_cadastro,
             modo.orga_codigo,
             modo.desm_cadastro,
             modo.texto_etiqueta,
             modo.destino,
             modo.texto_simples,
             modo.vara_codigo
      from ipr_comum.modl_doc modo,
           ipr_comum.tipo_doc tido
      where modo.tido_codigo = tido.codigo
        and tido.tido_type = 'TID2';
   /* */
   w_edtr_codigo       ipr_comum.docm_edtr.codigo%type;
   w_edtr_texto        ipr_comum.docm_edtr.texto%type;
   w_edtr_idc_valido   ipr_comum.docm_edtr.idc_valido%type;
   w_edtr_dt_inclusao  ipr_comum.docm_edtr.dt_inclusao%type;
   w_edtr_id_rec_falha ipr_comum.docm_edtr.id_rec_falha%type;
   /* */
   w_html_segmento     ipr_comum.docm_html.segmento%type;
   w_html_doed_codigo  ipr_comum.docm_html.doed_codigo%type;
   w_html_texto        ipr_comum.docm_html.texto%type;
   /* */
begin
   for c1_loop in c1 loop
     begin
      select ipredtr.codigo,
             ipredtr.texto,
             ipredtr.idc_valido,
             ipredtr.dt_inclusao,
             ipredtr.id_rec_falha
      into   w_edtr_codigo,
             w_edtr_texto,
             w_edtr_idc_valido,
             w_edtr_dt_inclusao,
             w_edtr_id_rec_falha
      from ipr_comum.docm_edtr ipredtr
      where ipredtr.codigo = c1_loop.doed_codigo;
      insert into docm_edtr_tmp
         values (w_edtr_codigo,w_edtr_texto,w_edtr_idc_valido,w_edtr_dt_inclusao,w_edtr_id_rec_falha);
      /* */
      select iprhtml.segmento,
             iprhtml.doed_codigo,
             iprhtml.texto
      into   w_html_segmento,
             w_html_doed_codigo,
             w_html_texto
      from ipr_comum.docm_html iprhtml
      where iprhtml.doed_codigo = c1_loop.doed_codigo;
      insert into docm_html_tmp
         values (w_html_segmento,w_html_doed_codigo,w_html_texto);
      /* */
      insert into modl_doc_tmp
         values (c1_loop.codigo,c1_loop.tido_codigo,c1_loop.doed_codigo,
                 c1_loop.descricao,c1_loop.idc_etiqueta,c1_loop.idc_relatorio,
                 c1_loop.juiz_cadastro,c1_loop.orga_codigo,c1_loop.desm_cadastro,
                 c1_loop.texto_etiqueta,c1_loop.destino,c1_loop.texto_simples,
                 c1_loop.vara_codigo);
    exception
       when NO_DATA_FOUND then
          null; 
    end;
   end loop;
end;
/