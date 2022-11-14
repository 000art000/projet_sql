
/*
    nombre de voyage ,nombre voyage terminé , nombre non terminé
*/

/*methode 1*/
select type_voyage,count(*)
from (
    select (CASE WHEN date_arrive IS NULL THEN 'voyage non termine' ELSE 'voyage termine' END) as type_voyage , date_depart,ship
    from voyage left join voyage_termine using (date_depart,ship)
    union
    select 'voyage' as type_voyage ,date_depart,ship from voyage
) as voyage
group by type_voyage

/*methode 2*/
select 
    count(*) as voyage , 
    count(*)-( select count(*) from voyage where (date_depart,ship) not in (select date_depart,ship from voyage_termine) ) as voyage_termine,
    count(*)-(select count(*) from voyage_termine) as voyage_non_termine
from voyage
