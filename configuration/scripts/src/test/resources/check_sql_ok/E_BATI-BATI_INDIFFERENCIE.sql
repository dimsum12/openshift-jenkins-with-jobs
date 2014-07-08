SET NAMES 'LATIN9';
--
-- BDUNI1.0  Ne pas effacer cette liiiiigne
--
start transaction;
-- B�timent de plus de 20 m�tres carr�s
--
create table BATI_INDIFFERENCIE (gid SERIAL not null, ID varchar(24) not null, PREC_PLANI decimal(6,1) not null, PREC_ALTI decimal(7,1) not null, ORIGIN_BAT varchar(8) default 'NR', HAUTEUR integer not null, Z_MIN float, Z_MAX float, constraint BATI_INDIFFERENCIE_pkey primary key (gid));
select AddGeometryColumn('','bati_indifferencie','the_geom','210642000','MULTIPOLYGON',3);
create index BATI_INDIFFERENCIE_geoidx on BATI_INDIFFERENCIE using gist (the_geom gist_geometry_ops);
--
commit;
--
-- BATI_INDIFFERENCIE
start transaction;
insert into BATI_INDIFFERENCIE values ('1','BATIMENT0000000070151398','   1.5','    1.0','Autre','0','4.000000','4.000000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.871884 14.435394 4.000000,-60.871919 14.435363 4.000000,-60.871883 14.435315 4.000000,-60.871833 14.435351 4.000000,-60.871884 14.435394 4.000000)))'));
insert into BATI_INDIFFERENCIE values ('2','BATIMENT0000000070150915','   1.5','    1.0','Autre','4','90.200000','90.200000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.832973 14.443209 90.200000,-60.832963 14.443073 90.200000,-60.832845 14.443083 90.200000,-60.832852 14.443196 90.200000,-60.832973 14.443209 90.200000)))'));
insert into BATI_INDIFFERENCIE values ('3','BATIMENT0000000070149473','   1.5','    1.0','Autre','4','16.200000','17.000000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.067202 14.466093 16.500000,-61.067245 14.466077 16.500000,-61.067233 14.466041 16.300000,-61.067338 14.466006 16.300000,-61.067298 14.465909 16.200000,-61.067180 14.465948 16.800000,-61.067190 14.466042 17.000000,-61.067202 14.466093 16.500000)))'));
insert into BATI_INDIFFERENCIE values ('4','BATIMENT0000000070149320','   1.5','    1.0','Autre','6','17.000000','17.100000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.954757 14.466315 17.100000,-60.954797 14.466301 17.100000,-60.954780 14.466239 17.000000,-60.954739 14.466248 17.100000,-60.954757 14.466315 17.100000)))'));
insert into BATI_INDIFFERENCIE values ('5','BATIMENT0000000070148290','   1.5','    1.0','Autre','7','16.000000','16.900000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.956669 14.469651 16.000000,-60.956602 14.469723 16.900000,-60.956682 14.469792 16.400000,-60.956746 14.469719 16.200000,-60.956669 14.469651 16.000000)))'));
insert into BATI_INDIFFERENCIE values ('6','BATIMENT0000000070147766','   1.5','    1.0','Autre','8','25.800000','25.900000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.919411 14.468539 25.800000,-60.919413 14.468487 25.800000,-60.919328 14.468483 25.900000,-60.919322 14.468536 25.900000,-60.919411 14.468539 25.800000)))'));
insert into BATI_INDIFFERENCIE values ('7','BATIMENT0000000070147539','   1.5','    1.0','Autre','3','5.000000','5.000000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.879167 14.469795 5.000000,-60.879138 14.469709 5.000000,-60.879068 14.469728 5.000000,-60.879098 14.469815 5.000000,-60.879167 14.469795 5.000000)))'));
insert into BATI_INDIFFERENCIE values ('8','BATIMENT0000000070146783','   1.5','    1.0','Autre','9','75.400000','75.400000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.923522 14.473826 75.400000,-60.923648 14.473815 75.400000,-60.923632 14.473687 75.400000,-60.923510 14.473692 75.400000,-60.923522 14.473826 75.400000)))'));
insert into BATI_INDIFFERENCIE values ('9','BATIMENT0000000070146438','   1.5','    1.0','Autre','5','28.500000','29.700000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.869067 14.473756 29.700000,-60.869029 14.473717 29.700000,-60.868974 14.473772 29.700000,-60.869010 14.473809 29.700000,-60.869043 14.473827 28.500000,-60.869100 14.473763 28.500000,-60.869067 14.473756 29.700000)))'));
insert into BATI_INDIFFERENCIE values ('10','BATIMENT0000000070146378','   1.5','    1.0','Autre','6','26.700000','26.700000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.868008 14.473158 26.700000,-60.868019 14.473089 26.700000,-60.867897 14.473073 26.700000,-60.867889 14.473142 26.700000,-60.868008 14.473158 26.700000)))'));
insert into BATI_INDIFFERENCIE values ('11','BATIMENT0000000070146247','   1.5','    1.0','Autre','8','26.500000','26.500000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.862096 14.473323 26.500000,-60.862060 14.473230 26.500000,-60.861970 14.473258 26.500000,-60.862002 14.473356 26.500000,-60.862096 14.473323 26.500000)))'));
insert into BATI_INDIFFERENCIE values ('12','BATIMENT0000000070145519','   1.5','    1.0','Autre','6','53.300000','53.300000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.881671 14.474500 53.300000,-60.881644 14.474440 53.300000,-60.881611 14.474452 53.300000,-60.881638 14.474516 53.300000,-60.881671 14.474500 53.300000)))'));
insert into BATI_INDIFFERENCIE values ('13','BATIMENT0000000070145466','   1.5','    1.0','Autre','8','42.200000','42.200000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.874863 14.475418 42.200000,-60.874884 14.475359 42.200000,-60.874802 14.475332 42.200000,-60.874781 14.475394 42.200000,-60.874863 14.475418 42.200000)))'));
insert into BATI_INDIFFERENCIE values ('14','BATIMENT0000000070145465','   1.5','    1.0','Autre','5','16.100000','16.100000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.874740 14.473981 16.100000,-60.874731 14.473887 16.100000,-60.874665 14.473888 16.100000,-60.874668 14.473932 16.100000,-60.874644 14.473935 16.100000,-60.874649 14.473997 16.100000,-60.874740 14.473981 16.100000)))'));
insert into BATI_INDIFFERENCIE values ('15','BATIMENT0000000070145371','   1.5','    1.0','Autre','6','45.500000','45.500000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.867921 14.474049 45.500000,-60.867951 14.473995 45.500000,-60.867863 14.473962 45.500000,-60.867837 14.474016 45.500000,-60.867921 14.474049 45.500000)))'));
insert into BATI_INDIFFERENCIE values ('16','BATIMENT0000000070145222','   1.5','    1.0','Autre','3','147.100000','147.100000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.836689 14.474423 147.100000,-60.836685 14.474386 147.100000,-60.836642 14.474388 147.100000,-60.836646 14.474425 147.100000,-60.836689 14.474423 147.100000)))'));
insert into BATI_INDIFFERENCIE values ('17','BATIMENT0000000070144034','   1.5','    1.0','Autre','6','85.000000','85.000000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.863364 14.477602 85.000000,-60.863367 14.477537 85.000000,-60.863283 14.477531 85.000000,-60.863279 14.477604 85.000000,-60.863364 14.477602 85.000000)))'));
insert into BATI_INDIFFERENCIE values ('18','BATIMENT0000000070143942','   1.5','    1.0','Autre','4','91.300000','91.300000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.841559 14.479356 91.300000,-60.841567 14.479275 91.300000,-60.841482 14.479267 91.300000,-60.841473 14.479344 91.300000,-60.841559 14.479356 91.300000)))'));
insert into BATI_INDIFFERENCIE values ('19','BATIMENT0000000070143225','   1.5','    1.0','Autre','7','17.800000','17.900000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.992842 14.482764 17.900000,-60.992841 14.482721 17.800000,-60.992755 14.482712 17.800000,-60.992752 14.482753 17.800000,-60.992842 14.482764 17.900000)))'));
insert into BATI_INDIFFERENCIE values ('20','BATIMENT0000000070143074','   1.5','    1.0','Autre','7','170.200000','170.200000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.917047 14.485345 170.200000,-60.917047 14.485308 170.200000,-60.916991 14.485306 170.200000,-60.916991 14.485272 170.200000,-60.916912 14.485271 170.200000,-60.916914 14.485349 170.200000,-60.917047 14.485345 170.200000)))'));
insert into BATI_INDIFFERENCIE values ('21','BATIMENT0000000070142226','   1.5','    1.0','Autre','9','131.100000','131.100000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.007951 14.488160 131.100000,-61.008066 14.488063 131.100000,-61.007991 14.487983 131.100000,-61.007877 14.488078 131.100000,-61.007951 14.488160 131.100000)))'));
insert into BATI_INDIFFERENCIE values ('22','BATIMENT0000000070142191','   1.5','    1.0','Autre','4','120.100000','120.100000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.006997 14.487377 120.100000,-61.006961 14.487399 120.100000,-61.006979 14.487446 120.100000,-61.007022 14.487431 120.100000,-61.006997 14.487377 120.100000)))'));
insert into BATI_INDIFFERENCIE values ('23','BATIMENT0000000070138206','   1.5','    1.0','Autre','4','106.700000','106.700000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.971715 14.501730 106.700000,-60.971721 14.501615 106.700000,-60.971580 14.501602 106.700000,-60.971575 14.501721 106.700000,-60.971715 14.501730 106.700000)))'));
insert into BATI_INDIFFERENCIE values ('24','BATIMENT0000000070137709','   1.5','    1.0','Autre','8','148.500000','148.600000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.876069 14.501489 148.500000,-60.876098 14.501322 148.600000,-60.875931 14.501295 148.600000,-60.875902 14.501459 148.600000,-60.876069 14.501489 148.500000)))'));
insert into BATI_INDIFFERENCIE values ('25','BATIMENT0000000070137670','   1.5','    1.0','Autre','10','320.300000','320.400000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.871742 14.502931 320.300000,-60.871867 14.502945 320.400000,-60.871879 14.502831 320.400000,-60.871754 14.502819 320.400000,-60.871742 14.502931 320.300000)))'));
insert into BATI_INDIFFERENCIE values ('26','BATIMENT0000000070137172','   1.5','    1.0','Autre','3','125.800000','125.800000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.962213 14.507172 125.800000,-60.962226 14.507111 125.800000,-60.962139 14.507085 125.800000,-60.962121 14.507143 125.800000,-60.962213 14.507172 125.800000)))'));
insert into BATI_INDIFFERENCIE values ('27','BATIMENT0000000070136111','   1.5','    1.0','Autre','2','67.900000','68.100000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.984229 14.508349 67.900000,-60.984339 14.508370 68.100000,-60.984352 14.508296 68.100000,-60.984249 14.508269 68.100000,-60.984229 14.508349 67.900000)))'));
insert into BATI_INDIFFERENCIE values ('28','BATIMENT0000000070135571','   1.5','    1.0','Autre','7','329.700000','329.900000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.926927 14.510289 329.700000,-60.926925 14.510203 329.800000,-60.926807 14.510195 329.800000,-60.926802 14.510297 329.900000,-60.926927 14.510289 329.700000)))'));
insert into BATI_INDIFFERENCIE values ('29','BATIMENT0000000070134192','   1.5','    1.0','Autre','4','5.800000','5.800000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.836821 14.511480 5.800000,-60.836816 14.511408 5.800000,-60.836776 14.511406 5.800000,-60.836778 14.511480 5.800000,-60.836821 14.511480 5.800000)))'));
insert into BATI_INDIFFERENCIE values ('30','BATIMENT0000000070132959','   1.5','    1.0','Autre','4','97.800000','98.600000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-61.038884 14.520543 97.800000,-61.038967 14.520469 97.800000,-61.038904 14.520404 98.600000,-61.038813 14.520481 98.600000,-61.038884 14.520543 97.800000)))'));
insert into BATI_INDIFFERENCIE values ('31','BATIMENT0000000070132326','   1.5','    1.0','Autre','3','181.000000','181.700000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.915221 14.519429 181.000000,-60.915181 14.519557 181.700000,-60.915275 14.519585 181.700000,-60.915319 14.519459 181.100000,-60.915221 14.519429 181.000000)))'));
insert into BATI_INDIFFERENCIE values ('32','BATIMENT0000000070132213','   1.5','    1.0','Autre','2','179.700000','179.700000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.903015 14.520239 179.700000,-60.902973 14.520262 179.700000,-60.903006 14.520309 179.700000,-60.903047 14.520284 179.700000,-60.903015 14.520239 179.700000)))'));
insert into BATI_INDIFFERENCIE values ('33','BATIMENT0000000070128803','   1.5','    1.0','Autre','4','7.100000','7.100000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.995953 14.531459 7.100000,-60.996014 14.531461 7.100000,-60.996014 14.531387 7.100000,-60.995950 14.531386 7.100000,-60.995953 14.531459 7.100000)))'));
insert into BATI_INDIFFERENCIE values ('34','BATIMENT0000000070125112','   1.5','    1.0','Autre','8','233.700000','234.000000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.887619 14.543068 234.000000,-60.887539 14.543038 233.700000,-60.887530 14.543098 233.700000,-60.887610 14.543111 233.700000,-60.887619 14.543068 234.000000)))'));
insert into BATI_INDIFFERENCIE values ('35','BATIMENT0000000070123798','   1.5','    1.0','Autre','4','300.900000','300.900000', GeomFromEWKT('SRID=210642000;MULTIPOLYGON(((-60.892917 14.545946 300.900000,-60.892969 14.545931 300.900000,-60.892946 14.545831 300.900000,-60.892880 14.545846 300.900000,-60.892917 14.545946 300.900000)))'));