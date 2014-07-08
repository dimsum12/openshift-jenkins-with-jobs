SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Lieu dit non habité
--
create table LIEU_DIT_NON_HABITE (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'Non renseigné', NOM varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', NATURE varchar(24) default 'NR', constraint LIEU_DIT_NON_HABITE_pkey primary key (gid));
select AddGeometryColumn('','lieu_dit_non_habite','the_geom','210642000','MULTIPOINT',2);
create index LIEU_DIT_NON_HABITE_geoidx on LIEU_DIT_NON_HABITE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- LIEU_DIT_NON_HABITE
start transaction;
insert into LIEU_DIT_NON_HABITE values ('1','PAICULOI0000000069986713','BDNyme','le jardin de la pelée','8','Espace , GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.138375 14.765055)'));
insert into LIEU_DIT_NON_HABITE values ('2','PAITRANS0000000069986169','BDNyme','barrage de la manzo','7','Barrage', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.945056 14.582680)'));
insert into LIEU_DIT_NON_HABITE values ('4','PAIRELIG0000000069986224','BDNyme','croix laurence','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.123297 14.819464)'));
insert into LIEU_DIT_NON_HABITE values ('5','PAIRELIG0000000069986234','BDNyme','vierge de la calebasse','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.145837 14.803823)'));
insert into LIEU_DIT_NON_HABITE values ('6','PAIRELIG0000000069986276','BDNyme','saint-marc','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.183390 14.715265)'));
insert into LIEU_DIT_NON_HABITE values ('7','PAIRELIG0000000069986225','BDNyme','vierge des marins','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.983583 14.777497)'));
insert into LIEU_DIT_NON_HABITE values ('8','PAIRELIG0000000069986296','BDNyme','lourdes','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.037859 14.677086)'));
insert into LIEU_DIT_NON_HABITE values ('9','PAIRELIG0000000069986374','BDNyme','croix bigotte','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.019444 14.565249)'));
insert into LIEU_DIT_NON_HABITE values ('10','PAIRELIG0000000069986222','BDNyme','vierge des marins','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.180884 14.872735)'));
insert into LIEU_DIT_NON_HABITE values ('11','PAIRELIG0000000069986244','BDNyme','vierge des marins','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.952723 14.741601)'));
insert into LIEU_DIT_NON_HABITE values ('12','PAIRELIG0000000069986275','BDNyme','croix mission','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.128510 14.700240)'));
insert into LIEU_DIT_NON_HABITE values ('13','PAIRELIG0000000069986223','BDNyme','vierge bourdon','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.054880 14.816165)'));
insert into LIEU_DIT_NON_HABITE values ('14','PAIRELIG0000000069986253','BDNyme','croix eustache','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.130589 14.732901)'));
insert into LIEU_DIT_NON_HABITE values ('15','PAIRELIG0000000069986270','BDNyme','vierge coat','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.036710 14.709988)'));
insert into LIEU_DIT_NON_HABITE values ('16','PAIRELIG0000000069986378','BDNyme','vierge des coolies','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.849028 14.421158)'));
insert into LIEU_DIT_NON_HABITE values ('17','PAIRELIG0000000069986329','BDNyme','croix mission','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.902246 14.611702)'));
insert into LIEU_DIT_NON_HABITE values ('18','PAIRELIG0000000069986255','BDNyme','vierge des marins','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.177068 14.735043)'));
insert into LIEU_DIT_NON_HABITE values ('19','PAIRELIG0000000069986376','BDNyme','vierge des marins','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.027708 14.481175)'));
insert into LIEU_DIT_NON_HABITE values ('20','PAIRELIG0000000069986380','BDNyme','croix des salines','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.871681 14.413022)'));
insert into LIEU_DIT_NON_HABITE values ('21','PAIRELIG0000000069986243','BDNyme','vierge durival','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.024172 14.760723)'));
insert into LIEU_DIT_NON_HABITE values ('22','PAIRELIG0000000069986379','BDNyme','vierge des marins','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.844131 14.420281)'));
insert into LIEU_DIT_NON_HABITE values ('23','PAIRELIG0000000069986256','BDNyme','vierge du sacré-coeur','8','Croix', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.178777 14.732743)'));
insert into LIEU_DIT_NON_HABITE values ('26','PAIE_NAT0000000069985099','BDNyme','boudou','7','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.128778 14.801126)'));
insert into LIEU_DIT_NON_HABITE values ('27','PAIE_NAT0000000069985133','BDNyme','le pont maximin','8','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.017475 14.773082)'));
insert into LIEU_DIT_NON_HABITE values ('28','PAIE_NAT0000000069985137','BDNyme','le bois de l\'union','8','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.044905 14.764490)'));
insert into LIEU_DIT_NON_HABITE values ('29','PAIE_NAT0000000069985266','BDNyme','habitation soudon','7','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.997140 14.649907)'));
insert into LIEU_DIT_NON_HABITE values ('30','PAIE_NAT0000000069985215','BDNyme','fond fougères','8','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.055358 14.701110)'));
insert into LIEU_DIT_NON_HABITE values ('31','PAIE_NAT0000000069985210','BDNyme','malgré tout','8','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.981090 14.700473)'));
insert into LIEU_DIT_NON_HABITE values ('32','PAIE_NAT0000000069985170','BDNyme','les marinières','8','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.952894 14.727333)'));
insert into LIEU_DIT_NON_HABITE values ('33','PAIE_NAT0000000069985012','BDNyme','habitation dehaumont','7','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.035641 14.818423)'));
insert into LIEU_DIT_NON_HABITE values ('34','PAIE_NAT0000000069985150','BDNyme','le petit jacob','8','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.091863 14.773712)'));
insert into LIEU_DIT_NON_HABITE values ('35','PAIE_NAT0000000069985138','BDNyme','habitation lassalle','8','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.045509 14.764285)'));
insert into LIEU_DIT_NON_HABITE values ('36','PAIE_NAT0000000069985244','BDNyme','habitation prospérité','8','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.022478 14.665559)'));
insert into LIEU_DIT_NON_HABITE values ('37','PAIE_NAT0000000069985348','BDNyme','crésus','8','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.051369 14.499096)'));
insert into LIEU_DIT_NON_HABITE values ('38','PAIE_NAT0000000069985021','BDNyme','les ombrages','8','Lieu-dit non habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.109951 14.819047)'));
