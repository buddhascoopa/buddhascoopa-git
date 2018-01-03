select sid, serial#, username, osuser, machine, to_char(logon_time, 'dd/mm/yyyy hh24:mi:ss') logon, command, program, module, status, last_call_et
from v$session
where sid in (select SID
                from v$access
               where object in (select segment_name'CDR_DATA'
             )
order by status, last_call_et;

select sid, serial#, username, osuser, machine, to_char(logon_time, 'dd/mm/yyyy hh24:mi:ss') logon, command, program, module, status, last_call_et
from v$session
where sid in (select SID
                from v$access
               where owner='UISBL'
                 and type='TABLE'
                 and object in
                ('SQLN_EXPLAIN_PLAN',
                'SBL_SAP_PRODUCT_MARGIN',
                'SBL_SAP_PRODUCT_PRICE',
                'SBL_META_DEALER',
                'SBL_META_FVI',
                'SBL_SACS_HANDSETS_LIST',
                'SBL_SACS_SIMCARD_LIST',
                'SBL_SAP_DEALER_PURCHASE',
                'SBL_SAP_PRODUCT',
                'SBL_HSET_ALONE',
                'SBL_CMS_SERV_PLANSERV',
                'SBL_CMS_CONTRACT',
                'SBL_CMS_CONTR_CONV_SERV',
                'SBL_CMS_CONTR_INST_DESIST',
                'SBL_CMS_CONTR_MSISDN_TIT',
                'SBL_CMS_CONTR_PROD',
                'SBL_CMS_DEALER',
                'SBL_CMS_FVI',
                'SBL_ICS_DISPUTE_ACCOUNTS',
                'SBL_DW_005_LOG',
                'SBL_DW_003_LOG',
                'PLAN_TABLE',
                'SBL_DW_001_LOG',
                'SBL_DW_017_LOG',
                'SBL_DW_009_LOG',
                'SBL_DW_006_LOG',
                'SBL_DW_019_LOG',
                'TMP_FRAUDE',
                'SBL_ICS_NUM_MSISDN',
                'SBL_ICS_MOTIVO_ALTERACAO',
                'SBL_DW_FIXOS',
                'SBL_DW_VPN'
                 )
             )
order by status, last_call_et;

