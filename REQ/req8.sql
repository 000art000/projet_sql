/*
    le maximum de la moyenne de nbr passager au depart pour chaque bateau
*/

with T as(
	select avg(nb_passager_depart) as nb from voyage group by ship 
)
select max(nb)
from T
