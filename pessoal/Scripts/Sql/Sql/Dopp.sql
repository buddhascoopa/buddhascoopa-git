set echo on
spool UpdDoppPrest81.log
drop index ibge.dopp81_1086_1026_FK_I;
--
--create unique index dopp81_uk1
--on dopp86 (codanopesq,codregeogr,codufcenso,codarmetro,nrctrl,nrserie)
--tablespace pnadi1981;
--
set serveroutput on
set arrays 5000
--
execute UpdDopp('DPPRES81','dopp81','PRESTME101','CODPRESTME2');
--
create bitmap index dopp81_1086_1026_FK_I
on dopp81(CODPRESTME2)
tablespace pnadi1981;
--
spool off
set echo off