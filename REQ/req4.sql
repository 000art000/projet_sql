/*
les ports qui n'ont jamais eux  de debarquement
*/

/*methode 1*/
select name_port ,country from port as p
where not exists (
    select * from debarquement where p.country=country and p.name_port=port
)

/*methode 2*/
select name_port ,country from port 
where (name_port,country) not in (select port ,country from debarquement)

/*methode 3*/
select name_port ,country from port 
except
select port ,country from debarquement
