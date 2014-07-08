SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Orographie
--
create table ORONYME (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'Non renseigné', NOM varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', NATURE varchar(11) default 'NR', constraint ORONYME_pkey primary key (gid));
select AddGeometryColumn('','oronyme','the_geom','210024000','MULTIPOINT',2);
create index ORONYME_geoidx on ORONYME using gist (the_geom gist_geometry_ops);
--
commit;
--
-- ORONYME
start transaction;
insert into ORONYME values ('1','PAIOROGR0000000214057774','BDNyme','île de beaucaire','8','Ile', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.086293 44.097691)'));
insert into ORONYME values ('2','PAIOROGR0000000023220898','BDNyme','île carn','7','Ile', GeomFromEWKT('SRID=210024000;MULTIPOINT(-4.692847 48.574935)'));
insert into ORONYME values ('3','PAIOROGR0000000211403828','BDNyme','grottes de maxange','8','Grotte', GeomFromEWKT('SRID=210024000;MULTIPOINT(0.917073 44.836742)'));
insert into ORONYME values ('4','PAIOROGR0000000076158671','BDNyme','men lem','7','Récif', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.092793 48.912428)'));
insert into ORONYME values ('5','PAIOROGR0000000076158670','BDNyme','les trois branches','7','Récif', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.093965 48.910573)'));
insert into ORONYME values ('6','PAIOROGR0000000095085129','BDNyme','serre du moulin à vent','8','Crête', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.300306 44.112143)'));
insert into ORONYME values ('7','PAIOROGR0000000095085127','BDNyme','croute sèque','7','Versant', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.304350 44.118573)'));
insert into ORONYME values ('8','PAIOROGR0000000095083317','BDNyme','serre des moures','8','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.309851 44.096222)'));
insert into ORONYME values ('9','PAIOROGR0000000000388898','Plan','bords de seine',DEFAULT,'Gorge', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.233053 48.822299)'));
insert into ORONYME values ('10','PAIOROGR0000000000819568','BDNyme','vallée de breux','8','Vallée', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.078581 48.767410)'));
insert into ORONYME values ('11','PAIOROGR0000000095083316','BDNyme','serre de la gardette','7','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.327690 44.089594)'));
insert into ORONYME values ('12','PAIOROGR0000000095083303','BDNyme','combe de pousselargues','8','Vallée', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.334794 44.062878)'));
insert into ORONYME values ('13','PAIOROGR0000000095083251','BDNyme','serre de légaton','8','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.329278 44.070551)'));
insert into ORONYME values ('14','PAIOROGR0000000095083185','BDNyme','la dame','7','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.294675 44.071314)'));
insert into ORONYME values ('15','PAIOROGR0000000095083184','BDNyme','la chau','7','Plaine', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.305690 44.066645)'));
insert into ORONYME values ('16','PAIOROGR0000000076158664','BDNyme','la jument','7','Récif', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.131494 48.915990)'));
insert into ORONYME values ('17','PAIOROGR0000000095083282','BDNyme','serre de roule-bel','8','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.343912 44.082946)'));
insert into ORONYME values ('18','PAIOROGR0000000095083283','BDNyme','serre de l\'éouzière','8','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.349748 44.093739)'));
insert into ORONYME values ('19','PAIOROGR0000000095083302','BDNyme','combe de saint-geniès','8','Vallée', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.347287 44.061336)'));
insert into ORONYME values ('20','PAIOROGR0000000076158663','BDNyme','les épées de tréguier','7','Récif', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.131101 48.912405)'));
insert into ORONYME values ('21','PAIOROGR0000000095083309','BDNyme','coste belle','6','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.348822 44.065560)'));
insert into ORONYME values ('22','PAIOROGR0000000076158662','BDNyme','pen ar heïn','7','Récif', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.110783 48.914273)'));
insert into ORONYME values ('23','PAIOROGR0000000095085278','BDNyme','côte de léris','7','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.357130 44.136586)'));
insert into ORONYME values ('24','PAIOROGR0000000076158661','BDNyme','kein braz kern','8','Récif', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.107188 48.918959)'));
insert into ORONYME values ('25','PAIOROGR0000000211416630','BDNyme','plage de men armor','8','Plage', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.480196 47.495138)'));
insert into ORONYME values ('26','PAIOROGR0000000006013131','BDNyme','île de cuissy','8','Ile', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.466724 47.756045)'));
insert into ORONYME values ('27','PAIOROGR0000000095085296','BDNyme','la grand combe','8','Vallée', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.373126 44.139679)'));
insert into ORONYME values ('28','PAIOROGR0000000095083775','BDNyme','île de miémar','4','Ile', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.776845 44.061150)'));
insert into ORONYME values ('29','PAIOROGR0000000095076113','BDNyme','combe vacquières','8','Vallée', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.559384 43.898617)'));
insert into ORONYME values ('30','PAIOROGR0000000095076100','BDNyme','combe del serre','8','Vallée', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.541265 43.915543)'));
insert into ORONYME values ('31','PAIOROGR0000000095076099','BDNyme','régos','8','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.546646 43.922280)'));
insert into ORONYME values ('32','PAIOROGR0000000095076075','BDNyme','combe du four','8','Vallée', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.501361 43.899568)'));
insert into ORONYME values ('33','PAIOROGR0000000095085313','BDNyme','côte de pignargues','7','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.371712 44.125693)'));
insert into ORONYME values ('34','PAIOROGR0000000095085337','BDNyme','la côte','7','Sommet', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.352083 44.138703)'));
insert into ORONYME values ('35','PAIOROGR0000000095071621','BDNyme','combe mégère','8','Vallée', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.320025 43.673273)'));
