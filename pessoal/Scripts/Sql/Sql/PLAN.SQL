
DELETE PLAN_TABLE WHERE STATEMENT_ID='ABC';                                   
COMMIT;                                                                         
EXPLAIN PLAN SET STATEMENT_ID='ABC' INTO PLAN_TABLE FOR                       
SELECT CIC.INVENTORY_ITEM_ID,
       MP.ORGANIZATION_ID,
       CIC.INVENTORY_ASSET_FLAG, 
       CIC.LOT_SIZE,
       CIC.BASED_ON_ROLLUP_FLAG,
       CIC.SHRINKAGE_RATE,
       CIC.DEFAULTED_FLAG, 
       CIC.COST_UPDATE_ID, 
       CIC.PL_MATERIAL,
       CIC.PL_MATERIAL_OVERHEAD, 
       CIC.PL_RESOURCE,
       CIC.PL_OUTSIDE_PROCESSING,
       CIC.PL_OVERHEAD, CIC.TL_MATERIAL,
       CIC.TL_MATERIAL_OVERHEAD,
       CIC.TL_RESOURCE, 
       CIC.TL_OUTSIDE_PROCESSING,
       CIC.TL_OVERHEAD,
       CIC.MATERIAL_COST,
       CIC.MATERIAL_OVERHEAD_COST,
       CIC.RESOURCE_COST,
       CIC.OUTSIDE_PROCESSING_COST,
       CIC.OVERHEAD_COST,
       CIC.PL_ITEM_COST,
       CIC.TL_ITEM_COST,
       CIC.ITEM_COST, 
       CIC.UNBURDENED_COST,
       CIC.BURDEN_COST,
       CIC.ATTRIBUTE1,
       CIC.ATTRIBUTE2,
       CIC.ATTRIBUTE3, 
       CIC.ATTRIBUTE4,
       CIC.ATTRIBUTE5,
       CIC.ATTRIBUTE6,
       CIC.ATTRIBUTE7,
       CIC.ATTRIBUTE8, 
       CIC.ATTRIBUTE9,
       CIC.ATTRIBUTE10,
       CIC.ATTRIBUTE11,
       CIC.ATTRIBUTE12, 
       CIC.ATTRIBUTE13,
       CIC.ATTRIBUTE14,
       CIC.ATTRIBUTE15
FROM MTL_PARAMETERS MP,
     CST_ITEM_COSTS CIC 
WHERE CIC.ORGANIZATION_ID = MP.COST_ORGANIZATION_ID
  AND CIC.COST_TYPE_ID = MP.PRIMARY_COST_METHOD                                                                    
/ 
select lpad('.',2*(level-1))||operation||'.'||options
||'.'||object_name
||'.'||decode(id,0,'Cost = '||position) "Query Plan"
from plan_table
start with id = 0 and statement_id = 'ABC'
connect by prior  id = parent_id and statement_id = 'ABC'
/
