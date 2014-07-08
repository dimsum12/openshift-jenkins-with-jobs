SET NAMES 'LATIN9';
--
-- SET NAMES 'LATIN9';
--
start transaction;
--Route numérotée ou nommée. Voie de communication destinée aux automobiles et possédant un numéro ou un nom particulier
--
create table ROUTENUM (gid SERIAL not null, CLEABS varchar(24) not null, ETATOBJ char(15), TYPEROUT char(16) not null, GESTION varchar(3), NUMERO varchar(10), GRAPHIEP varchar(70), ORIGINGP varchar(40), DATEVGP varchar(10), GRAPHIER varchar(70), ORIGINGR varchar(40), DATEVGR varchar(10), GRAPHIES varchar(70), ORIGINGS varchar(40), DATEVGS varchar(10), NOMLOCAL varchar(70), ORIGINNL varchar(40), NOMCAD varchar(70), NOMGEORO varchar(70), AUTRENOM varchar(70), VALIDE boolean not null, IMPORTAN char(11), CDBSEL25 boolean not null, CDBSEL50 boolean not null, CDBINFOT boolean not null, constraint ROUTENUM_pkey primary key (gid));
--
-- Assure qu'il n'y a pas de connexion logique en un noeud entre deux tronçons de route homogènes reliés à ce noeud. Cette logique de communication permet de traiter les cas d'interdiction de tourner, les impossibilités de faire demi-tour et les impossibilités de tourner induites par la présence de séparateurs non saisis. Elle est traduite comme un objet complexe : une "non communication" est un objet complexe composé d'un noeud routier d'un tronçon de route homogène A ne pouvant pas communiquer avec un tronçon B. En un noeud routier peuvent exister plusieurs "non communications".
--
create table NON_COMM (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), constraint NON_COMM_pkey primary key (gid));
select AddGeometryColumn('','non_comm','the_geom','-1','MULTIPOINT',3);
create index NON_COMM_geoidx on NON_COMM using gist (the_geom gist_geometry_ops);
--
-- Barrière
--
create table BARRIERE (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), NOM varchar(100), CDBBARR boolean not null, constraint BARRIERE_pkey primary key (gid));
select AddGeometryColumn('','barriere','the_geom','-1','MULTIPOINT',3);
create index BARRIERE_geoidx on BARRIERE using gist (the_geom gist_geometry_ops);
--
-- Troncon de route
--
create table TRONROUT (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), IMPORTAN char(10) not null, POSITION integer, NATURE char(115) not null, SENS_CIR char(12) not null, ACCES char(19) not null, NB_VOIES integer, ITINER_V char(16) not null, RESTRI_H char(3), RESTRI_P char(4), NOMRUE_G varchar(100), NOMRUE_D varchar(100), BORNE_DG varchar(15), BORNE_DD varchar(15), BORNE_FG varchar(15), BORNE_FD varchar(15), TYPE_ADR char(10), DATE_MES varchar(10), INSEEGAU varchar(5), INSEEDRO varchar(5), FICTIF boolean not null, LGCHAUSS decimal(10,2), BORNDINT boolean not null, FERMSAIS boolean not null, BORNFINT boolean not null, ID_FPBVG varchar(9), ID_FPBVD varchar(9), TOPINFRA varchar(70), RESERBUS char(12), CDBBRETA boolean not null, constraint TRONROUT_pkey primary key (gid));
select AddGeometryColumn('','tronrout','the_geom','-1','MULTILINESTRING',3);
create index TRONROUT_geoidx on TRONROUT using gist (the_geom gist_geometry_ops);
--
-- Surface de route. Partie de la chaussée d'une route caractérisée par une largeur exceptionnelle
--
create table SURFROUT (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(18) not null, constraint SURFROUT_pkey primary key (gid));
select AddGeometryColumn('','surfrout','the_geom','-1','MULTIPOLYGON',3);
create index SURFROUT_geoidx on SURFROUT using gist (the_geom gist_geometry_ops);
--
--Lien vers route nommée
--
create table TRO_RTN (ROUTENUM_key1 SERIAL not null, TRONROUT_key2 SERIAL not null, constraint TRO_RTN_pkey primary key (ROUTENUM_key1, TRONROUT_key2), constraint TRO_RTN_fkey1 foreign key (ROUTENUM_key1) references ROUTENUM on delete cascade, constraint TRO_RTN_fkey2 foreign key (TRONROUT_key2) references TRONROUT on delete cascade);
--
--Tronçon entrée
--
create table TRONCENT (NON_COMM_key1 SERIAL not null, TRONROUT_key2 SERIAL not null, constraint TRONCENT_pkey primary key (NON_COMM_key1, TRONROUT_key2), constraint TRONCENT_fkey1 foreign key (NON_COMM_key1) references NON_COMM on delete cascade, constraint TRONCENT_fkey2 foreign key (TRONROUT_key2) references TRONROUT on delete cascade);
--
--Tronçon sortie
--
create table TRONCSOR (NON_COMM_key1 SERIAL not null, TRONROUT_key2 SERIAL not null, constraint TRONCSOR_pkey primary key (NON_COMM_key1, TRONROUT_key2), constraint TRONCSOR_fkey1 foreign key (NON_COMM_key1) references NON_COMM on delete cascade, constraint TRONCSOR_fkey2 foreign key (TRONROUT_key2) references TRONROUT on delete cascade);
--
commit;
--
-- ROUTENUM
start transaction;
insert into ROUTENUM values ('15992078','ROUTNOMM0000000066197121',DEFAULT,'Départementale  ','55','D15B',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'false',DEFAULT,'false','false','false');
