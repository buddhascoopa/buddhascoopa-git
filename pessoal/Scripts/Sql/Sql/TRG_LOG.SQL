CREATE OR REPLACE TRIGGER TLOG$_PESSOA
after insert or update or delete on DG3.PESSOA
referencing old as old  
for each row
declare    
  dmltype char;  
begin    
 if     inserting then dmltype := 'I';    
 elsif  updating  then dmltype := 'U';
 elsif  deleting  then dmltype := 'D';
 end if;    
 insert into DG3.MLOG$_PESSOA
   ( m_row$$, dmltype$$, COD_PESSOA )
 values ( :OLD.rowid, dmltype, :NEW.COD_PESSOA ); 
end;
/

CREATE OR REPLACE TRIGGER TLOG$_PESSOA2
after insert or update or delete on DG3.PESSOA
declare
begin 

 update mlog$_PESSOA a
    set a.m_row$$ = ( select rowid from PESSOA b 
                      where b.COD_PESSOA =  
			    a.COD_PESSOA );  

end;
/