SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Santé
--
create table PAI_SANTE (gid SERIAL not null, ID varchar(24) not null, ORIGINE varchar(17) default 'NR', NATURE varchar(25) default 'NR', TOPONYME varchar(70) default 'NR', IMPORTANCE varchar(2) default 'NR', constraint PAI_SANTE_pkey primary key (gid));
select AddGeometryColumn('','pai_sante','the_geom','210642000','MULTIPOINT',2);
create index PAI_SANTE_geoidx on PAI_SANTE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- PAI_SANTE
start transaction;
insert into PAI_SANTE values ('1','PAISANTE0000000069986221','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.105200 14.621963)'));
insert into PAI_SANTE values ('2','PAISANTE0000000069986218','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.078518 14.610922)'));
insert into PAI_SANTE values ('3','PAISANTE0000000069986217','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.066135 14.607239)'));
insert into PAI_SANTE values ('4','PAISANTE0000000069986215','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.062142 14.614328)'));
insert into PAI_SANTE values ('5','PAISANTE0000000069986213','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.993225 14.619318)'));
insert into PAI_SANTE values ('6','PAISANTE0000000069986212','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.097175 14.641790)'));
insert into PAI_SANTE values ('7','PAISANTE0000000069986205','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.002087 14.710614)'));
insert into PAI_SANTE values ('8','PAISANTE0000000069986204','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.973992 14.690221)'));
insert into PAI_SANTE values ('9','PAISANTE0000000069986208','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.941282 14.680255)'));
insert into PAI_SANTE values ('10','PAISANTE0000000069986209','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.037525 14.669845)'));
insert into PAI_SANTE values ('11','PAISANTE0000000069986211','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.038337 14.633496)'));
insert into PAI_SANTE values ('12','PAISANTE0000000069986210','BDNyme','Etablissement hospitalier','ancienne station thermale d\'absalon','7', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.095279 14.676887)'));
insert into PAI_SANTE values ('13','PAISANTE0000000069986216','BDTopo','Hôpital',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.067235 14.613395)'));
insert into PAI_SANTE values ('14','PAISANTE0000000069986220','BDTopo','Hôpital',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.084040 14.617895)'));
insert into PAI_SANTE values ('15','PAISANTE0000000070582634','BDCarto','Hôpital',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.175161 14.741363)'));
insert into PAI_SANTE values ('16','PAISANTE0000000070582653','BDCarto','Hôpital',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.034974 14.537902)'));
insert into PAI_SANTE values ('17','PAISANTE0000000069986202','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.965110 14.736366)'));
insert into PAI_SANTE values ('18','PAISANTE0000000070582633','Orthophotographie','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.179823 14.702514)'));
insert into PAI_SANTE values ('19','PAISANTE0000000069986206','BDTopo','Etablissement hospitalier','hôpital psychiatrique de colson','6', GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.087105 14.687115)'));
insert into PAI_SANTE values ('20','PAISANTE0000000069986203','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.974804 14.744626)'));
insert into PAI_SANTE values ('21','PAISANTE0000000069986219','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-61.084946 14.608569)'));
insert into PAI_SANTE values ('22','PAISANTE0000000069986214','BDTopo','Etablissement hospitalier',DEFAULT,DEFAULT, GeomFromEWKT('SRID=210642000;MULTIPOINT(-60.999241 14.614864)'));
commit;
--
