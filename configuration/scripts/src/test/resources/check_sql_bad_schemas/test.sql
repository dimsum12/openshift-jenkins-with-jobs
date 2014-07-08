--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
-- Bâtiment de plus de 20 mètres carrés
--
create table schema_bad.BATI_INDIFFERENCIE (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, ORIGIN_BAT varchar(8) default 'NR', HAUTEUR integer not null, z_Min float, z_Max float, constraint BATI_INDIFFERENCIE_pkey primary key (gid));
select AddGeometryColumn('schema_bad','bati_indifferencie','the_geom','210024000','MULTIPOLYGON',3);
select AddGeometryColumn("", 'schema_bad.','bati_indifferencie','the_geom2','210024000','MULTIPOLYGON',3);
select AddGeometryColumn('schema_bad.bati_indifferencie','the_geom3','210024000','MULTIPOLYGON',3);
create index schema_bad.BATI_INDIFFERENCIE_geoidx on BATI_INDIFFERENCIE using gist (the_geom gist_geometry_ops);
create index BATI_INDIFFERENCIE_geoidx2 on schema_bad.BATI_INDIFFERENCIE using btree( test ) ;            
--
--
-- BATI_INDIFFERENCIE
insert into schema_bad.BATI_INDIFFERENCIE(  gid, ID,PREC_PLANI    ,PREC_ALTI, ORIGIN_BAT , HAUTEUR, z_Min, z_Max)values(nextval('fxx_rgf93g_ign_bdtopo_2_0_000_20081001_1mpg.BATI_INDIFFERENCIE_gid_seq'),'BATIMENT0000000075673069','   1.5','    1.0','Autre','4','986.900000','987.600000', GeomFromEWKT('SRID=210024000;MULTIPOLYGON(((6.120607 44.818714 987.600000,6.120716 44.818696 986.900000,6.120721 44.818759 986.900000,6.120613 44.818768 987.600000,6.120607 44.818714 987.600000)))'))   ;   
--
