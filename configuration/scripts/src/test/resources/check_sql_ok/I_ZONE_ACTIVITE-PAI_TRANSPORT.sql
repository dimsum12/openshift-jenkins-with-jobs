SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Transport
--
create table PAI_TRANSPORT (gid SERIAL not null, ID varchar(24) not null, ORIGINE varchar(17) default 'NR', NATURE varchar(25) default 'NR', TOPONYME varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', constraint PAI_TRANSPORT_pkey primary key (gid));
select AddGeometryColumn('','pai_transport','the_geom','210642000','MULTIPOINT',2);
create index PAI_TRANSPORT_geoidx on PAI_TRANSPORT using gist (the_geom gist_geometry_ops);
--
commit;
--
-- PAI_TRANSPORT
start transaction;
insert into PAI_TRANSPORT values ('1','PAITRANS0000000069986121','BDNyme','Chemin','route forestière de piton laroche','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.054796 14.764363)'));
insert into PAI_TRANSPORT values ('2','PAITRANS0000000070215462','BDParcellaire','Chemin',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.226675 14.804487)'));
insert into PAI_TRANSPORT values ('3','PAITRANS0000000070217099','BDParcellaire','Chemin',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.145670 14.876486)'));
insert into PAI_TRANSPORT values ('4','PAITRANS0000000070282266','BDParcellaire','Infrastructure routière',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.048227 14.626561)'));
insert into PAI_TRANSPORT values ('5','PAITRANS0000000069986140','BDNyme','Infrastructure routière','route forestière de rivière rouge','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.073846 14.710301)'));
insert into PAI_TRANSPORT values ('6','PAITRANS0000000069986180','BDNyme','Pont','pont mastor','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.852429 14.473327)'));
insert into PAI_TRANSPORT values ('7','PAITRANS0000000070503272','Calculé','Rond-point',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.134807 14.772152)'));
insert into PAI_TRANSPORT values ('8','PAITRANS0000000069986120','BDNyme','Infrastructure routière','route forestière de reculée','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.045429 14.773321)'));
insert into PAI_TRANSPORT values ('9','PAITRANS0000000069986181','BDNyme','Carrefour','croisée décius','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.862036 14.474310)'));
insert into PAI_TRANSPORT values ('10','PAITRANS0000000069986169','BDNyme','Barrage','barrage de la manzo','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.945056 14.582679)'));
insert into PAI_TRANSPORT values ('11','PAITRANS0000000069986158','BDNyme','Chemin','trace duclos nord','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.102027 14.683513)'));
insert into PAI_TRANSPORT values ('12','PAITRANS0000000069986155','BDNyme','Chemin','route forestière de fond baron','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.092730 14.674309)'));
insert into PAI_TRANSPORT values ('13','PAITRANS0000000069986142','BDNyme','Infrastructure routière','route forestière de fond mithon','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074006 14.692228)'));
insert into PAI_TRANSPORT values ('14','PAITRANS0000000069986141','BDNyme','Infrastructure routière','route forestière de fond fougères','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.064642 14.701187)'));
insert into PAI_TRANSPORT values ('15','PAITRANS0000000069986126','BDNyme','Infrastructure routière','route du calvaire','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.036466 14.737098)'));
insert into PAI_TRANSPORT values ('16','PAITRANS0000000069986153','BDNyme','Carrefour','croisée manioc','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.022832 14.671607)'));
insert into PAI_TRANSPORT values ('17','PAITRANS0000000069986177','BDNyme','Pont','cassis boisel','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.918960 14.501191)'));
insert into PAI_TRANSPORT values ('18','PAITRANS0000000069986184','BDNyme','Pont','pont fond banane','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.945537 14.467574)'));
insert into PAI_TRANSPORT values ('19','PAITRANS0000000069986152','BDNyme','Pont','pont minville','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.026580 14.673935)'));
insert into PAI_TRANSPORT values ('20','PAITRANS0000000069986174','BDNyme','Pont','cassis des oranges','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.897353 14.523263)'));
insert into PAI_TRANSPORT values ('21','PAITRANS0000000069986176','BDNyme','Pont','pont madeleine','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.904658 14.496219)'));
insert into PAI_TRANSPORT values ('22','PAITRANS0000000069986138','BDNyme','Pont','pont bois goudoux','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.036791 14.700952)'));
insert into PAI_TRANSPORT values ('23','PAITRANS0000000069986119','BDNyme','Pont','pont tully','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.989793 14.763806)'));
insert into PAI_TRANSPORT values ('24','PAITRANS0000000069986161','BDNyme','Rond-point','croisée jeanne d\'arc','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.008259 14.629156)'));
insert into PAI_TRANSPORT values ('25','PAITRANS0000000069986168','BDNyme','Pont','pont dix cornes','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.928552 14.578358)'));
insert into PAI_TRANSPORT values ('26','PAITRANS0000000069986114','BDNyme','Pont','pont fonds massacre','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.047224 14.830893)'));
insert into PAI_TRANSPORT values ('27','PAITRANS0000000069986179','BDNyme','Pont','pont albert','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.015482 14.482427)'));
insert into PAI_TRANSPORT values ('28','PAITRANS0000000069986162','BDNyme','Pont','pont alfred','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.037276 14.646734)'));
insert into PAI_TRANSPORT values ('29','PAITRANS0000000069986166','BDNyme','Pont','pont spitz','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.998349 14.605790)'));
insert into PAI_TRANSPORT values ('30','PAITRANS0000000069986125','BDNyme','Pont','pont lebrun','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.018061 14.718866)'));
insert into PAI_TRANSPORT values ('31','PAITRANS0000000069986183','BDNyme','Pont','pont café','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.937855 14.465749)'));
insert into PAI_TRANSPORT values ('32','PAITRANS0000000069986112','BDNyme','Pont','pont mol','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.156626 14.873308)'));
insert into PAI_TRANSPORT values ('33','PAITRANS0000000069986170','BDTopo','Aéroport quelconque','aéroport de fort-de-france-le lamentin','5', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.005803 14.591337)'));
insert into PAI_TRANSPORT values ('34','PAITRANS0000000069986165','BDNyme','Carrefour','les quatre croisées','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.935070 14.600673)'));
insert into PAI_TRANSPORT values ('35','PAITRANS0000000069986156','BDNyme','Chemin','route forestière de fond l\'étang','8', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.083719 14.677000)'));
