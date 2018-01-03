DELETE SYS.PLAN_TABLE WHERE STATEMENT_ID='ABC4';
COMMIT;
EXPLAIN PLAN SET STATEMENT_ID='ABC4' INTO SYS.PLAN_TABLE FOR
SELECT DISTINCT
       spb.batch_id,
       spb.name pick_batch_name,
       sh.shipment_priority_code,
       tfc.descricao        tipo_local_faixa,
       tfc.sequencia, 
       nvl(substr(msi.segment1,1, (to_number(instr(msi.segment1,'*',1,2)) - 1)),msi.segment1) segment1,
       msi.description                 description,
       sl.unit_code		unit_of_measure,
       sum(spl.requested_quantity)       qty_requested
FROM
       SO_PICKING_BATCHES_ALL    spb,
       SO_PICKING_HEADERS_ALL    sph,
       SO_HEADERS_ALL            sh,
       SO_PICKING_LINES_ALL	 spl,
       SO_PICKING_LINE_DETAILS	 spld,
       SO_LINE_DETAILS             sld,
       SO_LINES_ALL                sl ,
       BOM_INVENTORY_COMPONENTS    bic,
       MTL_SYSTEM_ITEMS            msi1,
       MTL_SYSTEM_ITEMS            msi,
       MTL_ITEM_LOC_DEFAULTS       mild,
       MTL_ITEM_LOCATIONS          mil,
       WSH_DELIVERIES                   wdel,
       WSH_DEPARTURES                wdep,
       RA_SITE_USES_ALL                  rsu,
       RA_ADDRESSES_ALL                ra,
       CTK_FAIXA_CEP_CORREIO        fcc,
       CTK_TIPO_FAIXA_CEP                tfc
   WHERE   spb.batch_id = :P_BATCH_ID
     AND sph.batch_id = spb.batch_id
     AND sh.header_id = sph.order_header_id
     AND spl.picking_header_id = sph.picking_header_id
     AND spld.picking_line_id = spl.picking_line_id
     AND spl.picking_line_id = spld.picking_line_id
     AND sph.order_header_id = sl.header_id
     AND rsu.site_use_id = spl.ship_to_site_use_id
     AND ra.address_id = rsu.address_id
     AND nvl(postal_code,'00000000') >= fcc.cod_cep_inicio
     AND nvl(postal_code,'00000000') <= fcc.cod_cep_final
     AND fcc.tipo_faixa_id           =  tfc.tipo_faixa_id
     AND tfc.organization_id         = :p_warehouse_id
     AND sld.line_detail_id = spl.line_detail_id
     AND sl.line_id = sld.line_id
     AND sl.component_sequence_id = bic.component_sequence_id(+)
     AND msi1.inventory_item_id = sl.inventory_item_id
     AND msi1.organization_id    = :P_WAREHOUSE_ID
     AND msi.inventory_item_id = decode(msi1.item_type, 'CPTM', sl.inventory_item_id, spl.inventory_item_id)
     AND msi.organization_id = :P_WAREHOUSE_ID
     AND mild.inventory_item_id(+) = spl.inventory_item_id
     AND mild.organization_id(+) = :P_WAREHOUSE_ID
     AND mild.default_type(+) = 1
     AND mil.inventory_location_id(+) = mild.locator_id
     AND wdel.delivery_id(+) = spld.delivery_id
     AND wdep.departure_id(+) = spld.departure_id
     -- G_PICK_DETAILS
     AND spl.warehouse_id = :P_WAREHOUSE_ID
     AND spld.warehouse_id = :P_WAREHOUSE_ID GROUP BY spb.batch_id,
       spb.name,
       sh.shipment_priority_code,
       tfc.descricao,
       tfc.sequencia, 
       nvl(substr(msi.segment1,1, (to_number(instr(msi.segment1,'*',1,2)) - 1)),msi.segment1),
       msi.description,
       sl.unit_code ORDER BY 1 ASC,2 ASC,3 ASC,5 ASC
/
col options for a15
col operation for a50
col linhas for a15
select lpad('.',2*(level-1))||operation operation,
       options,
       object_name
--       DECODE(id,0,'Custo = '||position,cardinality) Linhas
from sys.plan_table
start with id = 0 and statement_id = 'ABC4'
connect by prior id = parent_id and statement_id = 'ABC4'
/
