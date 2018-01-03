set serveroutput on
declare
file_location varchar2(256) := '<path>';
file_name     varchar2(256) := '<filename>';
file_text     varchar2(256) := '<texto>';
file_id       utl_file.file_type;
begin
  file_id := utl_file.fopen(file_location, file_name, 'W');
  utl_file.put_line(file_id, file_text);
  utl_file.fclose(file_id);
exception when utl_file.invalid_path then
  dbms_output.put_line('Invalid path ' || sqlerrm);
when others then
  dbms_output.put_line('Others '|| sqlcode || ' ' || sqlerrm);
end;
