spool indmtl.lis
prompt Criando indice mtl_system_items_n2

create index inv.mtl_system_items_n2
   on inv.mtl_system_items (organization_id,description)
   tablespace iin1i
   storage (initial 10m next 5m pctincrease 0)
/

prompt Criando indice mtl_system_items_n3

create index inv.mtl_system_items_n3
   on inv.mtl_system_items (inventory_item_status_code)
   tablespace iin1i
   storage (initial 10m next 5m pctincrease 0)
/

prompt Criando indice mtl_system_items_n4

create index inv.mtl_system_items_n4
   on inv.mtl_system_items (organization_id, auto_created_config_flag)
   tablespace iin1i
   storage (initial 10m next 5m pctincrease 0)
/

spool off
