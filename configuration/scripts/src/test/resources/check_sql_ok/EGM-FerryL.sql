SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "ferryl" (gid serial PRIMARY KEY,
"fcsubtype" int4,
"gfid" varchar(38),
"f_code" varchar(5),
"icc" varchar(5),
"sn" int2,
"detn" varchar(50),
"deta" varchar(50),
"dnln" varchar(3),
"rsu" int4,
"use_" int4,
"ferryid" varchar(38),
"shape_leng" numeric);
SELECT AddGeometryColumn('','ferryl','the_geom','4326','MULTILINESTRING',2);
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','2','AQ070','FI','3470','N_A','N_A','N_A','1','4','FI0041FI0042','1.04152199329e-002','0105000020E6100000010000000102000020E61000000200000010AB7823F3963C40A8807B9E3FC64E403017F19D98993C400845F30016C64E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','2','AQ070','FI','3470','N_A','N_A','N_A','1','4','FI0125FI0126','1.42521751151e-001','0105000020E6100000010000000102000020E610000032000000E0E8633E20E835401C59F96530194E40A020787C7BE935409835B1C057194E40F0B3CA4C69E93540A0A014ADDC194E40F831E6AE25E835407C1D3867441A4E4068C36169E0E73540A01342075D1A4E40405E0F26C5E7354008103E94681A4E40E82A16BF29E635402C82FFAD641B4E4050DE0033DFE735407867EDB60B1C4E4050ABAFAE0AE8354080C34483141C4E40A08E8EAB91E9354094ACC3D1551C4E4058A7CAF78CEC3540302AA913D01C4E40206D1CB116EF35406CC9AA08371D4E40A09A92ACC3EF35400C790437521D4E40A80BB1FA23F03540D450A390641D4E4070A296E656F03540281DACFF731D4E40C848BDA772F035409424CFF57D1D4E40F0C473B680F035401820D1048A1D4E4000ED478AC8F03540306475ABE71D4E40503C670B08F1354068A85148321E4E40C030992A18F135406456EF703B1E4E40B879E3A430F135403857CD73441E4E40D03C80457EF135409CBE9EAF591E4E40B09DEFA7C6F13540C066B96C741E4E40C8E40D30F3F135408C6665FB901E4E402872C119FCF13540041C42959A1E4E4068D95A5F24F235405CAD1397E31E4E4030772D211FF235401489096AF81E4E40E8417A8A1CF2354074E8F4BC1B1F4E4030DB4E5B23F23540983FDF162C1F4E4090CC237F30F23540AC9A20EA3E1F4E40605C717154F23540780261A7581F4E40380664AF77F33540685DA3E540204E40882D3D9AEAF33540582C45F295204E40D8F4673F52F43540F8D4B14AE9204E40B82231410DF53540C85EEFFE78214E40C89272F739F63540248AC91B60224E40D06531B1F9F6354048DDCEBEF2224E4040D175E107F7354040E8D9ACFA224E40408EE6C8CAF735403CA8C4758C234E40B03F506EDBF7354064A9F57EA3234E40882348A5D8F73540D8A19A92AC234E40B08009DCBAF7354034C687D9CB234E40C0E47FF277F73540B48993FB1D244E4088506C054DF73540248AC91B60244E40B80853944BF73540C049D3A068244E40007D5BB054F735407808E3A771244E406027F56569F7354080CCCEA277244E40389A5C8C81F735402C0ABB287A244E40F868AA27F3F73540247D5A457F244E40409B1C3EE9F635401CFCC401F4244E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','2','AQ070','FI','3470','N_A','N_A','N_A','1','4','FI0126FI0161','3.58292716729e-001','0105000020E6100000010000000102000020E61000002B000000E0E8633E20E835401C59F96530194E40B85CFDD824E93540E85E27F565194E404069E1B20AE93540B4BE4868CB194E40183BE12538E735407417618A721A4E4060062AE3DFE5354054B7B3AF3C1B4E4050B2D5E594E43540D49E9273621C4E4018C3D50110E33540D8CEF753E31C4E4060656D533CDE35406C41EF8D211D4E40009B73F04CDA354044292158551D4E40081DAD6A49D7354090E9D0E9791D4E40B85D68AED3D63540804A95287B1D4E405894128255D535404C2844C0211E4E40C85356D3F5D435406C37C1374D1E4E40C8E88024ECD3354010C0CDE2C51E4E4058C9C7EE02D3354014AFB2B6291F4E40F89507E929D235400C9FAD83831F4E40F0F78BD992D13540DC166536C81F4E40E0770C8FFDD035402C02637D03204E40C0A38D23D6D0354048ACC5A700204E40B068739CDBCE35407C9752978C1F4E4078A565A4DECD354058941282551F4E40A0BE9EAF59CC3540F030ED9BFB1E4E4040F4DDAD2CCB3540745776C1E01E4E4058B3CEF8BEC235402C6C06B8201E4E40781D71C806C235402C95B7239C1E4E40881E317A6EC13540A8D55757051F4E405081CCCEA2BF354000FF942A511F4E40F0D3B837BFBF35407C96E7C1DD1F4E4000581D39D2BF3540D8FD63213A204E40A8D6C22CB4BF3540A4677A89B1204E4008D50627A2BF3540704BE48233214E401895D40968BE35404459F8FA5A214E40C0E3141DC9BB35401C7E37DDB2214E40C8FD0E4581BA354034D07CCEDD214E40E028B2D650B83540EC2285B2F0214E40189E978A8DAD3540346FD575A8214E40C0E2A9471AA83540B0F9B83654214E4050C72AA567A63540E00F3FFF3D214E4000CDE7DCEDA23540C8BAB88D06214E40402619390BA1354028B9C32632214E40183C855CA99B354028B9C32632214E4008D49B51F399354014A6EF3504214E40F054C03DCF993540548847E2E5204E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','2','AQ070','FI','3470','N_A','N_A','N_A','1','4','FI0081FI0136','7.78559963237e-001','0105000020E6100000010000000102000020E610000032000000804E081D749535404016A243E0174E40805CE2C803953540488FDFDBF4174E406845D4449F8F354030056B9C4D184E40B0BFEC9E3C8C3540C88D226B0D184E40387F130A118035404C74965984184E40E8BB94BA647A3540F4B52E3542174E40B86E4A79AD743540389A232BBF164E407037C1374D6D354094E4B9BE0F164E40C069C18BBE6C354000FDBE7FF3154E40C8441152B76B354098F04BFDBC154E40F09A57755669354008D3307C44154E408862F2069867354084D89942E7144E40F8635A9BC6643540D4E940D653144E40005DFB027A633540C859D8D30E144E40109D9E7763613540C4CBD3B9A2134E40381D01DC2C5E3540D8A02FBDFD124E40C84E78094E5B3540D002B4AD66124E40487D59DAA9593540BC5D2F4D11124E40C05E28603B583540E8AA798EC8114E4028874F3A91563540BC2BBB6070114E40106954E06453354058B60F79CB104E40F06AB933135235407CF5F1D077104E40B839CE6DC251354028F911BF62104E40A06B98A1F1503540906802452C104E4038B874CC794E354054A35703940F4E40C0651536034A3540D0807A336A0E4E4010B1C1C249483540D8B79388F00D4E4060F3AACE6A43354000766EDA8C0C4E40385EBA490C3E35403023BC3D080B4E402877D844662235401060915F3F044E40D85889795622354034D252793B044E40B8BDA4315A1B3540888C47A984024E40E015C1FF561A3540F0DE516342024E40F0B435221819354058FAD005F5014E4040588D25AC1735409CCDE33098014E40D0FBFF3861163540982F2FC03E014E40505E2BA1BB143540344E4354E1FE4D40282158552F0D354068EBE0606FFC4D4010CB9F6F0B0A354018E6046D72FC4D40C865DCD440FF344044D95BCAF9FB4D4000BC3E73D6FB34407460394206FC4D40885968E734F9344074CB0EF10FFC4D40685419C6DDF234402CA8A8FA95FB4D4048718E3A3AE63440D046AE9B52FB4D40E003745FCEE434403CE63C635FFB4D4020D4450A65E334402C51F69672FB4D40688F17D2E1E3344048C2BE9D44FA4D40403C122F4FE53440D867CEFA94F94D40C8B9145795E534409802D2FE07F94D40009354A698E5344020C2F869DCF84D40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','2','AQ070','FI','3470','N_A','N_A','N_A','1','4','FI0132FI0133','1.50830315336e-001','0105000020E6100000010000000102000020E61000000C00000070DF6A9DB84C3440C04F1C40BF0E4E40C081C98D224D344080C4AF58C30E4E4018A20A7F864D3440EC9106B7B50E4E402091EF52EA4E3440D0ADD7F4A00E4E4090459A7807543440B80375CAA30E4E4050FEEE1D355A344088D349B6BA0E4E40A86950340F5E344064B2B8FFC80E4E40B07B2B1213663440BC3D0801F90D4E40486117450F6634403CFE0B04010E4E40A822DC6454633440C01BD2A8C0134E4000FA7DFFE66334406C8C9DF012144E4010AB3FC2306434405CF7562426144E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','2','AQ070','FI','3470','N_A','N_A','N_A','1','4','FI0131FI0132','1.73432369379e-001','0105000020E6100000010000000102000020E61000001400000010AB3FC2306434405CF7562426144E40F0552B137E633440BC5E9A22C0134E40B80D6ABFB563344044F5D6C056134E40D8F813950D653440BC7B80EECB104E40A8FDD64E9466344018080264E80D4E40F82D73BA2C683440A4E8818FC10D4E40A8AAD0402C6D3440645930F1470D4E40E057ACE1226F344078573D601E0D4E40C8570229B171344024016A6AD90C4E40F0815660C874344080768714030D4E4050724EECA175344074FF58880E0D4E4028BEDA519C793440C8D97404700E4E40F8B7CB7EDD7934400416C094810E4E4058D07B63087A3440C4C551B9890E4E40282499D53B7A3440704DBA2D910E4E40E8D022DBF97A3440BCD39D279E0E4E40403866D9937E34409C0DF967060F4E40286A300DC3813440102DB29DEF0E4E40C0FA78E8BB833440FC7266BB420E4E40389886E12384344010F92EA52E0E4E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','2','AQ070','FI','3470','N_A','N_A','N_A','1','4','FI0137FI0138','1.26523114185e-001','0105000020E6100000010000000102000020E61000000D0000005081936DE0603440C8772975C9034E40285F09A4C45C344074EB353D28044E40E8F527F1B95B34404CA8E0F082044E4058D2510E66593440F4B704E09F044E40188D7C5EF15634405078094E7D054E40B8C5353E93553440E02D90A0F8054E40E0C5C21039533440D40451F701074E4048E658DE55533440804A95287B074E40D0AACFD556523440A04FE449D2074E4090B1135E824934407470B03731084E40A0BFD023464734400CF4893C49084E4018FB928D07453440C88CB7955E084E40C0046EDDCD433440C86471FF91084E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','1837D5ED-757D-4FD6-AF95-EB366100E030','AQ070','EE#FI','3470','N_A','N_A','N_A','1','23','EE0001FI0003','8.03499578579e-001','0105000020E6100000010000000102000020E6100000100000003895456117C33840E86F422102B94D40680C738236C53840987329AE2AB94D40A8D425E318C738407C26FBE769B94D404882700514B238406C1B4641F0C84D40D8AF3BDD79CA3840E02C25CB49E84D4048EA043411CC3840F8E461A1D6E94D40C88B4CC0AFCD3840545F96766AEB4D403811FDDAFAD5384020C022BF7EF34D40C8C6832D76E33840181230BABCFD4D40B8D1C77C40EE3840341D3A3DEF054E4040F50F2219EE3840088849B890064E40F8F719170EEE3840BCAC8905BE064E407830629F00EE3840249F573CF5064E407842AF3F89EB38403040A20914114E40383C84F1D3EA3840F017B325AB124E4090A50F5D50EB3840F00EF0A485134E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','2217E3AD-AB72-40FA-AD0D-E8E8AEAAD525','AQ070','FI#SE','3470','N_A','N_A','N_A','1','23','FI0006SE0103','9.47824860163e-001','0105000020E6100000010000000102000020E61000001500000070C5C551B9113340B8A1293BFDDB4D4010881057CE163340E8245B5D4EDC4D402853CC41D02D3340AC9E93DE37DC4D4020ED7F80B5383340ACE0B721C6DD4D40681EF983813F33407C3F355EBADE4D40B025AB22DC403340EC8A19E1EDDE4D4078FA415DA4463340C070AE6186DF4D4090FCC1C0734D3340C45E28603BE04D4000C1559E405633409829ADBF25E14D40189947FE605E33401CBD1AA034E24D4048B071FDBB623340BC310400C7E24D4070BBD05CA76533407815527E52E34D40081BD7BFEB6B3340C070AE6186E44D409081751C3F6E3340A03E027FF8E44D4030207BBDFB71334050401361C3E54D40889CF7FF71763340387D3D5FB3E64D4028CADE52CE8F3340CC8DE9094BEE4D4018A75A0BB3963340D8D0CDFE40F04D40083C3080F0EB33409468C9E369084E40D01B278579ED33402457B1F84D094E40786D365662EE334000E8305F5E094E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','81AFA1B1-ACF8-44C3-B5E4-F3BFECC94932','AQ070','FI#SE','3470','N_A','N_A','N_A','1','23','FI0007SE0125','7.30312501602e-001','0105000020E6100000010000000102000020E610000009000000E8DCB419A7D1324020A4A7C8210C4E40000A2E56D4D632400CED9C66810B4E407893180456E03240CC6DFB1EF50A4E40301AF9BCE2173340D469DD06B5114E403029779FE317334044DD0720B5114E40F0B4352218253340EC758BC058134E40C0FC4E93192533402C6519E258134E40181747E52672334008B5DFDA891A4E40B0F84D61A58833403C191C25AF1C4E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','23DCCB96-6452-4C9A-83BF-9E0E8B0D9065','AQ070','FI#SE','3470','N_A','N_A','N_A','1','23','FI0005SE0122','5.08965070227e+000','0105000020E6100000010000000102000020E6100000A4000000B0D2A41474133240D0E3F736FDA84D4010DDB3AED11632408CB3E908E0A84D4060A8FC6B7917324024179CC1DFA84D40A82A6D718D193240404AECDADEA84D4050F17F47541A324034B6D782DEA84D4098215514AF1C3240F8B7CB7EDDA84D40C0F693313E1E3240CC332F87DDA84D40B053E57B46243240781D71C806A94D4010EE9579AB263240A435069D10A94D40D8AB8F87BE273240A452EC681CA94D40E0F8DA334B28324094BDA59C2FA94D4058D1E638B72D3240207EFE7BF0A94D4008D6389B8E323240580DC2DCEEAA4D4030815B77F3363240D8BE805EB8AB4D4080EB8A19E13B324028081EDFDEAC4D4088DEA9807B403240BCE6559DD5AD4D40904E5DF92C433240C43D963E74AE4D40D0DA34B6D7463240AC984A3FE1AE4D40986F44F7AC49324020D5B0DF13AF4D40889D62D5204C32401033FB3C46AF4D40583882548A513240145454FD4AAF4D4020A67D737F55324094C0E61C3CAF4D4018A3AEB5F75F32407C4B395FECAE4D40E02EFB75A7633240143C855CA9AE4D40480B9755D86A32406079909E22AE4D40B0BD4F55A16F3240E40F069E7BAD4D4068D7BD1589713240844BC79C67AE4D4078F7C77BD5723240647AC2120FAF4D4028BD361B2B7132402C3E05C078B04D40681877836871324034ECF7C43AB14D403067B62BF4713240987329AE2AB24D40E04EE960FD713240B40DDC813AB24D4050E8F527F17132404487C09140B24D40A88DEA742071324068CA4E3FA8B24D4008FEB7921D713240505436ACA9B24D4040A88B14CA703240B8291E17D5B24D40205E10919A703240C8CEDBD8ECB24D40A01F0DA7CC6F3240689E5C5320B34D4088CE328B506E32405CA8FC6B79B34D4088D00836AE693240B062F19BC2B44D40B80B94145866324034069D103AB74D4060BB7B80EE69324040C1C58A1AB74D40E06FB4E386713240505AB8ACC2B64D40D8B0DF13EB7232405C70067FBFB64D4000A7B05241753240B49AAE27BAB64D400860CAC0017B3240F01D3526C4B64D40B8E2E2A8DC7C3240147D3ECA88B64D40487155D977833240C4EE3B86C7B54D40F816D68D77873240E4C5C21039B54D40488FA67A328D3240E037BEF6CCB34D40C8211B4817973240309A95ED43B14D40981C774A079932409861A3ACDFB04D408083BD89219B3240642D3E05C0B04D40B025AB22DCA43240642D3E05C0B04D40583ECBF3E0AA324068B3EA73B5B04D40E877616BB6AE32400C0742B280B04D4030C170AE61B23240AC02B5183CB04D40E056410C74B33240A42424D236B04D40B84C86E3F9BC3240BC88B663EAAE4D4040E603029DC332405C33F9669BAC4D408878EBFCDBC732401893FE5E0AAB4D40187C613255CA3240740987DEE2A94D408009DCBA9BD332400CF148BC3CA84D4038DE1D19ABD93240A0F31ABB44A74D40E873EE76BDDA3240704562821AA74D40A89F70766BDD3240F4A62215C6A64D40F8F4D89601E132402CC0779B37A64D4098BBCFF1D1E23240DC5CFC6D4FA54D4018CD0358E4E33240943655F7C8A34D408887F71C58E83240D09F36AAD3A14D4030E9EFA5F0EE3240507B4ACE89A14D4060B35C363AF332405CDF878384A14D40E02BBAF59AFE324014EF004F5AA14D40D8F7E120210433405CC47762D6A04D40E878CC40650A33402475029A08A04D4000438F183D11334058E542E55F9D4D40781BD47E6B1F3340B0F02E17F19C4D4098FF571D39223340A4129ED0EB9C4D40382D78D1572E3340B8CEBF5DF69C4D40F0C682C2A03A33405C3D27BD6F9D4D4068F50EB7434933406C4AB20E479E4D40B815C26A2C61334070BE11DDB39F4D4038F7578FFB7A33403878263449A14D40D805836BEE80334028F224E99AA14D4018FF3EE3C28D3340A0E925C632A84D4048D8B793889633406C97361C96AE4D4078F1457BBCAE3340B4C2F4BD86E34D40D0D51D8B6DB8334018BF29AC54E94D40D83521AD31EC33404052448655084E40004C1938A0ED3340483D44A33B094E40786D365662EE334000E8305F5E094E40A8BD88B663EE3340545DC0CB0C094E40A81DC539EAEC3340C8FE791A30084E40801C9430D3EC3340DC813AE5D1074E401895D40968EC3340F8C610001C064E404007962364EC33403C35971B0C064E40B004190115EC3340980D32C9C8044E40F09A90D618EC3340BC783F6EBF044E40A83121E692EC334048DBF81395034E40C06BD097DEEC3340FCEB1516DC024E4058FF209221ED3340185DDE1CAE024E4070F085C954F1334010D6FF39CCFF4D4028D6A9F23D093440804067D2A6FA4D40406EBF7CB232344004098A1F63FA4D4060F1D4230D423440ECE2361AC0FF4D4000AC8E1CE9463440FCCC599F72014E40188D7C5EF15634405078094E7D054E40289529E62074344050C8CEDBD80C4E40F0815660C874344080768714030D4E404031B2648E753440F8CC9200350D4E40189B1DA9BE793440085A8121AB0E4E40C8C551B9897E3440D41055F8330F4E4068F0F78BD9823440B07B2B12130F4E40781E15FF77883440005130630A0F4E40401C2444F99434407C3ECA880B104E40D8C4025FD1973440EC67B114C90F4E409056B5A4A3983440387007EA940F4E4040E4F4F57C99344040E1ECD6320F4E40C01248895D9F344080A2B2614D0E4E4078832F4CA6A834402C431CEBE20C4E4020317A6EA1AF34407C15191D900C4E4048AE9B525EB334400C3ECDC98B0C4E4080B1F7E28BB43440C4ABAC6D8A0C4E40E855647440BA344010AAD4EC810C4E4058AEB7CD540A3540CCF5B6990A0C4E40505260014C153540905CFE43FA0B4E40201FF46C56153540F0643733FA0B4E404883143C851C3540B4FB5580EF0B4E400812DBDD032E35404417D4B7CC0C4E40D814C8EC2C38354084798F334D0D4E4010B56D1805473540608DB3E9080E4E402057EA5910503540F436363B52104E40D016105A0F533540A4B3CC2214114E40F0461FF3016D354088DEE2E13D164E40B885E7A5626F354050AF946588164E40788505F703743540400C74ED0B174E407035B22B2D753540F05696E82C174E40B05DA10F9679354030E065868D174E40B02FD978B07F3540F4E0EEACDD184E40B876A2242480354098B51490F6184E40E83C2AFEEF90354084D4EDEC2B1A4E40104E44BFB6A6354080AE7D01BD1B4E40D09D279EB3B73540585C1C959B1C4E403032C85D84C9354094205C01851D4E40C85356D3F5D435406C37C1374D1E4E4020ED7F80B5E03540F4237EC51A1F4E40B82231410DF53540C85EEFFE78214E40200934D8D4053640A094490D6D234E4000CCB568010A3640785089EB18254E40D83DB2B96A0C364070F4311F10264E40806C59BE2E0F3640307A6EA12B274E4020456458C5133640A8069ACFB92B4E40401A4E999B153640EC0A7DB08C2D4E40A0C7EF6DFA1536403C90F5D4EA2D4E40C0B986191A193640D49CBCC804314E40C8B260E28F223640F810548D5E354E4068A3737E8A253640702F698CD6354E40F054C03DCF293640ACBCE47FF2354E400889EDEE012C3640243D0CAD4E364E4050E8BCC62E2D36405C8E57207A364E40506A6803B02D3640803672DD94364E4070FC89CA862F36403404C765DC364E40E05B9198A0323640F8CE68AB92374E4040102043C73636406475ABE7A4374E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','2','AQ070','FI','3470','N_A','N_A','N_A','1','4','FI0131FI0133','2.23390502812e-001','0105000020E6100000010000000102000020E61000001100000070DF6A9DB84C3440C04F1C40BF0E4E407889EAAD814D3440D04543C6A30E4E4088E3C0ABE54E344070675F79900E4E4020AF0793E2533440887C9752970E4E4000B4AD669D593440E08FDB2F9F0E4E4048DC9C4A065E34407009C03FA50E4E4030CD74AF93663440F00A444FCA0D4E40D0D90242EB673440983446EBA80D4E40A05F5B3FFD6734408CD47B2AA70D4E4000BA2F67B67134405448F949B50C4E40289529E62074344050C8CEDBD80C4E40984EEB36A8753440740CC85EEF0C4E4098745B22177A3440B8C0E5B1660E4E40403866D9937E34401448895DDB0E4E40308507CDAE81344094D5743DD10E4E4008560E2DB2833440DC1B7C61320E4E40389886E12384344010F92EA52E0E4E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','2','AQ070','FI','3470','N_A','N_A','N_A','1','4','FI0130FI0136','2.97243448595e-001','0105000020E6100000010000000102000020E610000028000000009354A698E5344020C2F869DCF84D40F03CB83B6BE53440A4FE7A8505F94D40783D98141FE53440703AC95697F94D40285646239FE33440D0AB014A43FA4D4058AFE94141E3344004FA449E24FB4D40485B5CE333E33440D89C836742FB4D4048B9FB1C1FE33440B4D2A41474FB4D4078DB4C8578D834403C122F4FE7FB4D40605DDC4603D034404859BF9998FE4D40C0C3B46FEECB3440946A9F8EC7014E40480B9755D8CC3440C8D5C8AEB4024E40807DAD4B8DCC3440EC4960730E034E4098E1067C7ECA3440FCFA213658044E4018430070ECC93440BC5B59A2B3044E407059BE2EC3C93440CCCEA2772A054E40B087F6B182C93440FC648C0FB3054E40E01C75745CC9344044F0BF95EC054E40F8B31F2922C934408C9125732C064E40705303CDE7C83440702711E15F064E40F02422FC8BC834401048C2BE9D064E407010AD156DC8344028603B18B1064E4080FFE6C589C73440188D7C5EF1064E4070E00ED429C73440902BF52C08074E4058F5F23B4DC63440F8F02C4146074E40E8C5504EB4C534400834D8D479074E40E8F692C668C53440DC921CB0AB074E4018EAB0C22DC53440308B89CDC7074E40C0A38D23D6C4344004CDE7DCED074E40D8135D177EC43440F8E0B54B1B084E40E804341136C4344054F5F23B4D084E4010B69F8CF1C33440CC4E3FA88B084E403023F59ECAC33440D031207BBD084E4090A4A487A1C33440B4B6291E17094E40506C3EAE0DC3344064AA6054520A4E40506F46CD57BB3440BC0CFFE9060C4E40E855647440BA344010AAD4EC810C4E401012691B7FB83440246AA2CF470D4E4008B8E7F9D3B434404C917C25900D4E40A8D7666325B234404C5645B8C90D4E401860E63BF8AF344014ED2AA4FC0D4E40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','22C6DAB5-5BCB-4D42-AFF0-BBF4B6344991','AQ070','NO','3470','N_A','N_A','N_A','1','4','NO0034NO0037','2.24951927942e-001','0105000020E6100000010000000102000020E61000000B00000020B7D100DE021640D89AADBCE4E34D404061C268561616403C014D840DE44D40404BAC8C46261640C05AB56B42E44D4060F8FA5A97321640D8DCD1FF72E44D4060726A679862164038A1100187E64D4040EF54C03D771640309A95ED43E84D4040B7D095088416405CDA70581AE94D404002D4D4B2951640EC4D0CC9C9E94D4060DC9BDF30A91640EC4D0CC9C9E94D40A039799109C01640C08F6AD8EFE94D40A01C5A643BDF164060DD787764EA4D40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','11D64BF6-D584-4EC6-B4D1-3F5EAFCF141B','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0074SE0075','3.79998463814e-003','0105000020E6100000010000000102000020E610000002000000582BDA1CE7C63640FEF0F3DF039F5040701283C0CAC736409817601F1D9F5040');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','C40CDC78-3059-4558-84E3-0FA2E4665BB1','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0026SE0027','1.82607043196e-002','0105000020E6100000010000000102000020E6100000020000004090BC7328E53640D6FCF84B8B935040985E622CD3E9364056B5A4A39C935040');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','CA582F93-7B56-4F31-B0E0-0A1B3987115F','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0034SE0035','1.76811574009e-002','0105000020E6100000010000000102000020E61000000300000090B454DE8ED035403EF03158716B5040C026327381D3354054DFF945896B5040F05487DC0CD5354036A968AC7D6B5040');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','1C9EEF64-1BD0-4B6B-ACBE-5838F336367F','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0009SE0010','2.84056316327e-002','0105000020E6100000010000000102000020E610000004000000201538D906C22C4088653387A4914F4030957EC2D9C92C4098C9703C9F914F400003081F4AD02C40646CE8667F914F4070C7629B54D02C40982EC4EA8F914F40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','8C55805C-F6BB-4641-85C1-6663A2252992','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0013SE0014','4.01686011830e-002','0105000020E6100000010000000102000020E610000002000000F0052D24609C2C40741BD47E6B904F40A0D2C1FA3FAF2C400CB6114F76924F40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','FB7086F2-6D69-4A60-B049-3EACAC053762','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0007SE0008','9.94708732699e-003','0105000020E6100000010000000102000020E610000003000000400114234B962E40345706D5066A4F408094D8B5BD992E40642CD32F116A4F40B05626FC529B2E40904E5DF92C6A4F40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','A339B5A4-57CC-4AF2-B417-8A265694B516','AQ070','SE','3470','N_A','N_A','N_A','997','4','SE0001SE0002','1.06201847913e-002','0105000020E6100000010000000102000020E6100000020000006011C30E63FC3140F4565D876A584F40181406651AFF31407C71A94A5B584F40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','15973DB4-41C8-448A-9265-519C318242DD','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0024SE0025','4.02366002538e-003','0105000020E6100000010000000102000020E610000002000000588B8862F2EC3240949EE925C6D44D409837876BB5ED324094E68F696DD44D40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','F448EE95-688F-4366-B5EB-E2C2909CDC70','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0022SE0023','5.78708685352e-003','0105000020E6100000010000000102000020E61000000200000010CCD1E3F7EE3240C46A2C616DD34D40F809A01859F0324014E3FC4D28D34D40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','AFEC696B-D80D-4472-93D9-FF96C58BBF7D','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0105SE0104','1.66848124161e-002','0105000020E6100000010000000102000020E610000003000000B086C43D969232406028603B18C64D4090ACFC32189532404C361E6CB1C54D4068834C32729632404857E9EE3AC54D40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','A28CF671-D68F-435C-8B09-F4282D7E5B6D','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0015SE0016','1.58561470980e-002','0105000020E6100000010000000102000020E61000000400000040942F68212931402438F581E4BF4D4040F163CC5D27314024E010AAD4BF4D401828F04E3E2731403417B83CD6BF4D40A0B3CC22142531401815713AC9BF4D40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','A777E01D-C27B-483A-B627-F1CC3A79CFB4','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0030SE0031','4.18758051356e-003','0105000020E6100000010000000102000020E610000003000000E0BA29E5B52E2E40306D382C0D044D4040F20703CF2D2E40D0B69A75C6034D40201A16A3AE2D2E40A447533D99034D40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','55BE1202-DD02-46EB-A761-10B47E48E7C9','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0032SE0033','2.17951307234e-002','0105000020E6100000010000000102000020E61000000200000038765089EB0E33407071546EA2EE4C40D8A9B9DC60143340680C738236EF4C40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','B3CC7CC0-E27A-4079-A656-57762CA58F77','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0092SE0093','3.57154644378e-003','0105000020E6100000010000000102000020E6100000020000009000FC53AAC02740784EB340BBE84C4000F6984869C227401CACFF7398E84C40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','45C4720D-8157-40E9-B0CF-36B5EB30B089','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0019SE0020','1.42574734107e-002','0105000020E6100000010000000102000020E61000000400000040054EB681672740C4AEEDED96DA4C40A07AA4C16D652740106F9D7FBBDA4C40401C5DA5BB632740C458A65F22DB4C40B02FA017EE6027403CDA38622DDB4C40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','AF546108-E15B-48F7-BB59-5604B8E7A693','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0020SE0021','3.73487879087e-002','0105000020E6100000010000000102000020E610000002000000105FB4C70B552740C8B94DB857D94C4040054EB681672740C4AEEDED96DA4C40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','4C168817-FFA0-4610-877E-7AAC568AE7D5','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0028SE0029','1.71317616596e-002','0105000020E6100000010000000102000020E610000004000000F0A529029C662B4080ED60C43E814C4040D89B18926B2B40A8A10DC006814C40F043DE72F56B2B40BC8E386403814C40F0E505D8476F2B40B87D8FFAEB804C40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','93184422-A205-481B-A390-C921C6BFA4F6','AQ070','SE','3470','N_A','N_A','N_A','997','4','SE0036SE0037','7.58143613828e-002','0105000020E6100000010000000102000020E610000008000000D05E7D3CF4312F406CF12900C6144C40E0C0ABE5CE342F40E0218C9FC6144C40B035CD3B4E352F40085740A19E144C400097C79A91352F404CF8A57EDE134C4000274D83A2312F40C00AF0DDE6124C40D0C4AD82182C2F40501F813FFC114C40A06B98A1F1242F40EC4B361E6C114C4070774831401A2F40A4D11DC4CE0F4C40');
INSERT INTO "ferryl" ("fcsubtype","gfid","f_code","icc","sn","detn","deta","dnln","rsu","use_","ferryid","shape_leng",the_geom) VALUES ('1','1B4A5788-F358-41C4-B66C-8C34309B78AF','AQ070','SE','3470','N_A','N_A','N_A','1','4','SE0017SE0018','1.21154513948e-002','0105000020E6100000010000000102000020E61000000200000050F910548DBE2C40D48EE21C750E4C40D05A43A9BDC42C40E84141295A0E4C40');
