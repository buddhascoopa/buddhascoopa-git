select a.sal, 
       count(b.sal),
       sum((a.sal/c.total_sal)*100)
from (select * from emp) a,
     (select distinct sal from emp) b,
     (select sum(sal) total_sal from emp) c
where a.sal <= b.sal
group by a.sal,a.empno
order by sal desc
/
