rem DELETE PLAN_TABLE WHERE STATEMENT_ID='ABC4';
rem COMMIT;
rem EXPLAIN PLAN SET STATEMENT_ID='ABC4' INTO PLAN_TABLE FOR
SELECT /*+ index(dl dl_dl2_uk)*/ QL.QTD_LIVRO 
FROM   QTD_LIVRO QL, 
       detal_livro dl 
WHERE DL.COD_SEQ_DETAL_LIVRO = QL.COD_SEQ_DETAL_LIVRO 
  AND QL.COD_PRODUT_GENERC   = 50270  
  AND DL.COD_EMP             = 83  
  AND DL.COD_LIVRO           = 1  
  AND DL.COD_LINHA_LIVRO     = 4  
  AND DL.DAT_ANOMES_INIC     = to_date('01-09-97','DD-MM-YY')
  AND DL.IND_TIPO_COLUNA_LIVRO = 'Q'
/
rem col options for a15
rem col operation for a30
rem select lpad('.',2*(level-1))||operation operation,options,object_name
rem from plan_table
rem start with id = 0 and statement_id = 'ABC4'
rem connect by prior  id = parent_id and statement_id = 'ABC4'
rem /
