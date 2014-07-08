SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Orographie
--
create table ORONYME (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'Non renseigné', NOM varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', NATURE varchar(11) default 'NR', constraint ORONYME_pkey primary key (gid));
select AddGeometryColumn('','oronyme','the_geom','210642000','MULTIPOINT',2);
create index ORONYME_geoidx on ORONYME using gist (the_geom gist_geometry_ops);
--
commit;
--
-- ORONYME
start transaction;
insert into ORONYME values ('1','PAIOROGR0000000069985765','BDNyme','pointe à monter','8','Cap', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.087716 14.534252)'));
insert into ORONYME values ('2','PAIOROGR0000000069985651','BDNyme','le tombeau des anglais','8','Grotte', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.111529 14.647351)'));
insert into ORONYME values ('3','PAIOROGR0000000069985630','BDNyme','bois la roche','8','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.130120 14.671477)'));
insert into ORONYME values ('4','PAIOROGR0000000069985622','BDNyme','morne obely','7','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.119241 14.678945)'));
insert into ORONYME values ('5','PAIOROGR0000000069985616','BDNyme','morne duclos','6','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.097960 14.667438)'));
insert into ORONYME values ('6','PAIOROGR0000000069985612','BDNyme','morne césaire','6','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.082605 14.668613)'));
insert into ORONYME values ('7','PAIOROGR0000000069985530','BDNyme','morne du lorrain','6','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.079092 14.727316)'));
insert into ORONYME values ('8','PAIOROGR0000000069985388','BDNyme','crête de balata','7','Crête', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.179707 14.852391)'));
insert into ORONYME values ('9','PAIOROGR0000000069985387','BDNyme','pain de sucre','5','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.182487 14.842228)'));
insert into ORONYME values ('10','PAIOROGR0000000069985504','BDNyme','morne balisier','6','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.130362 14.764882)'));
insert into ORONYME values ('11','PAIOROGR0000000069985506','BDNyme','col raibaud','8','Col', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.133278 14.746316)'));
insert into ORONYME values ('12','PAIOROGR0000000069985507','BDNyme','morne montauban','7','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.138041 14.746525)'));
insert into ORONYME values ('13','PAIOROGR0000000069985437','BDNyme','morne courbaril','8','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.017321 14.800192)'));
insert into ORONYME values ('14','PAIOROGR0000000069985452','BDNyme','crête d\'or','7','Crête', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.111704 14.785216)'));
insert into ORONYME values ('15','PAIOROGR0000000069985451','BDNyme','crête du cournan','5','Crête', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.107116 14.787312)'));
insert into ORONYME values ('16','PAIOROGR0000000069985412','BDNyme','gorges de la falaise','7','Gorge', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.133368 14.819311)'));
insert into ORONYME values ('17','PAIOROGR0000000069985464','BDNyme','morne folie','7','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.214021 14.789135)'));
insert into ORONYME values ('18','PAIOROGR0000000069985423','BDNyme','la garanne','6','Crête', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.193311 14.823406)'));
insert into ORONYME values ('19','PAIOROGR0000000069985462','BDNyme','crête paviot','6','Crête', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.191362 14.782803)'));
insert into ORONYME values ('20','PAIOROGR0000000069985463','BDNyme','morne julien','6','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.207107 14.801905)'));
insert into ORONYME values ('21','PAIOROGR0000000069985457','BDNyme','morne saint-martin','8','Versant', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.169275 14.793807)'));
insert into ORONYME values ('22','PAIOROGR0000000069985417','BDNyme','montagne pelée','1','Montagne', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.167087 14.810817)'));
insert into ORONYME values ('23','PAIOROGR0000000069985458','BDNyme','morne perret ou morne lenard','6','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.178917 14.788199)'));
insert into ORONYME values ('24','PAIOROGR0000000069985453','BDNyme','morne calebasse','6','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.143090 14.799191)'));
insert into ORONYME values ('25','PAIOROGR0000000069985418','BDNyme','morne la croix','8','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.163909 14.813159)'));
insert into ORONYME values ('26','PAIOROGR0000000069985461','BDNyme','gros morne','6','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.186363 14.798679)'));
insert into ORONYME values ('27','PAIOROGR0000000069985528','BDNyme','morne bellevue','6','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.059908 14.736708)'));
insert into ORONYME values ('28','PAIOROGR0000000069985503','BDNyme','morne la caillerie','6','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.094241 14.753398)'));
insert into ORONYME values ('29','PAIOROGR0000000069985381','BDNyme','pointe raisiniers','6','Cap', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.084245 14.852904)'));
insert into ORONYME values ('30','PAIOROGR0000000069985594','BDNyme','îlet petit piton ou rocher de la grotte','8','Ile', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.880249 14.684489)'));
insert into ORONYME values ('31','PAIOROGR0000000069985718','BDNyme','pointe bois d\'inde ou pointe de la rose','6','Cap', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.038161 14.547334)'));
insert into ORONYME values ('32','PAIOROGR0000000069985614','BDNyme','morne moco','7','Sommet', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.082752 14.665650)'));
insert into ORONYME values ('33','PAIOROGR0000000069985518','BDNyme','pointe à chaux','7','Cap', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.915851 14.727002)'));
insert into ORONYME values ('34','PAIOROGR0000000069985374','BDNyme','pointe châteaugué','6','Cap', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.044860 14.836576)'));
insert into ORONYME values ('35','PAIOROGR0000000069985471','BDNyme','pointe granjean','8','Cap', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.894846 14.746178)'));
