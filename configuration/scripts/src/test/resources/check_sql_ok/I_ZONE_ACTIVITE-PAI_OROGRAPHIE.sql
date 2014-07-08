SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Orographie
--
create table PAI_OROGRAPHIE (gid SERIAL not null, ID varchar(24) not null, ORIGINE varchar(17) default 'NR', NATURE varchar(11) default 'NR', TOPONYME varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', constraint PAI_OROGRAPHIE_pkey primary key (gid));
select AddGeometryColumn('','pai_orographie','the_geom','210642000','MULTIPOINT',2);
create index PAI_OROGRAPHIE_geoidx on PAI_OROGRAPHIE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- PAI_OROGRAPHIE
start transaction;
insert into PAI_OROGRAPHIE values ('1','PAIOROGR0000000069985765','BDNyme','Cap','pointe à monter','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.087716 14.534253)'));
insert into PAI_OROGRAPHIE values ('2','PAIOROGR0000000069985651','BDNyme','Grotte','le tombeau des anglais','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.111529 14.647351)'));
insert into PAI_OROGRAPHIE values ('3','PAIOROGR0000000069985630','BDNyme','Sommet','bois la roche','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.130121 14.671477)'));
insert into PAI_OROGRAPHIE values ('4','PAIOROGR0000000069985622','BDNyme','Sommet','morne obely','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.119241 14.678945)'));
insert into PAI_OROGRAPHIE values ('5','PAIOROGR0000000069985616','BDNyme','Sommet','morne duclos','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.097960 14.667438)'));
insert into PAI_OROGRAPHIE values ('6','PAIOROGR0000000069985612','BDNyme','Sommet','morne césaire','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.082606 14.668613)'));
insert into PAI_OROGRAPHIE values ('7','PAIOROGR0000000069985530','BDNyme','Sommet','morne du lorrain','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.079092 14.727316)'));
insert into PAI_OROGRAPHIE values ('8','PAIOROGR0000000069985388','BDNyme','Crête','crête de balata','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.179707 14.852390)'));
insert into PAI_OROGRAPHIE values ('9','PAIOROGR0000000069985387','BDNyme','Sommet','pain de sucre','5', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.182487 14.842227)'));
insert into PAI_OROGRAPHIE values ('10','PAIOROGR0000000069985504','BDNyme','Sommet','morne balisier','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.130362 14.764882)'));
insert into PAI_OROGRAPHIE values ('11','PAIOROGR0000000069985506','BDNyme','Col','col raibaud','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.133279 14.746315)'));
insert into PAI_OROGRAPHIE values ('12','PAIOROGR0000000069985507','BDNyme','Sommet','morne montauban','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.138042 14.746526)'));
insert into PAI_OROGRAPHIE values ('13','PAIOROGR0000000069985437','BDNyme','Sommet','morne courbaril','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.017321 14.800192)'));
insert into PAI_OROGRAPHIE values ('14','PAIOROGR0000000069985452','BDNyme','Crête','crête d\'or','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.111704 14.785216)'));
insert into PAI_OROGRAPHIE values ('15','PAIOROGR0000000069985451','BDNyme','Crête','crête du cournan','5', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.107116 14.787311)'));
insert into PAI_OROGRAPHIE values ('16','PAIOROGR0000000069985412','BDNyme','Gorge','gorges de la falaise','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.133368 14.819311)'));
insert into PAI_OROGRAPHIE values ('17','PAIOROGR0000000069985464','BDNyme','Sommet','morne folie','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.214021 14.789135)'));
insert into PAI_OROGRAPHIE values ('18','PAIOROGR0000000069985423','BDNyme','Crête','la garanne','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.193310 14.823406)'));
insert into PAI_OROGRAPHIE values ('19','PAIOROGR0000000069985462','BDNyme','Crête','crête paviot','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.191363 14.782803)'));
insert into PAI_OROGRAPHIE values ('20','PAIOROGR0000000069985463','BDNyme','Sommet','morne julien','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.207108 14.801906)'));
insert into PAI_OROGRAPHIE values ('21','PAIOROGR0000000069985457','BDNyme','Versant','morne saint-martin','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.169275 14.793807)'));
insert into PAI_OROGRAPHIE values ('22','PAIOROGR0000000069985417','BDNyme','Montagne','montagne pelée','1', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.167088 14.810817)'));
insert into PAI_OROGRAPHIE values ('23','PAIOROGR0000000069985458','BDNyme','Sommet','morne perret ou morne lenard','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.178917 14.788200)'));
insert into PAI_OROGRAPHIE values ('24','PAIOROGR0000000069985453','BDNyme','Sommet','morne calebasse','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.143090 14.799192)'));
insert into PAI_OROGRAPHIE values ('25','PAIOROGR0000000069985418','BDNyme','Sommet','morne la croix','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.163910 14.813159)'));
insert into PAI_OROGRAPHIE values ('26','PAIOROGR0000000069985461','BDNyme','Sommet','gros morne','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.186363 14.798679)'));
insert into PAI_OROGRAPHIE values ('27','PAIOROGR0000000069985528','BDNyme','Sommet','morne bellevue','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.059908 14.736709)'));
insert into PAI_OROGRAPHIE values ('28','PAIOROGR0000000069985503','BDNyme','Sommet','morne la caillerie','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.094241 14.753397)'));
insert into PAI_OROGRAPHIE values ('29','PAIOROGR0000000069985381','BDNyme','Cap','pointe raisiniers','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.084245 14.852903)'));
insert into PAI_OROGRAPHIE values ('30','PAIOROGR0000000069985594','BDNyme','Ile','îlet petit piton ou rocher de la grotte','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.880249 14.684489)'));
insert into PAI_OROGRAPHIE values ('31','PAIOROGR0000000069985718','BDNyme','Cap','pointe bois d\'inde ou pointe de la rose','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.038161 14.547334)'));
insert into PAI_OROGRAPHIE values ('32','PAIOROGR0000000069985614','BDNyme','Sommet','morne moco','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.082752 14.665650)'));
insert into PAI_OROGRAPHIE values ('33','PAIOROGR0000000069985518','BDNyme','Cap','pointe à chaux','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.915851 14.727002)'));
insert into PAI_OROGRAPHIE values ('34','PAIOROGR0000000069985374','BDNyme','Cap','pointe châteaugué','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.044860 14.836576)'));
insert into PAI_OROGRAPHIE values ('35','PAIOROGR0000000069985471','BDNyme','Cap','pointe granjean','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.894846 14.746178)'));
