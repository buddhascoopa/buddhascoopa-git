Rem
Rem Criado em 11:33 02/29/2000
Rem 
Rem Locks totais e o número de blocos
SELECT I.KCLFIBUK    BUCKET#,      
       H.KCLFHSIZ    LOCKS,      
       SUM(F.BLOCKS) BLOCKS 
FROM SYS.X$KCLFH H,      
     SYS.X$KCLFI I,      
     DBA_DATA_FILES F        
WHERE I.KCLFIBUK = H.INDX          
  AND I.INDX     = F.FILE_ID     
GROUP BY I.KCLFIBUK, 
         H.KCLFHSIZ
/
Rem Locks por arquivos
SELECT KCLFIBUK  BUCKET#,
       FILE_NAME NAME,
       FILE_ID   FILE# 
FROM X$KCLFI,      
     DBA_DATA_FILES        
WHERE FILE_ID = INDX
/
