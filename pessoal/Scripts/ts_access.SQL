select sid, serial#, username, osuser, machine, to_char(logon_time, 'dd/mm/yyyy hh24:mi:ss') logon, command, program, module, status, last_call_et
from v$session
where sid in (select SID
                from v$access
               where object in (select segment_name
                                  from dba_segments
                                 where tablespace_name in ('CDR_DATA_NEW_G',
                                                           'TELEMAR_CDR_DATA_G',
                                                           'CUST_CDR_DATA_IDX',
                                                           'TELEMAR_CDR_DATA_IDX_G'
                                                          )
                               )
             )
order by status, last_call_et;

