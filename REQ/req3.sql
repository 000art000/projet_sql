/*
    pour chaque voyage le nombre de categorie de produit de depart
*/


/* methode 1*/
select ship,date_depart, (select count(distinct(categorie)) from quantite_depart join produit on (num=produit) where ship=v.ship and v.date_depart=date_depart) as nbr_cat
from voyage as v
order by ship,date_depart

/* methode 2 */
select ship,date_depart,count(distinct(categorie))
from quantite_depart join produit on (num=produit)
group by ship,date_depart
order by ship,date_depart