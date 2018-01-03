DELETE SYS.PLAN_TABLE WHERE STATEMENT_ID='ABC4';
COMMIT;
EXPLAIN PLAN SET STATEMENT_ID='ABC4' INTO SYS.PLAN_TABLE FOR
select /*+ INDEX(Mensagem_Voo_Realizado MVR_UNV_FK_I) FULL(Unidade_Vigencia) */ mvr_id
from Mensagem_Voo_Realizado,
     Unidade_Vigencia
Where  (UNV_ADM_CD_ADMINISTRADORA_FK=MVR_UNV_CD_ADMINISTRADORA_FK)
And    (UNV_CLA_CD_CLASSE_FK        =MVR_UNV_CD_CLASSE_FK)
And    (UNV_CAT_CD_CATEGORIA_FK     =MVR_UNV_CD_CATEGORIA_FK)
And    (UNV_UNA_SG_UNIDADE_FK       =MVR_UNV_SG_UNIDADE_FK)
And    (UNV_DT_VIGENCIA             =MVR_UNV_DT_VIGENCIA_FK)
AND    rownum=1
/
col options for a15
col operation for a50
col linhas for a15
select lpad('.',2*(level-1))||operation operation,
       options,
       object_name
--       DECODE(id,0,'Custo = '||position,cardinality) Linhas
from sys.plan_table
start with id = 0 and statement_id = 'ABC4'
connect by prior id = parent_id and statement_id = 'ABC4'
/
