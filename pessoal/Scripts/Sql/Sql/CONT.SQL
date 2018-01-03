rem DELETE PLAN_TABLE WHERE STATEMENT_ID='CONT';
rem COMMIT;
rem EXPLAIN PLAN SET STATEMENT_ID='CONT' INTO PLAN_TABLE FOR
Select  /* index(MMT MTL_MATERIAL_TRANSACTIONS_N1 */           
        count(*)                        
From    MTL_MATERIAL_TRANSACTIONS MMT
Where   inventory_item_id = 266619
  and   organization_id   = 2
  and   subinventory_code = 2 
  and   transaction_date  = to_date(to_char(199705),'YYYYMM')
/
rem col options for a15
rem col operation for a30
rem select lpad('.',2*(level-1))||operation operation,options,object_name
rem from plan_table
rem start with id = 0 and statement_id = 'CONT'
rem connect by prior  id = parent_id and statement_id = 'CONT'
rem /
