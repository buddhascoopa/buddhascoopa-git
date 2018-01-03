DELETE PLAN_TABLE WHERE STATEMENT_ID='CUSTO';                                   
COMMIT;                                                                         
EXPLAIN PLAN SET STATEMENT_ID='CUSTO' INTO PLAN_TABLE FOR                       
select  1 
from    mtl_material_transactions       mmt 
        , mtl_system_items              msi                                    
        , rcv_transactions             	rt                                     
        , mtl_item_categories          	mic                                    
        , mtl_category_sets            	mcs                                    
        , mtl_categories               	mc                                     
        , preco_reposi_gerenc           prg                                    
        , paride_moeda                 	pm                                     
        , hr_organization_units        	hou1                                   
where   trunc(mmt.transaction_date)   between add_months(trunc(sysdate),-4)
  and trunc(sysdate)       
  and   mmt.transaction_type_id	= 18                                     
  and   hou1.organization_id   	= mmt.organization_id                    
  and   hou1.date_to           	is null                                  
  and   hou1.attribute1        	= 083                                    
  and   msi.inventory_item_id  	= mmt.inventory_item_id                  
  and   msi.organization_id    	= mmt.organization_id                    
  and   rt.transaction_id      	= mmt.rcv_transaction_id                 
  and   mic.organization_id    	= 1
  and   mic.inventory_item_id  	= mmt.inventory_item_id                  
  and   mic.category_set_id    	in (21,24,25,33) /* MP, CPD, SBS, Fumo */
  and   mcs.category_set_id    	= mic.category_set_id                    
  and   prg.cod_emp             		= 083 
  and   prg.cod_produt_generc 	= to_number(msi.segment1)                
  and   prg.dat_anomes         	= to_char(mmt.transaction_date, 'yyyymm')
  and   prg.cod_moeda          	= 30 /* Real */                          
  and   pm.cod_moeda_princ     	= 11 /* Dolar */                         
  and   pm.cod_moeda_secund    	= 30 /* Real */                          
  and   pm.cod_tipo_cotac      	= 'V' /* venda */                        
  and   pm.cod_tipo_merc_paride	= 'C' /* Compra */                       
  and   pm.cod_tipo_serie      	= 'R' /* valor real */                   
  and   pm.dat_cotac_paride    	= to_date(to_char(mmt.transaction_date,'yyyymm'), 'yyyymm')

/
commit;
 
SELECT SUBSTR(LPAD(' ',2*(LEVEL-1)) || OPERATION,1,30) OPER, 
       SUBSTR(OPTIONS,1,13) OPTIONS,
       SUBSTR(OBJECT_NAME,1,15) OBJ_NAME, SUBSTR(POSITION,1,3) POS
  FROM PLAN_TABLE
  START WITH ID=0 AND STATEMENT_ID = 'CUSTO'
  CONNECT BY PRIOR ID = PARENT_ID AND STATEMENT_ID = 'CUSTO'
/
