/*
    les voyage qui on la distance et variante de produit le plus
*/

/*methode 1*/
with T as(   
    select date_depart,ship,distance,count(distinct(produit)) as nb
    from voyage_termine join quantite_depart using (date_depart,ship) 
    group by (date_depart,ship) 
)
select date_depart,ship
from T
order by (distance,nb) DESC
limit 1

/*methode 2*/
with nbr as(
    select count(*) as nb from produit
),
T as(   
    select date_depart,ship,distance*(10*length(cast( (select nb from nbr) as text)))+count(distinct(produit)) as nb
    from voyage_termine join quantite_depart using (date_depart,ship) 
    group by (date_depart,ship) 
)
select date_depart,ship from T
where nb >= all(select nb from T)

/*methode 3*/
with nbr as(
    select count(*) as nb from produit
),
T as(   
    select date_depart,ship,distance*(10*length(cast( (select nb from nbr) as text)))+count(distinct(produit)) as nb
    from voyage_termine join quantite_depart using (date_depart,ship) 
    group by (date_depart,ship) 
)
select date_depart,ship from T as A
where not exists (select * from T where A.nb<nb)