SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "damc" (gid serial PRIMARY KEY,
"fcsubtype" int4,
"gfid" varchar(38),
"f_code" varchar(5),
"icc" varchar(5),
"sn" int2);
SELECT AddGeometryColumn('','damc','the_geom','4326','POINT',2);
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','C234E934-EB8D-4692-B8F8-BA894564E77D','BI020','BE#FR','0','0101000020E61000008082FE428F180640409B559FAB624940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','28E39BD2-305C-47D4-A20F-9CC0E15F9D60','BI020','BE#FR','0','0101000020E6100000407CB60E0EF60640E42D90A0F8594940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','48C194BE-C1B6-49A7-B958-29AE298A98D7','BI020','FR','0','0101000020E6100000800BEC319152FC3F6CF46A80D2574940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','C860AFDD-B2BA-48BC-8979-B6EA24495991','BI020','FR','0','0101000020E610000000E73BF88903FF3F040CCB9F6F344940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','49AC2982-E3E3-4108-833C-4EE147101BEB','BI020','FR','0','0101000020E610000080E04735EC570040A4772AE09E304940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','C20D4FF6-28DA-457F-B211-B0BF40E38860','BI020','FR','0','0101000020E610000000938FDD058A004000EEB25F77204940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','81C41B2B-DADB-48E4-BF29-3DA5B0291566','BI020','FR','0','0101000020E6100000C03F51D9B0460140EC60FD9FC31B4940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','F420C6E5-2256-4F78-916E-085AA54E8D55','BI020','FR','0','0101000020E610000080C1FD80078601403035423F531A4940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','3D04F3C8-380D-490B-805A-1C99A776ECA2','BI020','FR','0','0101000020E610000040EEEBC039230240A87A32FFE8154940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','50C38127-D7FF-4F3C-8C37-3E22D4A25212','BI020','FR','0','0101000020E6100000C0B6D5AC339E02400009C38025144940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','EE4360B7-903A-44A2-98C9-A203659D687D','BI020','FR','0','0101000020E61000006091EEE7145413407C45F0BF95124940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','E4AFE2B2-97EF-4A87-856E-2A78977AA770','BI020','FR','0','0101000020E6100000E005A051BA141340D4E28C614E0E4940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','E00F8A27-7548-4D78-93F7-87106AACDE94','BI020','FR','0','0101000020E61000002062A06B5FF012405022C2BF080C4940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','2FA7B47B-42E5-4F00-81B4-F2CD1967B016','BI020','FR','0','0101000020E610000000744353763A1340EC633E20D00B4940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','BCF441FC-D3A8-4970-9413-6F203360D75A','BI020','FR','0','0101000020E6100000A0DAA84E07D2124088C09140830B4940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','105CEB70-C509-437F-9403-9A298893A56D','BI020','FR','0','0101000020E610000020EE79FEB43113400C151C5E100B4940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','C204BF5E-EFA6-4B93-BAD6-AF4D19F7C449','BI020','FR','0','0101000020E6100000802EFEB6274813409008C6C1A50A4940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','44621CE0-7999-4144-B2CD-E92CFD5EB33C','BI020','FR','0','0101000020E610000020C364AA60E41240241ADD41EC054940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','FB12FA20-3653-4912-97B2-30B63E663227','BI020','FR','0','0101000020E6100000E095B37746EB1240384DD87E32024940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','9EA9ABD4-AB63-4E5C-B675-D43A3A3D28BD','BI020','FR','0','0101000020E6100000A0484DBB98C6124014842BA050004940');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','E25D4B87-0869-412A-8870-95FF27B1BC36','BI020','FR','0','0101000020E610000080EF3845479200400833A6608DFD4840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','03AB1ED9-C9BC-414C-B623-944E90368207','BI020','FR','0','0101000020E6100000E099266C3FB91240D4E28C614EFD4840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','29C4A8D2-AB46-47A9-9294-BD74DFF73B61','BI020','FR','0','0101000020E610000040A25F5B3F1D0E4028F911BF62FA4840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','EF86CDE1-AD48-47AB-9C1C-0A14AD6AF9BB','BI020','FR','0','0101000020E6100000E093162EAB801240C464AA6054F74840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','32BF7A18-DDC4-4AE3-A2B3-3D193C47800D','BI020','FR','0','0101000020E610000040274D83A2B90C407C3C2D3F70F64840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','94F6BF76-58FD-4B79-A68E-003A7E152F99','BI020','FR','0','0101000020E6100000801DC70F95860C40E0274701A2F54840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','569332AA-B889-46E3-8A2E-CB4756A7DEE8','BI020','FR','0','0101000020E6100000A0E8D7D64FCF12409C417C60C7F44840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','BFF26CD0-275C-4511-B3C8-E6F3C0453315','BI020','FR','0','0101000020E6100000804ED1915C3E0240CC9D996038F44840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','8C4960E0-ABEF-4897-9AC8-CF02E3F00DB1','BI020','FR','0','0101000020E6100000E0C804FC1AB9124054103CBEBDF34840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','508DAAB6-4D0E-4E55-A27A-98D8017DC3E9','BI020','FR','0','0101000020E610000040174850FC780C4018B1886187F34840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','A9AD7DF8-A858-4B20-8B4A-2C63E983296F','BI020','FR','0','0101000020E610000040C1C6F5EF9A0D405C677C5F5CF34840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','C217EBC7-4DAA-4093-812C-B173FB15FCB6','BI020','FR','0','0101000020E6100000C0EAE6E26F9B0D4020E4F56052F34840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','3451444D-F42E-4A18-A5E6-C791C610383A','BI020','FR','0','0101000020E6100000802A1A6B7F270D4064B5F97FD5F24840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','DE56F43E-1ED6-42F6-86C4-60700C129076','BI020','FR','0','0101000020E61000008072F8A413F912401890F63FC0F04840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','7CB29155-1BDF-40C0-815D-AA3CB87FBC73','BI020','FR','0','0101000020E6100000805C8DEC4AEB1240E83922DFA5F04840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','D6EF4804-0640-4F56-83AA-6CC406C06A8D','BI020','FR','0','0101000020E610000020888219532013401C9FC9FE79F04840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','A30BECE5-68C9-4A77-AB05-7B7E7AFB0B27','BI020','FR','0','0101000020E6100000808D96033D041340807214200AEE4840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','03005E81-E3F3-4E76-BC91-BE01500857B4','BI020','FR','0','0101000020E6100000607AC37DE42613401C87FA5DD8ED4840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','412E2E46-1542-472B-A05E-78458B21D35B','BI020','FR','0','0101000020E61000000021AF0793021340F0815660C8EA4840');
INSERT INTO "damc" ("fcsubtype","gfid","f_code","icc","sn",the_geom) VALUES ('1','DE82E953-C43D-4B68-B11E-99D5810EF574','BI020','FR','0','0101000020E610000000DAE89C9F62EE3F34682101A3E74840');
