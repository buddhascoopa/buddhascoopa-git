Declare
table_name varchar2(20);
Begin
table_name:='MyTable';
trunca(table_name);
end;



create or replace procedure trunca(own in varchar2,tabla in varchar2) as
  CursorId   Integer;
Begin
  CursorId  :=  DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(CursorId,'Truncate table '||own||'.'||tabla||' drop storage',dbms_sql.v7);
  DBMS_SQL.CLOSE_CURSOR(CursorID);
Exception
  When Others then DBMS_SQL.CLOSE_CURSOR(CursorID);
  RAISE;
End trunca;
/