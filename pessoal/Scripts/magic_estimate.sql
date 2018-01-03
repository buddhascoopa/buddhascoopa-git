select a.status,substr(a.sid||','||a.serial#,1,20) "Ident.",
       substr(a.username,1,10) "Usuário",
       TO_CHAR(b.start_time,'DD-MM-YYYY HH24:MI') "Início",
       round(sofar/totalwork*100,2) "% Complete",
       substr(b.message,1,100) "Mensagem"
 from v$session a, v$session_longops b
 where a.sid = b.sid and
       a.serial# = b.serial# and
       -- a.username = 'SYSTEM' and
       a.sid in (27, 35, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48
        49
        50
        51
        52
        53
        54
        55
and
       round(sofar/totalwork*100,2) < 100
/

