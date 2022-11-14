/*
    les ports qui ont eux le plus de debarquement 
*/

/* methode 1*/
with T as(
    select count(*) as m from debarquement group by (port,country)
)
select p.name_port,p.country
from port as p, (select port,country,count(*) as nb from debarquement group by (port,country)) as tmp
where p.name_port=tmp.port and p.country=tmp.country 
    and tmp.nb>= all (select m from T )


/*methode 2*/
with T as(
    select count(*) as m from debarquement group by (port,country)
)
select port,country
from debarquement 
group by port,country
having count(*)>=(select max(m) from T)