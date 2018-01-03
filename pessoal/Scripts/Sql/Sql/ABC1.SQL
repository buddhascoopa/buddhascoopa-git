DELETE PLAN_TABLE WHERE STATEMENT_ID='ABC4';
COMMIT;
EXPLAIN PLAN SET STATEMENT_ID='ABC4' INTO PLAN_TABLE FOR
SELECT C.EXERCICIO,
       C.MOEDA,
       C.COD_PB,
       C.NUM_PROGRAMA,
       C.TIPO_PROJETO,
       C.NUM_PROJETO,
       C.COD_UO,
       C.COD_FR 
FROM COPLAN C 
/
col options for a15
col operation for a30
col linhas for a15
select lpad('.',2*(level-1))||operation operation,
       options,
       object_name,
       DECODE(id,0,'Custo = '||position,cardinality) Linhas
from plan_table
start with id = 0 and statement_id = 'ABC4'
connect by prior id = parent_id and statement_id = 'ABC4'
/
