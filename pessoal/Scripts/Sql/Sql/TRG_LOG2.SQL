CREATE OR REPLACE TRIGGER TLOG$_NOTA_FISCAL_PARCL_LI
after insert or update or delete on ig2.nota_fiscal_parcl_linha
referencing old as old  
for each row
declare    
  dmltype char;  
begin    
 if     inserting then dmltype := 'I';    
 elsif  updating  then dmltype := 'U';
 elsif  deleting  then dmltype := 'D';
 end if;    
 insert into IG2.MLOG$_NOTA_FISCAL_PARCL_LI 
   ( m_row$$, dmltype$$, COD_SEQ_NOTA_FISCAL_PARCL, NUM_LINHA )
 values ( :OLD.rowid, dmltype, :NEW.COD_SEQ_NOTA_FISCAL_PARCL,
                               :NEW.NUM_LINHA ); 
end;
/

CREATE OR REPLACE TRIGGER TLOG$_NOTA_FISCAL_PARCL_LI2
after insert or update or delete on ig2.nota_fiscal_parcl_linha
declare
begin 

 update mlog$_nota_fiscal_parcl_li a 
    set a.m_row$$ = ( select rowid from nota_fiscal_parcl_linha b 
                      where b.COD_SEQ_NOTA_FISCAL_PARCL =  
			    a.COD_SEQ_NOTA_FISCAL_PARCL
                      and   b.NUM_LINHA =
                            a.NUM_LINHA );  

end;
/