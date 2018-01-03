select owner,
       segment_type,
       (case when bytes/1024/1024 <= 4
          then 'P'
          else
            case when bytes/1024/1024 <= 128
              then 'M'
              else 'G'
            end
        end) Tamanho,
       sum(extents) tot_ext,
       sum(bytes)/1024/1024 mb
from dba_segments
where owner in
(
'INTPLAT',
'OPS$TI_OI',
'PCPPREPAGO',
'PREPAGO',
'REPASSE',
'SMSC'
)
group by owner,
         segment_type,
         (case when bytes/1024/1024 <= 4
          then 'P'
          else
            case when bytes/1024/1024 <= 128
              then 'M'
              else 'G'
            end
        end)

