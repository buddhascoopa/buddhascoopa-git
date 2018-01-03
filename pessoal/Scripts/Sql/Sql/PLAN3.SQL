DELETE PLAN_TABLE WHERE STATEMENT_ID='ABC4';
COMMIT;
EXPLAIN PLAN SET STATEMENT_ID='ABC4' INTO PLAN_TABLE FOR
Select cpr.cod_sistem            cod_sistem, 
       cpr.cod_fase              cod_fase,
       cpr.dat_ano_mes_contab    dat_anomes_contab,
       cpr.cod_produt_generc     cod_produt_generc,
       cpr.cod_seq_indexd_contab cod_seq_indexd_contab,
       cpr.cod_sub_elemen        cod_sub_elemen,
       cpr.cod_emp               cod_emp,
       cpr.cod_locald            cod_locald,
       sum(cpr.val_custo_produt) val_custo_produt,
       0                         qtd_movim,
       decode(ase.cod_grp_estoq, 3, 114, 4, 116, 5, 111, 6, 113, 7, 117, 8, 116,
                                 9, decode(cpr.cod_locald,
                                            64, 116,
                                                115 ),
                                10, decode(cpr.cod_locald,
                                            64, 116,
                                                115 ),
                                12, 116,
                                13, 115)           cod_trans_contab,
        ase.cod_sub_elemen_agrp   cod_sub_elemen_agrp
from  custo_produt                  cpr,
      assoc_sub_grp_produt_generc   aspg,
      trans_valida_grp_estoq        tvge,
      agrp_sub_elemen               ase
where aspg.cod_produt_generc     = cpr.cod_produt_generc 
  and aspg.cod_grp_estoq         = tvge.cod_grp_estoq
  and aspg.cod_emp               = cpr.cod_emp
  and ase.cod_sub_elemen         = cpr.cod_sub_elemen 
  and ase.cod_grp_estoq          = aspg.cod_grp_estoq
  and tvge.flg_tratam_sub_elemen = 'S' 
  and tvge.flg_ajust_safra       = 'N' 
  and tvge.cod_sistem_origem_val = 'CTS' 
  and cpr.cod_fase               = :wrk_fase_pre 
  and cpr.cod_sistem             = :wrk_sistem_pre 
  and cpr.dat_ano_mes_contab     = :wrk_dat_anomes_contab
  AND NOT EXISTS ( SELECT 'EXISTE'
                   FROM V_ESTOQ_QTD_TOTAL      VEQT,
                        trans_valida_grp_estoq tvge
                   WHERE tvge.cod_trans_contab      = veqt.cod_trans_contab 
                     and tvge.flg_tratam_sub_elemen = 'S' 
                     and tvge.flg_ajust_safra       = 'N' 
                     and tvge.cod_sistem_origem_val = 'CTS' 
                     and tvge.cod_grp_estoq         = aspg.cod_grp_estoq
                     and veqt.dat_anomes_contab     = :wrk_dat_anomes_contab
                     and veqt.cod_emp               = cpr.cod_emp 
                     and veqt.cod_locald            = cpr.cod_locald 
                     and veqt.cod_trans_contab      = tvge.cod_trans_contab 
                     and veqt.cod_produt_generc     = cpr.cod_produt_generc ) 
  and  EXISTS ( select 'EXISTE'
                from   movim_trans_estoq      MTE,
                       parm_trans_contab      ptc,
                       trans_valida_grp_estoq tvge
                where mte.cod_trans_contab  = ptc.cod_trans_contab 
                  and   tvge.cod_trans_contab = mte.cod_trans_contab
                  and   tvge.flg_tratam_sub_elemen = 'S' 
                  and   tvge.flg_ajust_safra       = 'N' 
                  and   tvge.cod_sistem_origem_val = 'CTS' 
                  and   tvge.cod_grp_estoq         = aspg.cod_grp_estoq
                  and    MTE.DAT_ANOMES_CONTAB >= :wrk_dat_anomes_contab
                  and    MTE.DAT_ANOMES_CONTAB <= LAST_DAY(:WRK_DAT_ANOMES_CONTAB)
                  and    MTE.cod_produt_generc = ASPG.cod_produt_generc
                  and    ptc.flg_tratam_val <> '1' )
group by cpr.cod_sistem, cpr.cod_fase, cpr.dat_ano_mes_contab, cpr.cod_produt_generc,cpr.cod_seq_indexd_contab, cpr.cod_sub_elemen, cpr.cod_emp, cpr.cod_locald,ase.cod_sub_elemen_agrp, ase.cod_grp_estoq
/
col options for a15
col operation for a30
select lpad('.',2*(level-1))||operation operation,options,object_name
from plan_table
start with id = 0 and statement_id = 'ABC4'
connect by prior  id = parent_id and statement_id = 'ABC4'
/
