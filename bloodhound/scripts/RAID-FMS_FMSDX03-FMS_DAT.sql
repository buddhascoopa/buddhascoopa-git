-- 31global
select *
from FMS_R_31_GLOBAL

-- SERASA
select * 
from fms_r_serasa_PF
where CPF_CNPJ = '07163966709'

select * 
from fms_r_serasa_PF
where logradouro = 'VERGUEIRO' and numero_endereco = '14' --and complemento_endereco in ('AP 1001', 'AP 1002') 

-- query BOV
select cpf_cnpj, terminal, tel_contato, numero_endereco, logradouro, bairro, orig_nome_logradouro 
from fms_t_bov 
where logradouro like '%VERGUEIRO%' and numero_endereco = '14'

-- query SINN pessoa
select * 
from fms_t_sinn_crm_pessoa
where id_pessoa in (select id_pessoa 
                    from fms_t_sinn_crm_contrato
                    where logradouro like '%CATETE%' and numero_endereco = '222' and complemento_endereco like '%604%')

select * 
from fms_t_sinn_crm_pessoa
where nome_cliente like 'VIVIANE%OLIVEIRA%MENDES'


-- query SINN contrato
select * 
from fms_t_sinn_actv_oitv
where logradouro like '%VERGUEIRO%' --and numero_endereco = '14'

-- query SINN contrato
select * 
from fms_t_sinn_crm_contrato
where logradouro like '%VERGUEIRO%' and numero_endereco = '14'

-- query SINN contrato
select * 
from fms_t_sinn_crm_contrato
where logradouro like '%CATETE%' and numero_endereco = '222' and complemento_endereco like '%604%'
