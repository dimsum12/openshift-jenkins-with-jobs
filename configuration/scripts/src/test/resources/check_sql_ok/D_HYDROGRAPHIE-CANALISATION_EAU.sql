SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Canalisation ou tapis roulant
--
create table CANALISATION_EAU (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, POS_SOL integer not null, constraint CANALISATION_EAU_pkey primary key (gid));
select AddGeometryColumn('','canalisation_eau','the_geom','210642000','LINESTRING',3);
create index CANALISATION_EAU_geoidx on CANALISATION_EAU using gist (the_geom gist_geometry_ops);
--
commit;
--
-- CANALISATION_EAU
start transaction;
insert into CANALISATION_EAU values ('1','CANALISA0000000069987413','   1.5','    1.0',0, GeomFromEWKT('SRID=210642000;LINESTRING(-61.115949 14.863125 56.800000,-61.115481 14.863626 54.900000)'));
insert into CANALISATION_EAU values ('2','CANALISA0000000069987415','   2.5','    2.5',1, GeomFromEWKT('SRID=210642000;LINESTRING(-60.994371 14.717824 126.400000,-60.994513 14.717773 123.200000,-60.994526 14.717769 122.900000,-60.994704 14.717704 122.600000,-60.994814 14.717664 122.300000)'));
insert into CANALISATION_EAU values ('3','CANALISA0000000069987414','   2.5','    2.5',1, GeomFromEWKT('SRID=210642000;LINESTRING(-61.144311 14.752874 323.300000,-61.144353 14.752874 323.300000,-61.144554 14.752877 323.300000,-61.144681 14.752874 323.300000)'));
commit;
--
