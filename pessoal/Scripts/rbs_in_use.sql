set linesize 100 pages 45
set pause on
set pause ENTER
set verify off message off echo off timing off time off
set feedback off
column osuser format a8 heading 'O/S|User'
column username format a10 heading 'Oracle|Userid'
column segment_name format a12 heading 'R-S|Name'
column sql_text format a45 heading 'Current Statement' word

select username,
       osuser,
       sid,
       r.segment_name,
       seg.extents,
       t.used_ublk,
       sa.sql_text
from   v$session s,
       v$transaction t,
       dba_rollback_segs r,
       v$sqlarea sa,
       dba_segments seg
where  s.taddr = t.addr
and    t.xidusn = r.segment_id(+)
and    s.sql_address = sa.address(+)
and    seg.segment_name=r.segment_name
/

set verify on
set message on
set lines 150
column osuser clear
column username clear
column segment_name clear
column sql_text clear

select segment_name, extents from dba_segments where segment_type='ROLLBACK'
/