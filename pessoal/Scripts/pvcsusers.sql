select c.UGNAME, a.USRFULLNM, a.USRLOGINID, a.USRTEL, a.USREMAIL
  from CENTRAL.TRKUSR a,
       CENTRAL.TRKUGE b,
       CENTRAL.TRKUG  c
 where a.USRFLAGS = 0
   and c.UGID  = b.UGEUGID
   and a.USRID = b.UGEUSRID
order by UGNAME, USRFULLNM
