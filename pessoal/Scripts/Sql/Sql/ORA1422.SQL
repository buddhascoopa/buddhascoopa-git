select msii.transaction_id
from mtl_system_items msi, mtl_system_items_interface msii
where msii.inventory_item_id is NULL
and msii.organization_id is not NULL
and msii.process_flag = 1
and msii.set_process_id = 0
and msii.organization_id = &1
/
