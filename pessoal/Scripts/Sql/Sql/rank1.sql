select a.dpt, sum((a.gasto/b.soma)*100)
from depto a,
     (select sum(gasto) soma from depto) b
group by a.dpt
/
