/******************************************************************************
     PROGRAMA : ICE124Q8.SQL

     INSERE NA MMTV OS CUSTOS DOS PRODUTOS DO CMS

     PARAMETROS: 
	&1 : ARQUIVO DE LOG
	&2 : ANO/MÊS CONTABIL (YYYYMM)
	&3 : SISTEMA (CARACTER(3))
	&4 : FASE (NUMÉRICO(2))
     
******************************************************************************* */
spool &1
set serveroutput on
whenever sqlerror exit 02

-- Variaveis de Trabalho

declare
wrk_cod_sub_elemen         VARCHAR2(2);
wrk_str                    VARCHAR2(100);
wrk_val_movim              NUMBER;
wrk_ind_cts                VARCHAR2(1);
wrk_ind_ultima_fase        VARCHAR2(1);
wrk_dsc_jutsva             VARCHAR2(30);
wrk_contador               NUMBER(2);
wrk_sub_sai_qtde_fh        NUMBER;
wrk_sub_sai_val_fh         NUMBER;
wrk_saldo_final            NUMBER;
wrk_reproc                 VARCHAR2(1);
wrk_data                   VARCHAR2(6);
wrk_seq_control            NUMBER;
wrk_sistem_pre             VARCHAR2(3);
wrk_fase_pre               NUMBER(2);
wrk_dat_anomes_contab             date;
wrk_sistem                        varchar2(3);
wrk_fase                          number(2);

Cursor cur_pr is Select prf.cod_sistem_pre_requst cod_sistem_pre_requst, 
                        prf.cod_fase_pre_requst   cod_fase_pre_requst, 
                        ffc.dat_anomes_ult_fechto dat_anomes_ult_fechto, 
                        ffc.flg_fechto_fase       flg_fechto_fase
                 from   pre_requst_fase prf,
                        fase_fechto ffc
                 where prf.cod_sistem = wrk_sistem 
                 and   prf.cod_fase = wrk_fase
                 and   ffc.cod_sistem = prf.cod_sistem_pre_requst 
                 and   ffc.cod_fase = prf.cod_fase_pre_requst;
reg_pr cur_pr%ROWTYPE;

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
             union
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
reg_cts cur_cts%ROWTYPE;

cursor cur_del is select /*+ index(mmtv i_movim_mensal_valzd_01) */ 
                        mmtv.rowid linha_mmtv
                   from movim_mensal_trans_valzd    mmtv,
                        assoc_fase_sub_grp          afsg,
                        assoc_sub_grp_produt_generc aspg,
                        trans_valida_grp_estoq      tvge
                   where mmtv.cod_trans_contab  = tvge.cod_trans_contab
                   and   aspg.cod_grp_estoq     = tvge.cod_grp_estoq
                   and   mmtv.cod_emp           = aspg.cod_emp
                   and   mmtv.cod_produt_generc = aspg.cod_produt_generc
                   and   aspg.cod_grp_estoq     = afsg.cod_grp_estoq
                   and   aspg.cod_sub_grp_estoq = afsg.cod_sub_grp_estoq
                   and   afsg.cod_sistem        = wrk_sistem
                   and   afsg.cod_fase          = wrk_fase
                   and   mmtv.dat_anomes_contab = wrk_dat_anomes_contab
                   and   tvge.cod_sistem_origem_val in ('CTS')
                   and   not exists ( select 'EXISTE'
                                      from a_restart_fase arf
                                      where arf.cod_fase          = wrk_fase
                                      and   arf.cod_sistem        = wrk_sistem
                                      and   arf.dat_anomes_contab = 
                                                           wrk_dat_anomes_contab
                                      and   arf.cod_produt_generc = 
                                                       mmtv.cod_produt_generc );
reg_del cur_del%ROWTYPE;

-- Tratar fase

begin

wrk_dat_anomes_contab := to_date('&2','yyyymm');
wrk_sistem            := '&3';
wrk_fase              := &4;

-- Verificando se os pre-requisitos foram fechados 
Open cur_pr;
loop
   fetch cur_pr into reg_pr;
   exit when cur_pr%NOTFOUND;
   If reg_pr.dat_anomes_ult_fechto = wrk_dat_anomes_contab and reg_pr.flg_fechto_fase = 'S' then
      If wrk_sistem = 'ICE' and reg_pr.cod_sistem_pre_requst= 'CTS' then
         wrk_ind_cts := 'S';
         wrk_fase_pre := reg_pr.cod_fase_pre_requst;
         wrk_sistem_pre := reg_pr.cod_sistem_pre_requst;
      End if;
   End If;
end loop;
Close cur_pr;

if wrk_ind_cts = 'S' then
open cur_del;
loop
   fetch cur_del into reg_del;
   exit when cur_del%NOTFOUND;
   delete from movim_mensal_trans_valzd
   where rowid = reg_del.linha_mmtv;
end loop;
close cur_del;
end if;


--Verifica se tem pre-requisito com CTS

If wrk_ind_cts = 'S' then
open cur_cts;
loop
   fetch cur_cts into reg_cts;
   exit when cur_cts%NOTFOUND;

   wrk_seq_control := contrl_seq.calc_digito('MOVIM_MENSAL_TRANS_VALZD','COD_SEQ_MOVIM_TRANS_VALZD');

   --Inserir na tabela movim_mensal_trans_valzd

   Insert into movim_mensal_trans_valzd
   (cod_seq_movim_trans_valzd, 
   dat_anomes_contab, 
   val_movim, 
   cod_seq_indexd_contab, 
   cod_sub_elemen, 
   cod_trans_contab, 
   cod_produt_generc, 
   cod_emp, 
   cod_locald,
   qtd_movim)
   values
   (wrk_seq_control, 
   wrk_dat_anomes_contab,
   reg_cts.val_custo_produt, 
   reg_cts.cod_seq_indexd_contab,
   reg_cts.cod_sub_elemen_agrp,
   reg_cts.cod_trans_contab, 
   reg_cts.cod_produt_generc, 
   reg_cts.cod_emp, 
   reg_cts.cod_locald, 
   reg_cts.qtd_movim);
end loop;
Close cur_cts;
End if;

commit;

End;
/
spool off
exit
