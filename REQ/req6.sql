/*
    les navires qui ont effectuer le plus de voyage depuis 1950
*/


/*methode 1*/
select b.id
from ship as b,( select ship,COALESCE(count(date_depart),0) as nb from voyage where extract(year from date_depart)>1950 group by ship ) as tmp
where b.id=tmp.ship and nb>= all (select count(date_depart) from voyage where extract(year from date_depart)>1950 group by ship)

/*methode 2*/
with nbr as(
    select count(date_depart) as m from voyage where extract(year from date_depart)>1950 group by ship
)
select b.id
from ship as B
where (select count(ship) from voyage where B.id=ship and extract(year from date_depart)>1950)>=all(select m from nbr) 


/*methode 3*/
with nbr as(
    select count(date_depart) as m from voyage where extract(year from date_depart)>1950 group by ship
)
select ship as id
from voyage
where extract(year from date_depart)>1950 
group by ship
having count(*)>=all(select m from nbr) 


