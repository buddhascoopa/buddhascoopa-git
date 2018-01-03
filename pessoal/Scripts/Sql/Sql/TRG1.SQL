DELETE PLAN_TABLE WHERE STATEMENT_ID='ABC4';
COMMIT;
EXPLAIN PLAN SET STATEMENT_ID='ABC4' INTO PLAN_TABLE FOR
SELECT IDT_CABEC_PEDIDO_VERSAO 
FROM CONDIC_COMRCL_PEDIDO_VERSAO CCPV,
	TAB_AUX_MUTANT TAM 
WHERE CCPV.ROWID=TAM.NUM_ROWID 
  AND TAM.NOM_TAB='CONDIC_COMRCL_PEDIDO_VERSAO';
/
col options for a15
col operation for a30
select lpad('.',2*(level-1))||operation operation,options,object_name
from plan_table
start with id = 0 and statement_id = 'ABC4'
connect by prior  id = parent_id and statement_id = 'ABC4'
/
