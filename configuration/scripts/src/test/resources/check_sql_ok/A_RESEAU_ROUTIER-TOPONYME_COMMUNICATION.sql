SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Toponyme de communication
--
create table TOPONYME_COMMUNICATION (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'NR', NOM varchar(70) default ' N R', IMPORTANCE varchar(2) default 'NR', NATURE varchar(23) default 'NR', constraint TOPONYME_COMMUNICATION_pkey primary key (gid));
select AddGeometryColumn('','toponyme_communication','the_geom','210642000','MULTIPOINT',2);
create index TOPONYME_COMMUNICATION_geoidx on TOPONYME_COMMUNICATION using gist (the_geom gist_geometry_ops);
--
commit;
--
-- TOPONYME_COMMUNICATION
start transaction;
insert into TOPONYME_COMMUNICATION values ('1','PAITRANS0000000069986121','BDNyme','route forestière de piton laroche','8','Chemin', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.054795 14.764364)'));
insert into TOPONYME_COMMUNICATION values ('2','PAITRANS0000000069986140','BDNyme','route forestière de rivière rouge','8','Infrastructure routière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.073846 14.710302)'));
insert into TOPONYME_COMMUNICATION values ('3','PAITRANS0000000069986180','BDNyme','pont mastor','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.852429 14.473328)'));
insert into TOPONYME_COMMUNICATION values ('4','PAITRANS0000000069986120','BDNyme','route forestière de reculée','8','Infrastructure routière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.045428 14.773321)'));
insert into TOPONYME_COMMUNICATION values ('5','PAITRANS0000000069986181','BDNyme','croisée décius','8','Carrefour', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.862036 14.474311)'));
insert into TOPONYME_COMMUNICATION values ('6','PAITRANS0000000069986158','BDNyme','trace duclos nord','8','Chemin', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.102027 14.683514)'));
insert into TOPONYME_COMMUNICATION values ('7','PAITRANS0000000069986155','BDNyme','route forestière de fond baron','8','Chemin', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.092731 14.674309)'));
insert into TOPONYME_COMMUNICATION values ('8','PAITRANS0000000069986142','BDNyme','route forestière de fond mithon','8','Infrastructure routière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074006 14.692228)'));
insert into TOPONYME_COMMUNICATION values ('9','PAITRANS0000000069986141','BDNyme','route forestière de fond fougères','8','Infrastructure routière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.064642 14.701187)'));
insert into TOPONYME_COMMUNICATION values ('10','PAITRANS0000000069986126','BDNyme','route du calvaire','8','Infrastructure routière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.036466 14.737098)'));
insert into TOPONYME_COMMUNICATION values ('11','PAITRANS0000000069986153','BDNyme','croisée manioc','8','Carrefour', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.022832 14.671607)'));
insert into TOPONYME_COMMUNICATION values ('12','PAITRANS0000000069986177','BDNyme','cassis boisel','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.918960 14.501191)'));
insert into TOPONYME_COMMUNICATION values ('13','PAITRANS0000000069986184','BDNyme','pont fond banane','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.945538 14.467574)'));
insert into TOPONYME_COMMUNICATION values ('14','PAITRANS0000000069986152','BDNyme','pont minville','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.026581 14.673935)'));
insert into TOPONYME_COMMUNICATION values ('15','PAITRANS0000000069986174','BDNyme','cassis des oranges','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.897352 14.523264)'));
insert into TOPONYME_COMMUNICATION values ('16','PAITRANS0000000069986176','BDNyme','pont madeleine','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.904658 14.496219)'));
insert into TOPONYME_COMMUNICATION values ('17','PAITRANS0000000069986138','BDNyme','pont bois goudoux','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.036792 14.700952)'));
insert into TOPONYME_COMMUNICATION values ('18','PAITRANS0000000069986119','BDNyme','pont tully','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.989793 14.763806)'));
insert into TOPONYME_COMMUNICATION values ('19','PAITRANS0000000069986161','BDNyme','croisée jeanne d\'arc','8','Rond-point', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.008259 14.629155)'));
insert into TOPONYME_COMMUNICATION values ('20','PAITRANS0000000069986168','BDNyme','pont dix cornes','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.928552 14.578358)'));
insert into TOPONYME_COMMUNICATION values ('21','PAITRANS0000000069986114','BDNyme','pont fonds massacre','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.047224 14.830894)'));
insert into TOPONYME_COMMUNICATION values ('22','PAITRANS0000000069986179','BDNyme','pont albert','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.015482 14.482427)'));
insert into TOPONYME_COMMUNICATION values ('23','PAITRANS0000000069986162','BDNyme','pont alfred','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.037276 14.646734)'));
insert into TOPONYME_COMMUNICATION values ('24','PAITRANS0000000069986166','BDNyme','pont spitz','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.998350 14.605790)'));
insert into TOPONYME_COMMUNICATION values ('25','PAITRANS0000000069986125','BDNyme','pont lebrun','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.018061 14.718866)'));
insert into TOPONYME_COMMUNICATION values ('26','PAITRANS0000000069986183','BDNyme','pont café','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.937855 14.465750)'));
insert into TOPONYME_COMMUNICATION values ('27','PAITRANS0000000069986112','BDNyme','pont mol','8','Pont', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.156625 14.873308)'));
insert into TOPONYME_COMMUNICATION values ('28','PAITRANS0000000069986165','BDNyme','les quatre croisées','8','Carrefour', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.935071 14.600673)'));
insert into TOPONYME_COMMUNICATION values ('29','PAITRANS0000000069986156','BDNyme','route forestière de fond l\'étang','8','Chemin', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.083720 14.677000)'));
insert into TOPONYME_COMMUNICATION values ('30','PAITRANS0000000069986143','BDNyme','aire d\'accueil de coeur bouliki','7','Infrastructure routière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074005 14.692318)'));
insert into TOPONYME_COMMUNICATION values ('31','PAITRANS0000000069986146','BDNyme','trace oliviers','8','Chemin', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.083289 14.692305)'));
insert into TOPONYME_COMMUNICATION values ('32','PAITRANS0000000069986139','BDNyme','route forestière de rivière rouge','8','Infrastructure routière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.055279 14.710145)'));
insert into TOPONYME_COMMUNICATION values ('33','PAITRANS0000000069986113','BDNyme','allée coco','8','Chemin', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.146891 14.855497)'));
insert into TOPONYME_COMMUNICATION values ('34','PAITRANS0000000069986131','BDNyme','trace des jésuites','8','Chemin', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.084089 14.743830)'));
insert into TOPONYME_COMMUNICATION values ('35','PAITRANS0000000069986127','BDNyme','trace l\'auberge','8','Chemin', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.064229 14.737332)'));
