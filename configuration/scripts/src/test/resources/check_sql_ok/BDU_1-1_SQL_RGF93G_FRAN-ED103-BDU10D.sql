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
insert into CDENOMME values ('3259318','COURNOMM0000000093111034',DEFAULT,'la vieille','BDTOPO','1985-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'la vieille','carte au 1 : 25000',DEFAULT,DEFAULT,'true','8          ','true','true','false');
insert into CDENOMME values ('3259319','COURNOMM0000000041789457',DEFAULT,'la vanne','BDTopo','1988-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('3259320','COURNOMM0000000083871031',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'ruisseau de la pisse','Scan25',DEFAULT,DEFAULT,'false','8          ','false','false','false');
insert into CDENOMME values ('3259321','COURNOMM0000000099717642',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'ruisseau du rohart',DEFAULT,DEFAULT,DEFAULT,'false',DEFAULT,'false','false','false');
insert into CDENOMME values ('3259322','COURNOMM0000000105712824',DEFAULT,'ruisseau des andraux','BDTopo','1982-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('3259323','COURNOMM0000000202558907',DEFAULT,'vieille rouille de boutric','BDTopo','1985-01-01',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('3259324','COURNOMM0000000207140433',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'canal de charrière-chaude','plan de ville',DEFAULT,DEFAULT,'false','8          ','false','false','false');
insert into CDENOMME values ('3259325','COURNOMM0000000000847497',DEFAULT,'le rhin','BDTopo','1996-03-06',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','8          ','true','false','false');
insert into CDENOMME values ('3259326','COURNOMM0000000003761500',DEFAULT,'ru du montubois','BDTopo','2001-02-08',DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'true','7          ','true','false','false');
