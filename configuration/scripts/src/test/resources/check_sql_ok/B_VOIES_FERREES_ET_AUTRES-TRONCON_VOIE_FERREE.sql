SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Tronçon de voie ferrée. Portion de voie ferrée homogéne pour l'ensemble des attributs qui la concernent. Une ligne composée de 2 voies parallèles est modélisée par seul objet
--
create table TRONCON_VOIE_FERREE (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, NATURE varchar(26) not null, ELECTRIFIE varchar(14) default 'NR', FRANCHISST varchar(6) not null, LARGEUR varchar(7) not null, NB_VOIES integer not null, POS_SOL integer not null, ETAT varchar(15) default 'NR', Z_INI float, Z_FIN float, constraint TRONCON_VOIE_FERREE_pkey primary key (gid));
select AddGeometryColumn('','troncon_voie_ferree','the_geom','210642000','LINESTRING',3);
create index TRONCON_VOIE_FERREE_geoidx on TRONCON_VOIE_FERREE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- TRONCON_VOIE_FERREE
start transaction;
insert into TRONCON_VOIE_FERREE values ('1','TRONFERR0000000069987434','   2.5','    2.5','Voie non exploitée','Non électrique','NC','Normale','1',0,DEFAULT,'4.200000','7.500000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.998541 14.781887 4.200000,-60.998566 14.781801 3.900000,-60.998590 14.781674 3.800000,-60.998650 14.781382 3.900000,-60.998690 14.781088 4.200000,-60.998810 14.780408 5.000000,-60.998874 14.780008 5.000000,-60.998930 14.779633 5.400000,-60.998954 14.779471 5.600000,-60.999016 14.778917 4.900000,-60.999020 14.778840 4.900000,-60.999041 14.778756 4.800000,-60.999072 14.778677 4.800000,-60.999152 14.778546 4.800000,-60.999291 14.778391 6.000000,-60.999858 14.777928 5.800000,-61.000451 14.777446 5.400000,-61.000524 14.777366 5.500000,-61.000662 14.777200 6.200000,-61.000807 14.777008 6.400000,-61.001000 14.776770 6.400000,-61.001448 14.776185 7.000000,-61.001635 14.775953 7.500000)'));
commit;
--
