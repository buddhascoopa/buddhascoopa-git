alter table posic_csolid_produt add constraint pocopr_pk primary key
(cod_emp,
cod_produt_generc,
dat_anomes_posic_csolid)
using index tablespace dg32i
storage (initial 5m next 500k)
/
