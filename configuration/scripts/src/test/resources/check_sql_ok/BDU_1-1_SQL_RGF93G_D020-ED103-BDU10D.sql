SET NAMES 'LATIN9';
--
-- SET NAMES 'LATIN9';
--
start transaction;
--Cours d'eau nommé. Portion du réseau hydrographique possédant un hydronyme
--
create table CDENOMME (gid SERIAL not null, CLEABS varchar(24) not null, ETATOBJ char(15), GRAPHIEP varchar(70), ORIGINGP varchar(40), DATEVGP varchar(10), GRAPHIER varchar(70), ORIGINGR varchar(40), DATEVGR varchar(10), GRAPHIES varchar(70), ORIGINGS varchar(40), DATEVGS varchar(10), NOMLOCAL varchar(70), ORIGINNL varchar(40), NOMCAD varchar(70), AUTRENOM varchar(70), VALIDE boolean not null, IMPORTAN char(11), CDBSEL25 boolean not null, CDBSEL50 boolean not null, CDBINFOT boolean not null, constraint CDENOMME_pkey primary key (gid));
--
-- Source, point de production d'eau ou point de stockage
--
create table POINDEAU (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(18) not null, constraint POINDEAU_pkey primary key (gid));
select AddGeometryColumn('','poindeau','the_geom','-1','MULTIPOINT',3);
create index POINDEAU_geoidx on POINDEAU using gist (the_geom gist_geometry_ops);
--
-- Troncon de cours d'eau. Portion de cours d'eau qui n'inclut pas de confluent
--
create table TRONDEAU (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(60) not null, ARTIFICI boolean not null, FICTIF boolean not null, REGIMEDE char(12) not null, POSITION integer not null, constraint TRONDEAU_pkey primary key (gid));
select AddGeometryColumn('','trondeau','the_geom','-1','MULTILINESTRING',3);
create index TRONDEAU_geoidx on TRONDEAU using gist (the_geom gist_geometry_ops);
--
-- Troncon de laisse, limite supérieure ou inférieure de l'estran
--
create table TRONLAIS (gid SERIAL not null, CLEABS varchar(24) not null, SOURCE2D char(30), ETATOBJ char(15), HAUTEUR char(27) not null, constraint TRONLAIS_pkey primary key (gid));
select AddGeometryColumn('','tronlais','the_geom','-1','MULTILINESTRING',3);
create index TRONLAIS_geoidx on TRONLAIS using gist (the_geom gist_geometry_ops);
--
-- Surface d'eau terrestre, naturelle ou artificielle
--
create table SURFDEAU (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(39) not null, REGIMEDE char(12) not null, constraint SURFDEAU_pkey primary key (gid));
select AddGeometryColumn('','surfdeau','the_geom','-1','MULTIPOLYGON',3);
create index SURFDEAU_geoidx on SURFDEAU using gist (the_geom gist_geometry_ops);
--
--Lien vers cours d'eau nommé
--
create table TCE_CDE (CDENOMME_key1 SERIAL not null, TRONDEAU_key2 SERIAL not null, constraint TCE_CDE_pkey primary key (CDENOMME_key1, TRONDEAU_key2), constraint TCE_CDE_fkey1 foreign key (CDENOMME_key1) references CDENOMME on delete cascade, constraint TCE_CDE_fkey2 foreign key (TRONDEAU_key2) references TRONDEAU on delete cascade);
--
commit;
--
-- CDENOMME
start transaction;
insert into CDENOMME values ('94723','COURNOMM0000000108372487',DEFAULT,'ruisseau de chiarasgiola','BDTopo','1988-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('94724','COURNOMM0000000108372380',DEFAULT,'ruisseau de cavallare','BDTopo','1988-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('94725','COURNOMM0000000108372891',DEFAULT,'ruisseau de stencia','BDTopo','1987-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('94726','COURNOMM0000000108372296',DEFAULT,'ruisseau de paratella','BDTopo','1988-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','7          ','true','false','false');
insert into CDENOMME values ('94727','COURNOMM0000000108372647',DEFAULT,'tenera','BDTopo','1987-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('94728','COURNOMM0000000109807955',DEFAULT,'ruisseau d\'erbolane','BDTopo','1987-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('94729','COURNOMM0000000109807575',DEFAULT,'ruisseau de san fiumento','BDTopo','1987-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('94730','COURNOMM0000000108372600',DEFAULT,'ruisseau de macinelli','BDTopo','1987-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('94731','COURNOMM0000000109807169',DEFAULT,'ruisseau de campianellu','BDTopo','1987-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
