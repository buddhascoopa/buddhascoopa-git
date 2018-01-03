rem DELETE PLAN_TABLE WHERE STATEMENT_ID='CONT1';
rem COMMIT;
rem EXPLAIN PLAN SET STATEMENT_ID='CONT1' INTO PLAN_TABLE FOR
Select count(*)
from   MTL_SYSTEM_ITEMS MSI,                                    
       MTL_ITEM_SUB_INVENTORIES MISI,                           
       MTL_SECONDARY_INVENTORIES MSE                            
where  misi.organization_id     = 2
  and  misi.inventory_item_id   = msi.inventory_item_id 
  and  misi.secondary_inventory = mse.secondary_inventory_name  
  and  mse.organization_id      = 2
  and  mse.attribute3           = to_date('199705','yyyymm')    
  and  mse.disable_date        is null                          
  and  substr(mse.attribute10,1,1) = 'S'
  and  msi.organization_id         = 2            
/
rem col options for a15
rem col operation for a30
rem select lpad('.',2*(level-1))||operation operation,options,object_name
rem from plan_table
rem start with id = 0 and statement_id = 'CONT1'
rem connect by prior  id = parent_id and statement_id = 'CONT1'
rem /
