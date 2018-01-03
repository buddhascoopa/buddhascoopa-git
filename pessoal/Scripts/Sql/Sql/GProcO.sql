undef proc
undef owner
accept sowner char prompt 'Entre com a Dono..: '

declare                                     
   fout1 utl_file.file_type;                
   caminho   varchar2(60)   := 'c:\OraTmp';                     
   wowner    varchar2(35)   := upper('&sowner');
   wtext     varchar2(31000):= null;
   wtext1    varchar2(1000) := null;
   wname     varchar2(30)   := ' ';
   wtype     varchar2(12)   := ' ';
   wextfile  varchar2(4);
   warqname  varchar2(35);
   wbuf      number := 0;
   cursor c1 (cowner varchar2) is                         
      select owner, 
             type, 
             name,
             line,
             text
      from sys.dba_source                   
      where owner = cowner
      order by owner, type, name, line;           
begin
   for c1rec in c1 (wowner) loop
      --
      if c1rec.name <> wname then
         if utl_file.is_open(fout1) then
            utl_file.put(fout1,'/');
            utl_file.new_line(fout1,1);
            utl_file.put(fout1,'show errors');
            utl_file.new_line(fout1,1);
            utl_file.fflush(fout1);
            utl_file.fclose(fout1);                  
         end if;  
         if c1rec.type = 'PACKAGE' then
            wextfile := '.pks';
         elsif c1rec.type = 'PACKAGE BODY' then
            wextfile := '.pkb';
         elsif c1rec.type = 'PROCEDURE' then
            wextfile := '.prc';
         elsif c1rec.type = 'FUNCTION' then
            wextfile := '.fct';
         else
            wextfile := '.sql';
         end if;
         warqname := lower(ltrim(rtrim(c1rec.name)))||wextfile;
         --
         fout1 := utl_file.fopen(caminho,warqname,'w');  
         -- utl_file.new_line(fout1,1);
         --
         wname    := c1rec.name; 
         wtype    := c1rec.type;
         warqname := null;
      end if;
      --
      if c1rec.line = 1 then
         if c1rec.type <> wtype then
            utl_file.put(fout1,'/');
            utl_file.new_line(fout1,1);
            --
            wtype := c1rec.type;
         end if;
         --
         utl_file.put(fout1,'create or replace ');
         wtext := ltrim(substr(c1rec.text,1,instr(c1rec.text,chr(10))-1));
         utl_file.put_line(fout1,wtext);
      else
         wtext := substr(c1rec.text,1,instr(c1rec.text,chr(10))-1);
         if length(wtext) > 1000 then
            wtext1 := substr(wtext,1,1000);
            utl_file.put_line(fout1,wtext1);
            wtext1 := substr(wtext,1001);
            utl_file.put_line(fout1,wtext1);
         else
            utl_file.put_line(fout1,wtext);
         end if;
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