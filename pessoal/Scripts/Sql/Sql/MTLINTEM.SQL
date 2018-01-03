alter table inv.mtl_system_items
add constraint mtl_system_items_u1
unique (inventory_item_id, organization_id)
using index 
pctfree 5
tablespace iin1i
storage (initial 20m next 5m pctincrease 0)
/
alter table inv.mtl_system_items
add constraint mtl_system_items_uc1
unique (organization_id, segment1)
using index
pctfree 5
tablespace iin1i
storage (initial 20m next 5m pctincrease 0)
/
