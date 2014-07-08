SET NAMES 'LATIN9';
--
-- SET NAMES 'LATIN9';
--
start transaction;
-- Tron�on de voie ferr�e. Portion de voie ferr�e homog�ne pour l'ensemble des attributs qui la concernent. Une ligne compos�e de 2 voies parall�les est mod�lis�e par seul objet
--
create table TVOIEFER (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29), SOURCE2D char(30), ETATOBJ char(15), NATURE char(71) not null, ENERGIE char(14), LARGEUR char(7) not null, NB_VOIES integer not null, POSITION integer not null, constraint TVOIEFER_pkey primary key (gid));
select AddGeometryColumn('','tvoiefer','the_geom','-1','MULTILINESTRING',3);
create index TVOIEFER_geoidx on TVOIEFER using gist (the_geom gist_geometry_ops);
--
-- Transport par c�ble. Moyen de transport constitu� d'un ou plusieurs c�bles porteurs
--
create table TRANSCAB (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29) not null, SOURCE2D char(30), ETATOBJ char(15), NATURE char(73) not null, CDBOUVTA boolean not null, constraint TRANSCAB_pkey primary key (gid));
select AddGeometryColumn('','transcab','the_geom','-1','MULTILINESTRING',3);
create index TRANSCAB_geoidx on TRANSCAB using gist (the_geom gist_geometry_ops);
--
-- Aire de triage. Ensemble des tron�ons de voies, voies de garage, aiguillagespermettant le tri des wagons et la composition des trains
--
create table AIRE_TRI (gid SERIAL not null, CLEABS varchar(24) not null, SOURCEZ char(29), SOURCE2D char(30), ETATOBJ char(15), constraint AIRE_TRI_pkey primary key (gid));
select AddGeometryColumn('','aire_tri','the_geom','-1','MULTIPOLYGON',3);
create index AIRE_TRI_geoidx on AIRE_TRI using gist (the_geom gist_geometry_ops);
--
commit;
--
-- TVOIEFER
start transaction;
insert into TVOIEFER values ('1458','TRONFERR0000000059017223','Photogramm�trie              ','Photogramm�trie               ',DEFAULT,'Voie ferr�e principale                                                 ','Non �lectrique','Normale','1',1, GeomFromEWKT('SRID=-1;MULTILINESTRING((1.586900 49.955720 43.000000,1.586855 49.955756 42.900000,1.586779 49.955818 42.800000))'));
insert into TVOIEFER values ('1459','TRONFERR0000000012537938','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e principale                                                 ','Electrique    ','Normale','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((6.468048 45.542841 424.800000,6.468073 45.542793 424.800000,6.468137 45.542627 424.900000,6.468191 45.542473 425.000000,6.468238 45.542332 425.000000,6.468270 45.542171 425.200000,6.468282 45.542084 425.300000))'));
insert into TVOIEFER values ('1460','TRONFERR0000000045732288','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e non exploit�e. Voie ferr�e neutralis�e, ferm�e ou d�class�e','Non �lectrique','Normale','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((2.679438 50.632169 18.800000,2.679880 50.632214 18.900000,2.680055 50.632228 18.900000,2.680201 50.632234 18.900000,2.680345 50.632237 18.800000,2.680480 50.632237 18.800000,2.680592 50.632231 18.800000,2.680775 50.632230 18.700000,2.681293 50.632187 18.900000,2.681529 50.632165 18.900000,2.681709 50.632159 18.800000,2.681859 50.632155 18.800000,2.681997 50.632158 18.800000,2.682133 50.632166 18.600000,2.682268 50.632185 18.499999,2.682403 50.632204 18.400000,2.682537 50.632229 18.400000,2.682648 50.632254 18.400000,2.682770 50.632293 18.400000,2.682879 50.632333 18.400000,2.682975 50.632369 18.400000,2.683052 50.632403 18.400000,2.683124 50.632436 18.400000,2.683173 50.632464 18.400000,2.683203 50.632485 18.400000,2.683244 50.632509 18.400000,2.683369 50.632590 18.300000,2.683486 50.632685 18.400000,2.683568 50.632767 18.600000,2.683655 50.632855 18.300000,2.683742 50.632967 18.300000,2.683800 50.633060 18.300000,2.683847 50.633166 18.100000,2.683867 50.633236 18.100000,2.683889 50.633314 18.100000,2.683922 50.633475 17.100000))'));
insert into TVOIEFER values ('1461','TRONFERR0000000076165335','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e principale                                                 ','Non �lectrique','Normale','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((-1.925767 48.529282 28.499999,-1.924036 48.530284 27.700000,-1.923587 48.530505 27.600000,-1.923472 48.530562 27.499999,-1.922562 48.530950 27.200000,-1.922142 48.531075 27.000000,-1.921390 48.531278 26.800000,-1.920732 48.531399 26.600000,-1.920128 48.531474 26.400000,-1.919619 48.531510 26.200000,-1.919124 48.531539 26.100000,-1.918942 48.531539 26.000000,-1.918882 48.531540 26.000000,-1.918822 48.531541 26.000000,-1.918524 48.531547 25.900000,-1.918221 48.531556 25.800000,-1.917767 48.531553 25.700000,-1.917744 48.531553 25.600000,-1.916455 48.531556 25.300000,-1.916069 48.531549 25.300000,-1.912890 48.531509 23.600000,-1.910790 48.531499 23.900000))'));
insert into TVOIEFER values ('1462','TRONFERR0000000000391984','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e principale                                                 ','Non �lectrique','Etroite','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((2.318235 48.935580 30.400000,2.318229 48.935528 30.300000,2.318213 48.935477 30.300000,2.318163 48.935395 30.200000,2.318125 48.935336 30.100000,2.317798 48.934830 29.600000))'));
insert into TVOIEFER values ('1463','TRONFERR0000000104613909','Photogramm�trie              ','Photogramm�trie               ',DEFAULT,'Voie ferr�e principale                                                 ','Electrique    ','Normale','3',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((1.709420 46.813530 153.000000,1.709222 46.813449 153.000000))'));
insert into TVOIEFER values ('1464','TRONFERR0000000104613908','Photogramm�trie              ','Photogramm�trie               ',DEFAULT,'Voie ferr�e principale                                                 ','Electrique    ','Normale','3',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((1.708937 46.813331 153.300000,1.707730 46.812836 153.800000))'));
insert into TVOIEFER values ('1465','TRONFERR0000000014615960','Photogramm�trie              ','Photogramm�trie               ',DEFAULT,'Voie ferr�e de service                                                 ','Non �lectrique','Normale','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((6.824582 47.516066 320.200000,6.823430 47.516022 320.000000,6.822365 47.515980 319.800000,6.821033 47.515918 319.600000,6.820327 47.515893 319.400000,6.819715 47.515819 319.300000))'));
insert into TVOIEFER values ('1466','TRONFERR0000000059018272','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e de service                                                 ','Non �lectrique','Normale','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((0.286890 49.481066 4.700000,0.284615 49.481394 4.499999,0.284551 49.481409 4.499999,0.283506 49.481547 4.499999,0.283173 49.481551 4.900000,0.282975 49.481525 4.300000,0.282805 49.481482 4.200000,0.282476 49.481356 5.000000,0.282335 49.481271 5.000000,0.282194 49.481167 4.900000,0.282113 49.481097 5.400000,0.281688 49.480806 5.100000,0.281538 49.480677 5.300000,0.281414 49.480533 2.900000,0.281295 49.480396 5.300000,0.281240 49.480305 5.200000,0.281067 49.479927 5.200000))'));
insert into TVOIEFER values ('1467','TRONFERR0000000202655788','Lev� GPS                     ','Lev� GPS                      ',DEFAULT,'Ligne de tramway                                                       ','Electrique    ','Normale','2',1, GeomFromEWKT('SRID=-1;MULTILINESTRING((-0.519501 44.884567 47.600000,-0.519492 44.884581 47.600000,-0.519480 44.884595 47.600000,-0.519471 44.884610 47.499999,-0.519461 44.884624 47.499999,-0.519452 44.884640 47.700000,-0.519443 44.884654 47.700000,-0.519432 44.884668 47.600000,-0.519421 44.884684 47.600000,-0.519411 44.884697 47.700000,-0.519403 44.884712 47.800000,-0.519393 44.884727 47.800000,-0.519384 44.884741 47.800000,-0.519373 44.884754 47.800000,-0.519363 44.884769 47.900000,-0.519354 44.884784 48.000000,-0.519344 44.884798 48.000000,-0.519333 44.884813 48.000000,-0.519324 44.884827 48.000000,-0.519314 44.884842 48.100000,-0.519304 44.884856 48.200000,-0.519291 44.884872 48.300000,-0.519280 44.884885 48.300000,-0.519271 44.884899 48.400000,-0.519261 44.884912 48.400000,-0.519252 44.884927 48.600000,-0.519241 44.884941 48.600000,-0.519229 44.884954 48.600000,-0.519218 44.884968 48.700000,-0.519207 44.884982 48.900000,-0.519196 44.884996 48.900000,-0.519185 44.885010 49.000000,-0.519172 44.885023 49.100000,-0.519160 44.885038 49.200000,-0.519149 44.885051 49.300000,-0.519137 44.885063 49.400000,-0.519123 44.885076 49.300000,-0.519110 44.885088 49.499999,-0.519097 44.885101 49.600000,-0.519083 44.885115 49.700000,-0.519070 44.885127 49.700000,-0.519056 44.885139 49.800000,-0.519042 44.885152 49.900000,-0.519028 44.885164 50.000000,-0.519012 44.885176 50.100000,-0.518997 44.885188 50.100000,-0.518982 44.885200 50.200000,-0.518967 44.885214 50.400000,-0.518954 44.885225 50.300000,-0.518940 44.885236 50.300000,-0.518923 44.885248 50.400000,-0.518908 44.885260 50.499999,-0.518893 44.885271 50.600000,-0.518875 44.885281 50.600000,-0.518857 44.885291 50.600000,-0.518840 44.885302 50.700000,-0.518822 44.885313 50.800000,-0.518806 44.885322 50.900000,-0.518787 44.885331 50.900000,-0.518768 44.885341 50.900000,-0.518752 44.885352 51.000000,-0.518733 44.885361 51.100000,-0.518713 44.885371 51.100000,-0.518695 44.885381 51.100000,-0.518678 44.885389 51.100000,-0.518658 44.885399 51.100000,-0.518640 44.885408 51.200000,-0.518621 44.885418 51.200000,-0.518602 44.885426 51.200000,-0.518583 44.885435 51.200000,-0.518563 44.885444 51.300000,-0.518543 44.885453 51.300000,-0.518525 44.885462 51.200000,-0.518504 44.885471 51.200000,-0.518486 44.885481 51.300000,-0.518468 44.885488 51.300000,-0.518451 44.885495 51.400000,-0.518435 44.885504 51.300000,-0.518418 44.885512 51.300000,-0.518401 44.885519 51.300000,-0.518384 44.885528 51.300000,-0.518365 44.885537 51.300000,-0.518347 44.885544 51.300000,-0.518330 44.885553 51.200000,-0.518310 44.885560 51.200000,-0.518292 44.885569 51.200000,-0.518273 44.885577 51.200000,-0.518255 44.885585 51.200000,-0.518236 44.885594 51.100000,-0.518220 44.885603 51.100000,-0.518202 44.885613 51.000000,-0.518183 44.885620 51.000000,-0.518166 44.885630 51.000000,-0.518147 44.885638 51.000000,-0.518128 44.885647 51.000000,-0.518111 44.885654 50.900000,-0.518093 44.885664 50.900000,-0.518075 44.885673 50.900000,-0.518056 44.885683 50.900000,-0.518037 44.885691 50.800000,-0.518021 44.885701 50.800000,-0.518003 44.885709 50.700000,-0.517986 44.885719 50.800000,-0.517969 44.885729 50.700000,-0.517953 44.885739 50.700000,-0.517937 44.885750 50.600000,-0.517920 44.885760 50.600000,-0.517903 44.885771 50.600000,-0.517888 44.885783 50.600000,-0.517871 44.885794 50.499999,-0.517857 44.885805 50.400000,-0.517842 44.885817 50.499999,-0.517827 44.885830 50.499999,-0.517812 44.885842 50.400000,-0.517798 44.885856 50.300000))'));
insert into TVOIEFER values ('1468','TRONFERR0000000013180108','BDTopo                       ','BDTopo                        ',DEFAULT,'Ligne de tramway                                                       ','Electrique    ','Normale','2',1, GeomFromEWKT('SRID=-1;MULTILINESTRING((4.985033 45.773365 192.100000,4.984816 45.773391 192.700000,4.984657 45.773410 193.200000,4.984509 45.773427 193.100000,4.984455 45.773434 193.100000,4.984390 45.773442 192.400000,4.984281 45.773455 191.300000,4.983978 45.773490 189.700000))'));
insert into TVOIEFER values ('1469','TRONFERR0000000013182453','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e de service                                                 ','Non �lectrique','Normale','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((4.767311 45.585963 158.900000,4.767053 45.585859 157.800000,4.766167 45.585592 158.200000))'));
insert into TVOIEFER values ('1470','TRONFERR0000000023227289','Photogramm�trie              ','Photogramm�trie               ',DEFAULT,'Voie ferr�e principale                                                 ','Electrique    ','Normale','2',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((-3.636005 48.570853 108.100000,-3.635919 48.571165 108.499999,-3.635668 48.572044 110.400000,-3.635623 48.572177 110.600000,-3.635563 48.572362 110.800000,-3.635473 48.572608 110.900000,-3.635390 48.572803 111.100000,-3.635319 48.572967 110.800000,-3.635247 48.573101 110.800000,-3.635187 48.573226 110.800000,-3.635134 48.573324 111.600000,-3.635056 48.573454 112.100000,-3.634976 48.573587 112.200000,-3.634894 48.573710 112.100000,-3.634816 48.573824 112.000000,-3.634723 48.573949 111.900000,-3.634705 48.573972 111.900000,-3.634662 48.574028 112.100000,-3.634586 48.574127 112.400000,-3.634542 48.574185 112.600000,-3.634475 48.574271 112.900000,-3.634365 48.574402 113.000000,-3.634256 48.574523 113.100000,-3.634165 48.574633 112.900000,-3.634059 48.574748 113.100000,-3.633946 48.574866 113.000000,-3.633803 48.575006 113.400000,-3.633667 48.575132 113.700000,-3.633494 48.575277 114.000000,-3.633284 48.575440 114.100000,-3.633040 48.575616 114.200000,-3.632783 48.575795 114.600000,-3.632564 48.575939 114.600000,-3.632271 48.576110 114.800000,-3.631988 48.576276 114.600000,-3.631897 48.576326 114.700000,-3.631645 48.576459 115.200000,-3.631358 48.576604 115.600000,-3.631109 48.576717 116.300000,-3.630814 48.576848 116.499999,-3.630647 48.576920 116.600000,-3.630425 48.577013 117.600000,-3.630119 48.577124 117.600000,-3.629809 48.577229 117.700000,-3.629455 48.577336 117.900000,-3.629072 48.577436 117.900000,-3.629043 48.577443 117.900000,-3.628625 48.577550 118.100000,-3.628103 48.577669 118.800000,-3.627698 48.577751 119.200000,-3.627207 48.577817 119.600000,-3.627162 48.577821 119.600000,-3.626551 48.577902 120.900000,-3.626363 48.577921 121.000000,-3.625589 48.577999 121.600000,-3.624026 48.578147 122.000000,-3.622597 48.578281 122.600000,-3.621563 48.578382 123.600000,-3.620325 48.578499 125.800000,-3.619102 48.578610 125.800000,-3.617726 48.578736 125.499999,-3.615299 48.578961 127.499999,-3.613224 48.579159 130.600000,-3.611181 48.579350 132.499999,-3.609877 48.579465 133.200000,-3.609532 48.579487 133.400000,-3.609248 48.579502 133.400000,-3.609061 48.579509 133.400000,-3.608957 48.579514 133.499999,-3.608673 48.579520 133.499999,-3.608185 48.579524 133.800000,-3.607694 48.579515 134.600000,-3.607189 48.579497 135.000000,-3.606679 48.579467 135.800000,-3.606048 48.579403 136.499999,-3.605446 48.579328 137.300000,-3.604927 48.579246 137.200000,-3.604303 48.579128 137.200000,-3.604043 48.579070 137.200000,-3.603711 48.578994 137.200000,-3.603688 48.578991 137.200000,-3.602816 48.578756 137.400000,-3.602189 48.578557 138.400000,-3.601127 48.578174 138.600000,-3.599904 48.577716 139.600000,-3.598945 48.577365 140.100000,-3.598207 48.577109 141.100000,-3.597697 48.576938 140.800000,-3.597361 48.576827 141.499999,-3.596999 48.576725 142.200000,-3.596874 48.576689 142.200000,-3.596724 48.576648 142.300000,-3.596388 48.576574 142.700000,-3.596036 48.576493 142.900000,-3.595694 48.576418 143.100000,-3.595400 48.576360 143.700000,-3.595049 48.576294 144.400000,-3.594720 48.576241 144.100000,-3.594376 48.576186 143.800000,-3.593981 48.576136 144.400000,-3.593449 48.576066 144.800000,-3.593097 48.576026 145.499999,-3.592754 48.575995 145.800000,-3.592367 48.575968 146.800000,-3.591890 48.575940 147.600000,-3.591405 48.575930 147.100000,-3.590959 48.575932 146.900000,-3.590511 48.575932 147.100000,-3.589982 48.575942 147.100000,-3.589624 48.575960 147.600000,-3.589164 48.575988 147.600000,-3.588734 48.576023 147.600000,-3.588353 48.576059 147.700000,-3.587874 48.576117 148.400000,-3.587454 48.576172 148.900000,-3.587036 48.576230 149.700000,-3.586748 48.576282 149.700000,-3.586396 48.576350 149.800000,-3.585970 48.576431 149.800000,-3.585563 48.576518 151.400000,-3.585119 48.576625 151.300000,-3.584363 48.576832 151.700000,-3.583535 48.577071 151.499999,-3.582730 48.577313 152.100000,-3.581838 48.577577 152.400000,-3.580869 48.577869 152.300000,-3.580661 48.577930 152.400000,-3.579998 48.578128 152.900000,-3.579179 48.578371 152.900000,-3.578855 48.578466 153.100000,-3.578559 48.578553 153.200000,-3.578357 48.578613 153.300000,-3.577210 48.578957 153.700000,-3.577115 48.578984 153.700000,-3.576219 48.579250 154.400000,-3.576041 48.579303 154.499999,-3.575128 48.579576 154.700000))'));
insert into TVOIEFER values ('1471','TRONFERR0000000000391885','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e principale                                                 ','Non �lectrique','Etroite','1',1, GeomFromEWKT('SRID=-1;MULTILINESTRING((2.313708 48.937949 35.300000,2.313739 48.938030 35.300000,2.313841 48.938246 35.300000,2.313913 48.938404 35.100000))'));
insert into TVOIEFER values ('1472','TRONFERR0000000000391882','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e principale                                                 ','Non �lectrique','Etroite','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((2.313991 48.938393 34.800000,2.314002 48.938416 34.800000,2.314015 48.938441 34.800000,2.314086 48.938590 34.600000,2.314087 48.938779 34.499999))'));
insert into TVOIEFER values ('1473','TRONFERR0000000000391878','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e principale                                                 ','Non �lectrique','Etroite','1',1, GeomFromEWKT('SRID=-1;MULTILINESTRING((2.313708 48.937949 35.300000,2.313834 48.938097 35.100000,2.313859 48.938124 35.100000,2.313923 48.938250 34.900000,2.313954 48.938312 34.900000,2.313991 48.938393 34.800000))'));
insert into TVOIEFER values ('1474','TRONFERR0000000000391875','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e principale                                                 ','Non �lectrique','Etroite','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((2.313700 48.937907 35.300000,2.313708 48.937949 35.300000))'));
insert into TVOIEFER values ('1475','TRONFERR0000000000391873','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e principale                                                 ','Non �lectrique','Etroite','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((2.313913 48.938404 35.100000,2.313923 48.938421 35.000000,2.313938 48.938457 35.000000,2.313946 48.938476 35.000000,2.314087 48.938779 34.499999))'));
insert into TVOIEFER values ('1476','TRONFERR0000000099169372','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e principale                                                 ','Non �lectrique','Etroite','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((2.311035 48.934007 28.700000,2.310893 48.933993 28.700000))'));
insert into TVOIEFER values ('1477','TRONFERR0000000026801035','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e de service                                                 ','Non �lectrique','Normale','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((4.782364 49.715987 151.900000,4.782371 49.716005 151.700000,4.782525 49.716424 151.800000))'));
insert into TVOIEFER values ('1478','TRONFERR0000000026801034','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e de service                                                 ','Non �lectrique','Normale','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((4.782603 49.716657 151.800000,4.782525 49.716424 151.800000))'));
insert into TVOIEFER values ('1479','TRONFERR0000000042247351','BDTopo                       ','BDTopo                        ',DEFAULT,'Voie ferr�e principale                                                 ','Electrique    ','Normale','2',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((-0.163410 43.102068 333.800000,-0.163041 43.101952 333.800000,-0.162384 43.101705 333.700000,-0.161909 43.101521 333.600000,-0.161479 43.101350 333.100000,-0.160781 43.101068 333.499999,-0.160318 43.100896 333.700000,-0.159935 43.100770 333.900000,-0.159872 43.100749 333.900000,-0.159424 43.100631 334.000000,-0.158670 43.100497 334.200000,-0.158008 43.100427 334.499999,-0.157606 43.100402 334.800000,-0.157202 43.100383 335.100000,-0.156884 43.100370 335.200000,-0.156168 43.100287 335.700000,-0.155494 43.100150 336.600000,-0.155199 43.100071 337.000000,-0.155125 43.100052 336.900000,-0.154526 43.099867 337.000000,-0.152806 43.099351 337.900000,-0.152315 43.099224 337.900000,-0.151938 43.099141 339.000000,-0.151845 43.099121 338.200000,-0.151314 43.099050 338.900000,-0.150750 43.099007 339.700000,-0.150228 43.099004 339.900000,-0.150033 43.099014 340.000000,-0.149668 43.099032 340.300000,-0.149147 43.099092 340.700000,-0.148592 43.099198 341.100000,-0.148143 43.099306 341.400000,-0.147703 43.099443 342.000000,-0.147615 43.099477 342.200000,-0.147222 43.099636 342.100000,-0.147009 43.099738 343.100000,-0.146695 43.099884 342.400000,-0.146267 43.100143 342.900000,-0.145849 43.100439 342.900000,-0.145741 43.100535 342.800000,-0.145637 43.100629 343.700000,-0.145487 43.100763 343.100000,-0.144660 43.101609 342.800000,-0.144561 43.101711 342.800000,-0.144260 43.101976 342.900000,-0.143997 43.102185 343.000000,-0.143974 43.102200 343.400000,-0.143691 43.102390 343.200000,-0.143392 43.102570 343.300000,-0.143306 43.102611 344.200000,-0.142791 43.102862 344.000000,-0.142236 43.103082 344.400000,-0.141705 43.103240 344.700000,-0.140993 43.103384 345.300000,-0.140367 43.103456 347.600000,-0.140305 43.103464 346.700000,-0.139627 43.103501 347.200000,-0.138956 43.103476 347.400000,-0.138189 43.103379 348.300000,-0.137527 43.103232 349.300000,-0.136767 43.102975 349.600000,-0.136105 43.102681 349.900000,-0.135645 43.102417 351.000000,-0.135596 43.102390 350.700000,-0.135184 43.102139 353.800000,-0.135022 43.102039 352.499999,-0.134252 43.101567 354.200000,-0.134189 43.101529 353.600000,-0.133915 43.101361 353.300000,-0.133425 43.101086 353.400000,-0.132958 43.100856 353.600000,-0.132534 43.100682 354.100000,-0.131980 43.100500 355.000000,-0.131659 43.100421 355.900000,-0.131471 43.100373 355.499999,-0.130885 43.100268 356.000000,-0.130246 43.100209 356.499999,-0.129729 43.100200 357.100000,-0.129193 43.100218 357.800000,-0.128717 43.100270 358.300000,-0.128155 43.100359 358.400000,-0.127585 43.100506 358.300000,-0.127125 43.100660 358.200000,-0.126619 43.100874 357.600000,-0.126325 43.101007 357.200000,-0.126103 43.101092 357.300000,-0.124869 43.101649 356.499999,-0.124607 43.101739 356.600000,-0.124404 43.101809 356.499999,-0.124046 43.101914 356.200000,-0.123836 43.101975 356.000000,-0.123641 43.102020 356.100000,-0.122177 43.102358 355.100000,-0.121933 43.102415 354.300000,-0.120613 43.102705 353.700000,-0.118781 43.103108 352.800000,-0.118526 43.103159 352.900000,-0.117922 43.103279 352.800000,-0.117102 43.103401 352.800000,-0.116209 43.103498 352.800000,-0.115678 43.103532 353.100000,-0.114650 43.103557 353.400000,-0.114360 43.103555 354.600000,-0.113799 43.103553 354.499999,-0.113218 43.103529 354.600000,-0.112468 43.103464 355.000000,-0.111892 43.103392 355.300000,-0.110649 43.103207 355.900000,-0.108530 43.102876 356.600000,-0.108168 43.102820 356.300000,-0.105618 43.102443 355.900000,-0.103842 43.102162 356.700000,-0.103529 43.102101 356.700000,-0.103058 43.101970 356.700000,-0.102114 43.101665 357.000000,-0.101353 43.101400 357.400000,-0.100633 43.101176 357.300000,-0.096777 43.100001 358.300000,-0.096705 43.099982 358.900000,-0.096096 43.099826 358.600000,-0.095720 43.099751 358.900000,-0.095141 43.099674 359.100000,-0.094689 43.099643 359.499999,-0.094683 43.099643 359.499999,-0.094298 43.099639 359.900000,-0.093780 43.099656 360.100000,-0.093256 43.099708 359.900000,-0.091155 43.100059 360.900000,-0.089632 43.100312 361.400000,-0.088412 43.100550 361.499999,-0.088342 43.100564 361.499999))'));
insert into TVOIEFER values ('1480','TRONFERR0000000023227520','Photogramm�trie              ','Photogramm�trie               ',DEFAULT,'Voie ferr�e principale                                                 ','Non �lectrique','Normale','1',0, GeomFromEWKT('SRID=-1;MULTILINESTRING((-3.551678 48.292005 106.300000,-3.551599 48.292083 105.800000,-3.551509 48.292197 105.700000,-3.551427 48.292318 105.000000,-3.551384 48.292386 104.800000,-3.551341 48.292463 105.400000,-3.551298 48.292590 105.400000,-3.551256 48.292730 105.300000,-3.551243 48.292821 105.000000,-3.551230 48.292902 104.700000,-3.551217 48.293083 104.300000,-3.551203 48.293295 103.800000,-3.551189 48.293539 103.600000,-3.551167 48.293983 103.499999,-3.551140 48.294448 103.600000,-3.551114 48.294855 103.499999,-3.551095 48.295227 103.499999,-3.551078 48.295528 103.600000,-3.551065 48.295839 103.800000,-3.551053 48.296145 103.800000,-3.551049 48.296325 104.000000,-3.551039 48.296505 103.600000,-3.551011 48.296650 103.800000,-3.550974 48.296792 103.499999,-3.550913 48.296944 103.800000,-3.550853 48.297074 104.100000,-3.550848 48.297083 104.000000,-3.550778 48.297187 103.900000,-3.550688 48.297301 104.000000,-3.550588 48.297413 104.000000,-3.550448 48.297542 104.000000,-3.550307 48.297651 104.100000,-3.550157 48.297743 104.300000,-3.550010 48.297822 104.300000,-3.549877 48.297887 104.300000,-3.549729 48.297951 104.400000,-3.549590 48.297999 104.300000,-3.549428 48.298050 104.200000,-3.549249 48.298095 104.100000,-3.549084 48.298130 104.000000,-3.548910 48.298161 103.900000,-3.548758 48.298180 103.800000,-3.548566 48.298191 103.600000,-3.548360 48.298191 103.400000,-3.548153 48.298182 103.400000,-3.547969 48.298163 103.400000,-3.547746 48.298133 103.499999,-3.547546 48.298104 103.600000,-3.547272 48.298064 103.600000,-3.546913 48.298006 103.600000,-3.546557 48.297951 103.499999,-3.546269 48.297916 103.400000,-3.545977 48.297888 103.400000,-3.545657 48.297866 103.300000,-3.545393 48.297851 102.900000,-3.545147 48.297840 102.499999,-3.544866 48.297834 101.900000,-3.544618 48.297840 101.499999,-3.544337 48.297853 101.200000,-3.544062 48.297877 101.100000,-3.543821 48.297906 101.100000,-3.543538 48.297944 101.100000,-3.543179 48.298003 100.600000,-3.542578 48.298101 99.000000,-3.541753 48.298243 98.200000,-3.541108 48.298354 96.900000,-3.540345 48.298493 95.700000,-3.540023 48.298554 95.200000,-3.539845 48.298592 95.000000,-3.539689 48.298635 94.900000,-3.539530 48.298687 94.600000,-3.539348 48.298757 94.499999,-3.539173 48.298831 94.200000,-3.539016 48.298913 94.200000,-3.538909 48.298978 93.800000,-3.538867 48.299004 93.700000,-3.538738 48.299093 93.200000,-3.538638 48.299178 92.800000,-3.538534 48.299272 92.499999,-3.538434 48.299376 92.000000,-3.538361 48.299466 91.700000,-3.538294 48.299552 91.200000,-3.538224 48.299653 90.700000,-3.538168 48.299760 90.400000,-3.538126 48.299866 90.300000,-3.538122 48.299885 90.200000,-3.538095 48.299987 90.200000,-3.538073 48.300113 90.200000,-3.538053 48.300268 90.100000,-3.538037 48.300545 90.100000,-3.538030 48.300871 90.100000,-3.538010 48.301214 89.900000,-3.537990 48.301502 89.900000,-3.537969 48.301698 90.400000,-3.537946 48.301854 90.700000,-3.537914 48.302007 90.300000,-3.537855 48.302242 90.300000,-3.537760 48.302530 90.499999,-3.537665 48.302791 90.400000,-3.537544 48.303041 90.300000,-3.537416 48.303283 90.000000,-3.537259 48.303546 89.900000,-3.537128 48.303744 90.100000,-3.537003 48.303911 90.000000,-3.536971 48.303950 90.000000,-3.536873 48.304078 90.000000,-3.536710 48.304269 90.000000,-3.536551 48.304443 90.000000,-3.536407 48.304591 90.000000,-3.536205 48.304784 90.000000,-3.536009 48.304959 90.000000,-3.535838 48.305117 90.000000,-3.535648 48.305296 90.100000,-3.535485 48.305447 90.100000,-3.535334 48.305583 90.100000,-3.535215 48.305686 90.100000,-3.535101 48.305780 90.200000,-3.534983 48.305863 90.200000,-3.534860 48.305941 90.200000,-3.534730 48.306019 90.200000,-3.534581 48.306102 90.300000,-3.534435 48.306181 90.200000,-3.534242 48.306281 89.600000,-3.534056 48.306379 89.499999,-3.533871 48.306483 89.300000,-3.533733 48.306555 89.200000,-3.533607 48.306638 89.400000,-3.533480 48.306732 89.600000,-3.533366 48.306823 89.800000,-3.533261 48.306914 90.000000,-3.533158 48.307007 89.900000,-3.533030 48.307134 90.000000,-3.532823 48.307340 89.700000,-3.532621 48.307545 89.700000,-3.532616 48.307551 89.800000,-3.532311 48.307870 89.800000,-3.532035 48.308154 89.800000,-3.531737 48.308451 90.100000,-3.531416 48.308772 89.600000,-3.531133 48.309056 89.600000,-3.530759 48.309437 89.300000,-3.530412 48.309798 89.400000,-3.529981 48.310259 88.300000,-3.529687 48.310630 88.300000,-3.529479 48.310932 88.700000,-3.529273 48.311281 88.700000,-3.529116 48.311601 89.499999,-3.529009 48.311860 89.499999,-3.528907 48.312151 89.499999,-3.528734 48.312664 89.499999,-3.528614 48.313033 89.499999,-3.528610 48.313042 89.499999,-3.528402 48.313686 89.900000,-3.528331 48.313934 91.000000,-3.528252 48.314136 91.000000,-3.528142 48.314363 91.000000,-3.527991 48.314610 91.499999,-3.527782 48.314857 91.400000,-3.527547 48.315081 91.600000,-3.527291 48.315276 91.900000,-3.526910 48.315527 90.400000,-3.526264 48.315904 90.400000,-3.526063 48.316017 90.000000,-3.525553 48.316310 90.000000,-3.525273 48.316439 89.600000,-3.524937 48.316558 89.600000,-3.524532 48.316649 89.800000,-3.524137 48.316714 89.800000,-3.523614 48.316780 89.300000,-3.523209 48.316835 90.900000,-3.522720 48.316900 90.300000,-3.522300 48.316959 90.700000,-3.521705 48.317062 90.900000,-3.520782 48.317243 89.900000,-3.520180 48.317362 91.100000,-3.519586 48.317484 89.700000,-3.519369 48.317522 90.900000,-3.518993 48.317588 90.900000,-3.518673 48.317634 90.900000,-3.517942 48.317703 90.400000,-3.517468 48.317739 90.400000,-3.517022 48.317774 90.200000,-3.516195 48.317840 90.000000,-3.515727 48.317878 91.000000,-3.514764 48.317962 90.499999,-3.514454 48.317988 90.499999,-3.514256 48.318017 90.499999,-3.514226 48.318021 90.400000,-3.513953 48.318071 89.900000,-3.513684 48.318138 90.900000,-3.513201 48.318268 90.900000,-3.512777 48.318408 90.200000,-3.512463 48.318544 91.300000,-3.512262 48.318640 92.300000,-3.511816 48.318881 92.300000,-3.511513 48.319069 92.300000,-3.511277 48.319238 92.300000,-3.511065 48.319386 92.300000,-3.510880 48.319543 92.300000,-3.510720 48.319673 93.100000,-3.510533 48.319847 94.300000,-3.510417 48.319968 94.300000,-3.510210 48.320203 94.300000,-3.510091 48.320348 93.300000,-3.510023 48.320424 93.300000,-3.509986 48.320465 93.300000,-3.509376 48.321190 94.200000,-3.509209 48.321335 94.200000,-3.508961 48.321536 94.300000,-3.508735 48.321699 94.300000,-3.508496 48.321876 94.600000,-3.508123 48.322150 94.600000,-3.507578 48.322550 94.900000,-3.507288 48.322758 94.200000,-3.506898 48.323038 94.200000,-3.506710 48.323187 94.200000,-3.506403 48.323461 94.200000,-3.506345 48.323519 93.900000,-3.506222 48.323640 93.900000,-3.506063 48.323824 93.900000,-3.505658 48.324281 94.499999,-3.505070 48.324956 95.100000,-3.504839 48.325218 95.000000,-3.504694 48.325409 94.000000,-3.504592 48.325578 93.200000,-3.504512 48.325738 93.200000,-3.504481 48.325852 93.200000,-3.504459 48.325934 93.200000,-3.504440 48.326050 93.200000,-3.504436 48.326122 93.499999,-3.504431 48.326194 94.000000,-3.504451 48.326478 94.600000,-3.504466 48.326653 93.900000,-3.504495 48.327017 93.600000,-3.504494 48.327361 93.600000,-3.504486 48.327489 93.600000,-3.504475 48.327578 93.600000,-3.504422 48.327755 93.600000,-3.504319 48.327997 94.600000,-3.504153 48.328333 94.600000,-3.503886 48.328831 95.300000,-3.503753 48.329058 95.300000,-3.503627 48.329302 95.300000,-3.503475 48.329617 95.200000,-3.503383 48.329857 95.200000,-3.503265 48.330253 95.200000,-3.503140 48.330653 95.300000,-3.502805 48.331588 94.400000,-3.502612 48.332112 94.400000,-3.502240 48.333087 95.100000,-3.502119 48.333373 95.700000,-3.501936 48.333691 95.300000,-3.501734 48.334004 95.100000,-3.501539 48.334306 95.300000,-3.501432 48.334467 95.300000,-3.501098 48.334974 95.800000,-3.500874 48.335280 96.200000,-3.500598 48.335584 96.499999,-3.500268 48.335907 96.800000,-3.499786 48.336275 96.800000,-3.499294 48.336593 96.800000,-3.498873 48.336835 97.100000,-3.498095 48.337262 98.000000,-3.497661 48.337504 97.700000,-3.497241 48.337704 98.200000,-3.497017 48.337796 98.700000,-3.496788 48.337864 97.900000,-3.496563 48.337917 98.600000,-3.496276 48.337964 98.600000,-3.496048 48.337996 98.600000,-3.495687 48.338017 98.600000,-3.495233 48.338044 98.700000,-3.494808 48.338079 98.900000))'));
