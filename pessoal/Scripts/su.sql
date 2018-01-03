-------------------------------------------------------------------------------
--
-- Script:	su.sql
-- Purpose:	to connect as another user without knowing their password
--
-- Author:  Steve Adams/Carlos Victor
-------------------------------------------------------------------------------

set termout off
set verify off
set echo off
set pagesize 0
set linesize 61
column line1 format a60
column line2 format a60
column line3 format a60
spool su.tmp

select
  'alter user &1 identified by sesame;'  line1,
  'connect &1/sesame@&2'  line2,
  'alter user &1 identified by values ''' || password || ''';'  line3
from
  sys.dba_users
where
  username = upper('&1')
/
spool off

@su.tmp
--host rm -f su.tmp	-- for Unix
--host del su.tmp		-- for others

define Prompt = "SQL> "

set termout off
select
  user || ' @ ' || instance_name || ':' || chr(10) || 'SQL> '  prompt
from
  sys.v_$instance
/
set termout on
set sqlprompt "&Prompt"

show user

set termout on
