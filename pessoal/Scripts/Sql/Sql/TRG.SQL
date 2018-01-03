truncate table plan_table
/
explain plan set statement_id='snap' into plan_table
for 
update po.mlog$_po_lines a                          
   set a.m_row$$ = ( select rowid from po.po_lines b
                     where b.po_line_id =           
                           a.po_line_id )          
/
commit
/
@plan

