set echo on
spool UpdFamiComp290.log
drop index ibge.fami90_1146_1002_FK_I;
--
-- create unique index Fami900_uk1
-- on Fami90 (codanopesq,codregeogr,codufcenso,codarmetro,nrctrl,nrserie,nrfami)
-- tablespace pnadi1990;
--
set serveroutput on
set arrays 5000
--
execute UpdFami('TPFAM90','Fami90','CODTPFAM');
--
CREATE BITMAP INDEX fami90_1146_1002_FK_I
ON fami90(CODTPFAM)
tablespace pnadi1990@;
--
spool off
set echo off