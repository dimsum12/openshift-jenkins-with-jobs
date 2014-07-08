SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "builtupp" (gid serial PRIMARY KEY,
"fcsubtype" int4,
"gfid" varchar(38),
"f_code" varchar(5),
"icc" varchar(5),
"sn" int2,
"namn1" varchar(50),
"namn2" varchar(50),
"nama1" varchar(50),
"nama2" varchar(50),
"nln1" varchar(3),
"nln2" varchar(3),
"ppl" int4,
"pp1" int4,
"pp2" int4,
"ident" int4);
SELECT AddGeometryColumn('','builtupp','the_geom','4326','POINT',2);
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','429B5EF5-A657-44F9-BA8F-DA56369B7089','AL020','FR','0','Marseillette','N_A','Marseillette','N_A','FRE','N_A','700','-29997','-29997','1','0101000020E6100000402A1BD654560440480DA661F8994540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','C5BEEEB6-E14B-44C1-B777-DC2B3E7F5EF7','AL020','FR','0','Blomac','N_A','Blomac','N_A','FRE','N_A','200','-29997','-29997','2','0101000020E6100000C0B0524145C504401087A5811F9A4540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','9CE23922-3FD7-403A-8BA0-07A7254ECAC4','AL020','FR','0','Saint-Couat-d''Aude','N_A','Saint-Couat-d''Aude','N_A','FRE','N_A','300','-29997','-29997','3','0101000020E61000008087156EF9080540FCBD4D7FF6994540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','B80146C4-E56F-4858-B94D-9476335D4A84','AL020','FR','0','Montbrun-des-Corbières','N_A','Montbrun-des-Corbieres','N_A','FRE','N_A','300','-29997','-29997','4','0101000020E6100000407DCC07047A0540345C1D0071994540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','84E6C4B2-6DA2-4F32-BCFD-01781ABF07D2','AL020','FR','0','Névian','N_A','Nevian','N_A','FRE','N_A','1100','-29997','-29997','5','0101000020E6100000C062F2069839074068E8D841259B4540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','0519B410-32D4-447A-B864-9FED835FAD2E','AL020','FR','0','Vinassan','N_A','Vinassan','N_A','FRE','N_A','2000','-29997','-29997','6','0101000020E6100000C05B77F35497084068B5C01E139A4540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','363FFFBF-B5CB-405F-A8F3-6AAA0ADBB6A1','AL020','FR','0','Alairac','N_A','Alairac','N_A','FRE','N_A','700','-29997','-29997','7','0101000020E610000080F487669EEC01400806103E94974540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','76DC6169-80B4-4F2C-8EDB-B990E45B6F71','AL020','FR','0','Couffoulens','N_A','Couffoulens','N_A','FRE','N_A','500','-29997','-29997','8','0101000020E610000000513239B573024090E733A0DE934540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','71676E1E-B940-4550-A8EC-502CD5836CC1','AL020','FR','0','Roullens','N_A','Roullens','N_A','FRE','N_A','400','-29997','-29997','9','0101000020E6100000C0054CE0D62D02401CBAD91F28954540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','B1F2D409-8516-46AE-887D-17DC8ABAA249','AL020','FR','0','Lavalette','N_A','Lavalette','N_A','FRE','N_A','1100','-29997','-29997','10','0101000020E6100000C0A833F7902002409C3E3BE0BA974540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','4B80B8B7-D0ED-45C2-B4C7-36E7990FEDE1','AL020','FR','0','Cavanac','N_A','Cavanac','N_A','FRE','N_A','700','-29997','-29997','11','0101000020E6100000C050DEC7D19C024090B454DE8E954540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','D36E2A0B-8FD1-43ED-9F05-DDD020F2A370','AL020','FR','0','Palaja','N_A','Palaja','N_A','FRE','N_A','1900','-29997','-29997','12','0101000020E610000040508BC1C314034090F678211D964540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','D4FDA3BC-7E5E-49F0-A336-3F7C17DC4040','AL020','FR','0','Cazilhac','N_A','Cazilhac','N_A','FRE','N_A','1400','-29997','-29997','13','0101000020E610000040F73C7FDAE80240CCA99D616A974540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','573B7F7E-408C-41F9-8448-7089C387D70C','AL020','FR','0','Montirat','N_A','Montirat','N_A','FRE','N_A','100','-29997','-29997','14','0101000020E6100000C09BC58B8581034014A5BDC117964540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','3758729C-24E1-4B8A-905C-E57E6450717E','AL020','FR','0','Monze','N_A','Monze','N_A','FRE','N_A','200','-29997','-29997','15','0101000020E6100000006D904946AE0340BC1CAF40F4934540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','88053672-7DAD-4825-A899-5058577AD7F4','AL020','FR','0','Floure','N_A','Floure','N_A','FRE','N_A','300','-29997','-29997','16','0101000020E6100000003B1C5DA5EB0340387A354069974540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','8946166B-919A-4CAA-89EE-21D7DAE9B003','AL020','FR','0','Fontiès-d''Aude','N_A','Fonties-d''Aude','N_A','FRE','N_A','400','-29997','-29997','17','0101000020E610000080723106D6A10340C03AC780EC974540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','32F666DA-5625-4464-A9F4-A576B226F804','AL020','FR','0','Barbaira','N_A','Barbaira','N_A','FRE','N_A','500','-29997','-29997','18','0101000020E6100000808DEC4ACB180440E869F981AB974540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','630B71D8-D600-4134-BBBA-49B8674DCA3A','AL020','FR','0','Comigne','N_A','Comigne','N_A','FRE','N_A','200','-29997','-29997','19','0101000020E6100000C0CEDDAE97A604408093A641D1954540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','87A34E28-34BC-422A-B456-585FFC7AFE41','AL020','FR','0','Capendu','N_A','Capendu','N_A','FRE','N_A','1400','-29997','-29997','20','0101000020E610000040A4E194B9790440A453909F8D974540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','97FB4DD8-5501-4EE7-A078-CEEBE3291CA6','AL020','FR','0','Douzens','N_A','Douzens','N_A','FRE','N_A','600','-29997','-29997','21','0101000020E6100000008DD47B2AC70440A853573ECB974540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','432AD834-7888-42C3-AE9E-9CF010B95B0F','AL020','FR','0','Moux','N_A','Moux','N_A','FRE','N_A','500','-29997','-29997','22','0101000020E61000008025034015370540E875C4211B974540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','08FB9798-897C-499D-B892-CBC19B4EA55C','AL020','FR','0','Fontcouverte','N_A','Fontcouverte','N_A','FRE','N_A','400','-29997','-29997','23','0101000020E6100000403B70CE888205409C5FCD0182954540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','D29342EE-F768-48FA-8EF8-6D8E1D4E2E63','AL020','FR','0','Conilhac-Corbières','N_A','Conilhac-Corbieres','N_A','FRE','N_A','600','-29997','-29997','24','0101000020E6100000C072F7393EBA0540D8A9F23D23984540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','D9B62975-DDE0-4EFD-B171-47BEE8C4829C','AL020','FR','0','Luc-sur-Orbieu','N_A','Luc-sur-Orbieu','N_A','FRE','N_A','800','-29997','-29997','25','0101000020E61000008058AA0B784906409005854199964540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','8C78852B-5A35-4C71-9584-3FCB8A1EF36C','AL020','FR','0','Ornaisons','N_A','Ornaisons','N_A','FRE','N_A','1000','-29997','-29997','26','0101000020E61000000037FE4465B30640D4B8702024974540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','04F91916-51AB-45A6-BDCE-74449E3FDE05','AL020','FR','0','Cruscades','N_A','Cruscades','N_A','FRE','N_A','300','-29997','-29997','27','0101000020E610000080D1E7A38C88064044DD408177984540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','1BDE6232-C954-4D8E-9838-67EAED4A6F00','AL020','FR','0','Bizanet','N_A','Bizanet','N_A','FRE','N_A','1100','-29997','-29997','28','0101000020E6100000C0EA1ED95CF50640586133C005954540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','2E00826E-EBDB-43DD-820F-CCCC689C927E','AL020','FR','0','Montredon-des-Corbières','N_A','Montredon-des-Corbieres','N_A','FRE','N_A','900','-29997','-29997','29','0101000020E610000040D0285DFA67074028FF93BF7B984540');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2","ident",the_geom) VALUES ('1','AF73AB57-394D-41A6-906C-C99C5315F350','AL020','FR','0','Armissan','N_A','Armissan','N_A','FRE','N_A','1200','-29997','-29997','30','0101000020E610000000E1EF17B3C50840D8CDC5DFF6974540');
