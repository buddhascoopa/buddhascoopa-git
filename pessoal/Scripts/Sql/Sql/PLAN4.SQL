DELETE PLAN_TABLE WHERE STATEMENT_ID='ABC4';
COMMIT;
EXPLAIN PLAN SET STATEMENT_ID='ABC4' INTO PLAN_TABLE FOR
SELECT 'EXISTE'
FROM V_ESTOQ_QTD_TOTAL      VEQT,
     trans_valida_grp_estoq tvge
WHERE tvge.cod_trans_contab      = :veqtcod_trans_contab 
  and tvge.flg_tratam_sub_elemen = 'S' 
  and tvge.flg_ajust_safra       = 'N' 
  and tvge.cod_sistem_origem_val = 'CTS' 
  and tvge.cod_grp_estoq         = :cod_grp_estoq
  and veqt.dat_anomes_contab     = to_date('01-FEV-98','DD-MON-YY')
  and veqt.cod_emp               = :cprcod_emp 
  and veqt.cod_locald            = :cprcod_locald 
  and veqt.cod_trans_contab      = tvge.cod_trans_contab 
  and veqt.cod_produt_generc     = :cprcod_produt_generc 
/
col options for a15
col operation for a30
select lpad('.',2*(level-1))||operation operation,options,object_name
from plan_table
start with id = 0 and statement_id = 'ABC4'
connect by prior  id = parent_id and statement_id = 'ABC4'
/
