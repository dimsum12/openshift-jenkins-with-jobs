SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Equipement administratif ou militaire
--
create table PAI_ADMINISTRATIF_MILITAIRE (gid SERIAL not null, ID varchar(24) not null, ORIGINE varchar(17) default 'NR', NATURE varchar(30) default 'NR', TOPONYME varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', constraint PAI_ADMINISTRATIF_MILITAIRE_pkey primary key (gid));
select AddGeometryColumn('','pai_administratif_militaire','the_geom','210642000','MULTIPOINT',2);
create index PAI_ADMINISTRATIF_MILITAIRE_geoidx on PAI_ADMINISTRATIF_MILITAIRE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- PAI_ADMINISTRATIF_MILITAIRE
start transaction;
insert into PAI_ADMINISTRATIF_MILITAIRE values ('1','PAIEQADM0000000069986804','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.101254 14.616252)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('2','PAIEQADM0000000069986796','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.071928 14.610841)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('3','PAIEQADM0000000069986782','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.068678 14.603581)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('4','PAIEQADM0000000069986777','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.078113 14.620700)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('5','PAIEQADM0000000069986774','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.052352 14.611031)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('6','PAIEQADM0000000069986769','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.001705 14.616217)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('7','PAIEQADM0000000069986767','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.991872 14.617891)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('8','PAIEQADM0000000069986762','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.138437 14.642768)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('9','PAIEQADM0000000069986759','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.067480 14.630770)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('10','PAIEQADM0000000069986758','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.055979 14.629451)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('11','PAIEQADM0000000069986750','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.037843 14.671007)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('12','PAIEQADM0000000069986746','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.939032 14.677832)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('13','PAIEQADM0000000069986741','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.003626 14.710821)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('14','PAIEQADM0000000069986738','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.974138 14.692735)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('15','PAIEQADM0000000069986735','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.016594 14.744960)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('16','PAIEQADM0000000069986731','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.963380 14.741545)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('17','PAIEQADM0000000069986724','BDTopo','Bureau ou h�tel des postes',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.992950 14.784470)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('18','PAIEQADM0000000069986808','BDTopo','Mairie',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.101289 14.616026)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('19','PAIEQADM0000000069986807','BDTopo','Gendarmerie',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.098670 14.614039)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('20','PAIEQADM0000000069986805','BDTopo','Enceinte militaire',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.098504 14.613100)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('21','PAIEQADM0000000069986806','BDTopo','Divers ou administratif',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.095020 14.614916)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('22','PAIEQADM0000000069986803','BDTopo','Enceinte militaire',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.090599 14.599366)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('23','PAIEQADM0000000069986802','BDTopo','Divers ou administratif',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.084878 14.617148)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('24','PAIEQADM0000000069986801','BDTopo','Divers ou administratif',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.081409 14.619084)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('25','PAIEQADM0000000069986800','BDTopo','H�tel de r�gion',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.081222 14.620238)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('26','PAIEQADM0000000069986794','BDTopo','Divers ou administratif',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.078251 14.609904)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('27','PAIEQADM0000000069986790','BDTopo','Palais de justice',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.077788 14.604990)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('28','PAIEQADM0000000069986785','BDTopo','Poste ou h�tel de police',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074991 14.610425)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('29','PAIEQADM0000000069986788','BDTopo','Caserne de pompiers',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074053 14.604586)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('30','PAIEQADM0000000069986789','BDTopo','Gendarmerie',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.071020 14.606858)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('31','PAIEQADM0000000069986793','BDTopo','Mairie',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.069513 14.607229)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('32','PAIEQADM0000000069986783','BDTopo','Divers ou administratif',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.069932 14.606583)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('33','PAIEQADM0000000069986787','BDTopo','Palais de justice',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.069581 14.605168)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('34','PAIEQADM0000000069986797','BDTopo','Pr�fecture',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.067677 14.605840)'));
insert into PAI_ADMINISTRATIF_MILITAIRE values ('35','PAIEQADM0000000069986799','BDTopo','H�tel de d�partement',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.066051 14.604155)'));
