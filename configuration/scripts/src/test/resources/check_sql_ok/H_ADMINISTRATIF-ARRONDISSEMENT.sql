SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Arrodissement urbain : subdivision administrative de certaines communes(Paris, Lyon, Marseille)
--
create table ARRONDISSEMENT (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, NOM varchar(45) not null, CODE_INSEE varchar(5) not null, constraint ARRONDISSEMENT_pkey primary key (gid));
select AddGeometryColumn('','arrondissement','the_geom','210642000','MULTIPOLYGON',2);
create index ARRONDISSEMENT_geoidx on ARRONDISSEMENT using gist (the_geom gist_geometry_ops);
--
commit;
--
