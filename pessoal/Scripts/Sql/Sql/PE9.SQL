DELETE PLAN_TABLE WHERE STATEMENT_ID='PE9';                                   
COMMIT;                                                                         
EXPLAIN PLAN SET STATEMENT_ID='PE9' INTO PLAN_TABLE FOR
select rowid 
from A_TEMP_POSIC_ESTOQ
WHERE ( num_seqial_proces = : P2 )
  and ( cod_regstr is null ) 
  AND ( :qit_dsc_classe = A_TEMP_POSIC_ESTOQ.dsc_classe) 
  AND ( :qit_cod_uom = A_TEMP_POSIC_ESTOQ.cod_uom) 
  AND ( :qit_idt_item = A_TEMP_POSIC_ESTOQ.idt_item)
order by cod_organz                    
/
col options for a15
col operation for a30
select lpad('.',2*(level-1))||operation operation,options,object_name
from plan_table
start with id = 0 and statement_id = 'PE9'
connect by prior  id = parent_id and statement_id = 'PE9'
/
