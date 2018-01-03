Select rn.Name "Rollback Segment",
       rs.RSSize/1024 "Size (KB)",
       rs.Gets "Gets",
       rs.waits "Waits",
       (rs.Waits/rs.Gets)*100 "% Waits",
       rs.Shrinks "# Shrinks",
       rs.Extends "# Extends"
from sys.v_$RollName rn, sys.v_$RollStat rs
where rn.usn = rs.usn
/
