set termout off
column global_name new_value prompt
select global_name||'> ' global_name from global_name;
set sqlprompt "&prompt"
set termout on
