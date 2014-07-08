SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Culture et loisirs
--
create table TOPONYME_DIVERS (gid SERIAL not null, ID varchar(24) not null, ORIGIN_NOM varchar(13) default 'Non renseigné', NOM varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', NATURE varchar(27) default 'NR', constraint TOPONYME_DIVERS_pkey primary key (gid));
select AddGeometryColumn('','toponyme_divers','the_geom','210024000','MULTIPOINT',2);
create index TOPONYME_DIVERS_geoidx on TOPONYME_DIVERS using gist (the_geom gist_geometry_ops);
--
commit;
--
-- TOPONYME_DIVERS
start transaction;
insert into TOPONYME_DIVERS values ('1','PAICULOI0000000076867312','BDNyme','jardin des oiseaux','7','Parc de loisirs', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.962629 44.800925)'));
insert into TOPONYME_DIVERS values ('2','PAICULOI0000000006691669','BDNyme','les routelles','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.557493 44.191722)'));
insert into TOPONYME_DIVERS values ('3','PAICULOI0000000006691670','BDNyme','les biaux','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.538221 44.201710)'));
insert into TOPONYME_DIVERS values ('4','PAICULOI0000000119887599','BDNyme','l\'enclos fleuri','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.813278 45.734061)'));
insert into TOPONYME_DIVERS values ('5','PAICULOI0000000119887631','BDNyme','les couderts','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.735851 45.600158)'));
insert into TOPONYME_DIVERS values ('6','PAICULOI0000000130415457','NR','la chrysalide','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-1.067624 45.076166)'));
insert into TOPONYME_DIVERS values ('7','PAICULOI0000000107405729','BDNyme','le meygal','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(4.122059 45.030164)'));
insert into TOPONYME_DIVERS values ('8','PAICULOI0000000076160595','BDNyme','la pépinière','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.985663 48.754658)'));
insert into TOPONYME_DIVERS values ('9','PAICULOI0000000076160561','BDNyme','le paon','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.013883 48.816928)'));
insert into TOPONYME_DIVERS values ('10','PAICULOI0000000000142229','BDTopo','jardin d\'acclimatation','8','Parc de loisirs', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.265087 48.877920)'));
insert into TOPONYME_DIVERS values ('11','PAICULOI0000000044348865','BDNyme','le tivoli','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.715053 43.925943)'));
insert into TOPONYME_DIVERS values ('12','PAICULOI0000000044348882','BDNyme','les vals','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(3.320975 43.711546)'));
insert into TOPONYME_DIVERS values ('13','PAICULOI0000000076160588','BDNyme','le cap horn','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.963822 48.760779)'));
insert into TOPONYME_DIVERS values ('14','PAICULOI0000000014612422','BDNyme','musée ledoux','8','Musée', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.776762 47.033162)'));
insert into TOPONYME_DIVERS values ('15','PAICULOI0000000001729250','BDTopo','parc d\'attractions','5','Parc de loisirs', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.776763 48.872553)'));
insert into TOPONYME_DIVERS values ('16','PAICULOI0000000076160619','BDTopo','les hortensias','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.628182 48.681700)'));
insert into TOPONYME_DIVERS values ('17','PAICULOI0000000000142534','BDNyme','statue de la liberté','8','Monument', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.279708 48.850021)'));
insert into TOPONYME_DIVERS values ('18','PAICULOI0000000000142498','BDNyme','hôtel de lauzun',DEFAULT,'Construction', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.358587 48.851354)'));
insert into TOPONYME_DIVERS values ('19','PAICULOI0000000076160649','BDTopo','la saline','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.413393 48.631101)'));
insert into TOPONYME_DIVERS values ('20','PAICULOI0000000087160356','BDNyme','lanivrec','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.089807 47.295518)'));
insert into TOPONYME_DIVERS values ('21','PAICULOI0000000000142459','BDNyme','institut de france',DEFAULT,'Construction', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.336524 48.852462)'));
insert into TOPONYME_DIVERS values ('22','PAICULOI0000000000142452','BDNyme','hôtel de beauvais',DEFAULT,'Construction', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.357689 48.855308)'));
insert into TOPONYME_DIVERS values ('23','PAICULOI0000000076160637','BDTopo','les hautes grées','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.426366 48.643572)'));
insert into TOPONYME_DIVERS values ('24','PAICULOI0000000045725323','BDTopo','les peupliers','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(1.893474 50.943156)'));
insert into TOPONYME_DIVERS values ('25','PAICULOI0000000076160631','BDNyme','l\'abri côtier','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.836421 48.635683)'));
insert into TOPONYME_DIVERS values ('26','PAICULOI0000000076160669','BDNyme','la vallée du préto','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.516868 48.592279)'));
insert into TOPONYME_DIVERS values ('27','PAICULOI0000000079951687','BDNyme','madres pyrénées','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.198598 42.737031)'));
insert into TOPONYME_DIVERS values ('28','PAICULOI0000000076160686','BDNyme','le verger','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.337747 48.573833)'));
insert into TOPONYME_DIVERS values ('29','PAICULOI0000000076160682','BDNyme','le vallon aux merlettes','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-2.294235 48.590402)'));
insert into TOPONYME_DIVERS values ('30','PAICULOI0000000075828178','BDNyme','la plaine tonique','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.136911 46.341958)'));
insert into TOPONYME_DIVERS values ('31','PAICULOI0000000023223853','BDNyme','camping de la vallée de l\'hyère','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(-3.602121 48.276708)'));
insert into TOPONYME_DIVERS values ('32','PAICULOI0000000006691648','BDNyme','ubertrop','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.263393 44.373214)'));
insert into TOPONYME_DIVERS values ('33','PAICULOI0000000006691645','BDNyme','le chambron','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.193011 44.417229)'));
insert into TOPONYME_DIVERS values ('34','PAICULOI0000000006691646','BDNyme','les terrasses provençales','8','Camping', GeomFromEWKT('SRID=210024000;MULTIPOINT(5.080283 44.408575)'));
insert into TOPONYME_DIVERS values ('35','PAICULOI0000000000142109','BDNyme','rotonde',DEFAULT,'Construction', GeomFromEWKT('SRID=210024000;MULTIPOINT(2.385034 48.895681)'));
