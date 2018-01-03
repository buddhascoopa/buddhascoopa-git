select inventory_item_id,organization_id,count(*)
from &1
group by inventory_item_id,organization_id
having count(*) > 1
/
