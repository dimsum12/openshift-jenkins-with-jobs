SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Hydrographie
--
create table PAI_HYDROGRAPHIE (gid SERIAL not null, ID varchar(24) not null, ORIGINE varchar(17) default 'NR', NATURE varchar(15) default 'NR', TOPONYME varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', constraint PAI_HYDROGRAPHIE_pkey primary key (gid));
select AddGeometryColumn('','pai_hydrographie','the_geom','210642000','MULTIPOINT',2);
create index PAI_HYDROGRAPHIE_geoidx on PAI_HYDROGRAPHIE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- PAI_HYDROGRAPHIE
start transaction;
insert into PAI_HYDROGRAPHIE values ('1','PAIHYDRO0000000069985966','BDNyme','Point d\'eau','source de la goyave','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.147537 14.770009)'));
insert into PAI_HYDROGRAPHIE values ('2','PAIHYDRO0000000069986017','BDNyme','Rivière','rivière ribodeau',DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074390 14.637957)'));
insert into PAI_HYDROGRAPHIE values ('3','PAIHYDRO0000000069985982','BDNyme','Point d\'eau','source gabrielle','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.129321 14.737870)'));
insert into PAI_HYDROGRAPHIE values ('4','PAIHYDRO0000000069985922','BDNyme','Cascade','saut babin','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.102779 14.813846)'));
insert into PAI_HYDROGRAPHIE values ('5','PAIHYDRO0000000069985891','BDNyme','Point d\'eau','la douche','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.116938 14.869081)'));
insert into PAI_HYDROGRAPHIE values ('6','PAIHYDRO0000000069985939','BDNyme','Baie','anse bois vert','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.874267 14.766762)'));
insert into PAI_HYDROGRAPHIE values ('7','PAIHYDRO0000000069985952','BDNyme','Baie','anse rivière','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.935756 14.759587)'));
insert into PAI_HYDROGRAPHIE values ('8','PAIHYDRO0000000069986020','BDNyme','Baie','trou monnerot','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.886344 14.617215)'));
insert into PAI_HYDROGRAPHIE values ('9','PAIHYDRO0000000069986071','BDNyme','Baie','la quille','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.089873 14.494966)'));
insert into PAI_HYDROGRAPHIE values ('10','PAIHYDRO0000000069986000','BDNyme','Rivière','rivière blanche','5', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.037034 14.673843)'));
insert into PAI_HYDROGRAPHIE values ('11','PAIHYDRO0000000069985917','BDNyme','Baie','baie de fonds d\'or','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.035709 14.818621)'));
insert into PAI_HYDROGRAPHIE values ('12','PAIHYDRO0000000069985944','BDNyme','Baie','cul-de-sac de tartane','5', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.887736 14.753856)'));
insert into PAI_HYDROGRAPHIE values ('13','PAIHYDRO0000000069985970','BDNyme','Baie','baie granjean','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.897196 14.735870)'));
insert into PAI_HYDROGRAPHIE values ('14','PAIHYDRO0000000069985903','BDNyme','Baie','anse chalvet','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.091180 14.856703)'));
insert into PAI_HYDROGRAPHIE values ('15','PAIHYDRO0000000069985907','BDNyme','Point d\'eau','source aux manettes','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.166061 14.856439)'));
insert into PAI_HYDROGRAPHIE values ('16','PAIHYDRO0000000069986105','BDNyme','Baie','trou sardines','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.855621 14.399791)'));
insert into PAI_HYDROGRAPHIE values ('17','PAIHYDRO0000000069986097','BDNyme','Baie','anse esprit','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.823113 14.444973)'));
insert into PAI_HYDROGRAPHIE values ('18','PAIHYDRO0000000069986027','BDNyme','Rivière','canal levassor','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074797 14.601863)'));
insert into PAI_HYDROGRAPHIE values ('19','PAIHYDRO0000000069986026','BDNyme','Baie','baie du carénage','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.064950 14.600841)'));
insert into PAI_HYDROGRAPHIE values ('20','PAIHYDRO0000000069986015','BDNyme','Baie','baie thalémont','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.892216 14.638638)'));
insert into PAI_HYDROGRAPHIE values ('21','PAIHYDRO0000000069985985','BDNyme','Baie','petite anse','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.182111 14.722557)'));
insert into PAI_HYDROGRAPHIE values ('22','PAIHYDRO0000000069986007','BDNyme','Rivière','ravine degras','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.111373 14.665425)'));
insert into PAI_HYDROGRAPHIE values ('23','PAIHYDRO0000000069986005','BDNyme','Rivière','rivière duclos','5', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.101998 14.665347)'));
insert into PAI_HYDROGRAPHIE values ('24','PAIHYDRO0000000069985906','BDNyme','Rivière','rivière oué','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.156260 14.846536)'));
insert into PAI_HYDROGRAPHIE values ('25','PAIHYDRO0000000069985924','BDNyme','Rivière','ravine avocat','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.147108 14.819350)'));
insert into PAI_HYDROGRAPHIE values ('26','PAIHYDRO0000000069985975','BDNyme','Banc','loup marguerite','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.959504 14.743378)'));
insert into PAI_HYDROGRAPHIE values ('27','PAIHYDRO0000000069986106','BDNyme','Baie','anse braham','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.859313 14.397549)'));
insert into PAI_HYDROGRAPHIE values ('28','PAIHYDRO0000000069986065','BDNyme','Point d\'eau','source dugane','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.926393 14.499738)'));
insert into PAI_HYDROGRAPHIE values ('29','PAIHYDRO0000000069985979','BDNyme','Rivière','ravine glace','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.073514 14.737500)'));
insert into PAI_HYDROGRAPHIE values ('30','PAIHYDRO0000000069986034','BDNyme','Rivière','rivière la digue','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.889475 14.573146)'));
insert into PAI_HYDROGRAPHIE values ('31','PAIHYDRO0000000069985938','BDNyme','Rivière','rivière claire','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.082337 14.800743)'));
insert into PAI_HYDROGRAPHIE values ('32','PAIHYDRO0000000069985919','BDNyme','Point d\'eau','source morne boeuf','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.066436 14.830785)'));
insert into PAI_HYDROGRAPHIE values ('33','PAIHYDRO0000000069985936','BDNyme','Rivière','rivière convinan','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.026599 14.791234)'));
insert into PAI_HYDROGRAPHIE values ('34','PAIHYDRO0000000069986067','BDNyme','Rivière','rivière carole','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.020010 14.501995)'));
insert into PAI_HYDROGRAPHIE values ('35','PAIHYDRO0000000069986054','BDNyme','Rivière','rivière bananes','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.029125 14.520146)'));
