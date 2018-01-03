undef trig
undef owner
accept sowner char prompt 'Entre com a Dono..: '

declare                                     
   fout1 utl_file.file_type;                
   caminho   varchar2(60)   := 'c:\OraTmp';                     
   wowner    varchar2(35)   := upper('&sowner');
   wtext     varchar2(1000) := null;
   wtexttmp  varchar2(32000):= null;
   wname     varchar2(30)   := ' ';
   wtype     varchar2(16)   := ' ';
   warqname  varchar2(35);
   wbuf      number := 0;
   wposi     number := 1;
   wposf     number := 1;
   cursor c1 (cowner varchar2) is                         
      select owner, 
             trigger_type, 
             trigger_name,
             triggering_event,
             table_owner,
             table_name,
             referencing_names,
             when_clause,
             description,
             trigger_body
      from sys.dba_triggers                   
      where owner = cowner
      order by table_owner, table_name, trigger_type, trigger_name;           
begin
   for c1rec in c1 (wowner) loop
      --
      if c1rec.trigger_name <> wname then
         if utl_file.is_open(fout1) then
            utl_file.put(fout1,'/');
            utl_file.new_line(fout1,1);
            utl_file.put(fout1,'show errors');
            utl_file.new_line(fout1,1);
            utl_file.put(fout1,'spool off');
            utl_file.new_line(fout1,1);
            utl_file.fflush(fout1);
            utl_file.fclose(fout1);                  
         end if;  
         warqname := lower(ltrim(rtrim(c1rec.trigger_name)))||'.sql';
         --
         fout1 := utl_file.fopen(caminho,warqname,'w');  
         utl_file.put(fout1,'spool ');
         utl_file.put(fout1,lower(ltrim(rtrim(c1rec.trigger_name))));
         utl_file.put(fout1,'.log');
         utl_file.new_line(fout1,1);
         --
         wname    := c1rec.trigger_name; 
         wtype    := c1rec.trigger_type;
         warqname := null;
      end if;
      --
      utl_file.put(fout1,'create or replace trigger ');
      utl_file.put(fout1,c1rec.owner);
      utl_file.put(fout1,'.');
      utl_file.put(fout1,c1rec.description);
      utl_file.new_line(fout1,1);
      --
      utl_file.put_line(fout1,c1rec.trigger_body);
   end loop;                                
   utl_file.put(fout1,'/');
   utl_file.new_line(fout1,1);
   utl_file.put(fout1,'show errors');
   utl_file.new_line(fout1,1);
   utl_file.put(fout1,'spool off');
   utl_file.new_line(fout1,1);
   utl_file.fflush(fout1);
   utl_file.fclose(fout1);                  
end;                                        
/