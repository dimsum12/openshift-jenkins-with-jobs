SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- Troncon de cours d'eau. Portion de cours d'eau qui n'inclut pas de confluent
--
create table TRONCON_COURS_EAU (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, ARTIF varchar(3) not null, FICTIF varchar(3) not null, FRANCHISST varchar(10) not null, NOM varchar(70) default 'NR', POS_SOL integer not null, REGIME varchar(12) not null, Z_INI float, Z_FIN float, constraint TRONCON_COURS_EAU_pkey primary key (gid));
select AddGeometryColumn('','troncon_cours_eau','the_geom','210642000','LINESTRING',3);
create index TRONCON_COURS_EAU_geoidx on TRONCON_COURS_EAU using gist (the_geom gist_geometry_ops);
--
commit;
--
-- TRONCON_COURS_EAU
start transaction;
insert into TRONCON_COURS_EAU values ('1','TRON_EAU0000000069992540','   2.5','    2.5','Oui','Non','Pont-canal',DEFAULT,1,'Permanent','376.800000','375.900000', GeomFromEWKT('SRID=210642000;LINESTRING(-61.101492 14.763165 376.800000,-61.101561 14.763189 376.300000,-61.101573 14.763193 376.200000,-61.101632 14.763216 375.900000)'));
insert into TRONCON_COURS_EAU values ('2','TRON_EAU0000000070000105','   2.5','    2.5','Oui','Non','Tunnel',DEFAULT,-1,'Permanent','1.400000','1.000000', GeomFromEWKT('SRID=210642000;LINESTRING(-61.000695 14.597700 1.400000,-61.001051 14.597638 1.200000,-61.001469 14.597574 1.000000)'));
insert into TRONCON_COURS_EAU values ('3','TRON_EAU0000000069996610','   2.5','    2.5','Oui','Non','Tunnel',DEFAULT,-1,'Permanent','24.900000','28.900000', GeomFromEWKT('SRID=210642000;LINESTRING(-61.178225 14.708543 24.900000,-61.178231 14.708492 25.000000,-61.178244 14.708391 25.300000,-61.178269 14.708197 25.800000,-61.178273 14.708009 26.300000,-61.178276 14.707772 27.000000,-61.178277 14.707738 27.000000,-61.178253 14.707367 28.100000,-61.178246 14.707298 28.200000,-61.178254 14.707226 28.400000,-61.178282 14.707168 28.600000,-61.178339 14.707078 28.900000)'));
insert into TRONCON_COURS_EAU values ('5','TRON_EAU0000000070003536','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','0.800000','0.100000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.866187 14.400640 0.800000,-60.866026 14.400395 0.300000,-60.865939 14.400266 0.100000,-60.865329 14.399220 0.000000,-60.864534 14.397828 0.000000,-60.864347 14.397435 0.000000,-60.864268 14.397302 0.000000,-60.864112 14.397164 0.000000,-60.863835 14.396971 0.000000,-60.863724 14.396902 0.000000,-60.863707 14.396848 0.000000,-60.863758 14.396682 0.100000)'));
insert into TRONCON_COURS_EAU values ('6','TRON_EAU0000000070003533','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','0.000000','0.000000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.884969 14.410213 0.000000,-60.885133 14.410359 0.000000,-60.885484 14.410530 0.000000,-60.885639 14.410638 0.000000)'));
insert into TRONCON_COURS_EAU values ('7','TRON_EAU0000000070003525','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','2.200000','1.300000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.878006 14.417272 2.200000,-60.878070 14.417241 1.300000)'));
insert into TRONCON_COURS_EAU values ('8','TRON_EAU0000000070003522','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','1.300000','2.200000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.878070 14.417241 1.300000,-60.878235 14.417126 0.500000,-60.878491 14.417026 0.500000,-60.878722 14.416934 0.500000,-60.878832 14.416885 2.200000)'));
insert into TRONCON_COURS_EAU values ('9','TRON_EAU0000000070003503','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','4.300000','4.300000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.864814 14.410114 4.300000,-60.864993 14.409954 4.200000,-60.865053 14.409854 2.900000,-60.865079 14.409756 1.900000,-60.865095 14.409573 1.700000,-60.865105 14.409368 1.600000,-60.865152 14.409109 1.000000,-60.865181 14.408890 1.000000,-60.865207 14.408675 1.000000,-60.865257 14.408377 0.900000,-60.865293 14.408245 0.900000,-60.865440 14.408030 3.200000,-60.865498 14.407980 3.200000,-60.865543 14.407938 4.300000)'));
insert into TRONCON_COURS_EAU values ('10','TRON_EAU0000000070003495','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','12.600000','1.900000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.857546 14.419054 12.600000,-60.857482 14.419029 12.600000,-60.857435 14.418987 12.600000,-60.857410 14.418966 12.600000,-60.857380 14.418867 12.600000,-60.857369 14.418462 10.400000,-60.857308 14.418070 8.200000,-60.857239 14.417885 7.600000,-60.857144 14.417656 6.900000,-60.857011 14.417525 6.300000,-60.856779 14.417281 6.100000,-60.856539 14.416991 5.500000,-60.856395 14.416866 5.500000,-60.856224 14.416690 4.600000,-60.855979 14.416468 4.300000,-60.855740 14.416248 3.600000,-60.855546 14.416042 3.200000,-60.855446 14.415920 3.000000,-60.855373 14.415825 2.700000,-60.855341 14.415743 2.600000,-60.855341 14.415685 2.600000,-60.855373 14.415586 1.900000)'));
insert into TRONCON_COURS_EAU values ('11','TRON_EAU0000000070003494','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','24.800000','0.000000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.887050 14.419317 24.800000,-60.887161 14.419395 24.800000,-60.887326 14.419476 22.000000,-60.887492 14.419516 22.000000,-60.887655 14.419535 22.000000,-60.887763 14.419573 22.000000,-60.887862 14.419650 19.900000,-60.887975 14.419687 19.600000,-60.888114 14.419725 19.600000,-60.888313 14.419785 18.200000,-60.888450 14.419835 17.300000,-60.888631 14.419898 15.400000,-60.888759 14.419960 15.400000,-60.888900 14.420020 14.000000,-60.889058 14.420083 11.400000,-60.889243 14.420160 11.400000,-60.889352 14.420238 11.400000,-60.889449 14.420351 11.400000,-60.889522 14.420471 11.400000,-60.889607 14.420600 9.200000,-60.889681 14.420745 7.100000,-60.889702 14.420826 6.900000,-60.889773 14.421001 6.900000,-60.889836 14.421084 5.500000,-60.889904 14.421172 5.400000,-60.890010 14.421339 4.100000,-60.890075 14.421466 3.000000,-60.890126 14.421524 3.000000,-60.890215 14.421579 3.000000,-60.890317 14.421684 3.000000,-60.890393 14.421770 1.400000,-60.890470 14.421841 1.400000,-60.890524 14.421917 0.700000,-60.890532 14.421933 0.000000)'));
insert into TRONCON_COURS_EAU values ('12','TRON_EAU0000000070003492','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','24.700000','6.700000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.886042 14.420122 24.700000,-60.886028 14.420120 24.300000,-60.886145 14.420252 24.300000,-60.886268 14.420362 22.900000,-60.886405 14.420434 22.700000,-60.886401 14.420443 22.700000,-60.886405 14.420446 22.700000,-60.886541 14.420513 21.100000,-60.886708 14.420572 21.100000,-60.886843 14.420628 20.100000,-60.886978 14.420694 19.100000,-60.887119 14.420772 17.300000,-60.887243 14.420842 17.300000,-60.887344 14.420917 16.500000,-60.887427 14.421031 16.200000,-60.887514 14.421176 14.500000,-60.887580 14.421273 14.500000,-60.887702 14.421513 12.600000,-60.887769 14.421691 11.100000,-60.887842 14.421851 11.100000,-60.887896 14.422021 10.000000,-60.887940 14.422218 9.800000,-60.887980 14.422371 7.900000,-60.888003 14.422480 7.000000,-60.888019 14.422542 6.700000)'));
insert into TRONCON_COURS_EAU values ('13','TRON_EAU0000000070003491','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','6.700000','0.000000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.888019 14.422542 6.700000,-60.888042 14.422545 6.700000,-60.888135 14.422573 6.600000,-60.888265 14.422611 6.600000,-60.888424 14.422658 6.200000,-60.888561 14.422714 4.900000,-60.888692 14.422756 4.800000,-60.888775 14.422802 4.600000,-60.888859 14.422887 3.800000,-60.888935 14.422960 3.800000,-60.889022 14.423048 3.200000,-60.889129 14.423117 2.100000,-60.889241 14.423156 1.700000,-60.889313 14.423173 1.700000,-60.889394 14.423210 1.000000,-60.889495 14.423266 0.500000,-60.889556 14.423306 0.000000,-60.889644 14.423348 0.000000)'));
insert into TRONCON_COURS_EAU values ('14','TRON_EAU0000000070003490','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','21.000000','6.700000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.885918 14.422790 21.000000,-60.885952 14.422711 21.000000,-60.886015 14.422631 19.400000,-60.886112 14.422551 14.600000,-60.886208 14.422502 14.300000,-60.886316 14.422453 14.200000,-60.886452 14.422403 14.100000,-60.886557 14.422390 14.100000,-60.886642 14.422389 14.600000,-60.886769 14.422384 14.600000,-60.886918 14.422379 13.100000,-60.887057 14.422392 13.100000,-60.887171 14.422424 10.900000,-60.887282 14.422450 10.900000,-60.887431 14.422476 10.900000,-60.887590 14.422507 9.600000,-60.887734 14.422524 9.000000,-60.887937 14.422536 6.700000,-60.888019 14.422542 6.700000)'));
insert into TRONCON_COURS_EAU values ('15','TRON_EAU0000000070003482','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','13.100000','12.400000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.868065 14.418400 13.100000,-60.868141 14.418359 12.400000)'));
insert into TRONCON_COURS_EAU values ('16','TRON_EAU0000000070003481','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','13.600000','13.100000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.867327 14.419210 13.600000,-60.867464 14.419186 13.600000,-60.867576 14.419148 13.600000,-60.867673 14.419075 13.600000,-60.867739 14.419003 13.600000,-60.867907 14.418766 13.600000,-60.868023 14.418630 13.600000,-60.868058 14.418560 13.600000,-60.868065 14.418400 13.100000)'));
insert into TRONCON_COURS_EAU values ('17','TRON_EAU0000000070003479','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','19.400000','13.100000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.866056 14.419040 19.400000,-60.866247 14.418900 19.400000,-60.866399 14.418821 19.300000,-60.866529 14.418756 18.800000,-60.866669 14.418700 17.200000,-60.866739 14.418690 16.000000,-60.867033 14.418661 15.700000,-60.867589 14.418573 14.900000,-60.867864 14.418512 14.800000,-60.868065 14.418400 13.100000)'));
insert into TRONCON_COURS_EAU values ('18','TRON_EAU0000000070003462','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','18.200000','17.700000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.865825 14.427498 18.200000,-60.865247 14.427554 17.700000)'));
insert into TRONCON_COURS_EAU values ('19','TRON_EAU0000000070003421','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','0.400000','0.500000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.878879 14.438967 0.400000,-60.879106 14.438947 0.500000)'));
insert into TRONCON_COURS_EAU values ('20','TRON_EAU0000000070003398','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','10.000000','1.300000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.868316 14.437093 10.000000,-60.868429 14.437124 9.600000,-60.868536 14.437142 8.700000,-60.868585 14.437137 8.500000,-60.868715 14.437080 8.300000,-60.868950 14.436900 6.700000,-60.869161 14.436719 5.500000,-60.869279 14.436647 5.100000,-60.869629 14.436506 4.300000,-60.869836 14.436390 3.400000,-60.870163 14.436240 3.100000,-60.870483 14.436013 2.600000,-60.870654 14.435872 2.100000,-60.870813 14.435764 1.900000,-60.870969 14.435681 1.500000,-60.871043 14.435646 1.500000,-60.871111 14.435586 1.400000,-60.871179 14.435519 1.300000,-60.871193 14.435500 1.300000)'));
insert into TRONCON_COURS_EAU values ('21','TRON_EAU0000000070003396','   1.5','    1.0','Oui','Oui','Barrage',DEFAULT,0,'Intermittent','12.100000','10.000000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.868193 14.437083 12.100000,-60.868230 14.437085 11.400000,-60.868316 14.437093 10.000000)'));
insert into TRONCON_COURS_EAU values ('22','TRON_EAU0000000070003395','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','18.300000','12.200000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.867294 14.437133 18.300000,-60.867370 14.437184 17.200000,-60.867446 14.437202 16.100000,-60.867521 14.437210 15.000000,-60.867627 14.437180 14.000000,-60.867742 14.437143 13.300000,-60.867928 14.437106 12.200000)'));
insert into TRONCON_COURS_EAU values ('23','TRON_EAU0000000070003389','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','34.200000','18.300000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.866729 14.436607 34.200000,-60.866750 14.436734 32.300000,-60.866784 14.436808 30.900000,-60.866857 14.436859 29.400000,-60.867000 14.436917 25.900000,-60.867102 14.436973 23.500000,-60.867196 14.437044 21.000000,-60.867294 14.437133 18.300000)'));
insert into TRONCON_COURS_EAU values ('24','TRON_EAU0000000070003387','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','32.600000','18.300000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.866311 14.437220 32.600000,-60.866420 14.437250 31.100000,-60.866465 14.437282 30.000000,-60.866535 14.437379 28.700000,-60.866594 14.437430 27.300000,-60.866677 14.437465 25.300000,-60.866773 14.437496 24.400000,-60.866865 14.437501 23.300000,-60.866962 14.437470 22.500000,-60.867066 14.437383 21.600000,-60.867162 14.437278 20.000000,-60.867219 14.437214 19.300000,-60.867294 14.437133 18.300000)'));
insert into TRONCON_COURS_EAU values ('25','TRON_EAU0000000070003383','   1.5','    1.0','Oui','Oui','Barrage',DEFAULT,0,'Intermittent','13.200000','9.600000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.864484 14.443659 13.200000,-60.864478 14.443683 11.800000,-60.864467 14.443724 9.600000)'));
insert into TRONCON_COURS_EAU values ('26','TRON_EAU0000000070003343','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','104.200000','69.100000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.847325 14.443950 104.200000,-60.847443 14.443947 98.500000,-60.847588 14.443922 91.300000,-60.847714 14.443911 88.700000,-60.847814 14.443908 84.600000,-60.847936 14.443926 80.000000,-60.848076 14.443967 74.600000,-60.848143 14.443978 72.600000,-60.848242 14.443979 71.400000,-60.848334 14.443939 69.100000)'));
insert into TRONCON_COURS_EAU values ('27','TRON_EAU0000000070003332','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','83.100000','74.200000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.841188 14.447077 83.100000,-60.841068 14.446934 80.300000,-60.840978 14.446807 78.600000,-60.840933 14.446776 78.000000,-60.840892 14.446723 77.400000,-60.840880 14.446683 77.100000,-60.840830 14.446635 75.800000,-60.840796 14.446598 75.500000,-60.840712 14.446467 74.200000)'));
insert into TRONCON_COURS_EAU values ('28','TRON_EAU0000000070003325','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','33.600000','22.600000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.831154 14.444295 33.600000,-60.831086 14.444378 31.200000,-60.831013 14.444472 29.100000,-60.830931 14.444557 26.200000,-60.830840 14.444613 24.000000,-60.830693 14.444700 22.700000,-60.830534 14.444798 22.600000)'));
insert into TRONCON_COURS_EAU values ('29','TRON_EAU0000000070003322','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','80.000000','33.600000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.832716 14.444480 80.000000,-60.832543 14.444486 75.000000,-60.832420 14.444483 72.200000,-60.832293 14.444472 66.000000,-60.832105 14.444434 60.200000,-60.831960 14.444385 55.400000,-60.831832 14.444332 51.000000,-60.831693 14.444294 46.000000,-60.831529 14.444279 40.300000,-60.831420 14.444280 36.500000,-60.831260 14.444279 34.100000,-60.831154 14.444295 33.600000)'));
insert into TRONCON_COURS_EAU values ('30','TRON_EAU0000000070003316','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','0.600000','1.400000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.828273 14.439557 0.600000,-60.828180 14.439508 0.500000,-60.828117 14.439456 0.500000,-60.827931 14.439192 1.400000)'));
insert into TRONCON_COURS_EAU values ('31','TRON_EAU0000000070003314','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','1.400000','1.400000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.827488 14.439052 1.400000,-60.827306 14.439080 1.400000,-60.827220 14.439083 1.400000,-60.827070 14.439087 1.400000,-60.826980 14.439092 1.400000,-60.826884 14.439115 1.400000)'));
insert into TRONCON_COURS_EAU values ('32','TRON_EAU0000000070003261','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','85.600000','52.900000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.842413 14.448476 85.600000,-60.842388 14.448678 80.200000,-60.842404 14.448784 76.800000,-60.842468 14.448930 73.300000,-60.842652 14.449101 69.400000,-60.842780 14.449230 67.200000,-60.842852 14.449374 66.000000,-60.842933 14.449708 61.900000,-60.842998 14.450060 58.000000,-60.843096 14.450516 52.900000)'));
insert into TRONCON_COURS_EAU values ('33','TRON_EAU0000000070003254','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','34.900000','31.400000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.843171 14.464549 34.900000,-60.843177 14.464336 34.700000,-60.843189 14.464135 34.400000,-60.843201 14.463936 33.600000,-60.843208 14.463747 33.400000,-60.843194 14.463461 33.200000,-60.843190 14.463176 33.100000,-60.843221 14.462948 32.900000,-60.843271 14.462818 32.900000,-60.843303 14.462715 32.900000,-60.843292 14.462645 32.800000,-60.843265 14.462623 32.800000,-60.843189 14.462592 32.800000,-60.843038 14.462571 32.800000,-60.842890 14.462545 32.900000,-60.842725 14.462493 32.900000,-60.842630 14.462414 32.900000,-60.842588 14.462311 32.900000,-60.842591 14.462201 32.900000,-60.842668 14.462109 32.900000,-60.842723 14.462064 32.900000,-60.842747 14.462023 32.900000,-60.842750 14.461960 32.900000,-60.842721 14.461888 32.900000,-60.842688 14.461831 32.600000,-60.842667 14.461766 32.500000,-60.842648 14.461678 32.500000,-60.842606 14.461608 32.500000,-60.842486 14.461498 31.400000)'));
insert into TRONCON_COURS_EAU values ('34','TRON_EAU0000000070003239','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Permanent','0.600000','0.000000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.824302 14.451794 0.600000,-60.824277 14.451780 0.500000,-60.824035 14.451625 0.000000)'));
insert into TRONCON_COURS_EAU values ('35','TRON_EAU0000000070003230','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','44.800000','11.300000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.823124 14.463121 44.800000,-60.822949 14.463036 40.100000,-60.822846 14.462994 37.600000,-60.822745 14.462976 34.900000,-60.822692 14.462956 33.900000,-60.822643 14.462920 33.000000,-60.822526 14.462884 31.300000,-60.822381 14.462858 28.800000,-60.822167 14.462838 25.200000,-60.821899 14.462808 21.600000,-60.821729 14.462787 20.500000,-60.821589 14.462748 19.200000,-60.821502 14.462686 18.200000,-60.821392 14.462575 17.600000,-60.821317 14.462511 17.000000,-60.821197 14.462459 16.700000,-60.821059 14.462459 16.600000,-60.820980 14.462479 15.500000,-60.820795 14.462511 15.300000,-60.820628 14.462535 14.100000,-60.820519 14.462541 13.700000,-60.820474 14.462509 13.300000,-60.820412 14.462429 12.400000,-60.820380 14.462338 12.200000,-60.820357 14.462239 11.900000,-60.820302 14.462182 11.300000)'));
insert into TRONCON_COURS_EAU values ('36','TRON_EAU0000000070003227','   1.5','    1.0','Non','Non','NC',DEFAULT,0,'Intermittent','11.200000','0.800000', GeomFromEWKT('SRID=210642000;LINESTRING(-60.820175 14.462025 11.200000,-60.820094 14.461897 9.600000,-60.819918 14.461682 8.800000,-60.819763 14.461464 6.400000,-60.819620 14.461246 5.400000,-60.819481 14.461076 4.300000,-60.819417 14.460988 3.500000,-60.819303 14.460895 3.000000,-60.819284 14.460880 3.000000,-60.819160 14.460819 1.700000,-60.818863 14.460657 0.500000,-60.818434 14.460423 0.600000,-60.818089 14.460225 0.600000,-60.817880 14.460063 0.600000,-60.817629 14.459790 0.800000)'));