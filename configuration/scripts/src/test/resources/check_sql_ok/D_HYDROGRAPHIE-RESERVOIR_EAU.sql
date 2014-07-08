SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- R�servoir (eau, mati�res industrielles,)
--
create table RESERVOIR_EAU (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, NATURE varchar(15) not null, HAUTEUR integer not null, Z_MIN float, Z_MAX float, constraint RESERVOIR_EAU_pkey primary key (gid));
select AddGeometryColumn('','reservoir_eau','the_geom','210642000','MULTIPOLYGON',3);
create index RESERVOIR_EAU_geoidx on RESERVOIR_EAU using gist (the_geom gist_geometry_ops);
--
commit;
--
-- RESERVOIR_EAU
start transaction;
insert into RESERVOIR_EAU values ('1','RESERVOI0000000070010560','   1.5','    1.0','R�servoir d\'eau','9','60.200000','60.200000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.074573 14.493092 60.200000,-61.074600 14.493104 60.200000,-61.074637 14.493105 60.200000,-61.074660 14.493092 60.200000,-61.074671 14.493073 60.200000,-61.074673 14.493051 60.200000,-61.074661 14.493021 60.200000,-61.074644 14.493004 60.200000,-61.074613 14.492995 60.200000,-61.074585 14.493003 60.200000,-61.074565 14.493019 60.200000,-61.074559 14.493035 60.200000,-61.074560 14.493064 60.200000,-61.074573 14.493092 60.200000)))'));
insert into RESERVOIR_EAU values ('2','RESERVOI0000000070010546','   1.5','    1.0','R�servoir d\'eau','3','20.800000','20.800000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.847177 14.504784 20.800000,-60.847080 14.504710 20.800000,-60.847034 14.504773 20.800000,-60.847135 14.504840 20.800000,-60.847177 14.504784 20.800000)))'));
insert into RESERVOIR_EAU values ('3','RESERVOI0000000070010542','   1.5','    1.0','R�servoir d\'eau','2','120.200000','120.200000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.892449 14.509263 120.200000,-60.892385 14.509270 120.200000,-60.892353 14.509289 120.200000,-60.892339 14.509331 120.200000,-60.892347 14.509376 120.200000,-60.892376 14.509419 120.200000,-60.892427 14.509427 120.200000,-60.892479 14.509407 120.200000,-60.892517 14.509357 120.200000,-60.892510 14.509293 120.200000,-60.892479 14.509268 120.200000,-60.892449 14.509263 120.200000)))'));
insert into RESERVOIR_EAU values ('4','RESERVOI0000000070010539','   1.5','    1.0','R�servoir d\'eau','9','75.100000','77.800000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.844549 14.511354 77.800000,-60.844578 14.511366 77.800000,-60.844601 14.511367 77.800000,-60.844631 14.511354 77.800000,-60.844644 14.511339 77.800000,-60.844651 14.511306 77.800000,-60.844646 14.511276 77.800000,-60.844619 14.511256 77.800000,-60.844608 14.511252 77.800000,-60.844584 14.511249 77.800000,-60.844562 14.511253 77.800000,-60.844537 14.511268 77.800000,-60.844525 14.511292 77.800000,-60.844480 14.511316 75.100000,-60.844490 14.511356 75.100000,-60.844537 14.511345 77.700000,-60.844549 14.511354 77.800000)))'));
insert into RESERVOIR_EAU values ('5','RESERVOI0000000070010531','   1.5','    1.0','R�servoir d\'eau','6','90.300000','90.300000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.884804 14.524387 90.300000,-60.884828 14.524382 90.300000,-60.884846 14.524366 90.300000,-60.884853 14.524348 90.300000,-60.884857 14.524330 90.300000,-60.884850 14.524310 90.300000,-60.884844 14.524298 90.300000,-60.884833 14.524287 90.300000,-60.884820 14.524278 90.300000,-60.884802 14.524273 90.300000,-60.884784 14.524274 90.300000,-60.884769 14.524280 90.300000,-60.884752 14.524297 90.300000,-60.884743 14.524323 90.300000,-60.884744 14.524347 90.300000,-60.884751 14.524367 90.300000,-60.884764 14.524381 90.300000,-60.884784 14.524390 90.300000,-60.884804 14.524387 90.300000)))'));
insert into RESERVOIR_EAU values ('6','RESERVOI0000000070010529','   1.5','    1.0','R�servoir d\'eau','8','148.400000','151.400000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.053839 14.529481 148.400000,-61.053810 14.529431 150.200000,-61.053820 14.529411 150.200000,-61.053824 14.529386 150.200000,-61.053824 14.529361 150.200000,-61.053813 14.529331 150.200000,-61.053795 14.529315 150.200000,-61.053765 14.529305 150.200000,-61.053732 14.529303 150.200000,-61.053708 14.529313 150.200000,-61.053690 14.529326 150.600000,-61.053674 14.529344 151.000000,-61.053665 14.529366 151.200000,-61.053664 14.529391 151.400000,-61.053665 14.529415 151.400000,-61.053683 14.529433 151.400000,-61.053701 14.529450 151.100000,-61.053722 14.529462 150.900000,-61.053752 14.529462 149.700000,-61.053785 14.529510 148.500000,-61.053839 14.529481 148.400000)))'));
insert into RESERVOIR_EAU values ('7','RESERVOI0000000070010477','   1.5','    1.0','R�servoir d\'eau','9','195.500000','198.400000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.889058 14.594166 195.800000,-60.889105 14.594165 195.500000,-60.889106 14.594128 198.000000,-60.889128 14.594120 198.000000,-60.889141 14.594106 198.000000,-60.889148 14.594084 198.000000,-60.889148 14.594061 198.000000,-60.889136 14.594040 198.000000,-60.889118 14.594027 198.000000,-60.889094 14.594020 198.000000,-60.889075 14.594022 198.000000,-60.889054 14.594031 198.400000,-60.889045 14.594040 198.400000,-60.889039 14.594055 198.400000,-60.889042 14.594079 198.400000,-60.889045 14.594099 198.400000,-60.889058 14.594117 197.300000,-60.889058 14.594166 195.800000)))'));
insert into RESERVOIR_EAU values ('8','RESERVOI0000000070010449','   1.5','    1.0','R�servoir d\'eau','6','59.200000','59.600000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.968999 14.607943 59.200000,-60.969046 14.607950 59.600000,-60.969052 14.607969 59.600000,-60.969062 14.607983 59.600000,-60.969079 14.607990 59.600000,-60.969101 14.607994 59.600000,-60.969124 14.607990 59.600000,-60.969138 14.607979 59.600000,-60.969151 14.607958 59.600000,-60.969150 14.607924 59.600000,-60.969139 14.607907 59.600000,-60.969122 14.607893 59.600000,-60.969097 14.607889 59.600000,-60.969083 14.607894 59.600000,-60.969063 14.607903 59.600000,-60.969053 14.607919 59.600000,-60.969003 14.607918 59.600000,-60.968999 14.607943 59.200000)))'));
insert into RESERVOIR_EAU values ('9','RESERVOI0000000070010445','   1.5','    1.0','R�servoir d\'eau','4','73.000000','73.000000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.077071 14.611897 73.000000,-61.077057 14.611877 73.000000,-61.077040 14.611866 73.000000,-61.077017 14.611863 73.000000,-61.076989 14.611862 73.000000,-61.076969 14.611884 73.000000,-61.076954 14.611917 73.000000,-61.076956 14.611940 73.000000,-61.076980 14.611969 73.000000,-61.077012 14.611981 73.000000,-61.077045 14.611974 73.000000,-61.077069 14.611956 73.000000,-61.077078 14.611926 73.000000,-61.077071 14.611897 73.000000)))'));
insert into RESERVOIR_EAU values ('10','RESERVOI0000000070010444','   1.5','    1.0','R�servoir d\'eau','5','73.000000','73.000000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.077167 14.611775 73.000000,-61.077148 14.611763 73.000000,-61.077128 14.611756 73.000000,-61.077100 14.611756 73.000000,-61.077072 14.611770 73.000000,-61.077059 14.611801 73.000000,-61.077067 14.611831 73.000000,-61.077086 14.611866 73.000000,-61.077123 14.611877 73.000000,-61.077151 14.611876 73.000000,-61.077173 14.611854 73.000000,-61.077182 14.611828 73.000000,-61.077180 14.611800 73.000000,-61.077167 14.611775 73.000000)))'));
insert into RESERVOIR_EAU values ('11','RESERVOI0000000070010394','   1.5','    1.0','R�servoir d\'eau','13','342.200000','344.200000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.948101 14.618381 344.200000,-60.948133 14.618370 342.200000,-60.948119 14.618338 342.200000,-60.948095 14.618344 344.200000,-60.948078 14.618333 344.200000,-60.948053 14.618327 344.200000,-60.948032 14.618332 344.200000,-60.948014 14.618342 344.200000,-60.948000 14.618357 344.200000,-60.947990 14.618375 344.200000,-60.947992 14.618402 344.200000,-60.948003 14.618420 344.200000,-60.948026 14.618431 344.200000,-60.948048 14.618432 344.200000,-60.948077 14.618424 344.200000,-60.948095 14.618404 344.200000,-60.948101 14.618381 344.200000)))'));
insert into RESERVOIR_EAU values ('12','RESERVOI0000000070010390','   1.5','    1.0','R�servoir d\'eau','4','72.900000','72.900000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.108528 14.625844 72.900000,-61.108563 14.625831 72.900000,-61.108579 14.625815 72.900000,-61.108588 14.625802 72.900000,-61.108587 14.625775 72.900000,-61.108579 14.625759 72.900000,-61.108557 14.625738 72.900000,-61.108534 14.625726 72.900000,-61.108510 14.625728 72.900000,-61.108486 14.625740 72.900000,-61.108466 14.625774 72.900000,-61.108466 14.625795 72.900000,-61.108475 14.625815 72.900000,-61.108487 14.625831 72.900000,-61.108505 14.625840 72.900000,-61.108528 14.625844 72.900000)))'));
insert into RESERVOIR_EAU values ('13','RESERVOI0000000070010356','   1.5','    1.0','R�servoir d\'eau','11','130.300000','130.800000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.967536 14.637207 130.800000,-60.967538 14.637183 130.800000,-60.967523 14.637164 130.800000,-60.967501 14.637159 130.700000,-60.967477 14.637165 130.500000,-60.967466 14.637184 130.400000,-60.967475 14.637207 130.400000,-60.967494 14.637223 130.300000,-60.967515 14.637227 130.400000,-60.967536 14.637207 130.800000)))'));
insert into RESERVOIR_EAU values ('14','RESERVOI0000000070010337','   1.5','    1.0','R�servoir d\'eau','3','276.700000','276.800000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.117260 14.649572 276.700000,-61.117283 14.649547 276.700000,-61.117236 14.649506 276.700000,-61.117211 14.649530 276.800000,-61.117260 14.649572 276.700000)))'));
insert into RESERVOIR_EAU values ('15','RESERVOI0000000070010308','   1.5','    1.0','R�servoir d\'eau','4','200.000000','203.200000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.148904 14.667529 200.000000,-61.148918 14.667466 200.000000,-61.148858 14.667448 203.200000,-61.148846 14.667424 203.200000,-61.148819 14.667407 203.200000,-61.148777 14.667412 203.200000,-61.148748 14.667432 203.200000,-61.148736 14.667463 203.200000,-61.148748 14.667501 203.200000,-61.148770 14.667524 203.200000,-61.148816 14.667535 203.200000,-61.148842 14.667523 203.200000,-61.148857 14.667507 203.200000,-61.148904 14.667529 200.000000)))'));
insert into RESERVOIR_EAU values ('16','RESERVOI0000000070010285','   1.5','    1.0','R�servoir d\'eau','3','197.600000','197.800000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.978979 14.676342 197.800000,-60.978961 14.676354 197.800000,-60.978955 14.676380 197.800000,-60.978957 14.676410 197.800000,-60.978978 14.676428 197.800000,-60.979002 14.676431 197.800000,-60.979032 14.676415 197.800000,-60.979036 14.676386 197.800000,-60.979028 14.676365 197.800000,-60.979011 14.676351 197.600000,-60.978979 14.676342 197.800000)))'));
insert into RESERVOIR_EAU values ('17','RESERVOI0000000070010282','   1.5','    1.0','R�servoir d\'eau','5','172.400000','174.200000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.018335 14.680351 174.200000,-61.018353 14.680358 174.200000,-61.018380 14.680356 174.200000,-61.018405 14.680347 174.200000,-61.018415 14.680338 174.200000,-61.018427 14.680319 174.200000,-61.018430 14.680296 174.200000,-61.018428 14.680270 174.200000,-61.018412 14.680248 174.200000,-61.018394 14.680238 174.200000,-61.018360 14.680232 174.200000,-61.018339 14.680241 174.200000,-61.018314 14.680256 174.200000,-61.018306 14.680276 174.200000,-61.018305 14.680299 174.200000,-61.018307 14.680317 174.200000,-61.018270 14.680332 172.400000,-61.018290 14.680361 172.400000,-61.018335 14.680351 174.200000)))'));
insert into RESERVOIR_EAU values ('18','RESERVOI0000000070010261','   1.5','    1.0','R�servoir d\'eau','3','592.800000','592.800000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.121989 14.702901 592.800000,-61.122008 14.702901 592.800000,-61.122029 14.702893 592.800000,-61.122044 14.702876 592.800000,-61.122045 14.702853 592.800000,-61.122040 14.702830 592.800000,-61.122020 14.702817 592.800000,-61.121995 14.702812 592.800000,-61.121976 14.702813 592.800000,-61.121960 14.702819 592.800000,-61.121949 14.702834 592.800000,-61.121946 14.702851 592.800000,-61.121945 14.702868 592.800000,-61.121953 14.702884 592.800000,-61.121965 14.702895 592.800000,-61.121989 14.702901 592.800000)))'));
insert into RESERVOIR_EAU values ('19','RESERVOI0000000070010239','   1.5','    1.0','R�servoir d\'eau','8','298.600000','298.600000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.022382 14.739685 298.600000,-61.022398 14.739677 298.600000,-61.022415 14.739665 298.600000,-61.022427 14.739649 298.600000,-61.022429 14.739631 298.600000,-61.022423 14.739611 298.600000,-61.022412 14.739593 298.600000,-61.022395 14.739583 298.600000,-61.022360 14.739581 298.600000,-61.022338 14.739588 298.600000,-61.022322 14.739607 298.600000,-61.022319 14.739630 298.600000,-61.022319 14.739659 298.600000,-61.022330 14.739674 298.600000,-61.022354 14.739684 298.600000,-61.022382 14.739685 298.600000)))'));
insert into RESERVOIR_EAU values ('20','RESERVOI0000000070010233','   1.5','    1.0','R�servoir d\'eau','6','479.600000','480.400000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.128135 14.752810 479.600000,-61.128155 14.752793 479.900000,-61.128180 14.752798 480.100000,-61.128202 14.752796 480.100000,-61.128220 14.752789 480.100000,-61.128237 14.752771 480.100000,-61.128247 14.752752 480.400000,-61.128245 14.752739 480.400000,-61.128234 14.752719 480.400000,-61.128212 14.752707 480.400000,-61.128186 14.752698 480.400000,-61.128170 14.752699 480.400000,-61.128147 14.752709 480.400000,-61.128136 14.752720 480.400000,-61.128133 14.752732 480.400000,-61.128135 14.752760 480.200000,-61.128114 14.752790 479.800000,-61.128135 14.752810 479.600000)))'));
insert into RESERVOIR_EAU values ('21','RESERVOI0000000070010221','   1.5','    1.0','R�servoir d\'eau','9','258.600000','258.600000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.022587 14.761718 258.600000,-61.022589 14.761709 258.600000,-61.022589 14.761699 258.600000,-61.022590 14.761689 258.600000,-61.022589 14.761676 258.600000,-61.022584 14.761665 258.600000,-61.022574 14.761654 258.600000,-61.022564 14.761647 258.600000,-61.022547 14.761643 258.600000,-61.022524 14.761640 258.600000,-61.022505 14.761643 258.600000,-61.022490 14.761650 258.600000,-61.022480 14.761663 258.600000,-61.022477 14.761676 258.600000,-61.022475 14.761693 258.600000,-61.022480 14.761716 258.600000,-61.022488 14.761732 258.600000,-61.022501 14.761743 258.600000,-61.022517 14.761750 258.600000,-61.022534 14.761750 258.600000,-61.022553 14.761746 258.600000,-61.022566 14.761740 258.600000,-61.022578 14.761730 258.600000,-61.022587 14.761718 258.600000)))'));
insert into RESERVOIR_EAU values ('22','RESERVOI0000000070010212','   1.5','    1.0','R�servoir d\'eau','8','258.900000','258.900000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.029641 14.781220 258.900000,-61.029663 14.781223 258.900000,-61.029683 14.781219 258.900000,-61.029694 14.781212 258.900000,-61.029701 14.781204 258.900000,-61.029706 14.781194 258.900000,-61.029708 14.781180 258.900000,-61.029707 14.781159 258.900000,-61.029694 14.781144 258.900000,-61.029673 14.781133 258.900000,-61.029642 14.781134 258.900000,-61.029620 14.781152 258.900000,-61.029612 14.781169 258.900000,-61.029612 14.781187 258.900000,-61.029616 14.781204 258.900000,-61.029625 14.781211 258.900000,-61.029641 14.781220 258.900000)))'));
insert into RESERVOIR_EAU values ('23','RESERVOI0000000070010211','   1.5','    1.0','R�servoir d\'eau','9','10.600000','10.700000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.997705 14.782937 10.600000,-60.997721 14.782949 10.700000,-60.997740 14.782954 10.700000,-60.997764 14.782949 10.700000,-60.997779 14.782919 10.700000,-60.997768 14.782881 10.700000,-60.997738 14.782869 10.700000,-60.997712 14.782880 10.700000,-60.997699 14.782905 10.700000,-60.997705 14.782937 10.600000)))'));
insert into RESERVOIR_EAU values ('24','RESERVOI0000000070010195','   1.5','    1.0','R�servoir d\'eau','8','305.300000','305.500000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.059370 14.800784 305.300000,-61.059419 14.800787 305.500000,-61.059438 14.800777 305.500000,-61.059457 14.800754 305.500000,-61.059458 14.800711 305.500000,-61.059440 14.800674 305.500000,-61.059405 14.800659 305.500000,-61.059368 14.800668 305.500000,-61.059340 14.800696 305.500000,-61.059330 14.800719 305.500000,-61.059334 14.800746 305.500000,-61.059348 14.800763 305.500000,-61.059370 14.800784 305.300000)))'));
insert into RESERVOIR_EAU values ('25','RESERVOI0000000070010193','   1.5','    1.0','R�servoir d\'eau','7','725.900000','725.900000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.145218 14.802404 725.900000,-61.145223 14.802401 725.900000,-61.145228 14.802394 725.900000,-61.145229 14.802388 725.900000,-61.145232 14.802381 725.900000,-61.145231 14.802374 725.900000,-61.145229 14.802358 725.900000,-61.145222 14.802352 725.900000,-61.145216 14.802349 725.900000,-61.145207 14.802348 725.900000,-61.145197 14.802348 725.900000,-61.145188 14.802350 725.900000,-61.145182 14.802356 725.900000,-61.145175 14.802362 725.900000,-61.145174 14.802370 725.900000,-61.145175 14.802382 725.900000,-61.145177 14.802391 725.900000,-61.145185 14.802395 725.900000,-61.145194 14.802402 725.900000,-61.145218 14.802404 725.900000)))'));
insert into RESERVOIR_EAU values ('26','RESERVOI0000000070010191','   1.5','    1.0','R�servoir d\'eau','8','206.700000','208.300000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.043696 14.805887 207.200000,-61.043675 14.805900 208.300000,-61.043653 14.805922 208.300000,-61.043637 14.805965 208.300000,-61.043638 14.805999 208.300000,-61.043651 14.806034 208.300000,-61.043602 14.806093 206.700000,-61.043652 14.806124 206.700000,-61.043700 14.806070 207.200000,-61.043753 14.806069 207.200000,-61.043787 14.806055 207.200000,-61.043815 14.806029 207.200000,-61.043826 14.805987 207.200000,-61.043821 14.805951 207.200000,-61.043807 14.805918 207.200000,-61.043773 14.805889 207.200000,-61.043734 14.805880 207.200000,-61.043696 14.805887 207.200000)))'));
insert into RESERVOIR_EAU values ('27','RESERVOI0000000070010174','   1.5','    1.0','R�servoir d\'eau','3','53.500000','53.500000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.030277 14.819084 53.500000,-61.030262 14.819078 53.500000,-61.030252 14.819064 53.500000,-61.030183 14.819105 53.500000,-61.030205 14.819148 53.500000,-61.030221 14.819159 53.500000,-61.030244 14.819160 53.500000,-61.030265 14.819151 53.500000,-61.030283 14.819130 53.500000,-61.030284 14.819105 53.500000,-61.030277 14.819084 53.500000)))'));
insert into RESERVOIR_EAU values ('28','RESERVOI0000000070010171','   1.5','    1.0','R�servoir d\'eau','7','122.000000','122.000000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.040828 14.820242 122.000000,-61.040811 14.820227 122.000000,-61.040779 14.820217 122.000000,-61.040754 14.820219 122.000000,-61.040726 14.820233 122.000000,-61.040712 14.820256 122.000000,-61.040715 14.820289 122.000000,-61.040729 14.820309 122.000000,-61.040753 14.820325 122.000000,-61.040785 14.820325 122.000000,-61.040808 14.820315 122.000000,-61.040824 14.820296 122.000000,-61.040830 14.820276 122.000000,-61.040828 14.820242 122.000000)))'));
insert into RESERVOIR_EAU values ('29','RESERVOI0000000070010170','   1.5','    1.0','R�servoir d\'eau','2','11.800000','11.800000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.032876 14.822943 11.800000,-61.032836 14.822972 11.800000,-61.032855 14.822997 11.800000,-61.032896 14.822967 11.800000,-61.032876 14.822943 11.800000)))'));
insert into RESERVOIR_EAU values ('30','RESERVOI0000000070010166','   1.5','    1.0','R�servoir d\'eau','8','149.400000','149.400000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.073925 14.830802 149.400000,-61.073969 14.830787 149.400000,-61.074013 14.830752 149.400000,-61.074027 14.830702 149.400000,-61.074023 14.830656 149.400000,-61.074002 14.830618 149.400000,-61.073963 14.830593 149.400000,-61.073902 14.830578 149.400000,-61.073842 14.830589 149.400000,-61.073791 14.830638 149.400000,-61.073778 14.830665 149.400000,-61.073779 14.830697 149.400000,-61.073794 14.830752 149.400000,-61.073829 14.830785 149.400000,-61.073881 14.830809 149.400000,-61.073925 14.830802 149.400000)))'));
insert into RESERVOIR_EAU values ('31','RESERVOI0000000070010573','   2.5','    2.5','R�servoir d\'eau','7','12.400000','12.900000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.964292 14.480006 12.400000,-60.964225 14.479992 12.800000,-60.964207 14.480042 12.900000,-60.964270 14.480062 12.900000,-60.964292 14.480006 12.400000)))'));
insert into RESERVOIR_EAU values ('32','RESERVOI0000000070010563','   2.5','    2.5','R�servoir d\'eau','6','142.200000','143.900000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.008457 14.488489 142.300000,-61.008488 14.488508 143.900000,-61.008478 14.488539 143.900000,-61.008482 14.488570 143.300000,-61.008499 14.488592 143.300000,-61.008526 14.488610 143.400000,-61.008554 14.488615 143.400000,-61.008586 14.488606 143.400000,-61.008612 14.488584 143.400000,-61.008625 14.488554 143.400000,-61.008620 14.488517 143.400000,-61.008597 14.488482 143.400000,-61.008559 14.488466 143.400000,-61.008518 14.488473 143.400000,-61.008485 14.488453 142.200000,-61.008457 14.488489 142.300000)))'));
insert into RESERVOIR_EAU values ('33','RESERVOI0000000070010562','   2.5','    2.5','R�servoir d\'eau','2','62.800000','62.800000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.848682 14.485601 62.800000,-60.848639 14.485550 62.800000,-60.848595 14.485582 62.800000,-60.848640 14.485635 62.800000,-60.848682 14.485601 62.800000)))'));
insert into RESERVOIR_EAU values ('34','RESERVOI0000000070010515','   2.5','    2.5','R�servoir d\'eau','11','370.700000','371.000000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.891570 14.547515 370.700000,-60.891541 14.547430 371.000000,-60.891496 14.547442 371.000000,-60.891521 14.547522 370.700000,-60.891570 14.547515 370.700000)))'));
insert into RESERVOIR_EAU values ('35','RESERVOI0000000070010508','   2.5','    2.5','R�servoir d\'eau','13','283.500000','283.500000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.898694 14.565280 283.500000,-60.898718 14.565246 283.500000,-60.898672 14.565211 283.500000,-60.898641 14.565255 283.500000,-60.898694 14.565280 283.500000)))'));
