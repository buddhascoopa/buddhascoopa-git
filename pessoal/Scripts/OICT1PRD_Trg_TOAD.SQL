alter trigger SYSTEM.BLOQTOAD disable
alter trigger SYSTEM.BLOQTOAD enable

create or replace trigger SYSTEM.BLOQTOAD
after logon on database
declare
   W_PROGRAM   varchar2(48);
   W_MODULE    varchar2(48);
   W_USERNAME  varchar2(30) := USER;
   W_OSUSER    varchar2(30);
   W_AUDSID    number;
begin
   --
   select upper( PROGRAM ), upper( MODULE ), upper( OSUSER )
     into W_PROGRAM, W_MODULE, W_OSUSER
     from SYS.V_$SESSION
    where AUDSID = userenv( 'SESSIONID' );
   --
   if W_USERNAME = 'ARBOR' and W_OSUSER not in ( '94211',
                                                 'CON12454',
                                                 'CON9053',
                                                 'CON8087',
                                                 'CON7611',
                                                 'CON12019',
                                                 'CON12494',
                                                 'CON12445'
                                                )
   then
      raise_application_error( -20001,'NÃO É PERMITIDO CONECTAR COMO ''ARBOR'' EM PRODUÇÃO! - ESTA TENTATIVA FOI REGISTRADA!');
   end if;
   --
   if ( W_PROGRAM in ( 'TOAD.EXE', 'TOAD' ) or W_MODULE like '%T_O_A_D%' ) and
        W_USERNAME not in ( 'ARBOR',
                            'CON8829',
                            'CON12222',
                            'OI92842',
                            'CON6018',
                            'CON12408',
                            'OI81755',
                            'OI67102',
                            'OI74801',
                            'OI100242',
                            'C62252',
                            'CON12275',
                            'CON12211',
                            'CON12336',
                            'CON12227',
                            'CON11356',
                            'PALOMAP',
                            'CON3915',
                            'OI94213',
                            'OI60505' ) then
      raise_application_error(-20001,'Programa NÃO PERMITIDO em BASE de PRODUÇÃO');
   end if; 
   --
end;
/   
