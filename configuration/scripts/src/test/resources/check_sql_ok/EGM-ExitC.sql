SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "exitc" (gid serial PRIMARY KEY,
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
"nln2" varchar(3));
SELECT AddGeometryColumn('','exitc','the_geom','4326','POINT',2);
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','711D03BE-3266-42AD-802B-1150665512E5','AQ090','MD#RO','0','Cahul','Oancea','Cahul','Oancea','MOL','RUM','0101000020E6100000C864389ECF1E3C404C13B69F8CF54640');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','93ADBCE3-CCA1-451A-B780-49BBA0C4A7CD','AQ090','MD#RO','0','Giurgiulesti','Galati','Giurgiulesti','Galati','MOL','RUM','0101000020E6100000E87E4E417E323C4060A3ACDF4CBC4640');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','EE4114C6-ADB9-4197-93C0-AC5F50AD5E90','AQ090','HU#RO','0','Csengersima','Petea','Csengersima','Petea','HUN','RUM','0101000020E6100000D8A3703D0AC73640E03312A111ED4740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','0915A1F3-0491-437B-8639-4A30E2C91427','AQ090','HU#RO','0','Nyírábrány','Valea lui Mihai','Nyirabrany','Valea lui Mihai','HUN','RUM','0101000020E6100000D0764CDD950736405467B5C01EC34740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','D2937544-3640-4B96-84CD-063B85B10F4A','AQ090','HU#RO','0','Ártánd','Bors','Artand','Bors','HUN','RUM','0101000020E6100000E0FDF15EB5CA3540B81CAF40F48F4740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','05A334E4-3F06-4F8E-B277-D1864174D919','AQ090','HU#RO','0','Ártánd','Bors','Artand','Bors','HUN','RUM','0101000020E6100000B80DA32078CA3540B0E94141298F4740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','5A682980-9266-4E14-B260-A5A7817C6BD3','AQ090','HU#RO','0','Gyula','Varsand','Gyula','Varsand','HUN','RUM','0101000020E61000002811A8FE41543540043FAA61BF504740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','C1BC96A0-28B1-4668-B3E2-09E590F6544C','AQ090','HU#RO','0','Lökösháza','Curtici','Lokoshaza','Curtici','HUN','RUM','0101000020E6100000D80968226C40354014AE47E17A344740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','FB40D42C-E767-4561-B15A-FFB43BB618E8','AQ090','HU#RO','0','Nagylak','Nadlac','Nagylak','Nadlac','HUN','RUM','0101000020E61000003023BC3D08B73440A0478C9E5B154740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','A7EE682A-DFF7-4491-AF67-E745682432B6','AQ090','HU#RO','0','Kiszombor','Cenad','Kiszombor','Cenad','HUN','RUM','0101000020E610000040F0F8F6AE7B344090A7E507AE144740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','839C5466-8EBB-4B40-84EF-D51146ECED97','AQ090','RO#UA','0','Câmpulung la Tisa','???????','Campulung la Tisa','Teresva','RUM','UKR','0101000020E6100000B092567C43BD37401430BABC39FF4740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','8BB354A1-7EAB-4CD9-8675-8121B8821D0D','AQ090','RO#UA','0','Valea Viseului','??????','Valea Viseului','Dilove','RUM','UKR','0101000020E610000040D862B7CF2A384090291F82AAF54740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','75D25A51-D05F-4D03-8A68-15458498208B','AQ090','RO#RS','0','Stamora - Moravita','UNK','Stamora - Moravita','UNK','RUM','N_A','0101000020E610000098F0845E7F403540C452245F099F4640');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1',NULL,'AQ090','BG#RO','0','UNK','Ostrov','UNK','Ostrov','N_A','RUM','0101000020E610000010691B7FA2463B405C18E945ED0E4640');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1',NULL,'AQ090','MD#RO','0','Stoianovca','Falciu','Stoianovca','Falciu','MOL','RUM','0101000020E610000000C974E8F4203C40B037312427214740');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','DF01B5AE-4CAA-454C-B8B7-D7A7FE887537','AQ090','LV#RU','0','Vientuli','UNK','Vientuli','UNK','LAV','N_A','0101000020E6100000808769DFDCC53B40B0BCAB1E30914C40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','086966A9-971F-4E18-BE4D-60BD4633E5DF','AQ090','LV#RU','0','Grebneva','UNK','Grebneva','UNK','LAV','N_A','0101000020E6100000E08A8BA372D53B4044A33B889D6F4C40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','FEF8BC2B-4CEC-404B-B154-5FCE7A33CC94','AQ090','LV#RU','0','Terehova','UNK','Terehova','UNK','LAV','N_A','0101000020E6100000C836A968AC313C4034D1E7A38C2D4C40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','8BCEE372-B80E-45E9-AF3C-C581A6181CA8','AQ090','BY#LV','0','Paternieki','UNK','Paternieki','UNK','LAV','N_A','0101000020E610000038D384ED27A13B402410AFEB17E94B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','EAD9094F-8D83-4A0F-9713-5D00DED28222','AQ090','BY#LV','0','Silene','UNK','Silene','UNK','LAV','N_A','0101000020E610000098F3C5DE8BDF3A4088A8C29FE1DB4B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','60DAD67C-6932-4390-B3DB-C3C704D1A6A4','AQ090','LT#RU','0','Nida','N_A','Nida','N_A','LIT','N_A','0101000020E6100000E88A5242B0F63440A874B0FECFA34B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','3FF6C8BA-2E0F-408A-A3DE-C21271E79F32','AQ090','BY#LT','0','Adutiškis','N_A','Adutiskis','N_A','LIT','N_A','0101000020E6100000484F9143C49F3A40AC7AF99D26934B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','A5A11CEE-B659-4DB2-86E1-7C32E0816F0F','AQ090','LT#RU','0','Pagegiai','N_A','Pagegiai','N_A','LIT','N_A','0101000020E610000078E272BC02E33540ACD7F4A0A08B4B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','05940295-588E-4EEB-A06E-5BD757DF0966','AQ090','BY#LT','0','Papelekis','N_A','Papelekis','N_A','LIT','N_A','0101000020E61000004870EA03C9413A4048E6913F188B4B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','B1853188-1739-4EB6-B225-738C1828D2F1','AQ090','LT#RU','0','Panemune','N_A','Panemune','N_A','LIT','N_A','0101000020E610000090DE701FB9E7354088A2409FC88A4B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','63F173BF-FE2A-4620-A014-1AA3573807B3','AQ090','LT#RU','0','Sudargas','N_A','Sudargas','N_A','LIT','N_A','0101000020E6100000E803029D4997364088C613419C874B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','0E15DBEC-6C43-4C50-9856-F7C2BA7D6365','AQ090','BY#LT','0','Geledne','N_A','Geledne','N_A','LIT','N_A','0101000020E61000000833A6608D1D3A40D0A0A17F827E4B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','09D7940B-5EC5-4054-8E42-1104B90FAF21','AQ090','BY#LT','0','Lavoriškes','N_A','Lavoriskes','N_A','LIT','N_A','0101000020E61000001018EB1B98BE3940107EE200FA5B4B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','1B12AA88-2F48-4004-A053-27FEC290F291','AQ090','LT#RU','0','Kybartai','N_A','Kybartai','N_A','LIT','N_A','0101000020E6100000C0823463D1BE36401893FE5E0A524B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','6A1AF1E2-6385-4212-9499-1F75531430DB','AQ090','LT#RU','0','Kybartai','N_A','Kybartai','N_A','LIT','N_A','0101000020E6100000A83B4F3C67BF3640E4C62DE6E7514B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','0981E9A6-34B8-4A57-8B8C-636F3FFDB836','AQ090','BY#LT','0','Kena','N_A','Kena','N_A','LIT','N_A','0101000020E610000000FDF7E0B5C139405467B5C01E4C4B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','506B787A-65C4-4A31-BF04-0558E97B29FF','AQ090','BY#LT','0','Medininkai','N_A','Medininkai','N_A','LIT','N_A','0101000020E6100000A83B4F3C67B339403877BB5E9A454B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','70B2B139-7588-400C-92C4-D253D5B47607','AQ090','BY#LT','0','Šalcininkai','N_A','Salcininkai','N_A','LIT','N_A','0101000020E610000058677C5F5C603940809C306134234B40');
INSERT INTO "exitc" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2",the_geom) VALUES ('1','1EECB398-1955-451E-B514-407859B21595','AQ090','BY#LT','0','Stasylos','N_A','Stasylos','N_A','LIT','N_A','0101000020E6100000F0B4FCC0555A3940E8633E20D0214B40');
