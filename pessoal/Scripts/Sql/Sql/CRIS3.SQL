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
                         decode(ase.cod_grp_estoq,
                                 3, 114,
                                 4, 116,
                                 5, 111,
                                 6, 113,
                                 7, 117,
                                 8, 116,
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
                 and   aspg.cod_emp               = cpr.cod_emp
                 and   tvge.flg_tratam_sub_elemen = 'S' 
                 and   tvge.flg_ajust_safra       = 'N' 
                 and   tvge.cod_sistem_origem_val = 'CTS' 
                 and   tvge.cod_grp_estoq         = aspg.cod_grp_estoq
                 and   cpr.cod_sistem             = wrk_sistem_pre 
                 and   cpr.cod_fase               = wrk_fase_pre 
                 and   cpr.dat_ano_mes_contab     = wrk_dat_anomes_contab
                 and   ase.cod_sub_elemen         = cpr.cod_sub_elemen 
                 and   ase.cod_grp_estoq          = aspg.cod_grp_estoq
                 AND   NOT EXISTS ( SELECT 'EXISTE'
                                    FROM V_ESTOQ_QTD_TOTAL      VEQT,
                                         trans_valida_grp_estoq tvge
                                    WHERE tvge.cod_trans_contab      = 
                                                      veqt.cod_trans_contab
                                    and   tvge.flg_tratam_sub_elemen = 'S' 
                                    and   tvge.flg_ajust_safra       = 'N' 
                                    and   tvge.cod_sistem_origem_val = 'CTS' 
                                    and   tvge.cod_grp_estoq         = 
                                                      aspg.cod_grp_estoq
                                    and   veqt.dat_anomes_contab     = 
                                                      wrk_dat_anomes_contab
                                    and   veqt.cod_emp               = 
                                                      cpr.cod_emp 
                                    and   veqt.cod_locald            = 
                                                      cpr.cod_locald 
                                    and   veqt.cod_trans_contab      = 
                                                      tvge.cod_trans_contab 
                                    and   veqt.cod_produt_generc     = 
                                                      cpr.cod_produt_generc )
                 and  (
/* MOVIMENTAÇÕES */       EXISTS ( select 'EXISTE'
/* PELO INV      */                from   movim_trans_estoq      MTE,
                                          parm_trans_contab      ptc,
                                          trans_valida_grp_estoq tvge
                                   where mte.cod_trans_contab  = 
                                                  ptc.cod_trans_contab 
                                   and   tvge.cod_trans_contab = 
                                                  mte.cod_trans_contab
                                   and   tvge.flg_tratam_sub_elemen = 'S' 
                                   and   tvge.flg_ajust_safra       = 'N' 
                                   and   tvge.cod_sistem_origem_val = 'CTS' 
                                   and   tvge.cod_grp_estoq         = 
                                                  aspg.cod_grp_estoq
                                   and    MTE.DAT_ANOMES_CONTAB >= 
                                                 wrk_dat_anomes_contab
                                   and    MTE.DAT_ANOMES_CONTAB <=
                                                 LAST_DAY(WRK_DAT_ANOMES_CONTAB)
                                   and    MTE.cod_produt_generc =
                                                 ASPG.cod_produt_generc
                                   and    ptc.flg_tratam_val <> '1' )
/* AJUSTE CONTAB.*/ OR    EXISTS ( select 'EXISTE'
/* P/ SETOR DE   */                from movim_mensal_trans_valzd mmtv
/* DE CUSTOS     */                where mmtv.cod_emp = cpr.cod_emp
                                   and   mmtv.cod_seq_indexd_contab =
                                                       cpr.cod_seq_indexd_contab
                                   and   mmtv.cod_produt_generc     =
                                                       aspg.cod_produt_generc
                                   and   mmtv.dat_anomes_contab     =
                                                       wrk_dat_anomes_contab
                                   and   mmtv.cod_trans_contab IN (400,401) )
/* ESTOQ. FINAL */  OR    EXISTS ( select 'EXISTE' 
/* MÊS ANTERIOR */                 from   posic_csolid_produt PCP	
                                   where  PCP.DAT_ANOMES_POSIC_CSOLID >=
                                           add_months(wrk_dat_anomes_contab, -1) 
                                   and    PCP.DAT_ANOMES_POSIC_CSOLID <=
                                 LAST_DAY(add_months(wrk_dat_anomes_contab, -1))
                                   AND    PCP.cod_emp = cpr.cod_emp            
                                   and    PCP.cod_produt_generc =
                                                          ASPG.cod_produt_generc
                                   and    PCP.QTD_CSOLID_ESTOQ_FINAL   <>   0 )
                         )
                 and   not exists ( select 'EXISTE'
                                    from a_restart_fase arf
                                    where arf.cod_fase          = wrk_fase
                                    and   arf.cod_sistem        = wrk_sistem
                                    and   arf.dat_anomes_contab = 
                                                           wrk_dat_anomes_contab
                                    and   arf.cod_produt_generc = 
                                                         cpr.cod_produt_generc )
                 group by cpr.cod_sistem, cpr.cod_fase, cpr.dat_ano_mes_contab, 
                 cpr.cod_produt_generc,cpr.cod_seq_indexd_contab,
                 cpr.cod_sub_elemen, cpr.cod_emp, cpr.cod_locald,
                 ase.cod_sub_elemen_agrp, ase.cod_grp_estoq;

