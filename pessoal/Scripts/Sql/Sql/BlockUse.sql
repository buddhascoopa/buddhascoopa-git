Rem
Rem Criado em 13:53 02/29/2000
Rem N�mero de blocos em uso
Rem
col file_name for a30
col tablepsace_name for a20

SELECT E.FILE_ID,
       F.FILE_NAME,
       F.TABLESPACE_NAME,
       SUM(E.BLOCKS) ALLOCATED,
       F.BLOCKS   "FILE SIZE"
FROM DBA_EXTENTS E,
     DBA_DATA_FILES F
WHERE E.FILE_ID = F.FILE_ID
GROUP BY E.FILE_ID, F.FILE_NAME, F.TABLESPACE_NAME, F.BLOCKS
ORDER BY E.FILE_ID
/
SELECT S.SEGMENT_NAME NAME, 
       SUM(R.BLOCKS) BLOCKS
FROM DBA_SEGMENTS S, 
     DBA_EXTENTS R
WHERE S.SEGMENT_TYPE = 'ROLLBACK'
  AND S.SEGMENT_NAME = R.SEGMENT_NAME
GROUP BY S.SEGMENT_NAME
/
