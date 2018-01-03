DELETE PLAN_TABLE WHERE STATEMENT_ID='ABC4';
COMMIT;
EXPLAIN PLAN SET STATEMENT_ID='ABC4' INTO PLAN_TABLE FOR
SELECT /*+ PUSH_SUBQ */ distinct m.flc_id
FROM  int_faleconoscomsg m,
      int_usuarios u 
WHERE  not exists ( select mu2.excluido
                    from int_faleconoscomsgusu mu2
                    where mu2.flc_id = m.flc_id
                      and mu2.idusuario = 111)
  AND  ((m.tipo_destinatario = 'TD' AND exists (select u.idusuario 
                                                from int_usuarios u 
                                                where u.idusuario = 111
                                                  and u.datacadastro < m.data_envio))
   OR  (m.tipo_destinatario = 'PP' AND	exists (select	pu.idusuario
                                                from int_faleconoscopapeisusu pu
                                                where pu.flp_id = m.id_destinatario
                                                  and pu.data_inclusao < m.data_envio 
                                                  and pu.idusuario = 111) )
   OR (m.tipo_destinatario = 'PF' AND exists (select pfu.idusuario
                                              from int_perfisusuarios pfu
                                              where pfu.idperfil = m.id_destinatario
                                         	and pfu.data_inclusao < m.data_envio 
                                                and pfu.idusuario = 111))
   OR (m.tipo_destinatario = 'US' AND m.id_destinatario = 111) 
   OR (m.flp_id_copia is not null AND exists (select puc.idusuario
                                              from int_faleconoscopapeisusu puc
                                              where puc.flp_id = m.flp_id_copia 
                                                and puc.data_inclusao < m.data_envio
                                                and puc.idusuario = 111)))
 group by m.flc_id  
/
col options for a15
col operation for a50
col linhas for a15
select lpad('.',2*(level-1))||operation operation,
       options,
       object_name
--       DECODE(id,0,'Custo = '||position,cardinality) Linhas
from plan_table
start with id = 0 and statement_id = 'ABC4'
connect by prior id = parent_id and statement_id = 'ABC4'
/
