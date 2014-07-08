SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Transport
--
create table TOPONYME_FERRE (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'Non renseign�', NOM varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', NATURE varchar(25) default 'NR', constraint TOPONYME_FERRE_pkey primary key (gid));
select AddGeometryColumn('','toponyme_ferre','the_geom','210024000','MULTIPOINT',2);
create index TOPONYME_FERRE_geoidx on TOPONYME_FERRE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- TOPONYME_FERRE
start transaction;
insert into TOPONYME_FERRE values ('1','PAITRANS0000000119239258','G�oroute','arr�t de decy-froidmont','NR','Gare voyageurs uniquement', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.691914 49.702551)'));
insert into TOPONYME_FERRE values ('2','PAITRANS0000000006690338','BDNyme','t�l�ski de la pyramide','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.606468 44.468932)'));
insert into TOPONYME_FERRE values ('3','PAITRANS0000000006690337','BDNyme','t�l�ski de la for�t','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.603774 44.476195)'));
insert into TOPONYME_FERRE values ('4','PAITRANS0000000006690339','BDNyme','t�l�ski du proron','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.607055 44.479680)'));
insert into TOPONYME_FERRE values ('5','PAITRANS0000000012529751','BDNyme','t�l�si�ge du chantel','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.779971 45.574008)'));
insert into TOPONYME_FERRE values ('6','PAITRANS0000000003089801','BDNyme','chemin de fer de saint-eutrope','8','Voie ferr�e', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.382277 48.626991)'));
insert into TOPONYME_FERRE values ('7','PAITRANS0000000075594818','BDNyme','t�l�ski des jouvencelles','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.335134 45.045390)'));
insert into TOPONYME_FERRE values ('8','PAITRANS0000000075594837','BDNyme','t�l�si�ge du chalvet','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.711327 44.948102)'));
insert into TOPONYME_FERRE values ('9','PAITRANS0000000075594834','BDNyme','t�l�si�ge du rocher rouge','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.722201 44.958138)'));
insert into TOPONYME_FERRE values ('10','PAITRANS0000000075594882','BDNyme','t�l�si�ge du col de l\'eychauda','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.500232 44.938723)'));
insert into TOPONYME_FERRE values ('11','PAITRANS0000000075594878','BDNyme','t�l�si�ge du bachas','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.502959 44.950600)'));
insert into TOPONYME_FERRE values ('12','PAITRANS0000000075594889','BDNyme','t�l�si�ge de l\'observatoire','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.711965 44.904006)'));
insert into TOPONYME_FERRE values ('13','PAITRANS0000000075594887','BDNyme','t�l�si�ge des gondrans','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.717809 44.899819)'));
insert into TOPONYME_FERRE values ('14','PAITRANS0000000075594937','BDNyme','t�l�ski des ajourdines','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.473951 44.856584)'));
insert into TOPONYME_FERRE values ('15','PAITRANS0000000075594981','BDNyme','t�l�ski du puy','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.461839 44.807634)'));
insert into TOPONYME_FERRE values ('16','PAITRANS0000000075594978','BDNyme','t�l�si�ge de la pendine','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.457245 44.803834)'));
insert into TOPONYME_FERRE values ('17','PAITRANS0000000075595020','BDNyme','t�leski de bramousse','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.766153 44.681023)'));
insert into TOPONYME_FERRE values ('18','PAITRANS0000000075595093','BDNyme','t�l�ski des veaux','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.902337 44.660543)'));
insert into TOPONYME_FERRE values ('19','PAITRANS0000000075595131','BDNyme','t�l�ski de l\'aiguille','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.043336 44.634448)'));
insert into TOPONYME_FERRE values ('20','PAITRANS0000000075595152','BDNyme','t�l�si�ge de la mayt','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.659703 44.579538)'));
insert into TOPONYME_FERRE values ('21','PAITRANS0000000075595235','BDNyme','t�l�skis de p�rescuelle','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.558644 44.494378)'));
insert into TOPONYME_FERRE values ('22','PAITRANS0000000075595251','BDNyme','t�l�ski de la sapie','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.922329 44.512167)'));
insert into TOPONYME_FERRE values ('23','PAITRANS0000000215181441','NR','t�l�ski du gelaz','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.420539 45.456526)'));
insert into TOPONYME_FERRE values ('24','PAITRANS0000000067337469','BDNyme','t�l�ph�rique de rochebrune','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.613849 45.839011)'));
insert into TOPONYME_FERRE values ('25','PAITRANS0000000012530094','BDNyme','t�l�ski du stade','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.566844 45.391258)'));
insert into TOPONYME_FERRE values ('26','PAITRANS0000000079950235','BDNyme','t�l�ski du labi�re','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.932778 42.783440)'));
insert into TOPONYME_FERRE values ('27','PAITRANS0000000098666493','Plan','t�l�cabine du varet','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.828115 45.569424)'));
insert into TOPONYME_FERRE values ('28','PAITRANS0000000067337118','BDNyme','t�l�si�ge de gron','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.663970 46.033219)'));
insert into TOPONYME_FERRE values ('29','PAITRANS0000000098666495','Plan','t�l�ph�rique de l\'aiguille rouge','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.836120 45.554500)'));
insert into TOPONYME_FERRE values ('30','PAITRANS0000000012530116','BDNyme','t�l�cabine de l\'arpasson','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.563327 45.381956)'));
insert into TOPONYME_FERRE values ('31','PAITRANS0000000012530464','BDNyme','t�l�ski des granges','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.718998 45.197868)'));
insert into TOPONYME_FERRE values ('32','PAITRANS0000000012530468','BDNyme','t�l�si�ge de l\'arlette','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.718549 45.197651)'));
insert into TOPONYME_FERRE values ('33','PAITRANS0000000012530638','BDNyme','t�l�ski des echaux','8','T�l�ph�rique', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.338055 45.207668)'));
insert into TOPONYME_FERRE values ('34','PAITRANS0000000008230088','BDNyme','gare de dole-triage','8','Gare fret uniquement', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.505732 47.101767)'));
insert into TOPONYME_FERRE values ('35','PAITRANS0000000041768159','G�oroute','gare de mon�teau-gurgy','8','Gare voyageurs uniquement', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.579835 47.850752)'));
