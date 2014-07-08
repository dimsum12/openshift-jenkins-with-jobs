SET NAMES 'LATIN9';
--
-- SET NAMES 'LATIN9';
--
start transaction;
-- Equipement administratif ou militaire
--
create table EQUADMIL (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(30) not null, GRAPHIEP varchar(70), ORIGINGP varchar(40), DATEVGP varchar(10), GRAPHIER varchar(70), ORIGINGR varchar(40), DATEVGR varchar(10), GRAPHIES varchar(70), ORIGINGS varchar(40), DATEVGS varchar(10), NOMLOCAL varchar(70), ORIGINNL varchar(40), NOMCAD varchar(70), NOMGEORO varchar(70), AUTRENOM varchar(70), VALIDE boolean not null, IMPORTAN char(11), ADREPOST varchar(70), IDENTFPB varchar(24), DESIGNAT varchar(70), CDBSEL25 boolean not null, CDBSEL50 boolean not null, CDBINFOT boolean not null, constraint EQUADMIL_pkey primary key (gid));
select AddGeometryColumn('','equadmil','the_geom','-1','MULTIPOINT',2);
create index EQUADMIL_geoidx on EQUADMIL using gist (the_geom gist_geometry_ops);
--
-- Culture et loisirs
--
create table CULTLOIS (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(24) not null, GRAPHIEP varchar(70), ORIGINGP varchar(40), DATEVGP varchar(10), GRAPHIER varchar(70), ORIGINGR varchar(40), DATEVGR varchar(10), GRAPHIES varchar(70), ORIGINGS varchar(40), DATEVGS varchar(10), NOMLOCAL varchar(70), ORIGINNL varchar(40), NOMCAD varchar(70), NOMGEORO varchar(70), AUTRENOM varchar(70), VALIDE boolean not null, IMPORTAN char(11), ADREPOST varchar(70), IDENTFPB varchar(24), DESIGNAT varchar(70), CDBSEL25 boolean not null, CDBSEL50 boolean not null, CDBINFOT boolean not null, constraint CULTLOIS_pkey primary key (gid));
select AddGeometryColumn('','cultlois','the_geom','-1','MULTIPOINT',2);
create index CULTLOIS_geoidx on CULTLOIS using gist (the_geom gist_geometry_ops);
--
-- Science et enseignement
--
create table SCIENENS (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(23) not null, GRAPHIEP varchar(70), ORIGINGP varchar(40), DATEVGP varchar(10), GRAPHIER varchar(70), ORIGINGR varchar(40), DATEVGR varchar(10), GRAPHIES varchar(70), ORIGINGS varchar(40), DATEVGS varchar(10), NOMLOCAL varchar(70), ORIGINNL varchar(40), NOMCAD varchar(70), NOMGEORO varchar(70), AUTRENOM varchar(70), VALIDE boolean not null, IMPORTAN char(11), ADREPOST varchar(70), IDENTFPB varchar(24), DESIGNAT varchar(70), CDBSEL25 boolean not null, CDBSEL50 boolean not null, CDBINFOT boolean not null, constraint SCIENENS_pkey primary key (gid));
select AddGeometryColumn('','scienens','the_geom','-1','MULTIPOINT',2);
create index SCIENENS_geoidx on SCIENENS using gist (the_geom gist_geometry_ops);
--
-- Gestion des eaux
--
create table GESTEAUX (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(28) not null, GRAPHIEP varchar(70), ORIGINGP varchar(40), DATEVGP varchar(10), GRAPHIER varchar(70), ORIGINGR varchar(40), DATEVGR varchar(10), GRAPHIES varchar(70), ORIGINGS varchar(40), DATEVGS varchar(10), NOMLOCAL varchar(70), ORIGINNL varchar(40), NOMCAD varchar(70), NOMGEORO varchar(70), AUTRENOM varchar(70), VALIDE boolean not null, IMPORTAN char(11), ADREPOST varchar(70), IDENTFPB varchar(24), DESIGNAT varchar(70), CDBSEL25 boolean not null, CDBSEL50 boolean not null, CDBINFOT boolean not null, constraint GESTEAUX_pkey primary key (gid));
select AddGeometryColumn('','gesteaux','the_geom','-1','MULTIPOINT',2);
create index GESTEAUX_geoidx on GESTEAUX using gist (the_geom gist_geometry_ops);
--
-- Industriel et commercial
--
create table INDUSCOM (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(19) not null, GRAPHIEP varchar(70), ORIGINGP varchar(40), DATEVGP varchar(10), GRAPHIER varchar(70), ORIGINGR varchar(40), DATEVGR varchar(10), GRAPHIES varchar(70), ORIGINGS varchar(40), DATEVGS varchar(10), NOMLOCAL varchar(70), ORIGINNL varchar(40), NOMCAD varchar(70), NOMGEORO varchar(70), AUTRENOM varchar(70), VALIDE boolean not null, IMPORTAN char(11), ADREPOST varchar(70), IDENTFPB varchar(24), DESIGNAT varchar(70), CDBSEL25 boolean not null, CDBSEL50 boolean not null, CDBINFOT boolean not null, constraint INDUSCOM_pkey primary key (gid));
select AddGeometryColumn('','induscom','the_geom','-1','MULTIPOINT',2);
create index INDUSCOM_geoidx on INDUSCOM using gist (the_geom gist_geometry_ops);
--
-- Religieux
--
create table RELIGIE (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(29) not null, GRAPHIEP varchar(70), ORIGINGP varchar(40), DATEVGP varchar(10), GRAPHIER varchar(70), ORIGINGR varchar(40), DATEVGR varchar(10), GRAPHIES varchar(70), ORIGINGS varchar(40), DATEVGS varchar(10), NOMLOCAL varchar(70), ORIGINNL varchar(40), NOMCAD varchar(70), NOMGEORO varchar(70), AUTRENOM varchar(70), VALIDE boolean not null, IMPORTAN char(11), ADREPOST varchar(70), IDENTFPB varchar(24), DESIGNAT varchar(70), CDBSEL25 boolean not null, CDBSEL50 boolean not null, CDBINFOT boolean not null, constraint RELIGIE_pkey primary key (gid));
select AddGeometryColumn('','religie','the_geom','-1','MULTIPOINT',2);
create index RELIGIE_geoidx on RELIGIE using gist (the_geom gist_geometry_ops);
--
-- Santé
--
create table SANTE (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(25) not null, GRAPHIEP varchar(70), ORIGINGP varchar(40), DATEVGP varchar(10), GRAPHIER varchar(70), ORIGINGR varchar(40), DATEVGR varchar(10), GRAPHIES varchar(70), ORIGINGS varchar(40), DATEVGS varchar(10), NOMLOCAL varchar(70), ORIGINNL varchar(40), NOMCAD varchar(70), NOMGEORO varchar(70), AUTRENOM varchar(70), VALIDE boolean not null, IMPORTAN char(11), ADREPOST varchar(70), IDENTFPB varchar(24), DESIGNAT varchar(70), CDBSEL25 boolean not null, CDBSEL50 boolean not null, CDBINFOT boolean not null, constraint SANTE_pkey primary key (gid));
select AddGeometryColumn('','sante','the_geom','-1','MULTIPOINT',2);
create index SANTE_geoidx on SANTE using gist (the_geom gist_geometry_ops);
--
-- Sport
--
create table SPORT (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(10) not null, GRAPHIEP varchar(70), ORIGINGP varchar(40), DATEVGP varchar(10), GRAPHIER varchar(70), ORIGINGR varchar(40), DATEVGR varchar(10), GRAPHIES varchar(70), ORIGINGS varchar(40), DATEVGS varchar(10), NOMLOCAL varchar(70), ORIGINNL varchar(40), NOMCAD varchar(70), NOMGEORO varchar(70), AUTRENOM varchar(70), VALIDE boolean not null, IMPORTAN char(11), ADREPOST varchar(70), IDENTFPB varchar(24), DESIGNAT varchar(70), CDBSEL25 boolean not null, CDBSEL50 boolean not null, CDBINFOT boolean not null, constraint SPORT_pkey primary key (gid));
