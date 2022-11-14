/*
les couples des ports (p1,p2) ou il existe un voyage de p1 vers p2 et un voyage de p2 vers p1
*/

select  distinct(v1.port_depart,v1.country_depart,v1.port_arrive,v1.country_arriver)
from voyage as v1 , voyage as v2
where v1.port_depart=v2.port_arrive and v1.port_arrive=v2.port_depart and v1.country_depart=v2.country_arriver and v2.country_depart=v1.country_arriver 
and v1.port_depart<=v2.port_arrive


