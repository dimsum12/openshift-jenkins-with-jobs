SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Points interm�diaires des lignes �lectriques correspondant � un pylone
--
create table PYLONE (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, constraint PYLONE_pkey primary key (gid));
select AddGeometryColumn('','pylone','the_geom','210642000','MULTIPOINT',3);
create index PYLONE_geoidx on PYLONE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- PYLONE
start transaction;
insert into PYLONE values ('1','PYLONE__0000000069987262','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.891307 14.501072 77.800000)'));
insert into PYLONE values ('2','PYLONE__0000000069987260','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.881435 14.494153 113.300000)'));
insert into PYLONE values ('3','PYLONE__0000000069987259','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.887042 14.498769 52.300000)'));
insert into PYLONE values ('4','PYLONE__0000000069987258','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.872351 14.483916 45.800000)'));
insert into PYLONE values ('5','PYLONE__0000000069987257','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.881765 14.495083 120.800000)'));
insert into PYLONE values ('6','PYLONE__0000000069987256','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.870411 14.483088 52.700000)'));
insert into PYLONE values ('7','PYLONE__0000000069987255','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.879987 14.490284 128.500000)'));
insert into PYLONE values ('8','PYLONE__0000000069987254','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.878644 14.486652 106.800000)'));
insert into PYLONE values ('9','PYLONE__0000000069987253','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.875084 14.485106 46.800000)'));
insert into PYLONE values ('10','PYLONE__0000000069987252','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.884696 14.497500 44.200000)'));
insert into PYLONE values ('11','PYLONE__0000000069987251','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.882730 14.496440 116.800000)'));
insert into PYLONE values ('12','PYLONE__0000000069987250','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.896758 14.504008 184.300000)'));
insert into PYLONE values ('13','PYLONE__0000000069987247','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.856558 14.476819 84.300000)'));
insert into PYLONE values ('14','PYLONE__0000000069987245','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.850246 14.487442 126.100000)'));
insert into PYLONE values ('15','PYLONE__0000000069987243','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.849157 14.494039 134.100000)'));
insert into PYLONE values ('16','PYLONE__0000000069987242','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.851902 14.481617 89.900000)'));
insert into PYLONE values ('17','PYLONE__0000000069987240','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.848983 14.498515 92.200000)'));
insert into PYLONE values ('18','PYLONE__0000000069986824','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.990882 14.757979 233.600000)'));
insert into PYLONE values ('19','PYLONE__0000000069987238','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.853558 14.475822 56.800000)'));
insert into PYLONE values ('20','PYLONE__0000000069987237','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.848805 14.503011 54.300000)'));
insert into PYLONE values ('21','PYLONE__0000000069987236','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.848666 14.506703 65.200000)'));
insert into PYLONE values ('22','PYLONE__0000000069987235','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.859371 14.477949 78.400000)'));
insert into PYLONE values ('23','PYLONE__0000000069987234','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.850878 14.485178 118.300000)'));
insert into PYLONE values ('24','PYLONE__0000000069987231','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.864635 14.480575 182.900000)'));
insert into PYLONE values ('25','PYLONE__0000000069987230','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.950543 14.543477 68.400000)'));
insert into PYLONE values ('26','PYLONE__0000000069987229','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.949346 14.542608 66.100000)'));
insert into PYLONE values ('27','PYLONE__0000000069987227','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.941574 14.536961 107.000000)'));
insert into PYLONE values ('28','PYLONE__0000000069987226','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.944972 14.539451 82.100000)'));
insert into PYLONE values ('29','PYLONE__0000000069987225','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.940333 14.536084 130.100000)'));
insert into PYLONE values ('30','PYLONE__0000000069987224','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.943768 14.538568 74.500000)'));
insert into PYLONE values ('31','PYLONE__0000000069987222','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.931291 14.529915 168.100000)'));
insert into PYLONE values ('32','PYLONE__0000000069987220','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.932480 14.530689 173.400000)'));
insert into PYLONE values ('33','PYLONE__0000000069987219','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.936220 14.533175 164.500000)'));
insert into PYLONE values ('34','PYLONE__0000000069987218','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.946234 14.540345 77.000000)'));
insert into PYLONE values ('35','PYLONE__0000000069987216','   1.5','    1.0', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.954243 14.546158 33.400000)'));
