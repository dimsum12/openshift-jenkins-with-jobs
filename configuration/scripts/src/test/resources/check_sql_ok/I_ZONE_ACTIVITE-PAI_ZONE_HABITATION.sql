SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Zone d'habitation
--
create table PAI_ZONE_HABITATION (gid SERIAL not null, ID varchar(24) not null, ORIGINE varchar(17) default 'NR', NATURE varchar(15) default 'NR', TOPONYME varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', constraint PAI_ZONE_HABITATION_pkey primary key (gid));
select AddGeometryColumn('','pai_zone_habitation','the_geom','210642000','MULTIPOINT',2);
create index PAI_ZONE_HABITATION_geoidx on PAI_ZONE_HABITATION using gist (the_geom gist_geometry_ops);
--
commit;
--
-- PAI_ZONE_HABITATION
start transaction;
insert into PAI_ZONE_HABITATION values ('1','PAIHABIT0000000070011324','BDNyme','Quartier','petit bois','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.102395 14.640887)'));
insert into PAI_ZONE_HABITATION values ('2','PAIHABIT0000000070011454','BDNyme','Quartier','grand paradis','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.084846 14.620274)'));
insert into PAI_ZONE_HABITATION values ('3','PAIHABIT0000000070011310','BDNyme','Quartier','godissard','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.069805 14.635648)'));
insert into PAI_ZONE_HABITATION values ('4','PAIHABIT0000000070011465','BDNyme','Lieu-dit habit�','habitation fond rousseau','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.102481 14.620165)'));
insert into PAI_ZONE_HABITATION values ('5','PAIHABIT0000000070011447','BDNyme','Quartier','la folie','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.063899 14.607465)'));
insert into PAI_ZONE_HABITATION values ('6','PAIHABIT0000000070011213','BDNyme','Lieu-dit habit�','le piton','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.092716 14.665271)'));
insert into PAI_ZONE_HABITATION values ('7','PAIHABIT0000000070010732','BDNyme','Lieu-dit habit�','cit� grenade','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.119240 14.819124)'));
insert into PAI_ZONE_HABITATION values ('8','PAIHABIT0000000070010727','BDNyme','Lieu-dit habit�','derri�re cimeti�re','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.114174 14.827680)'));
insert into PAI_ZONE_HABITATION values ('9','PAIHABIT0000000070215463','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.228312 14.816124)'));
insert into PAI_ZONE_HABITATION values ('10','PAIHABIT0000000070215464','BDParcellaire','Quartier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.221897 14.798696)'));
insert into PAI_ZONE_HABITATION values ('11','PAIHABIT0000000070215465','BDParcellaire','Quartier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.225858 14.805526)'));
insert into PAI_ZONE_HABITATION values ('12','PAIHABIT0000000070217100','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.145654 14.876119)'));
insert into PAI_ZONE_HABITATION values ('13','PAIHABIT0000000070217954','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.128464 14.801906)'));
insert into PAI_ZONE_HABITATION values ('14','PAIHABIT0000000070217955','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.108283 14.827356)'));
insert into PAI_ZONE_HABITATION values ('15','PAIHABIT0000000070217956','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.116348 14.825647)'));
insert into PAI_ZONE_HABITATION values ('16','PAIHABIT0000000070217957','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.126210 14.818556)'));
insert into PAI_ZONE_HABITATION values ('17','PAIHABIT0000000070219409','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.128399 14.733102)'));
insert into PAI_ZONE_HABITATION values ('18','PAIHABIT0000000070219410','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.130522 14.739338)'));
insert into PAI_ZONE_HABITATION values ('19','PAIHABIT0000000070219411','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.132905 14.736491)'));
insert into PAI_ZONE_HABITATION values ('20','PAIHABIT0000000070219412','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.134798 14.743712)'));
insert into PAI_ZONE_HABITATION values ('21','PAIHABIT0000000070219413','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.134285 14.735545)'));
insert into PAI_ZONE_HABITATION values ('22','PAIHABIT0000000070219414','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.132936 14.734559)'));
insert into PAI_ZONE_HABITATION values ('23','PAIHABIT0000000070221404','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.157736 14.709804)'));
insert into PAI_ZONE_HABITATION values ('24','PAIHABIT0000000070221405','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.140190 14.698913)'));
insert into PAI_ZONE_HABITATION values ('25','PAIHABIT0000000070221406','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.157149 14.710724)'));
insert into PAI_ZONE_HABITATION values ('26','PAIHABIT0000000070221407','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.146428 14.707486)'));
insert into PAI_ZONE_HABITATION values ('27','PAIHABIT0000000070221408','BDNyme','Lieu-dit habit�','joli mont','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.148912 14.701935)'));
insert into PAI_ZONE_HABITATION values ('28','PAIHABIT0000000070222979','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.089108 14.602351)'));
insert into PAI_ZONE_HABITATION values ('29','PAIHABIT0000000070223302','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.086618 14.605159)'));
insert into PAI_ZONE_HABITATION values ('30','PAIHABIT0000000070226010','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.083950 14.612324)'));
insert into PAI_ZONE_HABITATION values ('31','PAIHABIT0000000070226011','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.081136 14.615429)'));
insert into PAI_ZONE_HABITATION values ('32','PAIHABIT0000000070226012','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.083994 14.613865)'));
insert into PAI_ZONE_HABITATION values ('33','PAIHABIT0000000070227995','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.076537 14.602462)'));
insert into PAI_ZONE_HABITATION values ('34','PAIHABIT0000000070227996','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074816 14.603170)'));
insert into PAI_ZONE_HABITATION values ('35','PAIHABIT0000000070233469','BDParcellaire','Lieu-dit habit�',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.077452 14.610864)'));
