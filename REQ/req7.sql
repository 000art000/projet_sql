/*
les pays qui ont au minimum capture 2 bateau et au maximume 10 entre 1950 et 1980
*/

/*methode 1*/
select country , count(distinct(ship)) nb
from capture 
where (date_capture>='1950-01-01' or date_capture<'1981-01-01')
group by country
having count(distinct(ship))>=2 and count(distinct(ship))<=10
order by count(distinct(ship))

/*methode 2*/
select name , (select count(*) from capture where C.name=country)
from country as C
where (select count(*) from capture where C.name=country)>=2 and (select count(*) from capture where C.name=country)<=10
order by (select count(*) from capture where C.name=country)

/*methode 3*/
with T as(
    select country,count(*) as nb
    from capture
    group by country
)
select country,nb
from T
where nb >=2 and nb <=10
order by nb