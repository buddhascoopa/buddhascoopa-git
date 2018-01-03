alter rollback segment r38 offline;
drop rollback segment r38  ;
create  rollback segment r38 tablespace rbs storage (initial 5m next 2048k maxex
tents 249);
alter rollback segment r38 online; 
