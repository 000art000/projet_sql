/*
les bateau qui ont transporté tout les categories de produit en moins dans un voyage
*/

/* methode 1*/
with p_b as(
    select produit,ship,date_depart from quantite_depart 
            union
    select produit,ship,date_depart from acheter 
)
select distinct(ship) as bateau
from voyage as B
where not exists (
    select * from categorie_produit as C
    where not exists (
        select * from p_b join produit on (produit=num)
        where ship=B.ship and B.date_depart=date_depart and categorie=c.num
    )
)

/*methode 2*/
with p_b as(
    select produit,ship,date_depart from quantite_depart
        union
    select produit,ship,date_depart from acheter
),
num_produit as(
    select count(*) as nb from categorie_produit
)
select ship as bateau
from p_b join produit on (produit=num)
group by ship,date_depart
having count(distinct(categorie))=(select nb from num_produit) 
