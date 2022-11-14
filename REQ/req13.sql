/*
    le bateau qui a fait le plus de service (critere le temps et pas le nombre de voyage)
*/

with T as(
    select ship,extract(year from date_depart)*10000+extract(month from date_depart)*100+extract(day from date_depart) as dat from voyage
    union
    select ship,extract(year from date_arrive)*10000+extract(month from date_arrive)*100+extract(day from date_arrive) as dat from voyage_termine
    union
    select ship,extract(year from date_d)*10000+extract(month from date_d)*100+extract(day from date_d) as dat from debarquement
)
select ship
from T
group by ship
having max(dat)-min(dat) >= all (select max(dat)-min(dat) from T group by ship)
