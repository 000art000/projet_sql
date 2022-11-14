drop table if exists country cascade;
drop table if exists port cascade;
drop table if exists ship cascade;
drop table if exists relation_diplomatique cascade;
drop table if exists categorie_produit cascade;
drop table if exists produit cascade;
drop table if exists quantite_depart cascade;
drop table if exists vendre cascade;
drop table if exists acheter cascade;
drop table if exists voyage cascade;
drop table if exists voyage_termine cascade;
drop table if exists capture cascade;
drop table if exists debarquement cascade;

create table country(
    name text,
    continent text not null,
    constraint pk_country primary key (name),
    constraint check_continent check (continent in ('ASIA','AFRICA','EUROPE','AMERICA'))
);

create table port(
    name_port text not null,
    localisation varchar(5),
    country text,
    categorie integer not null,
    constraint fk_country foreign key (country) references country (name) on update cascade on delete cascade,
    constraint pk_port primary key (name_port,country),
    constraint check_categorie check (categorie in (1,2,3,4,5)),
    constraint check_localisation check (localisation in ('west','ouest','south','north'))
);

create table ship (
    id serial,
    type_s text not null,
    categorie integer not null,
    volume real not null,
    nb_passager integer not null,
    country text,
    constraint check_categorie check (categorie in (1,2,3,4,5)),
    constraint fk_country foreign key (country) references country (name) on update cascade on delete cascade,
    constraint pk_ship primary key (id)
);

create table relation_diplomatique(
    country_1 text,
    country_2 text,
    diplomatique text not null check (diplomatique in ('alliees commerciaux', 'alliees', 'neutres', 'guerre')),
    constraint fk_country_1 foreign key (country_1) references country(name) on delete cascade on update cascade,
    constraint fk_country_2 foreign key (country_2) references country(name) on delete cascade on update cascade,
    constraint check_country check (country_1 != country_2),
    constraint pk_relation_diplomatique primary key (country_1,country_2),
    constraint noo_doublons check (country_1<country_2)
);

create table categorie_produit(
    num serial primary key,
    discription text not null
);

create table produit(
    num serial primary key,
    name text not null,
    type_p text not null,
    categorie integer ,
    unite text not null,
    constraint check_unite check (unite in ('kg','m3','l','m2','m')),
    constraint fk_categorie foreign key (categorie) references categorie_produit(num) on delete cascade on update cascade,
    constraint check_type_p check(type_p in ('sec' ,'perissable'))
);

create table voyage(
    date_depart date not null,
    ship integer,
    type_v integer not null,
    port_depart text ,
    port_arrive text ,
    country_depart text,
    country_arriver text,
    loc_continental text not null,
    nb_passager_depart integer not null,
    constraint fk_port_depart foreign key (port_depart,country_depart)references port(name_port,country) on delete cascade on update cascade,
    constraint fk_port_arriver foreign key (port_arrive,country_arriver)references port(name_port,country) on delete cascade on update cascade,
    constraint type_voyage check (type_v in (2,1,3)),
    constraint check_loc check (loc_continental in ('ASIA','AFRICA','EUROPE','AMERICA','INTERCONTINENTAL') ),
    constraint fk_ship foreign key (ship) references ship(id) on delete cascade on update cascade,
    constraint pk_voyage primary key (date_depart,ship)
);

create table capture(
    date_capture date not null,
    country text,
    ship integer ,
    constraint fk_ship foreign key (ship) references ship(id) on delete cascade on update cascade,
    constraint fk_country foreign key (country) references country (name) on update cascade on delete cascade,
    constraint pk_capture primary key (date_capture,country,ship)
);

create table voyage_termine(
    date_arrive date not null,
    distance real not null,
    date_depart date,
    ship integer ,
    constraint fk_voyage foreign key (date_depart,ship) references voyage (date_depart,ship) on delete cascade on update cascade,
    constraint pk_voyage_termine primary key (date_depart,ship)
);
create table quantite_depart(
    date_depart date ,
    ship integer,
    produit integer ,
    volume real not null,
    constraint fk_voyage foreign key (date_depart,ship) references voyage (date_depart,ship) on delete cascade on update cascade,
    constraint fk_produit foreign key (produit) references produit (num),
    constraint pk_quantite_depart primary key (date_depart,ship,produit)
);

create table debarquement(
    date_d date not null,
    date_depart date ,
    ship integer,
    mouillage boolean not null,
    ravitaillage boolean not null,
    nb_personne_monte integer  not null,
    nb_personne_descendu integer not null,
    port text,
    country text,
    constraint fk_port foreign key (port,country) references port (name_port,country) on delete cascade on update cascade,
    constraint fk_voyage foreign key (date_depart,ship) references voyage (date_depart,ship) on delete cascade on update cascade,
    constraint pk_debarquement primary key (date_d,date_depart,ship,port,country)
);

create table vendre(
    date_d date ,
    date_depart date ,
    ship integer ,
    port text,
    country text,
    produit integer,
    volume real ,
    constraint fk_debarquement foreign key (date_d,date_depart,ship,port,country) references debarquement (date_d,date_depart,ship,port,country) on delete cascade on update cascade,
    constraint fk_produit foreign key (produit) references produit (num) on delete cascade on update cascade,
    constraint pk_vendre primary key (date_d ,date_depart,ship,port,country,produit)
 );

 create table acheter(
    date_d date not null,
    date_depart date ,
    ship integer ,
    port text,
    country text,
    produit integer,
    volume real ,
    constraint fk_debarquement foreign key (date_d,date_depart,ship,port,country) references debarquement (date_d,date_depart,ship,port,country) on delete cascade on update cascade,
    constraint fk_produit foreign key (produit) references produit (num) on delete cascade on update cascade,
    constraint pk_acheter primary key (date_d ,date_depart,ship,port,country,produit)
 );
