SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
create table LIEU_DIT_HABITE (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'NR', NOM varchar(70) default ' N R', IMPORTANCE varchar(2) default 'NR', NATURE varchar(15) not null, constraint LIEU_DIT_HABITE_pkey primary key (gid));
select AddGeometryColumn('','lieu_dit_habite','the_geom','210642000','MULTIPOINT',2);
create index LIEU_DIT_HABITE_geoidx on LIEU_DIT_HABITE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- LIEU_DIT_HABITE
start transaction;
insert into LIEU_DIT_HABITE values ('1','PAIHABIT0000000070011324','BDNyme','petit bois','7','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.102395 14.640887)'));
insert into LIEU_DIT_HABITE values ('2','PAIHABIT0000000070011454','BDNyme','grand paradis','8','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.084846 14.620274)'));
insert into LIEU_DIT_HABITE values ('3','PAIHABIT0000000070011310','BDNyme','godissard','7','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.069805 14.635648)'));
insert into LIEU_DIT_HABITE values ('4','PAIHABIT0000000070011465','BDNyme','habitation fond rousseau','8','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.102481 14.620165)'));
insert into LIEU_DIT_HABITE values ('5','PAIHABIT0000000070011447','BDNyme','la folie','7','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.063899 14.607466)'));
insert into LIEU_DIT_HABITE values ('6','PAIHABIT0000000070011213','BDNyme','le piton','8','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.092716 14.665271)'));
insert into LIEU_DIT_HABITE values ('7','PAIHABIT0000000070010732','BDNyme','cité grenade','7','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.119240 14.819123)'));
insert into LIEU_DIT_HABITE values ('8','PAIHABIT0000000070010727','BDNyme','derrière cimetière','6','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.114174 14.827680)'));
insert into LIEU_DIT_HABITE values ('9','PAIHABIT0000000070221408','BDNyme','joli mont','8','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.148912 14.701935)'));
insert into LIEU_DIT_HABITE values ('10','PAIHABIT0000000070011444','BDNyme','crozanville','6','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.064226 14.610450)'));
insert into LIEU_DIT_HABITE values ('11','PAIHABIT0000000070011430','BDNyme','ravine bouillé','6','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.061019 14.611073)'));
insert into LIEU_DIT_HABITE values ('12','PAIHABIT0000000070011432','BDNyme','morne vanier','7','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.058894 14.612015)'));
insert into LIEU_DIT_HABITE values ('13','PAIHABIT0000000070011417','BDNyme','la pointe des grives','7','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.046644 14.599205)'));
insert into LIEU_DIT_HABITE values ('14','PAIHABIT0000000070011413','BDNyme','morne morissot','7','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.041193 14.620677)'));
insert into LIEU_DIT_HABITE values ('15','PAIHABIT0000000070011342','BDNyme','la plate-forme','8','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.133969 14.634843)'));
insert into LIEU_DIT_HABITE values ('16','PAIHABIT0000000070011337','BDNyme','vétiver','8','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.130364 14.634137)'));
insert into LIEU_DIT_HABITE values ('17','PAIHABIT0000000070011349','BDParcellaire','petit fourneau','6','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.141523 14.645985)'));
insert into LIEU_DIT_HABITE values ('18','PAIHABIT0000000070011323','BDNyme','lotissement aubéry','7','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.099616 14.638099)'));
insert into LIEU_DIT_HABITE values ('19','PAIHABIT0000000070011466','BDNyme','anse collat','6','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.112156 14.626377)'));
insert into LIEU_DIT_HABITE values ('20','PAIHABIT0000000070011470','BDNyme','morne boye','8','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.094786 14.611661)'));
insert into LIEU_DIT_HABITE values ('21','PAIHABIT0000000070011232','BDNyme','quartier thalémont','7','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.901882 14.642088)'));
insert into LIEU_DIT_HABITE values ('22','PAIHABIT0000000070011388','BDNyme','château aubéry','7','Château', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.955354 14.607820)'));
insert into LIEU_DIT_HABITE values ('23','PAIHABIT0000000070011409','BDNyme','le calebassier','6','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.002813 14.617016)'));
insert into LIEU_DIT_HABITE values ('24','PAIHABIT0000000070011410','BDNyme','vieux pont','6','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.005463 14.613378)'));
insert into LIEU_DIT_HABITE values ('25','PAIHABIT0000000070011251','BDNyme','habitation petite rivière','6','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.968409 14.655322)'));
insert into LIEU_DIT_HABITE values ('26','PAIHABIT0000000070011550','BDNyme','le lazaret','7','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.976684 14.580018)'));
insert into LIEU_DIT_HABITE values ('27','PAIHABIT0000000070011551','BDNyme','la sérénité','6','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.979157 14.573289)'));
insert into LIEU_DIT_HABITE values ('28','PAIHABIT0000000070011180','BDNyme','en bidault','7','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.036860 14.682879)'));
insert into LIEU_DIT_HABITE values ('29','PAIHABIT0000000070011274','BDNyme','desgatte','7','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.032265 14.653966)'));
insert into LIEU_DIT_HABITE values ('30','PAIHABIT0000000070011020','BDNyme','les ananas','8','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.981174 14.691436)'));
insert into LIEU_DIT_HABITE values ('31','PAIHABIT0000000070011049','BDNyme','fonds abricot','7','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.009023 14.691677)'));
insert into LIEU_DIT_HABITE values ('32','PAIHABIT0000000070011035','BDNyme','morne congo','7','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.982778 14.704756)'));
insert into LIEU_DIT_HABITE values ('33','PAIHABIT0000000070010909','BDNyme','zone d\'aménagement concerté du bac','8','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.947505 14.729645)'));
insert into LIEU_DIT_HABITE values ('34','PAIHABIT0000000070010841','BDNyme','bonneville','8','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.989958 14.745733)'));
insert into LIEU_DIT_HABITE values ('35','PAIHABIT0000000070011756','BDNyme','cerise','8','Lieu-dit habité', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.064493 14.509904)'));
insert into LIEU_DIT_HABITE values ('36','PAIHABIT0000000070011424','BDNyme','montgérald','6','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.049324 14.621614)'));
insert into LIEU_DIT_HABITE values ('37','PAIHABIT0000000070011284','BDNyme','jambette','6','Quartier', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.041567 14.641186)'));
