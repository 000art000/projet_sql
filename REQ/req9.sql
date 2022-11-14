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