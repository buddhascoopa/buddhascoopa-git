DELETE PLAN_TABLE WHERE STATEMENT_ID='ABC4';
COMMIT;
EXPLAIN PLAN SET STATEMENT_ID='ABC4' INTO PLAN_TABLE FOR
Select 
	  t35.poco_cd_poco,	
	  to_char(t39.clpo_cd_class_poco) || t39.depo_sg_ref_nomina ||
	  to_char(t39.poco_nr_poco) || t39.poco_cd_tipo_dir ||
	  t39.poco_sg_repeticao, 
	  t35.unin_cd_unid_int,
	  t34.sond_cd_pref_sonda,
	  t35.uipo_hr_ini_vincul,
	  t35.uipo_qn_rot_ev_ca,
	  t35.uipo_md_lamin_agua
	from itv.unid_inter_poc t35, eep.poco t39, eng.sonda t34
	where uipo_sg_stat_camp = 'INI'  and
	t35.poco_cd_poco = t39.poco_cd_poco and
	t35.unin_cd_unid_int = t34.unin_cd_unid_int 
	order by  t35.poco_cd_poco
/
col options for a15
col operation for a30
select lpad('.',2*(level-1))||operation operation,options,object_name
from plan_table
start with id = 0 and statement_id = 'ABC4'
connect by prior  id = parent_id and statement_id = 'ABC4'
/
