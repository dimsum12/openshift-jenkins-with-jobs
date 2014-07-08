SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Lieu dit non habité
--
create table LIEU_DIT_NON_HABITE (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'Non renseigné', NOM varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', NATURE varchar(24) default 'NR', constraint LIEU_DIT_NON_HABITE_pkey primary key (gid));
select AddGeometryColumn('','lieu_dit_non_habite','the_geom','210024000','MULTIPOINT',2);
create index LIEU_DIT_NON_HABITE_geoidx on LIEU_DIT_NON_HABITE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- LIEU_DIT_NON_HABITE
start transaction;
insert into LIEU_DIT_NON_HABITE values ('1','PAICULOI0000000200062226','BDNyme','le grand parc','6','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(2.637761 46.831370)'));
insert into LIEU_DIT_NON_HABITE values ('2','PAICULOI0000000200062228','BDNyme','le parc','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(2.614231 47.424484)'));
insert into LIEU_DIT_NON_HABITE values ('3','PAICULOI0000000082916418','Terrain','abbaye de divielle',DEFAULT,'Vestiges archéologiques', GeomFromEWKT('SRID=210024000;MULTIPOINT(-0.923685 43.740222)'));
insert into LIEU_DIT_NON_HABITE values ('4','PAICULOI0000000076160644','BDNyme','fossé catuelan','8','Vestiges archéologiques', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.482904 48.643263)'));
insert into LIEU_DIT_NON_HABITE values ('5','PAICULOI0000000119887559','BDNyme','temple de mercure (ruines gallo-romaines)','8','Vestiges archéologiques', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.964601 45.771670)'));
insert into LIEU_DIT_NON_HABITE values ('6','PAICULOI0000000203097483','BDNyme','parc de bodélio','7','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.275029 47.690430)'));
insert into LIEU_DIT_NON_HABITE values ('7','PAICULOI0000000204650105','BDNyme','jardins des serres d\'auteuil',DEFAULT,'Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(2.253347 48.846492)'));
insert into LIEU_DIT_NON_HABITE values ('8','PAICULOI0000000201121963','BDNyme','parc de la chanterelle','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(2.991392 50.680921)'));
insert into LIEU_DIT_NON_HABITE values ('9','PAICULOI0000000201121964','BDNyme','parc barbieux','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(3.159790 50.674876)'));
insert into LIEU_DIT_NON_HABITE values ('10','PAICULOI0000000201121965','BDNyme','parc du lion','7','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(3.200044 50.710543)'));
insert into LIEU_DIT_NON_HABITE values ('11','PAICULOI0000000201121969','BDNyme','parc de l\'yser','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(3.168084 50.744935)'));
insert into LIEU_DIT_NON_HABITE values ('12','PAICULOI0000000028745827','BDNyme','la pierre tremblante','8','Vestiges archéologiques', GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.822201 47.180873)'));
insert into LIEU_DIT_NON_HABITE values ('13','PAICULOI0000000056485874','BDNyme','site sabatier','6','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(3.497043 50.406810)'));
insert into LIEU_DIT_NON_HABITE values ('14','PAICULOI0000000203176879','BDNyme','parc de la barbette','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.370493 46.199419)'));
insert into LIEU_DIT_NON_HABITE values ('15','PAICULOI0000000005314395','BDNyme','pierre du sacrifice','8','Dolmen', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.218628 44.300328)'));
insert into LIEU_DIT_NON_HABITE values ('16','PAICULOI0000000023223889','BDNyme','kazeg ven','8','Dolmen', GeomFromEWKT('SRID=210024000;MULTIPOINT(-4.206379 48.090806)'));
insert into LIEU_DIT_NON_HABITE values ('17','PAICULOI0000000001729579','BDNyme','table du roi','8','Vestiges archéologiques', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.665340 48.482888)'));
insert into LIEU_DIT_NON_HABITE values ('18','PAICULOI0000000001729580','BDNyme','table du grand maître','8','Vestiges archéologiques', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.660931 48.447327)'));
insert into LIEU_DIT_NON_HABITE values ('19','PAICULOI0000000119887663','BDNyme','dolmen de boisseyre','8','Dolmen', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.703465 45.546174)'));
insert into LIEU_DIT_NON_HABITE values ('20','PAICULOI0000000003754145','BDNyme','cimetière des anglais (allée couverte)','8','Dolmen', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.022017 49.022896)'));
insert into LIEU_DIT_NON_HABITE values ('21','PAICULOI0000000203178276','BDNyme','parc départemental du marais des bris','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.208362 45.824969)'));
insert into LIEU_DIT_NON_HABITE values ('22','PAICULOI0000000031059213','BDNyme','la pierre fondue','8','Dolmen', GeomFromEWKT('SRID=210024000;MULTIPOINT(0.599046 47.084111)'));
insert into LIEU_DIT_NON_HABITE values ('23','PAICULOI0000000203178590','BDNyme','parc charruyer','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.160501 46.161061)'));
insert into LIEU_DIT_NON_HABITE values ('24','PAICULOI0000000023223886','BDNyme','barque de saint-conogan','8','Dolmen', GeomFromEWKT('SRID=210024000;MULTIPOINT(-4.462481 48.094262)'));
insert into LIEU_DIT_NON_HABITE values ('25','PAICULOI0000000006016166','BDNyme','vestiges des fossés de l\'ancienne abbaye de chappes en bois','8','Vestiges archéologiques', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.417077 47.840125)'));
insert into LIEU_DIT_NON_HABITE values ('26','PAICULOI0000000073941312','Géoroute','square carnot','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(7.017356 43.565222)'));
insert into LIEU_DIT_NON_HABITE values ('27','PAICULOI0000000000391135','Plan','parc frédéric pic','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(2.282029 48.818972)'));
insert into LIEU_DIT_NON_HABITE values ('28','PAICULOI0000000200261368','BDNyme','petit parc','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(2.837291 49.417573)'));
insert into LIEU_DIT_NON_HABITE values ('29','PAICULOI0000000201249118','BDNyme','parc du sourdon','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(3.856971 49.007973)'));
insert into LIEU_DIT_NON_HABITE values ('30','PAICULOI0000000007462391','BDNyme','dolmen de l\'antillière','8','Dolmen', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.696899 45.433869)'));
insert into LIEU_DIT_NON_HABITE values ('31','PAICULOI0000000201249122','BDNyme','jardin de la patte-d\'oie','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(4.020707 49.253414)'));
insert into LIEU_DIT_NON_HABITE values ('32','PAICULOI0000000007462193','BDNyme','parc du vellein','8','Espace , GeomFromEWKT('SRID=210024000;MULTIPOINT(5.149767 45.618246)'));
insert into LIEU_DIT_NON_HABITE values ('33','PAICULOI0000000008230760','BDNyme','voie romaine de pointat','8','Vestiges archéologiques', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.789214 46.753553)'));
insert into LIEU_DIT_NON_HABITE values ('34','PAICULOI0000000213648510','BDNyme','site archéologique du colombier','8','Vestiges archéologiques', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.411424 45.857423)'));
insert into LIEU_DIT_NON_HABITE values ('35','PAICULOI0000000213648520','BDNyme','la pierre grise','8','Dolmen', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.659539 45.845451)'));
