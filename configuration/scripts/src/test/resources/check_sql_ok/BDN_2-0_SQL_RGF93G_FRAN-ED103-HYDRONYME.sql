SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Hydrographie
--
create table HYDRONYME (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'Non renseigné', NOM varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', NATURE varchar(15) default 'NR', constraint HYDRONYME_pkey primary key (gid));
select AddGeometryColumn('','hydronyme','the_geom','210024000','MULTIPOINT',2);
create index HYDRONYME_geoidx on HYDRONYME using gist (the_geom gist_geometry_ops);
--
commit;
--
-- HYDRONYME
start transaction;
insert into HYDRONYME values ('1','PAIHYDRO0000000095080646','BDNyme','font froide','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.965755 44.023496)'));
insert into HYDRONYME values ('2','PAIHYDRO0000000095080539','BDNyme','fontaine des sarrasins','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.908833 44.000790)'));
insert into HYDRONYME values ('3','PAIHYDRO0000000095078590','BDNyme','source des boulidous de sallèles','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.971961 43.992802)'));
insert into HYDRONYME values ('4','PAIHYDRO0000000095080606','BDNyme','fontaine de madame d\'anduze','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.980740 44.047335)'));
insert into HYDRONYME values ('5','PAIHYDRO0000000095080344','BDNyme','fontaine verte','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.896567 44.047601)'));
insert into HYDRONYME values ('6','PAIHYDRO0000000095080343','BDNyme','fontaine du lion','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.888545 44.044703)'));
insert into HYDRONYME values ('7','PAIHYDRO0000000210338438','BDNyme','marais du bois sur vessy','8','Marais', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.113116 46.265446)'));
insert into HYDRONYME values ('8','PAIHYDRO0000000000388919','BDNyme','étang colbert','8','Lac', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.271130 48.784891)'));
insert into HYDRONYME values ('9','PAIHYDRO0000000000388908','BDNyme','la grande gerbe','8','Lac', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.206059 48.834046)'));
insert into HYDRONYME values ('10','PAIHYDRO0000000095071053','BDNyme','étang de la ville','6','Lac', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.204918 43.550440)'));
insert into HYDRONYME values ('11','PAIHYDRO0000000211403829','BDNyme','étangs du bos','8','Lac', GeomFromEWKT('SRID=210024000;MULTIPOINT(0.971955 44.868311)'));
insert into HYDRONYME values ('12','PAIHYDRO0000000076159353','BDNyme','les sirlots','8','Amer', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.992314 48.881107)'));
insert into HYDRONYME values ('13','PAIHYDRO0000000095075985','BDNyme','la fontaine','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.461299 43.902687)'));
insert into HYDRONYME values ('14','PAIHYDRO0000000095076073','BDNyme','résurgence de la vis','6','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.482815 43.899837)'));
insert into HYDRONYME values ('15','PAIHYDRO0000000095076841','BDNyme','font du bayle','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.129862 43.876346)'));
insert into HYDRONYME values ('16','PAIHYDRO0000000095076006','BDNyme','la lavagne','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.417198 43.930377)'));
insert into HYDRONYME values ('17','PAIHYDRO0000000095073411','BDNyme','source du ranquet','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.231437 43.793166)'));
insert into HYDRONYME values ('18','PAIHYDRO0000000076159341','BDNyme','basses des épées','7','Espace maritime', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.127487 48.904463)'));
insert into HYDRONYME values ('19','PAIHYDRO0000000076159335','BDNyme','carec mingui','8','Espace maritime', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.008707 48.919106)'));
insert into HYDRONYME values ('20','PAIHYDRO0000000076159336','BDNyme','roc\'h ar bel','7','Espace maritime', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.002197 48.922110)'));
insert into HYDRONYME values ('21','PAIHYDRO0000000087158786','BDNyme','basse des pitochets','8','Banc', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.991834 47.280062)'));
insert into HYDRONYME values ('22','PAIHYDRO0000000095071170','BDNyme','clos de talar','7','Marais', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.289879 43.518921)'));
insert into HYDRONYME values ('23','PAIHYDRO0000000076159339','BDNyme','carec done','8','Espace maritime', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.999195 48.906922)'));
insert into HYDRONYME values ('24','PAIHYDRO0000000076159338','BDNyme','keïn énez terc\'h','7','Espace maritime', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.177664 48.912870)'));
insert into HYDRONYME values ('25','PAIHYDRO0000000095070783','BDNyme','les plaines de l\'abbé','6','Marais', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.241021 43.507406)'));
insert into HYDRONYME values ('26','PAIHYDRO0000000023222377','BDNyme','basse de porsac\'h',DEFAULT,'Espace maritime', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.587340 47.756809)'));
insert into HYDRONYME values ('27','PAIHYDRO0000000095074536','BDNyme','font des mas','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.122900 43.852184)'));
insert into HYDRONYME values ('28','PAIHYDRO0000000095074591','BDNyme','fontaran','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.172468 43.828743)'));
insert into HYDRONYME values ('29','PAIHYDRO0000000076159337','BDNyme','baz ar heïn hir','8','Espace maritime', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.077453 48.922170)'));
insert into HYDRONYME values ('30','PAIHYDRO0000000000820141','BDNyme','la bonne mare','8','Lac', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.391670 48.935945)'));
insert into HYDRONYME values ('31','PAIHYDRO0000000095072732','BDNyme','station de pompage aristide dumont','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.458517 43.717540)'));
insert into HYDRONYME values ('32','PAIHYDRO0000000095071346','BDNyme','étang de scamandre','7','Lac', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.358977 43.624521)'));
insert into HYDRONYME values ('33','PAIHYDRO0000000095084130','BDNyme','la pension','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.708062 44.134302)'));
insert into HYDRONYME values ('34','PAIHYDRO0000000095084142','BDNyme','source des moulènes (prise d\'eau)','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.667505 44.122574)'));
insert into HYDRONYME values ('35','PAIHYDRO0000000095079454','BDNyme','citerne de la langoustière','8','Point d\'eau', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.651001 43.980937)'));
