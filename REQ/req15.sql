/*
les voyages qui ont fait en moins 3 mouillage puis il se sont fait capturer au sein d un voyage
*/

/*methode 1*/
select ship,date_depart
from debarquement as v
where (ship,date_depart) not in (select ship,date_depart from voyage_termine) and mouillage is true
group by ship,date_depart
having count(*)>2

