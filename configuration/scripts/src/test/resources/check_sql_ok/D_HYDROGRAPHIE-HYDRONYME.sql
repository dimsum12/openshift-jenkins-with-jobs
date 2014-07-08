SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Hydrographie
--
create table HYDRONYME (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'Non renseigné', NOM varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', NATURE varchar(15) default 'NR', constraint HYDRONYME_pkey primary key (gid));
select AddGeometryColumn('','hydronyme','the_geom','210642000','MULTIPOINT',2);
create index HYDRONYME_geoidx on HYDRONYME using gist (the_geom gist_geometry_ops);
--
commit;
--
-- HYDRONYME
start transaction;
insert into HYDRONYME values ('1','PAIHYDRO0000000069985966','BDNyme','source de la goyave','8','Point d\'eau', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.147537 14.770009)'));
insert into HYDRONYME values ('2','PAIHYDRO0000000069986017','BDNyme','rivière ribodeau',DEFAULT,'Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074389 14.637957)'));
insert into HYDRONYME values ('3','PAIHYDRO0000000069985982','BDNyme','source gabrielle','8','Point d\'eau', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.129321 14.737870)'));
insert into HYDRONYME values ('4','PAIHYDRO0000000069985922','BDNyme','saut babin','8','Cascade', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.102779 14.813845)'));
insert into HYDRONYME values ('5','PAIHYDRO0000000069985891','BDNyme','la douche','8','Point d\'eau', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.116938 14.869081)'));
insert into HYDRONYME values ('6','PAIHYDRO0000000069985939','BDNyme','anse bois vert','8','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.874268 14.766762)'));
insert into HYDRONYME values ('7','PAIHYDRO0000000069985952','BDNyme','anse rivière','8','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.935755 14.759587)'));
insert into HYDRONYME values ('8','PAIHYDRO0000000069986020','BDNyme','trou monnerot','8','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.886344 14.617215)'));
insert into HYDRONYME values ('9','PAIHYDRO0000000069986071','BDNyme','la quille','7','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.089872 14.494967)'));
insert into HYDRONYME values ('10','PAIHYDRO0000000069986000','BDNyme','rivière blanche','5','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.037033 14.673844)'));
insert into HYDRONYME values ('11','PAIHYDRO0000000069985917','BDNyme','baie de fonds d\'or','7','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.035709 14.818620)'));
insert into HYDRONYME values ('12','PAIHYDRO0000000069985944','BDNyme','cul-de-sac de tartane','5','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.887737 14.753856)'));
insert into HYDRONYME values ('13','PAIHYDRO0000000069985970','BDNyme','baie granjean','6','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.897196 14.735869)'));
insert into HYDRONYME values ('14','PAIHYDRO0000000069985903','BDNyme','anse chalvet','6','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.091179 14.856703)'));
insert into HYDRONYME values ('15','PAIHYDRO0000000069985907','BDNyme','source aux manettes','8','Point d\'eau', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.166061 14.856439)'));
insert into HYDRONYME values ('16','PAIHYDRO0000000069986105','BDNyme','trou sardines','8','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.855621 14.399792)'));
insert into HYDRONYME values ('17','PAIHYDRO0000000069986097','BDNyme','anse esprit','8','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.823113 14.444973)'));
insert into HYDRONYME values ('18','PAIHYDRO0000000069986027','BDNyme','canal levassor','7','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074797 14.601863)'));
insert into HYDRONYME values ('19','PAIHYDRO0000000069986026','BDNyme','baie du carénage','7','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.064950 14.600841)'));
insert into HYDRONYME values ('20','PAIHYDRO0000000069986015','BDNyme','baie thalémont','7','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.892217 14.638639)'));
insert into HYDRONYME values ('21','PAIHYDRO0000000069985985','BDNyme','petite anse','8','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.182111 14.722557)'));
insert into HYDRONYME values ('22','PAIHYDRO0000000069986007','BDNyme','ravine degras','8','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.111373 14.665424)'));
insert into HYDRONYME values ('23','PAIHYDRO0000000069986005','BDNyme','rivière duclos','5','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.101997 14.665347)'));
insert into HYDRONYME values ('24','PAIHYDRO0000000069985906','BDNyme','rivière oué','8','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.156260 14.846536)'));
insert into HYDRONYME values ('25','PAIHYDRO0000000069985924','BDNyme','ravine avocat','8','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.147108 14.819350)'));
insert into HYDRONYME values ('26','PAIHYDRO0000000069985975','BDNyme','loup marguerite','8','Banc', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.959504 14.743378)'));
insert into HYDRONYME values ('27','PAIHYDRO0000000069986106','BDNyme','anse braham','8','Baie', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.859313 14.397549)'));
insert into HYDRONYME values ('28','PAIHYDRO0000000069986065','BDNyme','source dugane','8','Point d\'eau', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.926393 14.499739)'));
insert into HYDRONYME values ('29','PAIHYDRO0000000069985979','BDNyme','ravine glace','8','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.073513 14.737500)'));
insert into HYDRONYME values ('30','PAIHYDRO0000000069986034','BDNyme','rivière la digue','7','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.889475 14.573146)'));
insert into HYDRONYME values ('31','PAIHYDRO0000000069985938','BDNyme','rivière claire','7','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.082337 14.800744)'));
insert into HYDRONYME values ('32','PAIHYDRO0000000069985919','BDNyme','source morne boeuf','8','Point d\'eau', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.066436 14.830785)'));
insert into HYDRONYME values ('33','PAIHYDRO0000000069985936','BDNyme','rivière convinan','8','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.026599 14.791234)'));
insert into HYDRONYME values ('34','PAIHYDRO0000000069986067','BDNyme','rivière carole','7','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.020010 14.501996)'));
insert into HYDRONYME values ('35','PAIHYDRO0000000069986054','BDNyme','rivière bananes','7','Rivière', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.029125 14.520147)'));
