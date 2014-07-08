SET NAMES 'LATIN9';
--
-- SET NAMES 'LATIN9';
--
start transaction;
-- Points intermédiaires des lignes électriques correspondant à un pylone
--
create table PYLONE (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), ALTISOL decimal(7,1) not null, HAUTEUR decimal(7,1), HAUTSOL integer not null, constraint PYLONE_pkey primary key (gid));
select AddGeometryColumn('','pylone','the_geom','-1','MULTIPOINT',3);
create index PYLONE_geoidx on PYLONE using gist (the_geom gist_geometry_ops);
--
-- Canalisation ou tapis roulant
--
create table CANALISA (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(13) not null, POSITION integer not null, constraint CANALISA_pkey primary key (gid));
select AddGeometryColumn('','canalisa','the_geom','-1','MULTILINESTRING',3);
create index CANALISA_geoidx on CANALISA using gist (the_geom gist_geometry_ops);
--
-- Ligne électrique. Portion de ligne électrique homogène pour l'ensemble des attributs qui la concernent
--
create table LINEELEC (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), VOLTAGE char(8) not null, constraint LINEELEC_pkey primary key (gid));
select AddGeometryColumn('','lineelec','the_geom','-1','MULTILINESTRING',3);
create index LINEELEC_geoidx on LINEELEC using gist (the_geom gist_geometry_ops);
--
-- Poste de transformation
--
create table PTRANSFO (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), constraint PTRANSFO_pkey primary key (gid));
select AddGeometryColumn('','ptransfo','the_geom','-1','MULTIPOLYGON',3);
create index PTRANSFO_geoidx on PTRANSFO using gist (the_geom gist_geometry_ops);
--
commit;
--
-- PYLONE
start transaction;
insert into PYLONE values ('166','PYLONE__0000000223428314','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.964035 41.689520 251.000000)'));
insert into PYLONE values ('167','PYLONE__0000000223428318','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.968076 41.669269 188.900000)'));
insert into PYLONE values ('168','PYLONE__0000000223428320','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.955438 41.694964 72.500000)'));
insert into PYLONE values ('169','PYLONE__0000000223428325','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.962597 41.690843 194.700000)'));
insert into PYLONE values ('170','PYLONE__0000000223428327','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.966075 41.688382 314.300000)'));
insert into PYLONE values ('171','PYLONE__0000000223428344','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.962938 41.684474 454.600000)'));
insert into PYLONE values ('172','PYLONE__0000000223428345','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.950326 41.698912 61.700000)'));
insert into PYLONE values ('173','PYLONE__0000000223428350','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.943075 41.703205 99.400000)'));
insert into PYLONE values ('174','PYLONE__0000000223428352','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.946496 41.701042 91.900000)'));
insert into PYLONE values ('175','PYLONE__0000000223428373','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.951839 41.665603 219.700000)'));
insert into PYLONE values ('176','PYLONE__0000000223428449','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.941653 41.663287 219.000000)'));
insert into PYLONE values ('177','PYLONE__0000000223428450','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.932141 41.665299 213.300000)'));
insert into PYLONE values ('178','PYLONE__0000000223428451','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.936554 41.662119 150.300000)'));
insert into PYLONE values ('179','PYLONE__0000000223428458','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.931262 41.660924 150.900000)'));
insert into PYLONE values ('180','PYLONE__0000000223428461','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.931545 41.665329 203.800000)'));
insert into PYLONE values ('181','PYLONE__0000000223428465','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.946045 41.664281 229.600000)'));
insert into PYLONE values ('182','PYLONE__0000000223428613','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(8.948953 41.672372 457.800000)'));
