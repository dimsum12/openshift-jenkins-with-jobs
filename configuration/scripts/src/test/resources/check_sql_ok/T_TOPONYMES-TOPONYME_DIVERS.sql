SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Culture et loisirs
--
create table TOPONYME_DIVERS (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'Non renseigné', NOM varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', NATURE varchar(27) default 'NR', constraint TOPONYME_DIVERS_pkey primary key (gid));
select AddGeometryColumn('','toponyme_divers','the_geom','210642000','MULTIPOINT',2);
create index TOPONYME_DIVERS_geoidx on TOPONYME_DIVERS using gist (the_geom gist_geometry_ops);
--
commit;
--
-- TOPONYME_DIVERS
start transaction;
insert into TOPONYME_DIVERS values ('1','PAICULOI0000000069986721','BDNyme','musée de l\'impératrice joséphine','8','Musée', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.048573 14.531217)'));
insert into TOPONYME_DIVERS values ('2','PAICULOI0000000069986722','BDNyme','les boucaniers','6','Village de vacances', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.882747 14.448789)'));
insert into TOPONYME_DIVERS values ('3','PAICULOI0000000069986714','BDNyme','musée gauguin','8','Musée', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.179049 14.727892)'));
insert into TOPONYME_DIVERS values ('4','PAICULOI0000000069986712','BDNyme','maison de la nature','8','Maison du parc', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.100230 14.748250)'));
insert into TOPONYME_DIVERS values ('5','PAICULOI0000000069986710','BDNyme','musée du rhum','8','Musée', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.998912 14.781958)'));
insert into TOPONYME_DIVERS values ('6','PAIE_NAT0000000069985285','BDNyme','forêt départementalo-domaniale de la discorde','5','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.157863 14.656761)'));
insert into TOPONYME_DIVERS values ('7','PAIE_NAT0000000069985141','BDNyme','bois l\'encens','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.054622 14.773400)'));
insert into TOPONYME_DIVERS values ('8','PAIE_NAT0000000069985363','BDNyme','forêt départementalo-domaniale de crève-coeur','6','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.854549 14.446690)'));
insert into TOPONYME_DIVERS values ('9','PAIE_NAT0000000069985279','BDNyme','forêt départementale-domaniale de fond lahaye','5','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.111606 14.638314)'));
insert into TOPONYME_DIVERS values ('10','PAIE_NAT0000000069985274','BDNyme','forêt des anglais','7','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.106272 14.650941)'));
insert into TOPONYME_DIVERS values ('11','PAIE_NAT0000000069985144','BDNyme','bois de l\'étang','7','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.054864 14.746291)'));
insert into TOPONYME_DIVERS values ('12','PAIE_NAT0000000069985332','BDNyme','forêt départementalo-domaniale de lépinay','6','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.927261 14.501192)'));
insert into TOPONYME_DIVERS values ('13','PAIE_NAT0000000069985139','BDNyme','bois dessales','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.045578 14.746212)'));
insert into TOPONYME_DIVERS values ('14','PAIE_NAT0000000069985248','BDNyme','la donis','6','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.102013 14.674386)'));
insert into TOPONYME_DIVERS values ('15','PAIE_NAT0000000069985319','BDNyme','bois michel','6','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.009029 14.512195)'));
insert into TOPONYME_DIVERS values ('16','PAIE_NAT0000000069985225','BDNyme','grand bouliki','7','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.083038 14.710378)'));
insert into TOPONYME_DIVERS values ('17','PAIE_NAT0000000069985008','BDNyme','petit bois','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.029441 14.808628)'));
insert into TOPONYME_DIVERS values ('18','PAIE_NAT0000000069985090','BDNyme','bois montout','7','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.083394 14.796740)'));
insert into TOPONYME_DIVERS values ('19','PAIE_NAT0000000069985345','BDNyme','bois carré','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.050940 14.507949)'));
insert into TOPONYME_DIVERS values ('20','PAIE_NAT0000000069985219','BDNyme','petit bouliki','7','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.071225 14.706484)'));
insert into TOPONYME_DIVERS values ('21','PAIE_NAT0000000069985071','BDNyme','forêt de reculée','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.045894 14.776172)'));
insert into TOPONYME_DIVERS values ('22','PAIE_NAT0000000069984996','BDNyme','bois jean clair','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.164304 14.848888)'));
insert into TOPONYME_DIVERS values ('23','PAIE_NAT0000000069985142','BDNyme','bois crassous','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.060681 14.774038)'));
insert into TOPONYME_DIVERS values ('24','PAIE_NAT0000000069985083','BDNyme','bois condioneau','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.076187 14.789269)'));
insert into TOPONYME_DIVERS values ('25','PAIE_NAT0000000069985076','BDNyme','bois duhautmont','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.051424 14.784046)'));
insert into TOPONYME_DIVERS values ('26','PAIE_NAT0000000069985073','BDNyme','bois desmornières','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.051763 14.780370)'));
insert into TOPONYME_DIVERS values ('27','PAIE_NAT0000000069985074','BDNyme','bois duval','7','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.061561 14.791975)'));
insert into TOPONYME_DIVERS values ('28','PAIE_NAT0000000069985080','BDNyme','bois bellevue','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.067607 14.781687)'));
insert into TOPONYME_DIVERS values ('29','PAIE_NAT0000000069985336','BDNyme','forêt départementalo-domaniale de montravail','6','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.936619 14.492238)'));
insert into TOPONYME_DIVERS values ('30','PAIE_NAT0000000069985029','BDNyme','bois gradis','6','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.153028 14.833099)'));
insert into TOPONYME_DIVERS values ('31','PAIE_NAT0000000069985146','BDNyme','bois de l\'étang','7','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.052185 14.747786)'));
insert into TOPONYME_DIVERS values ('32','PAIE_NAT0000000069984988','BDNyme','bois jean hallay','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.161365 14.849144)'));
insert into TOPONYME_DIVERS values ('33','PAIE_NAT0000000069985086','BDNyme','bois d\'assier','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.082975 14.792552)'));
insert into TOPONYME_DIVERS values ('34','PAIE_NAT0000000069985077','BDNyme','bois l\'osole','8','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.061710 14.781656)'));
insert into TOPONYME_DIVERS values ('35','PAIE_NAT0000000069985092','BDNyme','bois jourdan','5','Bois', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.107217 14.794832)'));
