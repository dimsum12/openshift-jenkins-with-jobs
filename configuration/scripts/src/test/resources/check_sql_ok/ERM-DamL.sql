SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "daml" (gid serial PRIMARY KEY,
"fcsubtype" int4,
"gfid" varchar(38),
"f_code" varchar(5),
"icc" varchar(5),
"sn" int2,
"shape_leng" numeric);
SELECT AddGeometryColumn('','daml','the_geom','4326','MULTILINESTRING',2);
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','C4E3E18E-E099-41EC-90C6-714DD29DC78A','BI020','FR','0','1.54513146690e-003','0105000020E6100000010000000102000020E61000000200000020AB3FC230701240D4A0681EC0F648408038656EBE711240742D5A80B6F64840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','DD2911AA-551A-4AF7-BCB8-1F856BF2AFC9','BI020','FR','0','1.12281298532e-003','0105000020E6100000010000000102000020E6100000020000008038656EBE711240742D5A80B6F6484040EE7893DF7212408C9CBE9EAFF64840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','6397BA58-E9CB-464A-A74E-0C9EDC38E530','BI020','FR','0','2.44236115266e-003','0105000020E6100000010000000102000020E610000002000000C0954220975812400C630B410EF04840E0211B48175B1240E012B9E00CF04840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','BB2DB9F0-C23B-4406-A01B-E598C31490AA','BI020','FR','0','8.86135570901e-004','0105000020E6100000010000000102000020E610000002000000E0211B48175B1240E012B9E00CF04840C03A8F8AFF5B1240C013B35E0CF04840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','FE7B6F37-188E-4F51-B3A0-05CA7CE204E8','BI020','FR','0','3.06794279608e-003','0105000020E6100000010000000102000020E610000002000000403048FAB42A13402CF38FBE49C34840401B9DF3532C134044EC4CA1F3C24840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','1585F6A9-F2F7-4FB6-A0F1-F7C6C6C01FC8','BI020','FR','0','6.44085592145e-004','0105000020E6100000010000000102000020E610000002000000401B9DF3532C134044EC4CA1F3C2484000273108AC2C134088A8C29FE1C24840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','DA353C84-D453-4A82-BC88-FC24FB1FE867','BI020','FR','0','3.62566959333e-003','0105000020E6100000010000000102000020E610000002000000C033BE2F2E550D40A8B915C26ABB4840C08427F4FA530D40C0378600E0BB4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','E7BBF285-84F3-4F78-BF9A-38E984FEECCE','BI020','FR','0','2.50735896911e-003','0105000020E6100000010000000102000020E61000000200000000639B5434560D40F066463F1ABB4840C033BE2F2E550D40A8B915C26ABB4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','BD8D57F7-98CA-4572-8001-CBE1D7C504FD','BI020','FR','0','4.43891763863e-003','0105000020E6100000010000000102000020E6100000030000008016C09481C3F33FDC006C4084A74840009450FA42C8F33F742D5A80B6A74840008E412784CEF33F6CFD2D01F8A74840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','14EE9D49-49F3-49B4-B6E4-6373A94979B1','BI020','FR','0','4.43145892231e-003','0105000020E6100000010000000102000020E6100000040000006099B85510731640A498BC0166A24840C01727BEDA711640148AADA069A2484080D2DF4BE171164060B532E197A24840E0D3B9A2947016401051853FC3A24840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','B402CB70-9CAA-48C5-8E1B-3607516FEB8F','BI020','FR','0','3.47863682275e-003','0105000020E6100000010000000102000020E61000000300000000FF43FAED2BF63FFCA8BF5E6195484000498446B031F63FA47A6B60AB95484000DA74047033F63FBC10AB3FC2954840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','6724A777-A75B-40B5-8D1C-8473D28F47F1','BI020','FR','0','2.46343383309e-003','0105000020E6100000010000000102000020E61000000200000040A243E048D01B40F07211DF89814840E0B9F8DB9ED01B40541F48DE39814840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','401FEB8A-A3B6-4F3F-AC92-E55455DAE002','BI020','FR','0','3.87230864945e-003','0105000020E6100000010000000102000020E61000000300000080757286E2AE1340F4B4FCC05578484080F46A80D2B01340CC5EEFFE787848408028603B18B113400C7BDAE1AF784840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','E9349753-6411-464D-B118-92FB31ED2D1A','BI020','FR','0','3.74652097150e-002','0105000020E6100000010000000102000020E61000000A00000000228C9FC6ED1640D8F19881CA774840A0C6BE64E3F116401890F63FC07748408037FA980FF8164064AFB0E07E77484000804754A8FE164054616C21C87648406083BF5FCC061740CCA65CE15D764840C0B3E89D0A0817400406499F56764840803315E2910817404810E7E104764840A0909E2287081740ACC29FE1CD754840405C1D0071071740E83FA4DFBE754840802EFEB6270817409814580053754840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','D569F95E-868F-40FB-B40E-2CEA989A8D72','BI020','FR','0','1.74198880595e-003','0105000020E6100000010000000102000020E610000002000000608B6CE7FBD91640CCACDEE1766D4840A0156EF948DA16405840A19E3E6D4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','BF539774-CDA4-413F-A89D-EA25E2EB92B3','BI020','FR','0','5.33888565151e-004','0105000020E6100000010000000102000020E61000000200000080BD86E0B80CF1BF387D76C075664840801A9E5E290BF1BF9C5FCD0182664840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','60B92F92-DF5B-43BB-94AD-5420DEFA8F43','BI020','FR','0','1.23221923780e-003','0105000020E6100000010000000102000020E61000000200000080C14EB16A10F1BF74F7393E5A66484080BD86E0B80CF1BF387D76C075664840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','FD9A1267-C6A1-4365-9E96-E892D179B758','BI020','FR','0','4.49750123456e-002','0105000020E6100000010000000102000020E61000000800000060E2E5E95C01134024020EA14A4D484040CD3B4ED1011340C88EC6A17E4D4840E0C56D348007134034410DDFC24D4840C0764D486B0C134070E525FF934D4840E0172653051313401C93FE5E0A4D484000ED9DD15615134000C4961E4D4D4840A0AE44A0FA1713407424D060534D48404075029A082B1340C4525DC0CB4C4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','20DD1792-0670-44CE-8ECF-8110D10CC7AE','BI020','FR','0','1.47948580595e-003','0105000020E6100000010000000102000020E610000002000000804E5AB8ACC2F3BF54465C001A4A4840805DD89AADBCF3BF10846401134A4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','5F6D8ADD-3E5F-4242-8756-774FFEAD7ABF','BI020','FR','0','1.70096570557e-003','0105000020E6100000010000000102000020E610000003000000805DD89AADBCF3BF10846401134A484000C6DCB584BCF3BFD094D6DF124A48408096AAB4C5B5F3BFF0B1F4A10B4A4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','D83851FC-F7BA-4262-80F9-3D4111888443','BI020','FR','0','1.57661372251e-001','0105000020E6100000010000000102000020E61000003300000040B5A50EF20A13407842E8A04B474840C0F38C7DC9061340A89542209747484060E257ACE1021340041B1021AE474840A08CB96B09F912405031074147474840C0249694BBEF1240A498BC0166474840202368CC24EA1240EC93DC6113474840807B82C476E71240F0B1F4A10B474840403BFDA02EE212408CF9B9A12947484080757286E2DE1240EC8711C2A347484080C345EEE9DA12405C94D920934748408034F279C5D312409826A5A0DB474840E0A0681EC0D2124048BC75FEED47484040DE736039D212401CE1ED4108484840C03924B550D2124008FA449E24484840801135D1E7D3124064AC6F607248484000B3EDB435D212408878245E9E48484000653733FAD11240407D04FEF048484060F01472A5CE1240DCD30E7F4D4948406045D5AF74CE124024DBF97E6A4948406078094E7DD01240081555BFD2494840E07630629FD01240940BCEE0EF494840C03E575BB1CF1240CCA0DAE0444A484080FCA6B052D1124068F4A3E1944A4840007FDC7EF9D41240345C1D00714A48408010E6762FD71240A02FF65E7C4A4840C095D05D12D7124084785DBF604A4840801D39D219D812408054C37E4F4A4840E04D621058D912407C849A21554A48406057E9EE3ADB1240B8C876BE9F4A4840404D11E0F4DE124024C0E95DBC4A484040B8AD2D3CDF1240504354E1CF4A4840E03BC09316DE12401C87FA5DD84A484020AC1C5A64DB124074E5EC9DD14A484020E09F5225DA1240F0815660C84A4840A0AE44A0FAD7124064D34A21904A4840C044679945D81240EC39E97DE34A4840A0E7FA3E1CD412404804E3E0D24A4840E02CD0EE90D212400C6F0F42404B48402088821953D01240D070033E3F4B4840E02BD7DB66CA1240587C43E1B34B484040E868554BCA1240F4C98AE1EA4B4840A0FAEB1516CC1240D48E1B7E374C4840805B3FFD67CD1240042D5DC1364C4840A04F8F6D19D01240082D2460744C484080096B63ECD41240D07344BE4B4C4840601059A489D7124058707841444C4840403196E997D812402C44C021544C4840E04EB16A10D61240B8C5353E934C4840A0F7713447D61240B8D100DE024D4840A0A2957B81D91240544CDE00334D4840A0BA48A12CDC124048EC1340314D4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','BCE9EEAD-5E72-4F0F-8C97-8D9BF7488A48','BI020','FR','0','1.17413321311e-002','0105000020E6100000010000000102000020E61000000300000040B682A62516134028E4839ECD464840E05F05F86E1313401033349E0847484040B5A50EF20A13407842E8A04B474840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','E2A43E7B-BFCE-4AB7-9CE2-FE1BBA48AB5A','BI020','FR','0','1.38404777736e-003','0105000020E6100000010000000102000020E610000002000000006D567DAE361F4020F98381E74548406060014C19381F4044E90B21E7454840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','DD4769BD-CE00-474E-8619-A4ED7917DE13','BI020','FR','0','2.10539346391e-002','0105000020E6100000010000000102000020E61000000400000000B612BA4B021240E4361AC05B2D4840205454FD4A071240D0A0A17F822D4840007C629D2A0F124028F911BF622D4840A0992842EA161240144E0B5EF42C4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','F5089A07-5EA3-47B3-B732-2E547116CC53','BI020','FR','0','3.84903471666e-003','0105000020E6100000010000000102000020E61000000200000020FA7DFFE6D51140B4AA5E7EA72C484080C9E369F9D111409C17601F9D2C4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','6488FCAD-DA15-4C12-AB72-7B0B86313F1E','BI020','FR','0','1.28737723916e-002','0105000020E6100000010000000102000020E6100000030000008033A31F0DF7114024E4BCFF8F2C48404075029A08FB114024D26F5F072D484000B612BA4B021240E4361AC05B2D4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','115C79F5-F9B5-4D22-9428-96A3305293A5','BI020','FR','0','3.89537123085e-002','0105000020E6100000010000000102000020E61000000600000080C9E369F9D111409C17601F9D2C4840E0347EE195C41140F04E779E782C484080643BDF4FBD114094DB2F9FAC2B4840A0331477BCB911403CA11001872B4840A0DE701FB9B5114004124DA0882B4840800A647616AD1140D0B56801DA2B4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','F6E26697-C676-4BB3-8CEF-27C5E5DC88DD','BI020','FR','0','7.15021843035e-002','0105000020E6100000010000000102000020E61000000C000000800A647616AD1140D0B56801DA2B4840A0F7E3F6CBA71140A03BC1FEEB2B484060EB538EC9921140542E8D5F782B484040C11BD2A8901140EC84D041972A4840004FB0FF3A871140186F641EF9294840400C7558E18611400C4B3CA06C294840C0EBDE8AC48411401063D2DF4B294840C0560A815C821140809065C1C42848406036ACA92C7A1140D8FA22A12D284840E0779B374E7A11406070067FBF27484020C66CC9AA78114094239D8191274840A0EE59D76879114000C7D79E59274840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','0272034F-B4EA-4511-BBF2-FCFC5E8B5B6D','BI020','FR','0','2.78252408652e-003','0105000020E6100000010000000102000020E610000004000000E023B891B2A51140A8B6D4415E204840A0D6355A0EA4114044DAFF006B204840A0F4DBD781A31140DCFAE93F6B204840C006616EF7A21140082D246074204840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','2E55400A-74EA-49C9-8260-394FEE5853DB','BI020','FR','0','7.91455806571e-002','0105000020E6100000010000000102000020E610000012000000C0F2AFE5953B114044EC4CA1F31F484080D6A71C93351140B80A62A06B204840C012109370311140D8A9F23D23214840E0A44DD53D32114044E90B21E7214840807B82C47637114040B0E3BF40224840E0285DFA97341140981799805F22484040FF21FDF6351140C852245F09234840604772F90F3911403C8F8AFF3B234840C0506B9A773C11409435EA211A23484060539275383A1140BCE68EFE972348408039B4C8763E1140389886E123244840202E8F352343114020FCC401F4234840003049658A491140A877F17EDC23484000863B17464A1140A06B98A1F1234840E0D18E1B7E4711409017D2E1212448400090300C58421140189CC1DF2F24484060A7751BD43E11401881B1BE8124484060310741473B114018B4C9E193244840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','160EC7E1-0D81-4546-8B34-CC1A67D331CE','BI020','FR','0','3.33761591921e-002','0105000020E6100000010000000102000020E610000005000000E0EFA65B76581140504354E1CF204840E0C41F459D491140C0FE243E771F48404018231285461140805182FE421F4840E02346CF2D4411402C44C021541F4840C0F2AFE5953B114044EC4CA1F31F4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','33A71422-282D-446A-BFB3-24FC3BC8795F','BI020','FR','0','1.78350687072e-003','0105000020E6100000010000000102000020E61000000400000040D65416851D0A4028F0879FFF1B4840C0029A081B1E0A40C85565DF151C484040A7E8482E1F0A4068B5C01E131C4840C0F52A323A200A406C03B001111C4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','A0BA09DC-76AD-4C2E-89D5-B91F07209B08','BI020','FR','0','1.08606272838e-003','0105000020E6100000010000000102000020E610000002000000E04752D2C3981E4094C01F7EFE1A48404061342BDB971E4010846401131B4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','91C6DACF-C2AB-4F6E-B0D1-DE37441F4D0C','BI020','FR','0','1.18841669879e-003','0105000020E6100000010000000102000020E61000000200000080923A014D2408C0F89CF4BEF1184840C0D8B27C5D2608C0D091955F06194840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','34CBC249-6F18-4BBE-AF07-8EAF414F271B','BI020','FR','0','1.34061898018e-003','0105000020E6100000010000000102000020E61000000200000080D6506A2F2208C000D6E3BED518484080923A014D2408C0F89CF4BEF1184840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','75FF7143-0096-4CBD-9A1B-71871AD45714','BI020','FR','0','3.39647409089e-003','0105000020E6100000010000000102000020E61000000200000000525BEA202FEFBF2CED0DBE300E484000C891CEC048EFBF7C51BB5F050E4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','EA96B550-C117-43A9-A68D-8113C29B4BBF','BI020','FR','0','1.07563934490e-004','0105000020E6100000010000000102000020E61000000200000000C891CEC048EFBF7C51BB5F050E4840004526E0D748EFBF941150E1080E4840');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','18C022B6-D17E-4DD3-BCDE-2518AE8E9D9F','BI020','FR','0','3.86047924481e-004','0105000020E6100000010000000102000020E61000000200000060D7A19A926C1540185D177E70F547402012143FC66C15404CEF1B5F7BF54740');
INSERT INTO "daml" ("fcsubtype","gfid","f_code","icc","sn","shape_leng",the_geom) VALUES ('1','4C5BD17C-C6B4-4B81-9BC4-E4F98CD75965','BI020','FR','0','2.61173122660e-003','0105000020E6100000010000000102000020E610000002000000801CEA77616B1540389886E123F5474060D7A19A926C1540185D177E70F54740');