SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Transport par câble. Moyen de transport constitué d'un ou plusieurs câbles porteurs
--
create table TRANSPORT_CABLE (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, NATURE varchar(18) default 'NR', Z_MIN float, Z_MAX float, Z_INI float, Z_FIN float, constraint TRANSPORT_CABLE_pkey primary key (gid));
select AddGeometryColumn('','transport_cable','the_geom','210642000','MULTILINESTRING',3);
create index TRANSPORT_CABLE_geoidx on TRANSPORT_CABLE using gist (the_geom gist_geometry_ops);
--
commit;
--
