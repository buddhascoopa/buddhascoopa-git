Cursor cur_cts is Select cpr.cod_sistem            cod_sistem, 
                         cpr.cod_fase              cod_fase,
                         cpr.dat_ano_mes_contab    dat_anomes_contab,
                         cpr.cod_produt_generc     cod_produt_generc,
                         cpr.cod_seq_indexd_contab cod_seq_indexd_contab,
                         cpr.cod_sub_elemen        cod_sub_elemen,
                         cpr.cod_emp               cod_emp,
                         cpr.cod_locald            cod_locald,
                         sum(cpr.val_custo_produt) val_custo_produt,
                         veqt.qtd_movim            qtd_movim,
                         tvge.cod_trans_contab     cod_trans_contab,
                         ase.cod_sub_elemen_agrp   cod_sub_elemen_agrp
                  from  custo_produt                  cpr,
                        v_estoq_qtd_total             veqt,
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
                 and   veqt.dat_anomes_contab     = wrk_dat_anomes_contab
                 and   veqt.cod_emp               = cpr.cod_emp 
                 and   veqt.cod_locald            = cpr.cod_locald 
                 and   veqt.cod_trans_contab      = tvge.cod_trans_contab 
                 and   veqt.cod_produt_generc     = cpr.cod_produt_generc
                 and   ase.cod_sub_elemen         = cpr.cod_sub_elemen 
                 and   ase.cod_grp_estoq          = aspg.cod_grp_estoq
                 and   not exists ( select 'EXISTE'
                                    from a_restart_fase arf
                                    where arf.cod_fase          = wrk_fase
                                    and   arf.cod_sistem        = wrk_sistem
                                    and   arf.dat_anomes_contab = 
                                                           wrk_dat_anomes_contab
                                    and   arf.cod_produt_generc = 
                                                         cpr.cod_produt_generc )
                 group by cpr.cod_sistem, cpr.cod_fase, cpr.dat_ano_mes_contab, 
                 cpr.cod_produt_generc,cpr.cod_seq_indexd_contab, cpr.cod_sub_elemen, 
                 cpr.cod_emp, cpr.cod_locald, tvge.cod_trans_contab, ase.cod_sub_elemen_agrp,
                 veqt.qtd_movim
