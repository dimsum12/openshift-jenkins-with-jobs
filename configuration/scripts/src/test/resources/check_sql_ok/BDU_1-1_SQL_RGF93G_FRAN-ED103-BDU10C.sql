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
insert into PYLONE values ('21943','PYLONE__0000000056488836','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,' -100.0',DEFAULT,'0', GeomFromEWKT('SRID=-1;MULTIPOINT(2.361514 50.712026 41.200001)'));
insert into PYLONE values ('21944','PYLONE__0000000066463532','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.562570 49.433259 145.400000)'));
insert into PYLONE values ('21945','PYLONE__0000000066463533','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.561619 49.432539 155.700000)'));
insert into PYLONE values ('21946','PYLONE__0000000066463534','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.564915 49.430544 159.300000)'));
insert into PYLONE values ('21947','PYLONE__0000000066463535','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.563558 49.422826 162.900000)'));
insert into PYLONE values ('21948','PYLONE__0000000066463536','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.565731 49.426900 149.600001)'));
insert into PYLONE values ('21949','PYLONE__0000000066463537','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.564187 49.426358 163.900000)'));
insert into PYLONE values ('21950','PYLONE__0000000066463538','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.566453 49.430923 143.900000)'));
insert into PYLONE values ('21951','PYLONE__0000000066463539','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.565035 49.423046 152.500000)'));
insert into PYLONE values ('21952','PYLONE__0000000220885880','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(-1.231685 43.906194 61.300000)'));
insert into PYLONE values ('21953','PYLONE__0000000066463511','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(1.282472 49.118486 162.400000)'));
insert into PYLONE values ('21954','PYLONE__0000000066463512','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(1.287826 49.120489 157.800000)'));
insert into PYLONE values ('21955','PYLONE__0000000066463513','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(1.291640 49.121921 150.900000)'));
insert into PYLONE values ('21956','PYLONE__0000000066463514','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(1.274511 49.115508 182.000000)'));
insert into PYLONE values ('21957','PYLONE__0000000066463515','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.833893 49.258775 206.100000)'));
insert into PYLONE values ('21958','PYLONE__0000000066463516','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.827768 49.262163 214.900000)'));
insert into PYLONE values ('21959','PYLONE__0000000066463517','Photogrammétrie              ','Photogrammétrie               ',DEFAULT,'    0.0','    0.0','0', GeomFromEWKT('SRID=-1;MULTIPOINT(0.849024 49.245533 212.400000)'));
