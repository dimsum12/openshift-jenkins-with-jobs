SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Bâtiment de plus de 20 mètres carrés
--
create table GARE (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, constraint GARE_pkey primary key (gid));
select AddGeometryColumn('','gare','the_geom','210642000','MULTIPOLYGON',3);
create index GARE_geoidx on GARE using gist (the_geom gist_geometry_ops);
--
commit;
--
