/*
    les nations qui on capturé le plus de navire par decennie
*/

with T as(
select country ,  floor(extract(year from date_capture)/10) as decennie,count(*) as nb
from capture
group by country,floor(extract(year from date_capture)/10)
)
select decennie,country,nb_capture
from T as D
where nb>=all (select nb from T where D.decennie=decennie)
order by decennie
