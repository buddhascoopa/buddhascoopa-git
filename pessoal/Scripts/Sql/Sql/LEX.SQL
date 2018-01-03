select segment_name, owner, SEGMENT_TYPE , extents
from dba_segments
where segment_type in ('TABLE','INDEX')
and extents > 100
/
