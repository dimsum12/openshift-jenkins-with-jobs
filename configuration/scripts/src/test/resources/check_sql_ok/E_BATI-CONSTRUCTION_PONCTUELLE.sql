SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Construction ponctuelle. Construction de faible emprise et de grande hauteur
--
create table CONSTRUCTION_PONCTUELLE (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, NATURE varchar(14) not null, ALTITUDE float, constraint CONSTRUCTION_PONCTUELLE_pkey primary key (gid));
select AddGeometryColumn('','construction_ponctuelle','the_geom','210642000','MULTIPOINT',3);
create index CONSTRUCTION_PONCTUELLE_geoidx on CONSTRUCTION_PONCTUELLE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- CONSTRUCTION_PONCTUELLE
start transaction;
insert into CONSTRUCTION_PONCTUELLE values ('1','CONSPONC0000000070006914','   1.5','    1.0','Indifférencié','300.100000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.900966 14.459324 300.100000)'));
insert into CONSTRUCTION_PONCTUELLE values ('2','CONSPONC0000000070006904','   1.5','    1.0','Antenne','153.300000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.869792 14.477136 153.300000)'));
insert into CONSTRUCTION_PONCTUELLE values ('3','CONSPONC0000000070006893','   1.5','    1.0','Indifférencié','30.800000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.079274 14.491915 30.800000)'));
insert into CONSTRUCTION_PONCTUELLE values ('4','CONSPONC0000000070006870','   1.5','    1.0','Indifférencié','148.100000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.052856 14.530397 148.100000)'));
insert into CONSTRUCTION_PONCTUELLE values ('5','CONSPONC0000000070006868','   1.5','    1.0','Indifférencié','404.400000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.898675 14.527207 404.400000)'));
insert into CONSTRUCTION_PONCTUELLE values ('6','CONSPONC0000000070006865','   1.5','    1.0','Indifférencié','24.100000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.980812 14.533909 24.100000)'));
insert into CONSTRUCTION_PONCTUELLE values ('7','CONSPONC0000000070006864','   1.5','    1.0','Indifférencié','37.500000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.980636 14.531359 37.500000)'));
insert into CONSTRUCTION_PONCTUELLE values ('8','CONSPONC0000000070006861','   1.5','    1.0','Indifférencié','23.900000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.979483 14.533457 23.900000)'));
insert into CONSTRUCTION_PONCTUELLE values ('9','CONSPONC0000000070006860','   1.5','    1.0','Indifférencié','16.700000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.978646 14.533793 16.700000)'));
insert into CONSTRUCTION_PONCTUELLE values ('10','CONSPONC0000000070006859','   1.5','    1.0','Indifférencié','17.000000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.977885 14.532275 17.000000)'));
insert into CONSTRUCTION_PONCTUELLE values ('11','CONSPONC0000000070006858','   1.5','    1.0','Indifférencié','20.300000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.980065 14.533935 20.300000)'));
insert into CONSTRUCTION_PONCTUELLE values ('12','CONSPONC0000000070006857','   1.5','    1.0','Indifférencié','22.600000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.980445 14.532949 22.600000)'));
insert into CONSTRUCTION_PONCTUELLE values ('13','CONSPONC0000000070006854','   1.5','    1.0','Antenne','17.100000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.985009 14.537644 17.100000)'));
insert into CONSTRUCTION_PONCTUELLE values ('14','CONSPONC0000000070006853','   1.5','    1.0','Indifférencié','22.900000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.979107 14.534442 22.900000)'));
insert into CONSTRUCTION_PONCTUELLE values ('15','CONSPONC0000000070006851','   1.5','    1.0','Indifférencié','125.700000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.860763 14.536011 125.700000)'));
insert into CONSTRUCTION_PONCTUELLE values ('16','CONSPONC0000000070006841','   1.5','    1.0','Indifférencié','16.400000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.053079 14.555035 16.400000)'));
insert into CONSTRUCTION_PONCTUELLE values ('17','CONSPONC0000000070006840','   1.5','    1.0','Indifférencié','23.000000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.052032 14.554181 23.000000)'));
insert into CONSTRUCTION_PONCTUELLE values ('18','CONSPONC0000000070006838','   1.5','    1.0','Antenne','106.100000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.958794 14.554846 106.100000)'));
insert into CONSTRUCTION_PONCTUELLE values ('19','CONSPONC0000000070006826','   1.5','    1.0','Indifférencié','96.700000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.965469 14.577640 96.700000)'));
insert into CONSTRUCTION_PONCTUELLE values ('20','CONSPONC0000000070006824','   1.5','    1.0','Antenne','12.700000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.022785 14.590748 12.700000)'));
insert into CONSTRUCTION_PONCTUELLE values ('21','CONSPONC0000000070006823','   1.5','    1.0','Indifférencié','10.300000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.015292 14.590078 10.300000)'));
insert into CONSTRUCTION_PONCTUELLE values ('22','CONSPONC0000000070006822','   1.5','    1.0','Indifférencié','14.300000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.015459 14.590047 14.300000)'));
insert into CONSTRUCTION_PONCTUELLE values ('23','CONSPONC0000000070006813','   1.5','    1.0','Antenne','31.500000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.998676 14.596882 31.500000)'));
insert into CONSTRUCTION_PONCTUELLE values ('24','CONSPONC0000000070006809','   1.5','    1.0','Indifférencié','15.200000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.074314 14.604415 15.200000)'));
insert into CONSTRUCTION_PONCTUELLE values ('25','CONSPONC0000000070006804','   1.5','    1.0','Antenne','207.000000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.941041 14.607146 207.000000)'));
insert into CONSTRUCTION_PONCTUELLE values ('26','CONSPONC0000000070006796','   1.5','    1.0','Indifférencié','17.300000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.997853 14.612571 17.300000)'));
insert into CONSTRUCTION_PONCTUELLE values ('27','CONSPONC0000000070006790','   1.5','    1.0','Antenne','142.300000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.082498 14.623370 142.300000)'));
insert into CONSTRUCTION_PONCTUELLE values ('28','CONSPONC0000000070006783','   1.5','    1.0','Indifférencié','12.000000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.005328 14.629622 12.000000)'));
insert into CONSTRUCTION_PONCTUELLE values ('29','CONSPONC0000000070006781','   1.5','    1.0','Antenne','56.200000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.987775 14.629177 56.200000)'));
insert into CONSTRUCTION_PONCTUELLE values ('30','CONSPONC0000000070006776','   1.5','    1.0','Antenne','381.000000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.949332 14.626753 381.000000)'));
insert into CONSTRUCTION_PONCTUELLE values ('31','CONSPONC0000000070006768','   1.5','    1.0','Indifférencié','30.400000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.891334 14.635909 30.400000)'));
insert into CONSTRUCTION_PONCTUELLE values ('32','CONSPONC0000000070006767','   1.5','    1.0','Antenne','132.400000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.131648 14.639245 132.400000)'));
insert into CONSTRUCTION_PONCTUELLE values ('33','CONSPONC0000000070006766','   1.5','    1.0','Antenne','131.400000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.131190 14.639382 131.400000)'));
insert into CONSTRUCTION_PONCTUELLE values ('34','CONSPONC0000000070006765','   1.5','    1.0','Antenne','88.800000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.010206 14.641178 88.800000)'));
insert into CONSTRUCTION_PONCTUELLE values ('35','CONSPONC0000000070006763','   1.5','    1.0','Indifférencié','106.000000', GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.954459 14.643476 106.000000)'));
