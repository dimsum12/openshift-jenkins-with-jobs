SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Aire de triage. Ensemble des tronçons de voies, voies de garage, aiguillagespermettant le tri des wagons et la composition des trains
--
create table AIRE_TRIAGE (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, constraint AIRE_TRIAGE_pkey primary key (gid));
select AddGeometryColumn('','aire_triage','the_geom','210642000','MULTIPOLYGON',3);
create index AIRE_TRIAGE_geoidx on AIRE_TRIAGE using gist (the_geom gist_geometry_ops);
--
commit;
--
