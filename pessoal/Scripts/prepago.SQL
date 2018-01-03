select tab.owner, tab.table_name, part.partition_name, tab.ini_trans, seg.extents
from dba_tables tab, dba_segments seg, dba_tab_partitions part
where tab.owner in
(
'INTPLAT',
'OPS$TI_OI',
'PCPPREPAGO',
'PREPAGO',
'REPASSE',
'SMSC'
)
and tab.table_name=seg.segment_name
and tab.table_name=part.partition_name(+)
order by 1,2

