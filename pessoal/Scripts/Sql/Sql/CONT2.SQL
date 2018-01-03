DELETE PLAN_TABLE WHERE STATEMENT_ID='CONT2';
COMMIT;
EXPLAIN PLAN SET STATEMENT_ID='CONT2' INTO PLAN_TABLE FOR
Select  QTD_ESTOQ_FECHTO                                       
from    POSIC_MENSAL_ESTOQ_SUBINV                              
where   COD_EMP                  = 083                         
  and   COD_LOCALD               = 1664
  and   COD_PRODUT_GENERC        = 101079
  and   SECONDARY_INVENTORY_NAME = '02'
  and   DAT_FECHTO               = to_number(to_char(add_months(to_date('199705','yyyymm'),-1),'yyyymm'))
/
col options for a15
col operation for a30
select lpad('.',2*(level-1))||operation operation,options,object_name
from plan_table
start with id = 0 and statement_id = 'CONT2'
connect by prior  id = parent_id and statement_id = 'CONT2'
/
