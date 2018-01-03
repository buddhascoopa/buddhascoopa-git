alter table inv.mtl_catalog_search_items
add constraint mtl_catalog_search_items_u1
unique (group_handle_id,inventory_item_id,organization_id)
using index
tablespace iin1i
storage (initial 5m next 500k pctincrease 0)
/
