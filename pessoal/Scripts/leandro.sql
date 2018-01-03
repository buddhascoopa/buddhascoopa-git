select name,
       to_char(dq.created,'dd/mm/yyyy hh24:mi:ss'),
       to_char(dq.VERIFY_DT,'dd/mm/yyyy hh24:mi:ss'),
       to_char(dq.REV_DT,'dd/mm/yyyy hh24:mi:ss'),
       to_char(dq.PRICING_DT,'dd/mm/yyyy hh24:mi:ss')
from siebel.s_doc_quote dq
where created > to_date('20030319000000','yyyymmddhh24miss')
  and (dq.VERIFY_DT is not null and dq.REV_DT is not null and dq.PRICING_DT is null)
order by created

select * from dba_jobs

select sum(bytes)/1024/1024 from dba_extents where owner='PERFSTAT'

declare
jobno number;
begin
DBMS_JOB.remove(67);
end;
