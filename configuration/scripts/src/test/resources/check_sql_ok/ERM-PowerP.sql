SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "powerp" (gid serial PRIMARY KEY,
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
"ppc" int4,
"ident" int4);
SELECT AddGeometryColumn('','powerp','the_geom','4326','POINT',2);
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','25E27BF7-894A-46CA-BBEB-2E26F1472987','AD010','FR','0','Centrale Électrique de Chinon','N_A','Centrale Electrique de Chinon','N_A','FRE','N_A','0','1','0101000020E610000000A8B5696CAFC53F607F129F3B9D4740');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','A73B1B30-F480-48EB-980B-AC409E7AC111','AD010','FR','0','Centrale Thermique de Cordemais','N_A','Centrale Thermique de Cordemais','N_A','FRE','N_A','4','2','0101000020E61000008001BA2F6716FEBF806308008EA34740');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','A45809C6-7521-4D71-9B24-1A44BA1B5B39','AD010','FR','0','Centrale Électrique de Nantes-Cheviré','N_A','Centrale Electrique de Nantes-Chevire','N_A','FRE','N_A','0','3','0101000020E610000000D5C9198ABBF9BF00E2E7BF07984740');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','93CAF73C-8256-45EE-A14F-7A2885AF6A8F','AD010','FR','0','Centrale Électrique de la Bâthie','N_A','Centrale Electrique de la Bathie','N_A','FRE','N_A','0','4','0101000020E61000002099D6A6B1C51940781E15FF77D24640');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','7ABF0658-40DE-478B-8CD5-D54B314E4186','AD010','FR','0','Centrale Électrique du Blayais','N_A','Centrale Electrique du Blayais','N_A','FRE','N_A','0','5','0101000020E6100000002AC3B81B04E6BF04F4FBFECDA04640');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','A76ADEB5-183E-45D2-948F-15CA2FDDFFBB','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','4','6','0101000020E610000000F5EFFACCD9E1BF18B7D100DE804640');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','288E5C11-9031-4301-A7C6-FA771D2BD829','AD010','FR','0','Centrale Électrique de Cruas-Meysse','N_A','Centrale Electrique de Cruas-Meysse','N_A','FRE','N_A','0','7','0101000020E6100000C0B8E34D7E031340DCF15F2008514640');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','B42843FE-9ED1-40FA-A8CE-D9978DF2C220','AD010','FR','0','Centrale Électrique du Tricastin','N_A','Centrale Electrique du Tricastin','N_A','FRE','N_A','0','8','0101000020E610000000E65B1FD6EB1240303883BF5F2A4640');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','5254DFB0-85FD-43A4-92E3-A61F45BC52F5','AD010','FR','0','Centrale Électrique des Monts d''Arrée','N_A','Centrale Electrique des Monts d''Arree','N_A','FRE','N_A','0','9','0101000020E6100000C052793BC2F90EC07C5A7EE02A2D4840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','9B78878A-8C6E-449E-AA06-4361830BA2B9','AD010','FR','0','Centrale Électrique de Porcheville','N_A','Centrale Electrique de Porcheville','N_A','FRE','N_A','0','10','0101000020E610000080B6D8EDB32AFC3FF8B182DF867C4840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','017B069D-D697-42AF-B7FD-D800B2079FF7','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','4','11','0101000020E610000000BB2A508B110240146C5CFFAE914840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','E4828611-2D13-477B-951C-8AA8EC62C403','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','0','12','0101000020E6100000E0C7D2872EA01240D8C1C1DEC4F04540');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','952794D3-D7B5-4050-8A2F-9903620670BE','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','0','13','0101000020E610000040C501F4FB1E0140E03653211EFA4540');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','D9E6F39B-C331-442A-80DD-A5A96D2E8F00','AD010','FR','0','Centrale Électrique de Saint-Denis','N_A','Centrale Electrique de Saint-Denis','N_A','FRE','N_A','0','14','0101000020E6100000C06EF59CF4AE024084BD892139764840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','D4171EC2-1251-41D4-9C50-878DDB267DB8','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','0','15','0101000020E610000000D34B8C651AFEBF3C7D3D5FB3C44840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','21EFA33A-FCB2-4308-A5A8-BAEB5C817D5F','AD010','FR','0','Centrale Thermique de Lucciana','N_A','Centrale Thermique de Lucciana','N_A','FRE','N_A','4','16','0101000020E610000080BED87BF1E52240F48DE89E75434540');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','E26AC372-5D75-4E74-B870-4DC2FE579BCB','AD010','FR','0','Centrale Thermique d''Artix','N_A','Centrale Thermique d''Artix','N_A','FRE','N_A','4','17','0101000020E61000000062601DC7CFE2BF20C3633F8BB14540');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','78F978E5-95C2-4175-8080-D49E2BCF7543','AD010','FR','0','Centrale Électrique du Bugey','N_A','Centrale Electrique du Bugey','N_A','FRE','N_A','0','18','0101000020E610000080A1D634EF1015408887307E1AE64640');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','F46354C5-66F5-44DF-AD73-BCF84F8BBCB1','AD010','FR','0','Centrale Électrique de Creys-Malville','N_A','Centrale Electrique de Creys-Malville','N_A','FRE','N_A','0','19','0101000020E610000080AA0B7899E1154090EDB5A0F7E04640');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','EE91AB05-5C6B-4B3C-9BC4-0908F83FED89','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','4','20','0101000020E6100000401BD654165503407842E8A04B654840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','6B508535-8CC2-46F7-94B4-D710A725AFA6','AD010','FR','0','Centrale Électrique Arrighi','N_A','Centrale Electrique Arrighi','N_A','FRE','N_A','0','21','0101000020E61000004019E59997530340D0A0A17F82644840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','2998F191-401F-4A9C-818A-4B9FF2A4EBF6','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','0','22','0101000020E610000080DE3994A13A0540587F8461C06F4840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','A07050A6-380D-491D-9911-D49304FF7B55','AD010','FR','0','Centrale Thermique de Montereau','N_A','Centrale Thermique de Montereau','N_A','FRE','N_A','4','23','0101000020E61000000092B245D2DE06406CEBE0606F304840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','13989C06-CB44-40BF-BA28-A5A4C252DBE2','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','0','24','0101000020E610000080B48EAA26180140B0B6627FD9814940');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','19C99C95-EEFA-44A3-8AF6-FF261CF2251C','AD010','FR','0','Centrale Thermique des Ansereuilles','N_A','Centrale Thermique des Ansereuilles','N_A','FRE','N_A','4','25','0101000020E6100000C03B342C467D074088B4C6A013474940');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','4A759F44-E7D6-46F2-A043-DC9E159BD83C','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','0','26','0101000020E6100000009B1F7F69D10740BCE9CF7EA4354940');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','ED30CFFD-19D9-4351-8250-44E4E1927F0B','AD010','FR','0','Centrale Électrique de Paluel','N_A','Centrale Electrique de Paluel','N_A','FRE','N_A','0','27','0101000020E610000000257CEF6F50E43FB8F5D37FD6ED4840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','F8602A58-C387-4481-B5A1-26237F5E4FDD','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','0','28','0101000020E6100000407097FDBA830A4068B5C01E13264940');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','4D4E8FAB-63CB-4797-A7F7-5F42FF501351','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','0','29','0101000020E6100000400B992B83BA0A40A0685721E52F4940');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','60BA218C-92E1-4AEF-89F8-A8D3ECAAD38D','AD010','FR','0','UNK','N_A','UNK','N_A','N_A','N_A','0','30','0101000020E610000000E208522936EA3F64764F1E16BB4840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','9C4C1FBB-51D4-47CC-AF4B-868A6623554E','AD010','FR','0','Centrale Électrique de Penly','N_A','Centrale Electrique de Penly','N_A','FRE','N_A','0','31','0101000020E6100000006497A8DE5AF33FC89DD2C1FAFC4840');
INSERT INTO "powerp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppc","ident",the_geom) VALUES ('1','CA4DD31F-0E7F-491E-BEE3-C4D28933C39C','AD010','FR','0','Centrale Électrique de Dampierre-en-Burly','N_A','Centrale Electrique de Dampierre-en-Burly','N_A','FRE','N_A','0','32','0101000020E610000000FF243E77220440C846205ED7DD4740');
