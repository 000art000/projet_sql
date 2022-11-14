\echo requete_1

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
);

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
having count(distinct(categorie))=(select nb from num_produit) ;


\echo requete_2

/*
les couples des ports (p1,p2) ou il existe un voyage de p1 vers p2 et un voyage de p2 vers p1
*/

select  distinct(v1.port_depart,v1.country_depart,v1.port_arrive,v1.country_arriver)
from voyage as v1 , voyage as v2
where v1.port_depart=v2.port_arrive and v1.port_arrive=v2.port_depart and v1.country_depart=v2.country_arriver and v2.country_depart=v1.country_arriver 
and v1.port_depart<=v2.port_arrive ;

\echo requete_3

/*
    pour chaque voyage le nombre de categorie de produit de depart
*/


/* methode 1*/
select ship,date_depart, (select count(distinct(categorie)) from quantite_depart join produit on (num=produit) where ship=v.ship and v.date_depart=date_depart) as nbr_cat
from voyage as v
order by ship,date_depart;

/* methode 2 */
select ship,date_depart,count(distinct(categorie))
from quantite_depart join produit on (num=produit)
group by ship,date_depart
order by ship,date_depart ;

\echo requete_4

/*
les ports qui n'ont jamais eux  de debarquement
*/

/*methode 1*/
select name_port ,country from port as p
where not exists (
    select * from debarquement where p.country=country and p.name_port=port
)
;
/*methode 2*/
select name_port ,country from port 
where (name_port,country) not in (select port ,country from debarquement)
;
/*methode 3*/
select name_port ,country from port 
except
select port ,country from debarquement
;
\echo requete_5

/*
    les ports qui ont eux le plus de debarquement 
*/

/* methode 1*/
with T as(
    select count(*) as m from debarquement group by (port,country)
)
select p.name_port,p.country
from port as p, (select port,country,count(*) as nb from debarquement group by (port,country)) as tmp
where p.name_port=tmp.port and p.country=tmp.country 
    and tmp.nb>= all (select m from T )
;

/*methode 2*/
with T as(
    select count(*) as m from debarquement group by (port,country)
)
select port,country
from debarquement 
group by port,country
having count(*)>=(select max(m) from T)
;

\echo requete_6

/*
    les navires qui ont effectuer le plus de voyage depuis 1950
*/


/*methode 1*/
select b.id
from ship as b,( select ship,COALESCE(count(date_depart),0) as nb from voyage where extract(year from date_depart)>1950 group by ship ) as tmp
where b.id=tmp.ship and nb>= all (select count(date_depart) from voyage where extract(year from date_depart)>1950 group by ship)
;

/*methode 2*/
with nbr as(
    select count(date_depart) as m from voyage where extract(year from date_depart)>1950 group by ship
)
select b.id
from ship as B
where (select count(ship) from voyage where B.id=ship and extract(year from date_depart)>1950)>=all(select m from nbr) 
;

/*methode 3*/
with nbr as(
    select count(date_depart) as m from voyage where extract(year from date_depart)>1950 group by ship
)
select ship as id
from voyage
where extract(year from date_depart)>1950 
group by ship
having count(*)>=all(select m from nbr) 
;

\echo requete_7

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
;

/*methode 2*/
select name , (select count(*) from capture where C.name=country)
from country as C
where (select count(*) from capture where C.name=country)>=2 and (select count(*) from capture where C.name=country)<=10
order by (select count(*) from capture where C.name=country)
;

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
;

\echo requete_8

/*
    le maximum de la moyenne de nbr passager au depart pour chaque bateau
*/
with T as(
	select avg(nb_passager_depart) as nb from voyage group by ship 
)
select max(nb)
from T
;

\echo requete_9

/*
    les iteneraire qui'étais possible depuis 2015
*/

with RECURSIVE let_possible(port_depart,port_arrive,date_depart,date_arrive) as(
    with tmp as(
    select A.port_depart,A.port_arrive,A.date_depart,B.date_arrive from voyage A join voyage_termine B on (A.date_depart=B.date_depart and A.ship=B.ship )
    where A.date_depart>'2015-01-01' 
    )
    select * from tmp
    union 
    SELECT T.port_depart, L.port_arrive,T.date_depart,L.date_arrive
    FROM tmp T, let_possible L
    WHERE T.port_arrive = L.port_depart and L.date_depart>T.date_arrive
)
select * from let_possible 
;

\echo requete_10

/*

    l'evaluation de peurcentage de volume pour chaque voyage etape par etape

*/


with depart as(
    select date_depart,ship,date_depart as date_d,port_depart as port,country_depart as country,sum(volume) as volume
    from quantite_depart join voyage using (date_depart,ship)
    group by date_depart,ship,port_depart,country_depart
),
etape as(
select date_depart,ship,date_d,port,country,
    (coalesce((select volume from depart where D.date_depart=date_depart and D.ship=ship),0) + 
    coalesce((select sum(volume) from acheter as A where  A.ship=D.ship and A.date_depart=D.date_depart and A.date_d<=D.date_d),0) - 
    coalesce((select sum(volume) from vendre as A where A.ship=D.ship and A.date_depart=D.date_depart and A.date_d<=D.date_d),0) ) as volume
from debarquement as D

union

select * from depart

)
select ship,date_depart,date_d,port,country,round(CAST((volume / (select volume from ship where E.ship=id)*100.0) as numeric),2) as prc_volume
from etape as E
where ship not in (select id from ship where volume=0)
order by ship,date_depart,date_d,port,country
;

