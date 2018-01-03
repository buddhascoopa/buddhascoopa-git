select a.sal, count(b.sal)
from (select * from emp) a,
     (select distinct sal from emp) b
where a.sal <= b.sal
group by a.sal,a.empno
order by sal desc
/
