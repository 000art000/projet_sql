/*
le voyage qui a eu le plus de passager a un certain moment de voyage par rapport au tout les voyage (debut de voyage non inclus)
*/

with etape as(
select date_depart,ship,nb_personne_monte-nb_personne_descendu+(select nb_passager_depart from voyage where D.ship=ship and D.date_depart=date_depart) as nb
from debarquement as D
)
select date_depart,ship,nb
from etape
where nb>=all(select nb from etape)