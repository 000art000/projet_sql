/*

    l'evaluation de peurcentage de volume pour chaque voyage etape par etape

*/


with depart as(
    select date_depart,ship,date_depart as date_d,port_depart as port,country_depart as country,sum(volume) as volume
    from quantite_depart join voyage using (date_depart,ship)
    group by date_depart,ship,port_depart,country_depart
),
etape as(
select date_depart,ship,date_d,port,country,
    (coalesce((select volume from depart where D.date_depart=date_depart and D.ship=ship),0) + 
    coalesce((select sum(volume) from acheter as A where  A.ship=D.ship and A.date_depart=D.date_depart and A.date_d<=D.date_d),0) - 
    coalesce((select sum(volume) from vendre as A where A.ship=D.ship and A.date_depart=D.date_depart and A.date_d<=D.date_d),0) ) as volume
from debarquement as D

union

select * from depart

)
select ship,date_depart,date_d,port,country,round(CAST((volume / (select volume from ship where E.ship=id)*100.0) as numeric),2) as prc_volume
from etape as E
where ship not in (select id from ship where volume=0)
order by ship,date_depart,date_d,port,country


