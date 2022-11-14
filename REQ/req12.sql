/*
deux requˆetes qui renverraient le mˆeme r ́esultat si vos tables de contenaient pas
de nulls, mais qui renvoient des r ́esultats diff ́erents ici

pour un debarquement le volume acheter - vendu

*/

select date_d ,date_depart,ship,port,country,sum(A.volume-V.volume) as volume
from acheter as A join vendre as V using(date_d ,date_depart,ship,port,country,produit)
where A.date_depart='1958-06-16' and ship=3 group by date_d ,date_depart,ship,port,country
order by date_d ,date_depart,ship,port,country;

select date_d ,date_depart,ship,port,country,sum(A.volume)-sum(V.volume) as volume
from acheter as A join vendre as V using(date_d ,date_depart,ship,port,country,produit)
where A.date_depart='1958-06-16' and ship=3 group by date_d ,date_depart,ship,port,country
order by date_d ,date_depart,ship,port,country;