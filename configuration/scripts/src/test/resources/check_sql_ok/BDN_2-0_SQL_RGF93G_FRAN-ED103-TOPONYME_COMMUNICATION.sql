SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Toponyme de communication
--
create table TOPONYME_COMMUNICATION (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'NR', NOM varchar(70) default ' N R', IMPORTANCE varchar(2) default 'NR', NATURE varchar(23) default 'NR', constraint TOPONYME_COMMUNICATION_pkey primary key (gid));
select AddGeometryColumn('','toponyme_communication','the_geom','210024000','MULTIPOINT',2);
create index TOPONYME_COMMUNICATION_geoidx on TOPONYME_COMMUNICATION using gist (the_geom gist_geometry_ops);
--
commit;
--
-- TOPONYME_COMMUNICATION
start transaction;
insert into TOPONYME_COMMUNICATION values ('1','PAITRANS0000000028743552','BDNyme','ligne du cerisier ou de poidras','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.420654 47.537690)'));
insert into TOPONYME_COMMUNICATION values ('2','PAITRANS0000000012529671','BDNyme','tour du mont-blanc et tour du beaufortain','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.615925 45.796282)'));
insert into TOPONYME_COMMUNICATION values ('3','PAITRANS0000000028743652','BDNyme','route du grand gouet','8','Infrastructure routière', GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.809902 47.539386)'));
insert into TOPONYME_COMMUNICATION values ('4','PAITRANS0000000024230401','BDNyme','chasse du houlet','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.553712 49.633320)'));
insert into TOPONYME_COMMUNICATION values ('5','PAITRANS0000000024230351','BDNyme','route des couplets','8','Infrastructure routière', GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.551258 49.644326)'));
insert into TOPONYME_COMMUNICATION values ('6','PAITRANS0000000119886226','BDNyme','la croix des tuiles','8','Carrefour', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.664025 45.792389)'));
insert into TOPONYME_COMMUNICATION values ('7','PAITRANS0000000000389107','BDNyme','route du mail','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.218530 48.803959)'));
insert into TOPONYME_COMMUNICATION values ('8','PAITRANS0000000000389104','BDNyme','route de la fontaine aux lynx','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.246403 48.793830)'));
insert into TOPONYME_COMMUNICATION values ('9','PAITRANS0000000000389102','BDNyme','route du carré aux pièges','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.244125 48.799047)'));
insert into TOPONYME_COMMUNICATION values ('10','PAITRANS0000000000389101','BDNyme','route du vertugadin','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.244703 48.800818)'));
insert into TOPONYME_COMMUNICATION values ('11','PAITRANS0000000000389097','BDNyme','route de la justice','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.248845 48.798181)'));
insert into TOPONYME_COMMUNICATION values ('12','PAITRANS0000000028743620','BDNyme','allée forestière de grenée','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.784927 47.554381)'));
insert into TOPONYME_COMMUNICATION values ('13','PAITRANS0000000000389090','BDNyme','route de la porte verte','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.152425 48.818621)'));
insert into TOPONYME_COMMUNICATION values ('14','PAITRANS0000000210338777','BDNyme','pont de zone','8','Pont', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.212566 46.174747)'));
insert into TOPONYME_COMMUNICATION values ('15','PAITRANS0000000000389078','BDNyme','route de morval','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.200634 48.811006)'));
insert into TOPONYME_COMMUNICATION values ('16','PAITRANS0000000000389048','BDNyme','route de jardy','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.162788 48.820497)'));
insert into TOPONYME_COMMUNICATION values ('17','PAITRANS0000000067336841','BDNyme','littoral du léman','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(6.312375 46.341479)'));
insert into TOPONYME_COMMUNICATION values ('18','PAITRANS0000000000389040','BDNyme','allée de chartres','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.200298 48.834400)'));
insert into TOPONYME_COMMUNICATION values ('19','PAITRANS0000000006690316','BDNyme','pont de pémia','8','Pont', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.274764 44.576453)'));
insert into TOPONYME_COMMUNICATION values ('20','PAITRANS0000000056480098','BDNyme','échangeur d\'armentières ouest','8','Echangeur', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.841332 50.683755)'));
insert into TOPONYME_COMMUNICATION values ('21','PAITRANS0000000000389009','BDNyme','allée de chamillard','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.192594 48.835060)'));
insert into TOPONYME_COMMUNICATION values ('22','PAITRANS0000000045722440','BDNyme','route forestière du clitre','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.329911 50.748045)'));
insert into TOPONYME_COMMUNICATION values ('23','PAITRANS0000000045722413','BDNyme','chemin forestier du long chêne','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.363424 50.760414)'));
insert into TOPONYME_COMMUNICATION values ('24','PAITRANS0000000056480015','BDNyme','botter straete','8','Infrastructure routière', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.347848 50.792772)'));
insert into TOPONYME_COMMUNICATION values ('25','PAITRANS0000000212977301','BDNyme','gr de pays tour de la lys','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.469327 50.641912)'));
insert into TOPONYME_COMMUNICATION values ('26','PAITRANS0000000056479989','BDNyme','boeren weg','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.345006 50.806252)'));
insert into TOPONYME_COMMUNICATION values ('27','PAITRANS0000000056480010','BDNyme','papote straete','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.336501 50.801758)'));
insert into TOPONYME_COMMUNICATION values ('28','PAITRANS0000000056480012','BDNyme','wulf straete','8','Infrastructure routière', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.366282 50.789174)'));
insert into TOPONYME_COMMUNICATION values ('29','PAITRANS0000000056480006','BDNyme','rue de l\'église','8','Infrastructure routière', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.377620 50.797259)'));
insert into TOPONYME_COMMUNICATION values ('30','PAITRANS0000000056479984','BDNyme','meulen straete','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.363456 50.823333)'));
insert into TOPONYME_COMMUNICATION values ('31','PAITRANS0000000056479985','BDNyme','boog straete','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.371973 50.815242)'));
insert into TOPONYME_COMMUNICATION values ('32','PAITRANS0000000056479976','BDNyme','aire de service de saint-laurent','8','Aire de service', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.584277 50.827449)'));
insert into TOPONYME_COMMUNICATION values ('33','PAITRANS0000000056480039','BDNyme','échangeur de méteren','7','Echangeur', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.677536 50.743905)'));
insert into TOPONYME_COMMUNICATION values ('34','PAITRANS0000000006690228','BDNyme','chemin des feuilles','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.386146 44.856068)'));
insert into TOPONYME_COMMUNICATION values ('35','PAITRANS0000000006690317','BDNyme','sentier sur les pas des huguenots en pays de bourdeaux','8','Chemin', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.130651 44.592646)'));
