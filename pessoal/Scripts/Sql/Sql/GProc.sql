undef sname
undef sowner
accept sowner char prompt 'Entre com a Dono..: '
accept sname  char prompt 'Entre com o Nome..: '

declare                                     
   fout1 utl_file.file_type;                
   caminho   varchar2(60)   := '/oracle/temp';                     
   wowner    varchar2(35)   := upper('&sowner');
   wtext     varchar2(1000) := null;
   wname     varchar2(30)   := upper('&sname');
   wtype     varchar2(12)   := ' ';
   warqname  varchar2(35);
   waux      boolean := true;
   cursor c1 (cowner varchar2, cname varchar2) is                         
      select owner, 
             type, 
             name,
             line,
             text
      from sys.dba_source                   
      where owner = cowner
        and name  = cname
      order by owner, name, type, line;           
begin
   for c1rec in c1 (wowner, wname) loop
      --
      if waux then
         warqname := lower(ltrim(rtrim(c1rec.name)))||'.sql';
         --
         fout1 := utl_file.fopen(caminho,warqname,'w');  
         utl_file.put(fout1,'spool ');
         utl_file.put(fout1,lower(ltrim(rtrim(c1rec.name))));
         utl_file.put(fout1,'.log');
         utl_file.new_line(fout1,1);
         --
         wtype    := c1rec.type;
         warqname := null;
         waux     := false;
      end if;
      --
      if c1rec.line = 1 then
         if c1rec.type <> wtype then
            if utl_file.is_open(fout1) then
               utl_file.put(fout1,'/');
               utl_file.new_line(fout1,1);
               utl_file.put_line(fout1,'show errors');
               utl_file.new_line(fout1,1);
               utl_file.fflush(fout1);
            end if;
            --
            wtype := c1rec.type;
         end if;
         --
         utl_file.put(fout1,'create or replace ');
         utl_file.put(fout1,c1rec.type);
         utl_file.put(fout1,' ');
         utl_file.put(fout1,c1rec.owner);
         utl_file.put(fout1,'.');
         utl_file.put(fout1,c1rec.name);
         if c1rec.type = 'PACKAGE' or c1rec.type = 'PACKAGE BODY' then
            utl_file.put(fout1,' as ');
         elsif c1rec.type = 'PROCEDURE' then
            utl_file.put(fout1,' is begin ');
         end if;
         utl_file.new_line(fout1,1);
      else
         wtext := substr(c1rec.text,1,instr(c1rec.text,chr(10))-1);
         utl_file.put_line(fout1,wtext);
         wtext := null;
      end if;
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