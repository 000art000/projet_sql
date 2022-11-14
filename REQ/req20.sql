/*
    combien les pays en capture de navire dans les année au y'avais le plus de capturation 
*/


with annee as(
    select extract(year from date_capture) as date_capture from capture
    group by extract(year from date_capture) 
    having count(*)>=all(select count(*) from capture group by extract(year from date_capture))
)
select country,count(*) 
from capture join annee on(extract(year from capture.date_capture) = annee.date_capture)
group by country
