SELECT *
FROM v$rollname rn, v$rollstat rs
WHERE rs.usn = rn.usn
/
