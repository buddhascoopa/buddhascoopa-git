create index mtl_system_items_interface_n1 
  on mtl_system_items_interface
(inventory_item_id,organization_id)
tablespace iin1i
storage (initial 10m next 5m pctincrease 0);

create index mtl_system_items_interface_n2
   on mtl_system_items_interface
(item_number)
tablespace iin1i
storage (initial 10m next 5m pctincrease 0);

create index mtl_system_items_interface_nc1
    on mtl_system_items_interface
(organization_id,segment1)
tablespace iin1i
storage (initial 10m next 5m pctincrease 0);

alter table mtl_system_items_interface
add constraint mtl_system_items_interface_u1
unique (transaction_id)
using index pctfree 5 tablespace iin1i
storage (initial 5m next 3m pctincrease 0);

alter table mtl_system_items_interface
add constraint mtl_system_items_interface_uc1
unique (organization_id,item_number)
tablespace iin1i
storage (initial 10m next 5m pctincrease 0);
