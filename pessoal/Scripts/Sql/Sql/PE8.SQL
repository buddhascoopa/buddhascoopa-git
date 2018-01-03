DELETE PLAN_TABLE WHERE STATEMENT_ID='PE8';                                   
COMMIT;                                                                         
EXPLAIN PLAN SET STATEMENT_ID='PE8' INTO PLAN_TABLE FOR
UPDATE A_TEMP_POSIC_ESTOQ 
SET QTD_ESTOQ_APROV=:b1,QTD_ESTOQ_INSPEC=:b2,
    QTD_DURAC_APROV_INSPEC=:b3,
    QTD_TRANST=:b4,
    QTD_DURAC_APROV_INSP_TRANST=:b5,
    QTD_CONSUM=:b6,
    QTD_SALDO_PEDIDO=:b7,
    DAT_ULT_ENTRAD=:b8,
    DAT_ULT_SAIDA=:b9,
    DAT_ULT_CONSUM=:b10,
    QTD_ESTOQ_REJEIT=:b11,
    PRC_REJEIT=:b12,
    QTD_DEMAND_MEDIA_MENSAL=:b13,
    VAL_ESTOQ_APROV=(:b1 * :b15 ),
    VAL_ESTOQ_INSPEC=(:b2 * :b15 ),
    VAL_TRANST=(:b4 * :b15 ),
    VAL_CONSUM=(:b6 * :b15 ),
    VAL_SALDO_PEDIDO=(:b7 * :b15 ),
    VAL_ESTOQ_REJEIT=(:b11 * :b15 ),
    VAL_DEMAND_MEDIA_MENSAL=(:b13 * :b15 ),
    VAL_PRECO=(:b15) 
WHERE NUM_SEQIAL_PROCES = :b29  
  AND DSC_CLASSE = :b30  
  AND IDT_ITEM   = :b31  
  AND IDT_ORGANZ = :b32        
/
col options for a15
col operation for a30
select lpad('.',2*(level-1))||operation operation,options,object_name
from plan_table
start with id = 0 and statement_id = 'PE8'
connect by prior  id = parent_id and statement_id = 'PE8'
/
