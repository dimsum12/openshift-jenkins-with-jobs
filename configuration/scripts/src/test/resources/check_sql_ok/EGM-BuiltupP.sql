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
"pp2" int4);
SELECT AddGeometryColumn('','builtupp','the_geom','4326','POINT',2);
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','4368E138-54CF-4AF8-B4B3-130AC3F11913','AL020','FI','2010','Jääli','N_A','Jaali','N_A','FIN','N_A','3952','-29997','-29997','0101000020E610000070512D228AAD39407C6308000E465040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','7BEDF4E6-990F-47A2-930A-A46256AB05D4','AL020','FI','2010','Ylikiiminki','N_A','Ylikiiminki','N_A','FIN','N_A','985','-29997','-29997','0101000020E610000048E350BF0B273A40BC1C76DFB1415040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','D771216D-36CA-406D-A68D-8A4A12AC5E86','AL020','FI','2010','Hailuoto','N_A','Hailuoto','N_A','FIN','N_A','689','-29997','-29997','0101000020E610000048B9347EE1B93840260516C094405040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','6EC66DD6-FD3A-4EA7-87FA-B03FAE9A456A','AL020','FI','2010','Oulunsalo','N_A','Oulunsalo','N_A','FIN','N_A','7437','-29997','-29997','0101000020E6100000A0772AE09E6B39401AA88C7F1F3C5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','468BD571-E64C-446E-863E-47FE2CABFE19','AL020','FI','2010','Kempele','N_A','Kempele','N_A','FIN','N_A','14085','-29997','-29997','0101000020E61000007815527E52833940E869C020693A5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','9AD3BE73-FB0D-4024-8E6D-1DB62B2E6CA2','AL020','FI','2010','Suomussalmi','N_A','Suomussalmi','N_A','FIN','N_A','1424','-29997','-29997','0101000020E6100000481FF30181003D40545227A089395040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','D4AE3C70-900E-4509-8080-81CD3D8E3FB4','AL020','FI','2010','Ämmänsaari','N_A','Ammansaari','N_A','FIN','N_A','10400','-29997','-29997','0101000020E6100000281A6B7F67F33C405C8E5720FA375040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','CB428A3B-33F4-4533-A27F-6852982C1D1B','AL020','FI','2010','Puolanka','N_A','Puolanka','N_A','FIN','N_A','2450','-29997','-29997','0101000020E6100000C8D3B9A294AA3B40B6DD04DFB4375040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','89C82B7F-0C1C-47D7-82E9-40A6CCE4BE5F','AL020','FI','2010','Lumijoki','N_A','Lumijoki','N_A','FIN','N_A','1100','-29997','-29997','0101000020E610000028E4839ECD2E3940A48FF98040355040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','92853EBA-013F-4EDD-BFD8-42EFD0EF31AE','AL020','FI','2010','Keskikylä','N_A','Keskikyla','N_A','FIN','N_A','571','-29997','-29997','0101000020E6100000D0F1D1E28CC33840981AA19FA9335040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','5334AE93-54C1-4B24-AF18-EBF7B1388DDF','AL020','FI','2010','Muhos','N_A','Muhos','N_A','FIN','N_A','4383','-29997','-29997','0101000020E610000098F38C7DC9FE3940F6B704E09F335040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','15CB9102-F457-4548-A402-2948FB8534A0','AL020','FI','2010','Liminka','N_A','Liminka','N_A','FIN','N_A','3257','-29997','-29997','0101000020E6100000B80D6ABFB56539403CBCE7C072335040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','31C48E87-6C30-4F93-A3F5-01E4189FF208','AL020','FI','2010','Tyrnävä','N_A','Tyrnava','N_A','FIN','N_A','2180','-29997','-29997','0101000020E6100000F0936A9F8EA73940D0BBB1A0B0305040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','3B2E08A6-EB34-4D86-A15D-377282154FFD','AL020','FI','2010','Utajärvi','N_A','Utajarvi','N_A','FIN','N_A','1387','-29997','-29997','0101000020E6100000986E1283C06A3A40F6B182DF86305040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','A9F47CFA-695C-4334-9EF4-CF283EEE7A98','AL020','FI','2010','Revonlahti','N_A','Revonlahti','N_A','FIN','N_A','441','-29997','-29997','0101000020E61000000812143FC6F238401060915FBF2D5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','7CC8369B-C650-4FEA-8964-A5A8C7EBE419','AL020','FI','2010','Pattijoki','N_A','Pattijoki','N_A','FIN','N_A','6700','-29997','-29997','0101000020E6100000E8060ABC93933840761E15FFF72B5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','64037870-A876-4337-B718-97B7777C9A29','AL020','FI','2010','Raahe','N_A','Raahe','N_A','FIN','N_A','13000','-29997','-29997','0101000020E6100000C8C7EE02257738401EE1B4E0452B5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','3354B83D-F750-4EC6-BB3A-14A835C0ED9D','AL020','FI','2010','Hyrynsalmi','N_A','Hyrynsalmi','N_A','FIN','N_A','2505','-29997','-29997','0101000020E61000001875ADBD4F833C40940ED6FF392B5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','A563C208-844D-4FAE-89C2-F9D890D160B0','AL020','FI','2010','Ruukki','N_A','Ruukki','N_A','FIN','N_A','1278','-29997','-29997','0101000020E610000018450F7C0C163940CE91955F862A5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','5B395E3B-3745-4F63-8955-EE4FE1490839','AL020','FI','2010','Saloinen','N_A','Saloinen','N_A','FIN','N_A','1452','-29997','-29997','0101000020E610000048BFB67EFA753840C682C2A04C295040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','2C01AC1C-CBFF-4D9F-9AD2-8DFF9855A703','AL020','FI','2010','Paavola','N_A','Paavola','N_A','FIN','N_A','534','-29997','-29997','0101000020E6100000D088997D1E333940FCFCF7E0B5265040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','77D81088-6CFA-4CEB-8C34-6527FB063C47','AL020','FI','2010','Piehinki','N_A','Piehinki','N_A','FIN','N_A','414','-29997','-29997','0101000020E610000040DAFF006B67384086AB03206E245040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','66A45FCF-5C86-4B67-AE19-9A901EB5B61B','AL020','FI','2010','Vaala','N_A','Vaala','N_A','FIN','N_A','1772','-29997','-29997','0101000020E610000038BF28417FD53A40C04351A0CF235040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','5E73CCF3-DACC-408F-8CDD-4F0C1FBF9B86','AL020','FI','2010','Rantsila','N_A','Rantsila','N_A','FIN','N_A','901','-29997','-29997','0101000020E6100000D08558FD11AA3940742A19002A205040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','AE509522-CE53-4592-87D8-59ED84E1AFB3','AL020','FI','2010','Ristijärvi','N_A','Ristijarvi','N_A','FIN','N_A','882','-29997','-29997','0101000020E610000068A9BC1DE1363C40A8A44E40931F5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','B7774E3F-6DFE-4513-AD86-9A59B95891A8','AL020','FI','2010','Vihanti','N_A','Vihanti','N_A','FIN','N_A','1549','-29997','-29997','0101000020E6100000803CF4DDADFC384092E7FA3E1C1F5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','417551CF-507E-4DC3-A7B7-B9261AC52B67','AL020','FI','2010','Parhalahti','N_A','Parhalahti','N_A','FIN','N_A','395','-29997','-29997','0101000020E6100000E0180280635138400436E7E0191F5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','5D519131-83D7-489E-9206-6EB58A2D8E58','AL020','FI','2010','Pyhäjoki','N_A','Pyhajoki','N_A','FIN','N_A','2110','-29997','-29997','0101000020E6100000F054C03DCF453840A053909F0D1E5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','5AB3DE72-3A9D-4BF9-903B-98C46A4E0218','AL020','FI','2010','Säräisniemi','N_A','Saraisniemi','N_A','FIN','N_A','278','-29997','-29997','0101000020E6100000906B0A6476CA3A406AD619DF971C5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','0982E906-47B4-4EFF-9439-A152F3CC5C22','AL020','FI','2010','Alpua','N_A','Alpua','N_A','FIN','N_A','254','-29997','-29997','0101000020E6100000782AE09EE7393940D09D60FFF51A5040');
INSERT INTO "builtupp" ("fcsubtype","gfid","f_code","icc","sn","namn1","namn2","nama1","nama2","nln1","nln2","ppl","pp1","pp2",the_geom) VALUES ('1','C033B268-3A00-4591-B512-4974416FFD6D','AL020','FI','2010','Paltamo','N_A','Paltamo','N_A','FIN','N_A','3231','-29997','-29997','0101000020E61000005858703FE0D53B40D09D60FF751A5040');
