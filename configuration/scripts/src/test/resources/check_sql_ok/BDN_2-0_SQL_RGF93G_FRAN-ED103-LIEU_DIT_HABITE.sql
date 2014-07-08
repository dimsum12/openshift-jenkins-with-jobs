SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
create table LIEU_DIT_HABITE (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'NR', NOM varchar(70) default ' N R', IMPORTANCE varchar(2) default 'NR', NATURE varchar(15) not null, constraint LIEU_DIT_HABITE_pkey primary key (gid));
select AddGeometryColumn('','lieu_dit_habite','the_geom','210024000','MULTIPOINT',2);
create index LIEU_DIT_HABITE_geoidx on LIEU_DIT_HABITE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- LIEU_DIT_HABITE
start transaction;
insert into LIEU_DIT_HABITE values ('1','PAIHABIT0000000050812460','BDNyme','le bois tiffray','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(-0.080196 44.972113)'));
insert into LIEU_DIT_HABITE values ('2','PAIHABIT0000000000148266','BDNyme','le marais','6','Quartier', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.357690 48.856729)'));
insert into LIEU_DIT_HABITE values ('3','PAIHABIT0000000076203818','BDNyme','poul derrien','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.127079 48.857121)'));
insert into LIEU_DIT_HABITE values ('4','PAIHABIT0000000028859185','Géoroute','le moulin neuf','7','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.262028 47.080427)'));
insert into LIEU_DIT_HABITE values ('5','PAIHABIT0000000028858750','Géoroute','le gât','7','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.239815 47.070159)'));
insert into LIEU_DIT_HABITE values ('6','PAIHABIT0000000010571056','Géoroute','petite lande','7','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.248760 45.885132)'));
insert into LIEU_DIT_HABITE values ('7','PAIHABIT0000000010571075','BDNyme','le buyausou','8','Quartier', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.248112 45.880770)'));
insert into LIEU_DIT_HABITE values ('8','PAIHABIT0000000010571039','BDNyme','le mauzelet','7','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.268780 45.879241)'));
insert into LIEU_DIT_HABITE values ('9','PAIHABIT0000000010571045','Géoroute','les cambuses','7','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.267739 45.886376)'));
insert into LIEU_DIT_HABITE values ('10','PAIHABIT0000000010571038','BDNyme','les gravelles','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.277363 45.887060)'));
insert into LIEU_DIT_HABITE values ('11','PAIHABIT0000000010571524','Géoroute','le vigenal','6','Quartier', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.251378 45.854996)'));
insert into LIEU_DIT_HABITE values ('12','PAIHABIT0000000010571443','Géoroute','le haut du châtenet','7','Quartier', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.309488 45.873727)'));
insert into LIEU_DIT_HABITE values ('13','PAIHABIT0000000010571488','Géoroute','la bastide','7','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.277048 45.858058)'));
insert into LIEU_DIT_HABITE values ('14','PAIHABIT0000000010571985','BDNyme','les audouines','7','Quartier', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.282091 45.847533)'));
insert into LIEU_DIT_HABITE values ('15','PAIHABIT0000000010571955','BDNyme','château de la quintaine','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.310472 45.842514)'));
insert into LIEU_DIT_HABITE values ('16','PAIHABIT0000000010571975','BDNyme','château de la rue','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.323373 45.839626)'));
insert into LIEU_DIT_HABITE values ('17','PAIHABIT0000000023307247','BDNyme','kerantous','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.991219 47.935505)'));
insert into LIEU_DIT_HABITE values ('18','PAIHABIT0000000028863412','Géoroute','les carrés','6','Quartier', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.029444 47.078309)'));
insert into LIEU_DIT_HABITE values ('19','PAIHABIT0000000000419918','BDNyme','les sablons','7','Quartier', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.279630 48.797381)'));
insert into LIEU_DIT_HABITE values ('20','PAIHABIT0000000010572464','BDNyme','ardennes','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.337666 45.808352)'));
insert into LIEU_DIT_HABITE values ('21','PAIHABIT0000000010572457','BDNyme','la croix des rameaux','6','Quartier', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.333998 45.811208)'));
insert into LIEU_DIT_HABITE values ('22','PAIHABIT0000000010571406','BDNyme','les molletteries','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.395534 45.872896)'));
insert into LIEU_DIT_HABITE values ('23','PAIHABIT0000000010571429','BDNyme','gourly','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.378192 45.859154)'));
insert into LIEU_DIT_HABITE values ('24','PAIHABIT0000000010571436','BDNyme','la chabasse','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.358641 45.876693)'));
insert into LIEU_DIT_HABITE values ('25','PAIHABIT0000000010571477','Géoroute','les rivailles','6','Quartier', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.330066 45.878295)'));
insert into LIEU_DIT_HABITE values ('26','PAIHABIT0000000010571431','BDNyme','le moulin du verdier','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.368440 45.873243)'));
insert into LIEU_DIT_HABITE values ('27','PAIHABIT0000000010570971','BDNyme','la haute gorce','7','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.387234 45.891767)'));
insert into LIEU_DIT_HABITE values ('28','PAIHABIT0000000010571428','BDNyme','le fort maneix','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.371528 45.872658)'));
insert into LIEU_DIT_HABITE values ('29','PAIHABIT0000000010572377','BDNyme','la tuilerie du verdurier','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.459577 45.805251)'));
insert into LIEU_DIT_HABITE values ('30','PAIHABIT0000000010572953','BDNyme','la tuilerie','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.428956 45.787516)'));
insert into LIEU_DIT_HABITE values ('31','PAIHABIT0000000010571877','BDNyme','laugère','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.434074 45.844655)'));
insert into LIEU_DIT_HABITE values ('32','PAIHABIT0000000010571403','BDNyme','les pierres','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.419231 45.851544)'));
insert into LIEU_DIT_HABITE values ('33','PAIHABIT0000000010571382','BDNyme','le pinier','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.427752 45.852495)'));
insert into LIEU_DIT_HABITE values ('34','PAIHABIT0000000010570976','BDNyme','les pampisses','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.412349 45.886388)'));
insert into LIEU_DIT_HABITE values ('35','PAIHABIT0000000010571900','Géoroute','fontaguly','6','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.414335 45.844855)'));
insert into LIEU_DIT_HABITE values ('36','PAIHABIT0000000010570975','BDNyme','le moulin de cintrat','8','Lieu-dit habité', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.411401 45.884447)'));
insert into LIEU_DIT_HABITE values ('37','PAIHABIT0000000010571377','BDNyme','le moulin de marsac','8','Moulin', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.459066 45.854876)'));
