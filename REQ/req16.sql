/*

les navires capturés (affichage nation qui a capturé,navire,nation avant capturation,date de capture) par les pays qui ont plus de 30 % d'ennemies 

*/


with T as(
    select country_1,country_2,diplomatique
    from relation_diplomatique
    union
    select country_2 as country_1,country_1 as country_2,diplomatique
    from relation_diplomatique
),
le_plus as(
select country_1 as country,count(*)*100.0/((select count(*) from country )-1) as prc
from T 
where diplomatique ='guerre'
group by country_1
having count(*)*100.0/((select count(*) from country )-1)>30.0
),
tout_capturation as(
    select A.country as country_new, B.country as country_prec ,A.ship ,A.date_capture from Capture A,Capture B where A.ship=B.ship and A.date_capture>B.date_capture and not exists(
    select * from capture c where c.ship=A.ship and c.date_capture>B.date_capture and c.date_capture<A.date_capture )
    union
    select tmp.country as country_new, b.country as country_prec, tmp.ship, date_capture
    from capture as tmp, ship as b
    where not exists (select * from capture where tmp.ship=ship and date_capture<tmp.date_capture)
    and b.id=tmp.ship
)
select country,ship,country_prec,date_capture
from tout_capturation join le_plus on (country_new=country)
order by country,date_capture



