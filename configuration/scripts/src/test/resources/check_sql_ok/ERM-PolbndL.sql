SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "polbndl" (gid serial PRIMARY KEY,
"fcsubtype" int4,
"gfid" varchar(38),
"f_code" varchar(5),
"icc" varchar(5),
"sn" int2,
"bst" int4,
"use_" int4,
"shape_leng" numeric);
SELECT AddGeometryColumn('','polbndl','the_geom','4326','MULTILINESTRING',2);
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','D1CE5765-AAA2-4468-94D7-8C859DCC74DC','FA000','DE#FR','0','1','23','2.00943351048e-002','0105000020E6100000010000000102000020E61000000700000020CC5F217315204004FDBE7FF3814840706F9BA91013204040D175E107824840905DDBDB2D11204044CBBA7F2C8248401082C7B7771120403C8F8AFF3B82484060C8957A161020405476FA415D8248401003081F4A0C20402C44C02154824840A002D2FE070C20407815527E52824840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','34B1317D-F8CE-43C6-8FE3-254C1A3A186A','FA000','DE#FR','0','1','23','3.40306742291e-002','0105000020E6100000010000000102000020E61000000B000000C0B9A3FFE5222040FCBA0CFFE97F4840B0FB00A4362120400CC4EBFA05804840C0CBF09F6E202040E44BE141B3804840708A00A7771D2040F89CF4BEF18048407069E047351C20400015C78157814840504DF4F9281B2040BC287AE063814840E0EB1681B11A2040E0D6169E978148409042041C421920405834D6FECE814840B0C29FE1CD16204020A5129ED081484040B742588D152040D088D2DEE081484020CC5F217315204004FDBE7FF3814840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','4CD0F6FA-F272-4AF2-9DA2-3FA3BB028E28','FA000','DE#FR','0','1','23','4.28045850349e-004','0105000020E6100000010000000102000020E610000002000000C0B9A3FFE5222040FCBA0CFFE97F4840907555A016232040B8F81400E37F4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','6B3AD262-C91B-4AE5-A92C-86F2AA9D4A9E','FA000','DE#FR','0','1','23','2.80077177122e-002','0105000020E6100000010000000102000020E61000000D000000907555A016232040B8F81400E37F4840E066D5E76A2320408C9CBE9EAF7F4840306F47382D242040C41F7EFE7B7F484090E464E25625204014902FA1827F4840E088601C5C26204054280B5F5F7F4840E0092FC1A927204044D7BE805E7F4840001B2D077A282040888DB27E337F484080FDBB3E732A2040807BD7A02F7F4840F004DF347D2A20401457CEDE197F4840A0BD175FB42B204008483481227F4840006ADC9BDF2C2040DCDC989EB07E4840100951BEA02D20401C601F9DBA7E4840902F8507CD2E20404CF8DEDFA07E4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','B125DE1E-C6FD-45D4-8FB3-06909DF7B338','FA000','DE#FR','0','1','23','4.84276205552e-002','0105000020E6100000010000000102000020E610000014000000902F8507CD2E20404CF8DEDFA07E484030CB49287D31204000FAB660A97E484010A60C1CD03220403C747ADE8D7E48403003B2D7BB33204078AF93FAB27E4840902040868E352040ACB35A608F7E4840B0E15B5837362040FCD51C20987E484050D05FE81137204084C0CAA1457E4840E02B2CB81F3820400015C781577E4840E088997D1E3B20401CC39CA04D7E4840A06B7C26FB3B2040E87805A2277E4840503B6EF8DD3C2040084B75012F7E4840F04944F8173D20403426FDBD147E4840507364E5973D2040F06305BF0D7E4840F01FEF552B3F204084C0CAA1457E48402017B9A7AB3F2040888DB27E337E4840B0EFA7C64B3F20404C07EBFF1C7E4840708EACFC32402040480DA661F87D484060EFE2FDB84120408881E7DEC37D4840A07A1684F24220407C758E01D97D484020FFE9060A4420408CE42B81947D4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','46D965D4-3782-4AC2-A7CB-08A8BFA92CBC','FA000','DE#FR','0','1','23','6.09800172159e-004','0105000020E6100000010000000102000020E610000002000000D0CE86FC335320400C185DDE1C7D4840009C5088805320406079909E227D4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','7868AE59-8B75-4D62-A64A-F8FB6213194A','FA000','DE#FR','0','1','23','3.21273916665e-002','0105000020E6100000010000000102000020E61000000C00000020FFE9060A4420408CE42B81947D4840B065A4DE53452040A035785F957D4840F0813AE5D145204050378941607D484080AE6186C6472040507CB5A3387D484080FF1F274C4820402C417FA1477D48405083143C85482040980B957F2D7D4840A0E65608AB492040D4915CFE437D484040FC6EBA654B20409435EA211A7D4840B023B9FC874C20408499EFE0277D4840F0A337DC474E2040CC737D1F0E7D48400066304624522040ACCE6A813D7D4840D0CE86FC335320400C185DDE1C7D4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','3E1CC015-7942-47EA-BD44-1454D1EBB8D7','FA000','DE#FR','0','1','23','8.15161505708e-002','0105000020E6100000010000000102000020E610000017000000009C5088805320406079909E227D4840B0C343183F552040C858A65F227D484080B515FBCB562040B4DD3D40F77C484080FDF49F35572040F41DFCC4017D4840F018028063572040C882C2A04C7D484020FDDAFAE95720402C44C021547D48400052B81E855B2040783FA7203F7D484070F16261885C204034772D211F7D4840D05BAE7E6C5E2040305F97E13F7D4840C0DAC35E28602040F41DFCC4017D48405089CF9D60632040D8D688601C7D484010C1559E40642040D8CDC5DFF67C4840C0CEBF5DF663204050F8A57EDE7C48405008C89750652040F04B361E6C7C4840204E999B6F642040F8729F1C057C484020450F7C0C66204020F30181CE7B4840A08653E6E6672040F066463F1A7C4840B068E55E606A2040ACCB2901317C484090307E1AF76A2040106954E0647C48407004C6FA066E204064B5F97FD57C484030C9737D1F722040C03AC780EC7C4840C04467994574204058790261A77C48402011FE45D0742040584CA59F707C4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','E994868E-889F-4921-B57E-7142D77609F8','FA000','DE#FR','0','1','23','7.32927990852e-003','0105000020E6100000010000000102000020E6100000040000002011FE45D0742040584CA59F707C4840408194D8B575204094E1783E037C4840F0F4F57CCD762040607347FFCB7B4840202384471B7720401CAE0E80B87B4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','B92ACD1C-CCB3-4F7A-8521-9F093A4691A4','FA000','DE#FR','0','1','23','1.34788398981e-003','0105000020E6100000010000000102000020E610000002000000C065C0594A562040A02633DE567648405065C39ACA562040187E703E75764840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','88B522EE-1D13-4F82-B842-AD50BFD5FE32','FA000','DE#FR','0','1','23','6.51913715531e-003','0105000020E6100000010000000102000020E61000000200000070360186E553204024F0C000C2754840C065C0594A562040A02633DE56764840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','1369146D-4D60-42BE-B947-7878244D4953','FA000','DE#FR','0','1','23','3.26966892022e-002','0105000020E6100000010000000102000020E61000000300000060F2785A7E482040482BF702B3724840C043FCC3964E2040781E15FF7774484070360186E553204024F0C000C2754840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','49FAA122-E1CE-42C3-8FEE-56E126BB174D','FA000','DE#FR','0','1','23','3.70936289431e-002','0105000020E6100000010000000102000020E61000000300000060F2785A7E482040482BF702B3724840A07A1684F2422040CC8E8D40BC7048404090A0F8313E2040AC6E2EFEB66E4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','CF0B0956-8B3F-40B1-ABBF-9C6CDAAB99D4','FA000','DE#FR','0','1','23','1.35769431114e-002','0105000020E6100000010000000102000020E6100000020000004090A0F8313E2040AC6E2EFEB66E484010685BCD3A3B204008FA449E246D4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','82F71891-E6D8-489D-9AEF-DFBDB502A8D1','FA000','DE#FR','0','1','23','2.58202568951e-002','0105000020E6100000010000000102000020E61000000300000010685BCD3A3B204008FA449E246D4840706CAF05BD3720408499EFE0276B4840C050F9D7F2362040E4512AE1096A4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','056C9A37-EB9B-4029-BBCB-7C65684814CD','FA000','DE#FR','0','1','23','4.71162657686e-004','0105000020E6100000010000000102000020E610000002000000805776C1E0362040BCEF181EFB694840C050F9D7F2362040E4512AE1096A4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','2F454189-6679-4430-A525-D58853F0D951','FA000','DE#FR','0','1','23','3.34559006658e-002','0105000020E6100000010000000102000020E61000000500000050A0FA07912C204024EA3E00A966484010C03FA54A302040781E15FF7767484060C58D5BCC332040BC2BBB607068484040849CF7FF3520407C6000E143694840805776C1E0362040BCEF181EFB694840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','6296FCFF-3D58-44EB-8084-4E5799845D49','FA000','DE#FR','0','1','23','3.51614465715e-003','0105000020E6100000010000000102000020E61000000200000090AD122C0E2B2040CCA99D616A66484050A0FA07912C204024EA3E00A9664840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','63B29911-C748-43C4-B3AF-6699A10AF8CE','FA000','DE#FR','0','1','23','8.60399582227e-002','0105000020E6100000010000000102000020E61000000B00000020001C7BF608204014691B7FA261484090FD9E58A70A2040F0AEB321FF6148407037FA980F0C2040CC61307F85624840F0EA8EC5360D20400427DBC01D64484020299485AF0F2040C4525DC0CB64484030ED461FF311204060A3E5400F654840F0BDDC2747152040386E313F37654840A08DCEF9291E2040E42D90A0F86448409048F8DEDF2020400C151C5E1065484060971AA19F252040E021C5008965484090AD122C0E2B2040CCA99D616A664840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','BCA57144-A4FC-431E-B205-EFA4F3F29319','FA000','DE#FR','0','1','23','3.53461933456e-002','0105000020E6100000010000000102000020E61000000500000000A629029CEE1F40F04B361E6C614840E0D38041D2FF1F408CD860E124614840608B4F013002204088B7072120614840401D01DC2C062040C882C2A04C61484020001C7BF608204014691B7FA2614840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','BD3EAAC5-9C8C-4F3C-B6E8-61518AA4CF1B','FA000','DE#FR','0','1','23','5.25081102257e-002','0105000020E6100000010000000102000020E610000008000000E002983270D01B406088D51F619A4840401D3A3DEFD61B40C01072DEFF9948408006F1811DDF1B400836E7E0999A48406015FE0C6FE61B40F4A5F0A0D99A48408022DE3AFFF61B40189337C0CC994840602635B401F81B401CAE0E80B8994840E0156C239EFC1B405843E21E4B99484080C136E2C9FE1B406CF7AB00DF984840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','BAF111ED-33F5-412E-ADD1-95A3FD9AA4E9','FA000','DE#FR','0','1','23','2.92742781815e-002','0105000020E6100000010000000102000020E610000008000000A02B67EF8C661B406CF12900C6984840A03FC39B35681B408087A2409F9948408088635DDC661B4050F8A57EDE99484000B876A224641B40A8897780279A4840E0449F8F32621B40387172BF439A4840E0141E34BB5E1B40BCE9CF7EA49A484020658C0FB3571B407C54FCDF119B4840E041B456B4591B4060AFE941419B4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','D5B478C1-AF5C-452F-B18C-40167784AAA5','FA000','DE#FR','0','1','23','2.21954920420e-002','0105000020E6100000010000000102000020E61000000500000080C136E2C9FE1B406CF7AB00DF984840E02AA5677A091C4020D2A8C0C9984840E0909C4CDC0A1C407C573D601E98484040FD6838650E1C405C5B785E2A984840A0E4F21FD20F1C40A02FF65E7C984840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','C82779CD-D90F-41A9-A88C-4867CFFADFF0','FA000','DE#FR','0','1','23','3.51774934759e-002','0105000020E6100000010000000102000020E610000002000000200726378AA41D40388C82E0F1964840A0B932A836C81D40304487C091974840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','95574B6F-EDB1-4B98-AB8A-DC83A531DCB9','FA000','DE#FR','0','1','23','1.98883752295e-002','0105000020E6100000010000000102000020E610000005000000A02B67EF8C661B406CF12900C6984840401F662FDB6E1B40A0685721E5974840007BA2EBC26F1B4004124DA088974840403BFDA02E721B4004309E414397484020F775E09C711B40B4D7BB3FDE964840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','21E18F2D-D3D1-4DFD-87B9-DA17D9DD5750','FA000','DE#FR','0','1','23','3.88604226781e-002','0105000020E6100000010000000102000020E610000009000000A0E4F21FD20F1C40A02FF65E7C984840A0B88E71C5151C40F07E15E0BB9848406082C5E1CC171C40CC01BB9A3C984840C037F8C2641A1C40808159A148984840002313F06B1C1C4048FB58C16F984840800514EAE9231C40AC8C7F9F7198484060787B1002221C409C50C1E1059848404058E36C3A221C40A85F22DE3A97484000C7F484251E1C40A4772AE09E964840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','4B94C8BE-AE3C-4AD5-8909-A9784A1D2626','FA000','DE#FR','0','1','23','5.59157122497e-002','0105000020E6100000010000000102000020E610000007000000A0AD6708C7E41A405440DAFF009C4840C005137F14E51A40C87C7901F69B4840E03B4ED191EC1A40A86E675F799A48408026512FF8EC1A4000E8305F5E9A484020CB113290E71A402C2CF180B299484080EA758BC0D81A40187B681F2B984840C0CA30EE06E11A40D0A623809B964840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','9A2B5F03-8A97-4132-935E-814364128979','FA000','DE#FR','0','1','23','2.94286088399e-002','0105000020E6100000010000000102000020E61000000200000080D102B4AD861D407C3C2D3F70964840200726378AA41D40388C82E0F1964840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','A8A59AEA-9423-4F6C-A939-515F823AE753','FA000','DE#FR','0','1','23','1.66326598449e-002','0105000020E6100000010000000102000020E61000000500000000FE463B6EE01F40C46D6DE179604840A0172829B0E01F4088C613419C6048404080B74082E21F4074EB6E9EEA6048402072FBE593E51F400009C3802561484000A629029CEE1F40F04B361E6C614840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','473466C5-8634-4978-8526-A9E9398DB99D','FA000','DE#FR','0','1','23','2.41326779139e-002','0105000020E6100000010000000102000020E610000003000000400A4966F5DE1F4024DBF97E6A5D484020E6CC7685DE1F4094CF2B9E7A5F484000FE463B6EE01F40C46D6DE179604840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','7A252FE0-C256-40A6-A032-E366E4A54ECD','FA000','DE#FR','0','1','23','1.43507003897e-002','0105000020E6100000010000000102000020E610000004000000E061DBA2CCD61F40782D211FF45B48404076C24B70DA1F402C172AFF5A5C4840E032C4B12EDE1F40D8CDC5DFF65C4840400A4966F5DE1F4024DBF97E6A5D4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','0BBD5C9A-87FB-40C4-A311-45395D14F9D1','FA000','DE#FR','0','1','23','4.48330472754e-002','0105000020E6100000010000000102000020E610000002000000804D81CCCEB21F405849641F64584840E061DBA2CCD61F40782D211FF45B4840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','99EF8475-D2BE-4047-8856-A304C1173064','FA000','DE#FR','0','1','23','3.67046494739e-002','0105000020E6100000010000000102000020E610000002000000E0E3141DC9951F40082AE3DF67554840804D81CCCEB21F405849641F64584840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','5360B771-85F9-40B8-8C57-D854E34FCC99','FA000','DE#FR','0','1','23','7.08114870197e-002','0105000020E6100000010000000102000020E6100000080000008044149337581F40A04A06802A514840C0376A85E95B1F405025034015524840C06DA7AD11611F4088C613419C52484080E76D6C76641F409480D1E5CD52484000446CB070721F4098111780465348408010AD156D861F406082531F48544840405E49F25C8F1F40EC633E20D0544840E0E3141DC9951F40082AE3DF67554840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','1C864E87-78B2-4EA6-B8F0-A74FF5B536E8','FA000','DE#FR','0','1','23','4.57502185789e-004','0105000020E6100000010000000102000020E6100000020000002037A79201581F40A838471D1D5148408044149337581F40A04A06802A514840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','414DEE0A-7594-4AD5-AD52-E1D7D69C861A','FA000','DE#FR','0','1','23','1.53997340523e-001','0105000020E6100000010000000102000020E61000000E000000E0608C48142A1F406C006F810440484000C0EB33672D1F4088DEE2E13D404840C0DF13EB54311F405855682096404840A05B936E4B341F40743C9F01F5404840C0666490BB381F40607347FFCB41484080E1EB6B5D3A1F401CB49080D14248406061C26856361F40146F9D7FBB444840204BCADDE7381F40D46D895C7046484060D9B0A6B2381F408093A641D1474840C0027CB779331F40E03312A1114A484080A3737E8A331F4088CFD6C1C14A484080D5592DB0371F403C8600E0D84B4840C053E57B46521F409C35B1C0574F48402037A79201581F40A838471D1D514840');
INSERT INTO "polbndl" ("fcsubtype","gfid","f_code","icc","sn","bst","use_","shape_leng",the_geom) VALUES ('2','F9EF68F6-C2AF-47CE-9EE2-468AE5314F16','FA000','DE#FR','0','1','23','2.10427885331e-002','0105000020E6100000010000000102000020E610000002000000E074931804161F40EC42ACFE083F4840E0608C48142A1F406C006F8104404840');
