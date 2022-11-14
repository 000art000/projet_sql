/*
la categorie des produit qui a été vendu dans plus de 80 peurcent des pays
*/


select categorie
from vendre join produit on (produit=num)
group by categorie
having count(distinct(country))*100.0/(select count(*) from country)>80.0
