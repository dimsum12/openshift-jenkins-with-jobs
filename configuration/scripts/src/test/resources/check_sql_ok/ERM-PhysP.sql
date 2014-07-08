SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "physp" (gid serial PRIMARY KEY,
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
"ident" int4);
SELECT AddGeometryColumn('','physp','the_geom','4326','POINT',2);
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','615EF20A-21E1-4CAB-8539-77F070B8640E','DB030','FR','0','Caune de l''Arago','N_A','Caune de l''Arago','N_A','FRE','N_A','1','0101000020E610000040EE96E4800D0640503DD2E0B66B4540');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','0FF78191-D348-4DD3-A291-BF74C38831AD','DB030','FR','0','Grotte des Grandes Canalettes','N_A','Grotte des Grandes Canalettes','N_A','FRE','N_A','2','0101000020E610000040A72215C6F6024044AD69DE714A4540');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','15EE697B-BE7B-41DE-8283-47CCAD55B5DF','DB030','FR','0','Le Gouffre de Gourfouran','N_A','Le Gouffre de Gourfouran','N_A','FRE','N_A','3','0101000020E6100000E034D3BD4E4A1A40BC10AB3FC25D4640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','EBFA6FC0-DF0B-4D01-8003-6A39D3598367','DB030','FR','0','Enclos Paroissial','N_A','Enclos Paroissial','N_A','FRE','N_A','4','0101000020E610000000350A49667510C0408C101E6D4D4840');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','F93092A0-2670-4193-9FD5-5112B64F351F','DB030','FR','0','UNK#Grotte','N_A','UNK#Grotte','N_A','FRE','N_A','5','0101000020E610000040CB48BDA70212C0B8D782DE1B1C4840');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','E60F95B6-9BAB-4750-A261-77636CCBF5A8','DB030','FR','0','UNK#Grotte','N_A','UNK#Grotte','N_A','FRE','N_A','6','0101000020E61000004055DAE21AEF11C0387A3540691E4840');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','EDE8CBC5-A279-428D-8901-93E05FFA5E5E','DB030','FR','0','Grotte des Sirènes','N_A','Grotte des Sirenes','N_A','FRE','N_A','7','0101000020E61000000023F59ECAE900C0B80DA32078524840');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','044D78C0-ED0F-45EB-BD2D-6F9B32052F76','DB030','FR','0','Troglodytes','N_A','Troglodytes','N_A','FRE','N_A','8','0101000020E61000000080D26D895C803FDCB8FE5D9F9D4740');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','16A98EBA-E693-49A0-9E60-B92A84468459','DB030','FR','0','Troglodytes','N_A','Troglodytes','N_A','FRE','N_A','9','0101000020E610000000A0AD2EA7049C3FC00166BE839C4740');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','95BB1C35-C31D-43B7-8708-7D2C31DCFBFA','DB030','FR','0','Troglodytes','N_A','Troglodytes','N_A','FRE','N_A','10','0101000020E610000000B0409FC893AC3F90DE701FB99B4740');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','930CED8E-10C4-4FBD-9E2C-7AD9DE6A2260','DB030','FR','0','Grotte de Carpe Diem','N_A','Grotte de Carpe Diem','N_A','FRE','N_A','11','0101000020E610000000897E6DFD74EF3F784B72C0AE7A4640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','FD678852-DC9B-43F7-93D9-44D54CD2A460','DB030','FR','0','Grotte du Sorcier','N_A','Grotte du Sorcier','N_A','FRE','N_A','12','0101000020E610000000DCA4A2B1F6EE3F304487C091764640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','D2039064-04DE-4D0D-9D00-6B2C68B05936','DB030','FR','0','Grotte de Bara-Bahau','N_A','Grotte de Bara-Bahau','N_A','FRE','N_A','13','0101000020E610000000179F02607CED3FD4E28C614E764640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','44521935-6338-4BB3-A885-EBC30252D83A','DB030','FR','0','Grotte du Proumeyssac','N_A','Grotte du Proumeyssac','N_A','FRE','N_A','14','0101000020E61000000004780B24E8ED3F0C630B410E724640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','14E1CD72-170B-4D92-BB3F-6C59F469700E','DB030','FR','0','Cro de Grandville Dite Grotte de Rouffignac','N_A','Cro de Grandville Dite Grotte de Rouffignac','N_A','FRE','N_A','15','0101000020E610000000CAAA083799EF3F7C573D601E814640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','E787F64C-EB7E-4485-8A38-0B36903B7791','DB030','FR','0','Village Troglodyte Abri de la Madeleine','N_A','Village Troglodyte Abri de la Madeleine','N_A','FRE','N_A','16','0101000020E610000080D367075C77F03FC42B499EEB7B4640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','987E9D7C-9659-4F7C-9121-B35374849042','DB030','FR','0','UNK#Grotte','N_A','UNK#Grotte','N_A','FRE','N_A','17','0101000020E610000080CAA7C7B6ACF03FAC92C83EC8784640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','9B66A8FD-62DE-453B-A43C-3CD7866F8DD4','DB030','FR','0','Abri du Cro-Magnon','N_A','Abri du Cro-Magnon','N_A','FRE','N_A','18','0101000020E610000080C286A7572AF03FC837143E5B784640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','2FDD1686-CDCA-4CF5-AA77-F7F18306D350','DB030','FR','0','Grotte du Font de Gaume','N_A','Grotte du Font de Gaume','N_A','FRE','N_A','19','0101000020E610000080DAFF006B75F03F88C954C1A8774640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','04A72590-2D5D-4231-BB15-79CC39865794','DB030','FR','0','Grotte du Grand Roc','N_A','Grotte du Grand Roc','N_A','FRE','N_A','20','0101000020E6100000002716F88AEEEF3F8CE1EA0088794640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','A4B66D98-C644-41EA-A769-55086A0DC11A','DB030','FR','0','Abri','N_A','Abri','N_A','FRE','N_A','21','0101000020E6100000004C55DAE2FAF03F34384A5E9D7F4640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','9C3C472D-DDD2-4393-A655-284CF01195A4','DB030','FR','0','Roque Saint-Christophe et Pas du Mirroir','N_A','Roque Saint-Christophe et Pas du Mirroir','N_A','FRE','N_A','22','0101000020E61000008053211E8917F13F44EF8D21007E4640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','6AE4BE45-22CE-45AD-BC2B-8E4FF8328D5F','DB030','FR','0','Abri Préhistorique du Cap Blanc','N_A','Abri Prehistorique du Cap Blanc','N_A','FRE','N_A','23','0101000020E610000000540262128EF13F408386FE09794640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','F59BD9F5-AF0D-4A69-95BD-5981CA0F00AA','DB030','FR','0','Grotte de Bernifal','N_A','Grotte de Bernifal','N_A','FRE','N_A','24','0101000020E6100000002E58AA0B18F13F804B00FE29774640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','6ED6D95C-7F80-4FC0-AC37-977C0D6DF7A0','DB030','FR','0','Grotte de Lascaux','N_A','Grotte de Lascaux','N_A','FRE','N_A','25','0101000020E610000080D270CADCBCF23FD8C743DFDD864640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','C41C9534-EC53-432D-A094-51CD1CD995F7','DB030','FR','0','Grotte de Saint-Antoine','N_A','Grotte de Saint-Antoine','N_A','FRE','N_A','26','0101000020E610000080F110C64F83F83FCC586DFE5F924640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','CF47E27A-2406-45A5-B012-F06A099F7FA9','DB030','FR','0','Grottes de Lamouroux','N_A','Grottes de Lamouroux','N_A','FRE','N_A','27','0101000020E6100000007AE57ADB6CF83FF8BD86E0B88E4640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','21E3F806-01D0-42DE-9C70-01B68DFA1ADA','DB030','FR','0','Abîmes de la Fage','N_A','Abimes de la Fage','N_A','FRE','N_A','28','0101000020E6100000000EDE57E562F83FDCCD8C7E348A4640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','06E2748E-417A-477D-AB8D-E3356171EEBC','DB030','FR','0','Blagour Gouffre','N_A','Blagour Gouffre','N_A','FRE','N_A','29','0101000020E6100000003B1DC87ACAF73FBC2BBB6070774640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','0B4F84CC-FC3C-4E87-A3B7-2AB025379678','DB030','FR','0','Grottes de Lacave','N_A','Grottes de Lacave','N_A','FRE','N_A','30','0101000020E610000080272EC72BF0F83F5422895E466C4640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','CF49A216-0CA2-4489-BD09-CA86D828E5DE','DB030','FR','0','Gouffre de Padirac','N_A','Gouffre de Padirac','N_A','FRE','N_A','31','0101000020E610000000AFEFC34102FC3F1C87FA5DD86D4640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','FDC412D4-01DE-4B51-B140-447A4983CCBD','DB030','FR','0','Grotte de Presque','N_A','Grotte de Presque','N_A','FRE','N_A','32','0101000020E610000080E620E86875FD3FC458DFC0E46C4640');
INSERT INTO "physp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ident",the_geom) VALUES ('1','43B6FEC2-3DE8-458C-97BB-700DE3471CFF','DB030','FR','0','UNK#Grotte','N_A','UNK#Grotte','N_A','FRE','N_A','33','0101000020E610000060FBAD9D280917404C287D21E4A94540');