\echo requete_11

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
;

\echo requete_12

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
;

\echo requete_13

/*
    le bateau qui a fait le plus de service (critere le temps et pas le nombre de voyage)
*/

with T as(
    select ship,extract(year from date_depart)*10000+extract(month from date_depart)*100+extract(day from date_depart) as dat from voyage
    union
    select ship,extract(year from date_arrive)*10000+extract(month from date_arrive)*100+extract(day from date_arrive) as dat from voyage_termine
    union
    select ship,extract(year from date_d)*10000+extract(month from date_d)*100+extract(day from date_d) as dat from debarquement
)
select ship
from T
group by ship
having max(dat)-min(dat) >= all (select max(dat)-min(dat) from T group by ship)
;

\echo requete_14

/*
    les nations qui on capturé le plus de navire par decennie
*/

with T as(
select country ,  floor(extract(year from date_capture)/10) as decennie,count(*) as nb
from capture
group by country,floor(extract(year from date_capture)/10)
)
select decennie,country,nb_capture
from T as D
where nb>=all (select nb from T where D.decennie=decennie)
order by decennie
;

\echo requete_15

/*
les voyages qui ont fait en moins 3 mouillage puis il se sont fait capturer en sain d un voyage
*/

/*methode 1*/
select ship,date_depart
from debarquement as v
where (ship,date_depart) not in (select ship,date_depart from voyage_termine) and mouillage is true
group by ship,date_depart
having count(*)>2
;

\echo requete_16

/*

les navires capturés (affichage nation qui a capturé,navire,nation avant capturation,date de capture) par les pays qui ont plus de 30 % d'ennemies 

*/


with T as(
    select country_1,country_2,diplomatique
    from relation_diplomatique
    union
    select country_2 as country_1,country_1 as country_2,diplomatique
    from relation_diplomatique
),
le_plus as(
select country_1 as country,count(*)*100.0/((select count(*) from country )-1) as prc
from T 
where diplomatique ='guerre'
group by country_1
having count(*)*100.0/((select count(*) from country )-1)>30.0
),
tout_capturation as(
    select A.country as country_new, B.country as country_prec ,A.ship ,A.date_capture from Capture A,Capture B where A.ship=B.ship and A.date_capture>B.date_capture and not exists(
    select * from capture c where c.ship=A.ship and c.date_capture>B.date_capture and c.date_capture<A.date_capture )
    union
    select tmp.country as country_new, b.country as country_prec, tmp.ship, date_capture
    from capture as tmp, ship as b
    where not exists (select * from capture where tmp.ship=ship and date_capture<tmp.date_capture)
    and b.id=tmp.ship
)
select country,ship,country_prec,date_capture
from tout_capturation join le_plus on (country_new=country)
order by country,date_capture
;

\echo requete_17

/*
la categorie des produit qui a été vendu dans plus de 80 peurcent des pays
*/


select categorie
from vendre join produit on (produit=num)
group by categorie
having count(distinct(country))*100.0/(select count(*) from country)>80.0
;

\echo requete_18

/*
    les voyage qui on la distance et variante de produit le plus
*/

/*methode 1*/
with T as(   
    select date_depart,ship,distance,count(distinct(produit)) as nb
    from voyage_termine join quantite_depart using (date_depart,ship) 
    group by (date_depart,ship) 
)
select date_depart,ship
from T
order by (distance,nb) DESC
limit 1
;
/*methode 2*/
with nbr as(
    select count(*) as nb from produit
),
T as(   
    select date_depart,ship,distance*(10*length(cast( (select nb from nbr) as text)))+count(distinct(produit)) as nb
    from voyage_termine join quantite_depart using (date_depart,ship) 
    group by (date_depart,ship) 
)
select date_depart,ship from T
where nb >= all(select nb from T)
;
/*methode 3*/
with nbr as(
    select count(*) as nb from produit
),
T as(   
    select date_depart,ship,distance*(10*length(cast( (select nb from nbr) as text)))+count(distinct(produit)) as nb
    from voyage_termine join quantite_depart using (date_depart,ship) 
    group by (date_depart,ship) 
)
select date_depart,ship from T as A
where not exists (select * from T where A.nb<nb)
;
\echo requete_19

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
;

/*methode 2*/
select 
    count(*) as voyage , 
    count(*)-( select count(*) from voyage where (date_depart,ship) not in (select date_depart,ship from voyage_termine) ) as voyage_termine,
    count(*)-(select count(*) from voyage_termine) as voyage_non_termine
from voyage
;

\echo requete_20

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
;

