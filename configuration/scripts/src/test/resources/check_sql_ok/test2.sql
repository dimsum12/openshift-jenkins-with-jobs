SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Religieux
--
create table PAI_RELIGIEUX (gid SERIAL not null, ID varchar(24) not null, ORIGINE varchar(17) default 'NR', NATURE varchar(29) default 'NR', TOPONYME varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', constraint PAI_RELIGIEUX_pkey primary key (gid));
select AddGeometryColumn('','pai_religieux','the_geom','210024000','MULTIPOINT',2);
create index PAI_RELIGIEUX_geoidx on PAI_RELIGIEUX using gist (the_geom gist_geometry_ops);
--
commit;
--
-- PAI_RELIGIEUX
start transaction;
insert into PAI_RELIGIEUX values ('1','PAIRELIG0000000204209339','Terrain','Culte catholique ou orthodoxe',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(8.859814 42.508754)'));
insert into PAI_RELIGIEUX values ('2','PAIRELIG0000000201334742','NR','Culte catholique ou orthodoxe',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(8.855789 42.508379)'));
insert into PAI_RELIGIEUX values ('3','PAIRELIG0000000213388466','Terrain','Culte catholique ou orthodoxe',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(9.417581 42.546256)'));
insert into PAI_RELIGIEUX values ('4','PAIRELIG0000000213388467','Terrain','Croix',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(9.480662 42.547137)'));
insert into PAI_RELIGIEUX values ('5','PAIRELIG0000000213592561','Orthophotographie','Tombeau',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(9.418666 42.547379)'));
insert into PAI_RELIGIEUX values ('6','PAIRELIG0000000206726136','BDParcellaire','Culte catholique ou orthodoxe',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(9.402157 42.393480)'));
insert into PAI_RELIGIEUX values ('7','PAIRELIG0000000206381743','BDParcellaire','Culte catholique ou orthodoxe',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(9.352179 42.398386)'));
insert into PAI_RELIGIEUX values ('8','PAIRELIG0000000207238476','BDParcellaire','Culte catholique ou orthodoxe',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(9.149741 42.306662)'));
insert into PAI_RELIGIEUX values ('9','PAIRELIG0000000213074516','Orthophotographie','Tombeau',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(9.161588 42.307480)'));
insert into PAI_RELIGIEUX values ('10','PAIRELIG0000000213074517','Terrain','Croix',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(9.146362 42.308946)'));
insert into PAI_RELIGIEUX values ('11','PAIRELIG0000000212399117','Terrain','Culte catholique ou orthodoxe',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(9.439983 42.551553)'));
insert into PAI_RELIGIEUX values ('12','PAIRELIG0000000211677632','Terrain','Culte catholique ou orthodoxe',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210024000;MULTIPOINT(9.207836 42.459915)'));
insert into PAI_RELIGIEUX values ('13','PAIRELIG0000000109751450','BDNyme','Croix','le calvaire','8', GeomFromEWKT('SRID=210024000;MULTIPOINT(9.474454 42.413826)'));
commit;




