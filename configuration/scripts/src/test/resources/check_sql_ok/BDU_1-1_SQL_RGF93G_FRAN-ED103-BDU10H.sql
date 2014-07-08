SET NAMES 'LATIN9';
--
-- SET NAMES 'LATIN9';
--
start transaction;
--pseudo-classe non localisée pais zone d'ahabitat pour coder le lien inter-lot entre les chefs-lieux et les pais zones d'habitat
--
create table ZONEHABI (gid SERIAL not null, CLEABS varchar(24) not null, constraint ZONEHABI_pkey primary key (gid));
--
-- ponctuel commune : cette classe contient toute la semantiquede l'administratif (commune,canton,arrondissement,dep., region,arrondissement urbain) ; cette semantique est identique a celle portee par les communes et les arrondissements municipaux
--
create table PCOMMUNE (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NOMOFF varchar(45), ORIGNOM char(24), ARTICLE varchar(5), NOMNORM varchar(50), NUMINSEE varchar(5), IDBDADM integer, DATECRE varchar(10), DATEDES varchar(10), ALTIMIN integer, ALTIMAX integer, STATUT char(26), SUPERFIC integer, POPU integer, ORGREC varchar(20), DATEREC varchar(10), NOMCANT varchar(45), ARTCANT varchar(5), INSEECAN varchar(2), NOMARRD varchar(45), ARTARRD varchar(5), INSEEARD varchar(1), NOMDEPT varchar(30), ARTDEPT varchar(5), INSEEDEP varchar(3), NOMREG varchar(30), ARTREG varchar(5), INSEEREG varchar(2), MULTICAN char(3) not null, INSEECHC varchar(5), INSEECHA varchar(5), NOMCHCAN varchar(45), NOMCHARR varchar(45), constraint PCOMMUNE_pkey primary key (gid));
select AddGeometryColumn('','pcommune','the_geom','-1','MULTIPOINT',2);
create index PCOMMUNE_geoidx on PCOMMUNE using gist (the_geom gist_geometry_ops);
--
-- Chef-lieu
--
create table CHEFLIEU (gid SERIAL not null, CLEABS varchar(24) not null, ETATOBJ char(15), GRAPHIE varchar(70), constraint CHEFLIEU_pkey primary key (gid));
select AddGeometryColumn('','cheflieu','the_geom','-1','MULTIPOINT',2);
create index CHEFLIEU_geoidx on CHEFLIEU using gist (the_geom gist_geometry_ops);
--
-- Limite administrative
--
create table LIMITADM (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), RECALAGE char(39), constraint LIMITADM_pkey primary key (gid));
select AddGeometryColumn('','limitadm','the_geom','-1','MULTILINESTRING',2);
create index LIMITADM_geoidx on LIMITADM using gist (the_geom gist_geometry_ops);
--
-- Plus petite subdivision du territoire,administrée par un maire,des adjoints et un conseil municipal
--
create table COMMUNE (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NOMOFF varchar(45), ORIGNOM char(24), ARTICLE varchar(5), NOMNORM varchar(50), NUMINSEE varchar(5), IDBDADM integer, DATECRE varchar(10), DATEDES varchar(10), ALTIMIN integer, ALTIMAX integer, STATUT char(26), SUPERFIC integer, POPU integer, ORGREC varchar(20), DATEREC varchar(10), NOMCANT varchar(45), ARTCANT varchar(5), INSEECAN varchar(2), NOMARRD varchar(45), ARTARRD varchar(5), INSEEARD varchar(1), NOMDEPT varchar(30), ARTDEPT varchar(5), INSEEDEP varchar(3), NOMREG varchar(30), ARTREG varchar(5), INSEEREG varchar(2), MULTICAN char(3) not null, INSEECHC varchar(5), INSEECHA varchar(5), NOMCHCAN varchar(45), NOMCHARR varchar(45), constraint COMMUNE_pkey primary key (gid));
select AddGeometryColumn('','commune','the_geom','-1','MULTIPOLYGON',2);
create index COMMUNE_geoidx on COMMUNE using gist (the_geom gist_geometry_ops);
--
-- Arrondissement municipal : subdivision administrative de certaines communes(Paris, Lyon, Marseille)
--
create table ARRONDIS (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NUMINSEE varchar(5) not null, NOMOFF varchar(45) not null, NOMNORM varchar(45), constraint ARRONDIS_pkey primary key (gid));
select AddGeometryColumn('','arrondis','the_geom','-1','MULTIPOLYGON',2);
create index ARRONDIS_geoidx on ARRONDIS using gist (the_geom gist_geometry_ops);
--
--Lien entre les chefs-lieux et les pais zone d'habitat
--
create table CHL_PAI (ZONEHABI_key1 SERIAL not null, CHEFLIEU_key2 SERIAL not null, constraint CHL_PAI_pkey primary key (ZONEHABI_key1, CHEFLIEU_key2), constraint CHL_PAI_fkey1 foreign key (ZONEHABI_key1) references ZONEHABI on delete cascade, constraint CHL_PAI_fkey2 foreign key (CHEFLIEU_key2) references CHEFLIEU on delete cascade);
--
--Lien vers chef-lieu
--
create table COM_CHL (COMMUNE_key1 SERIAL not null, CHEFLIEU_key2 SERIAL not null, constraint COM_CHL_pkey primary key (COMMUNE_key1, CHEFLIEU_key2), constraint COM_CHL_fkey1 foreign key (COMMUNE_key1) references COMMUNE on delete cascade, constraint COM_CHL_fkey2 foreign key (CHEFLIEU_key2) references CHEFLIEU on delete cascade);
--
--Lien vers chef-lieu
--
create table PCOM_CHL (PCOMMUNE_key1 SERIAL not null, CHEFLIEU_key2 SERIAL not null, constraint PCOM_CHL_pkey primary key (PCOMMUNE_key1, CHEFLIEU_key2), constraint PCOM_CHL_fkey1 foreign key (PCOMMUNE_key1) references PCOMMUNE on delete cascade, constraint PCOM_CHL_fkey2 foreign key (CHEFLIEU_key2) references CHEFLIEU on delete cascade);
