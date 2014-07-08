SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Bâtiment de plus de 20 mètres carrés
--
create table CONSTRUCTION_LEGERE (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, ORIGIN_BAT varchar(8) default 'NR', HAUTEUR integer not null, constraint CONSTRUCTION_LEGERE_pkey primary key (gid));
select AddGeometryColumn('','construction_legere','the_geom','210642000','MULTIPOLYGON',3);
create index CONSTRUCTION_LEGERE_geoidx on CONSTRUCTION_LEGERE using gist (the_geom gist_geometry_ops);
--
commit;
--
