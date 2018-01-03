create or replace procedure ciops(mes in varchar2) is begin

declare
   sinstance1 varchar2(10);
   sdisco1    varchar2(50);
   ddata1     date;
   nio1       number;
   sinstance2 varchar2(10);
   sdisco2    varchar2(50);
   ddata2     date;
   nio2       number;
   ns         number;
   niops      number;
   ndio       number;
   n1         number;
   n2         number;
   n3         number;

   cursor c1(cmes varchar2) is
      select instance,
             substr(disco,1,50),
             to_date(data,'ddmmyy hh24:mi:ss'),
             io
      from ioperf
      where substr(data,3,2) = cmes
      order by 1,2,3
      for update of iops, s, dio;

begin
   set transaction use rollback segment r03;
   open c1 (mes);
   fetch c1 into sinstance1,
                 sdisco1,
                 ddata1,
                 nio1;
   loop
      fetch c1 into sinstance2,
                    sdisco2,
                    ddata2,
                    nio2;
      exit when c1%notfound;
      
      if sinstance1 = sinstance2 and
         sdisco1    = sdisco2    and
         to_char(ddata1,'ddmmyy') = to_char(ddata2,'ddmmyy')
      then
         n1 := ddata2 - ddata1;
         n2 := trunc(n1);
         n3 := n1 - n2;
         
         ns    := (n2 * 86400) + (86400 * n3);
         ndio  := (nio2 - nio1);
         if ndio < 0 then
            ndio := 0;
         end if;
         if ns = 0 then
            niops := 0;
         else
            niops := trunc((ndio/ns),1);
         end if;
         update ioperf 
            set iops = niops, s = ns, dio = ndio where current of c1;
      else
         update ioperf 
            set iops = 0, s = 0, dio = 0 where current of c1;
      end if;
      
      sinstance1 := sinstance2;
      sdisco1    := sdisco2;
      ddata1     := ddata2;
      nio1       := nio2;
   end loop;
   commit;
end;
end ciops;
/