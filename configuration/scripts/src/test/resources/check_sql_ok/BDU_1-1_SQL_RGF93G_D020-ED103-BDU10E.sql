SET NAMES 'LATIN9';
--
-- SET NAMES 'LATIN9';
--
start transaction;
-- Construction ponctuelle. Construction de faible emprise et de grande hauteur
--
create table CONSPONC (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(16) not null, constraint CONSPONC_pkey primary key (gid));
select AddGeometryColumn('','consponc','the_geom','-1','MULTIPOINT',3);
create index CONSPONC_geoidx on CONSPONC using gist (the_geom gist_geometry_ops);
--
-- Construction linéaire
--
create table CONSLINE (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(24) not null, constraint CONSLINE_pkey primary key (gid));
select AddGeometryColumn('','consline','the_geom','-1','MULTILINESTRING',3);
create index CONSLINE_geoidx on CONSLINE using gist (the_geom gist_geometry_ops);
--
-- Bâtiment de plus de 20 mètres carrés
--
create table BATIMENT (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), TYPEBATI char(19), NATURE char(154) not null, FONCTION char(15) not null, ALTISOL decimal(7,1), ALTITT decimal(7,1), HAUTEUR decimal(7,1), HAUTSOL integer not null, constraint BATIMENT_pkey primary key (gid));
select AddGeometryColumn('','batiment','the_geom','-1','MULTIPOLYGON',3);
create index BATIMENT_geoidx on BATIMENT using gist (the_geom gist_geometry_ops);
--
-- Construction surfacique. Ouvrage de grande surface lié au franchissement d'un obstacle par une voie de communication,ou à l'aménagement d'une rivière ou d'un canal
--
create table CONSSURF (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(19) not null, constraint CONSSURF_pkey primary key (gid));
select AddGeometryColumn('','conssurf','the_geom','-1','MULTIPOLYGON',3);
create index CONSSURF_geoidx on CONSSURF using gist (the_geom gist_geometry_ops);
--
-- Réservoir (eau, matières industrielles,)
--
create table RESERVOI (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(39) not null, ALTISOL decimal(7,1), ALTITT decimal(7,1), HAUTEUR decimal(7,1), HAUTSOL integer not null, constraint RESERVOI_pkey primary key (gid));
select AddGeometryColumn('','reservoi','the_geom','-1','MULTIPOLYGON',3);
create index RESERVOI_geoidx on RESERVOI using gist (the_geom gist_geometry_ops);
--
-- Terrain de sport. Equipement sportif de plein air
--
create table TERRSPOR (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(18) not null, constraint TERRSPOR_pkey primary key (gid));
select AddGeometryColumn('','terrspor','the_geom','-1','MULTIPOLYGON',3);
create index TERRSPOR_geoidx on TERRSPOR using gist (the_geom gist_geometry_ops);
--
-- Cimetière. Endroit où reposent les morts.
--
create table CIMETIER (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(9) not null, constraint CIMETIER_pkey primary key (gid));
select AddGeometryColumn('','cimetier','the_geom','-1','MULTIPOLYGON',3);
create index CIMETIER_geoidx on CIMETIER using gist (the_geom gist_geometry_ops);
--
-- Piste d'aérodrome. Aire située sur un aérodrome, aménagée afin de servir au roulement des aéronefs, au décollage et à l'atterrissage.
--
create table PISTAERO (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(49) not null, constraint PISTAERO_pkey primary key (gid));
