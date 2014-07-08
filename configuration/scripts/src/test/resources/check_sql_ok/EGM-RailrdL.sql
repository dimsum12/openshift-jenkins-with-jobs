SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "railrdl" (gid serial PRIMARY KEY,
"fcsubtype" int4,
"gfid" varchar(38),
"f_code" varchar(5),
"icc" varchar(5),
"sn" int2,
"exs" int4,
"fco" int4,
"gaw" int4,
"loc" int4,
"rgc" int4,
"rra" int4,
"rsu" int4,
"shape_leng" numeric,
"railid" varchar(12));
SELECT AddGeometryColumn('','railrdl','the_geom','4326','MULTILINESTRING',2);
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','9.12367244248e-002','AN010FI00144','0105000020E6100000010000000102000020E61000000900000050465C001ACB3840CC85CABF965E4E40A098F56228CB3840989EB0C4035F4E40C0FBE3BD6ACB3840346E6AA0F9604E40107EA99F37CB3840B80DA32078624E40585EB9DE36CB3840744EECA17D624E40A0AD4A22FBC8384088D2DEE00B654E40A0866F61DDC23840CC7344BE4B684E40502B4CDF6BC2384020EA3E00A9684E409023D6E253C2384000D061BEBC684E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','9.08508943316e-001','AN010FI00148','0105000020E6100000010000000102000020E61000003E00000020179CC1DF47364048EF1B5F7B3A4E408813984EEB483640BC218D0A9C3B4E40E0EF17B325493640C0ED0912DB3B4E40D8DCD1FF72493640E84B6F7F2E3C4E4040C23060C9493640DC09F65FE73C4E4048E00F3FFF493640D0E5CDE15A3D4E40F869DC9BDF4A36405C971AA19F3D4E40A0CC3FFA264B364020ED7F80B53D4E40B83D4162BB4B364014014EEFE23D4E4020938C9C854D364028FC523F6F3E4E40B8DAC35E284E3640949EE925C63E4E4028F6D03E565036402C2CB81FF03F4E401048C2BE9D5036409853026212414E40B0AC342905513640742D5A80B6424E40785AB741ED51364020680586AC434E40383E93FDF35436406C0C3A2174444E402820ED7F8055364090FF024180444E40D0BBB1A030583640106F9D7FBB444E40505260014C5B36400000000000454E40187B2FBE68613640F8F36DC152454E40986588635D643640A86BED7DAA454E405082FE428F663640041BD7BFEB454E4050E9279CDD703640FCA204FD85484E40983270404B713640D8092FC1A9484E40E0C4909C4C743640D4E8D500A5494E40A0B0C403CA78364094205C01854A4E406097A8DE1A7A36407C698A00A74A4E40303BC43F6C8136409838F240644B4E4020F609A018893640ACD7F4A0A04D4E407094BC3AC78A3640B896C9703C4E4E40301477BCC98D36403035423F534F4E40A8A487A1D58F3640E42494BE10504E40C8BB2363B5933640C03A8E1F2A524E40C02E8A1EF89636405C7347FFCB524E4048A33B889D9736405875560BEC524E40689126DE01983640E400FA7DFF524E4080DB1324B69F3640C473B680D0534E40807EDFBF79A336404C07EBFF1C544E4040B62C5F97A73640DC54DD239B544E4008F148BC3CAB364068D311C0CD544E40582E1B9DF3AF36407445292158564E40880E812381B436405C8B16A06D574E40F0272A1BD6BA3640C440D7BE80584E408863963D09C03640D4EE5701BE594E40D04065FCFBC03640F44E05DCF3594E402802D53F88CC3640E8AE25E4835C4E4070B54E5C8ECF36400C45BA9F535D4E40E04598A25CD436401048C2BE9D5E4E4018541B9C88D43640542B137EA95E4E408033F8FBC5DC3640782AE09EE75F4E40B025AB22DCE4364090E1B19FC5614E40085A8121ABEB3640DC21C50089634E40E0BA624678ED364064C5707500644E40C8DC7C23BAF13640F4237EC51A654E4060A2410A9EF83640E427D53E1D664E40304487C091FC3640D45DD90583664E40702711E15F023740E0067C7E18674E4028C0B0FCF9063740F4A8F8BF23684E408887307E1A09374038143E5B07694E40C8AF1F62830D3740FCCF9A1F7F6A4E4068DCD440F30F37404C253CA1D76B4E4008871744A410374020DE7360396C4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','3.66217729452e-002','AN010FI00149','0105000020E6100000010000000102000020E610000003000000B0075A8121AB3A40FCF33460906E4E400088F4DBD7B33A40F0A83121E66E4E4050E09D7C7AB43A407C4B395FEC6E4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','5.86144883472e-002','AN010FI00150','0105000020E6100000010000000102000020E61000000300000050E09D7C7AB43A407C4B395FEC6E4E40B8F5D37FD6B83A40FCE42840146F4E40C85EEFFE78C33A403C86C77E166F4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','1.80866668506e-001','AN010FI00156','0105000020E6100000010000000102000020E610000011000000F0B73D41627D3940C8552C7E53724E40B01919E42E8439408CF0F62004754E40F81400E3198639405007B29E5A764E4030AA0CE36E8639401499B9C0E5764E400079AF5A99863940546AF6402B774E4088ECBC8DCD8639407CB5A33847774E40304DD87E328A394040F50F2219794E4030F31DFCC48D3940D0E80E62677A4E40F8BD4D7FF68F394078A565A4DE7A4E40900BCEE0EF913940349886E1237B4E4080B1F7E28B923940DCEEE53E397B4E40889FFF1EBC9239402C5F97E13F7B4E40B088618731953940203F1BB96E7B4E40901D1B8178953940281DACFF737B4E40C837143E5B993940C073EFE1927B4E4010786000E19B3940CCB56801DA7B4E4028DEC83CF2A3394050250340157D4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','1.04353629176e+000','AN010FI00157','0105000020E6100000010000000102000020E61000001C000000C85EEFFE78C33A403C86C77E166F4E40B02E6EA301CA3A40FCCC599F726F4E401866A19DD3D43A40D0B2EE1F0B704E40F87B293C68DE3A400854FF2092704E40F884251E50EC3A4088E76C01A1704E4010FFE9060AF43A40BC0A293FA9704E40C8EEC9C342FD3A40C8703C9F01714E40184850FC180B3B4018B7D100DE714E40704EECA17D1E3B40805D4D9EB2724E4048B6F3FDD4203B40E43FA4DFBE724E4060DF4E22C2353B409CFC169D2C734E4070162F16863C3B40F484251E50734E4018541B9C88463B40A0CE15A584734E405861FA5E43523B403C1F9E25C8734E402835B401D85A3B405CA626C11B744E40B071FDBB3E6B3B4068EE21E17B744E40802766BD18883B40D4BB783F6E754E404089CF9D608F3B40A8531EDD08754E405025CADE52923B4070693524EE744E4020DBF97E6A983B40B41CE8A1B6744E40202098A3C79D3B40F0845E7F12754E40B0F84D61A5A63B40DCEEE53E39764E401863601DC7A73B4064F4DC4257764E4000F1BA7EC1AE3B40B0E3BF4010774E40589198A086B93B40A8D1E4620C784E408899B67F65C33B40380186E5CF784E40B080423D7DC63B407833A31F0D794E40D05D4BC807CD3B406043705CC6794E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','3.17454695911e-001','AN010FI00159','0105000020E6100000010000000102000020E61000001A00000008871744A410374020DE7360396C4E405804FF5BC9103740D4B2B5BE486C4E409052D0ED2511374028FC523F6F6C4E40C00AB77C24133740DC3F16A2436D4E40588E90813C1737400C45BA9F536E4E4070AF05BD372037404C1C7920B26F4E404097A949F02237409C1727BEDA6F4E4000DBC1887D2A374034535A7F4B704E4090D8EE1EA02D374004098A1F63704E40A86BED7DAA32374044BC75FEED6F4E408060C77F81363740C84CA25EF06F4E4060E28FA2CE363740083C3080F06F4E403874B33F503A37409017D2E121704E40985984622B3E374064821ABE85704E40B0E0B721C64137407439252026714E40E83922DFA5443740C070AE6186714E4088F678211D4C37402CFC19DEAC714E403856629E954E37406CD619DF17724E40402B3064754F3740D0E80E6267724E40F08AA71E695037402C20B41EBE724E40B0F36F97FD503740B4A338471D734E40F8E12021CA51374014B70A62A0734E4000D0285DFA5337404C3ACAC16C744E4090A2CEDC43563740701283C0CA744E40C801F4FBFE593740C84961DEE3744E40A8C2D842905D3740D4D9C9E028754E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','5.89783509309e-001','AN010FI00160','0105000020E6100000010000000102000020E61000002C000000A8C2D842905D3740D4D9C9E028754E40E0DFA0BDFA5E3740082461DF4E754E4048F8174163603740CCFACDC474754E4020BDE13E72633740E0270EA0DF754E40005471E316653740181406651A764E405013B69F8C6B37403050526001774E40489E245D33753740D0AFAD9FFE784E4098B7239C1678374064A6B4FE96794E40803E9127497D3740209A79724D7A4E401048C2BE9D84374098B036C64E7B4E40688EACFC32863740C070AE61867B4E4058130B7C458F37404C2844C0217D4E40B016D863229137405C9A5B21AC7E4E4028486C770F923740AC6F6072A37F4E40D052B29C84923740C0374D9F1D804E4080B08C0DDD923740886A4AB20E814E4090EDB5A0F792374020054F2157814E409035EA211A95374040D7BE805E824E40E0180280639737405001309E41834E40F0052D2460983740E88711C2A3834E40A8B9DC60A89B37405067EE21E1844E4068C70DBF9B9E374074874D64E6854E4030EC3026FD9F3740E0A0BDFA78864E4070E2AB1DC5A137408CFCFA2136874E40B84604E3E0A23740A49E05A1BC874E406052B5DD04A3374068D311C0CD874E4038B6D782DEA33740A8AAD0402C884E4060A9674128A73740C44659BF99894E400005DEC9A7A73740ACFA5C6DC5894E4018EAE923F0AB37408CCF64FF3C8B4E40586CCCEB88AF37405473B9C1508C4E40E0CCAFE600B13740A8BF5E61C18C4E40A011A5BDC1B337400C42791F478D4E40C082FB010FB63740A86E2EFEB68D4E408084285FD0BA3740408C101E6D8E4E40E0CD531D72CD3740804E417E36914E40C8552C7E53CE374024DBF97E6A914E4030E411DC48CF374088997D1EA3914E4068E21DE049D137406C0377A04E924E404819710168D6374014AE47E17A934E407066BB421FDE374020B75F3E59944E40C0A563CE33E03740C0C6F5EFFA944E40F0B4FCC055E0374038622D3E05954E403877F4BF5CE137407C849A2155954E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','1.54097887389e-001','AN010FI00161','0105000020E6100000010000000102000020E61000000A0000009023D6E253C2384000D061BEBC684E402084807C09C138403883BF5FCC694E40C0D4CF9B8ABC3840DC8D3EE6036B4E403886C77E16B93840481FF301816C4E4070253B3602B73840581EA4A7C86D4E4060C77F8120B638400C45BA9F536E4E40F89672BED8B53840C0A085048C6E4E4050E6E61BD1B3384088D860E124704E408078962023AC3840D0B2EE1F0B734E40F86393FC88A538408CC6DADFD9754E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','9.84338301973e-001','AN010FI00162','0105000020E6100000010000000102000020E61000002D00000000DFA63FFBB3394060B87361A47C4E40F027637C98B53940A448BE12487C4E4038BC202235B93940E45DF580797B4E40B8438A0112BD394064D68BA19C7A4E40802DAF5C6FCB394084E7A56263794E40189FC9FE79CE3940D8D0CDFE40794E40D8B27C5D86D3394080C0030308794E40A8B6D4415ED939406CF12900C6784E40B0BF2500FFE239407C336ABE4A784E40F80EB743C3EC39403CC5AA4198774E40D058FB3BDBF13940CC6ABA9EE8764E4088FC3383F8FA3940E82D1EDE73764E40A06B98A1F1023A40382F4E7CB5764E403083F8C08E033A40C02EC37FBA764E40E0606F6248043A40C8F2AE7AC0764E40B0C5A70018073A40EC7E15E0BB764E40786682E15C153A40DCD9571EA4764E4040BFEFDFBC1C3A40347D76C075764E4010A2B5A2CD213A404CE658DE55764E40D85240DAFF283A40CC001764CB754E40E054A4C2D82C3A403C71395E81754E40A0CEDC43C22F3A403035423F53754E40A071A8DF85373A4004452C62D8744E408811C2A38D393A404092921E86744E4060B83A00E23C3A40F0AEB321FF734E40105D50DF32413A40ACD7F4A0A0724E40B0A415DF50483A40B4B3E89D0A724E404076DEC666513A403C747ADE8D714E40C02500FF94543A4008FA0B3D62714E40B06EF59CF4583A40D033F6251B714E4028ED461FF3673A40C879FF1F27704E40D8B27C5D86713A401CC3633F8B6F4E40704E2503407D3A40689DF17D716E4E4020BAA0BE658C3A40B8E34D7E8B6C4E40D8E89C9FE28C3A4068EE21E17B6C4E402074D0251C963A402C29779FE36B4E402838F581E4993A4088CF9D60FF6B4E40784B395FEC993A4024F0879FFF6B4E40809065C1C49B3A407833A31F0D6C4E40C070E7C2489F3A400C6954E0646C4E40D8E3857478A03A4080501729946C4E40303D618907A23A40A04FE449D26C4E4008F52D73BAA23A4058276728EE6C4E4088EAE6E26FA73A401CF9BCE2A96D4E40B0075A8121AB3A40FCF33460906E4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','1.68916586371e-002','AN010FI00164','0105000020E6100000010000000102000020E61000000300000028DEC83CF2A3394050250340157D4E404074081C09A43940C45565DF157D4E405861FA5E43A839404450357A357D4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','4.61579730373e-002','AN010FI00165','0105000020E6100000010000000102000020E6100000040000005861FA5E43A839404450357A357D4E4068006F8104A93940283E3E213B7D4E4098711AA20AAB394044F295404A7D4E4000DFA63FFBB3394060B87361A47C4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','1.90836364414e-001','AN010FI00166','0105000020E6100000010000000102000020E61000000D000000F86393FC88A538408CC6DADFD9754E4060AC6F6072A538401499B9C0E5754E40500FD1E80EA03840DCDFD91EBD784E4098E447FC8A9B3840C44CDBBFB2794E40D05EB69DB696384068B5C01E137A4E404055850662933840A8C7B60C387A4E406043705CC691384068E21DE0497A4E4028F38FBE498D38401472A59E057B4E40389204E10A843840307DAF21387D4E40B0045262D7823840545BEA20AF7D4E4048ADF71BED7E3840504CDE00337F4E4098ED0A7DB07C38407C48F8DEDF7F4E4090088D60E37A384040DAFF006B804E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','1.23325451846e-001','AN010FI00168','0105000020E6100000010000000102000020E61000000B00000090088D60E37A384040DAFF006B804E40901491611579384064F4DC4257814E401021AE9CBD753840D4D347E00F824E40C0C3EDD0B07438408C5E0D501A824E407083DA6FED7238402CA391CF2B824E40F858C16F43723840AC97DF6932824E40D049EF1B5F6F3840A0444B1E4F824E40D018ADA3AA6D3840503DD2E0B6824E4080B1F7E28B663840082AE3DF67844E40D0122BA3915F384024D5777E51864E40B82EFCE07C5E384034384A5E9D864E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','2.27051725078e-001','AN010FI00169','0105000020E6100000010000000102000020E61000000E000000B82EFCE07C5E384034384A5E9D864E406818778368593840E01B430070874E407815527E52593840F4DBD78173874E40100C207C28593840D09D60FF75874E40B82572C11956384040B96DDFA3874E40684B1DE4F54E38405CA3E5400F884E40D8791B9B1D49384094490D6D00884E40485B5CE333453840F8BD4D7FF6874E40509D0E643D4138404C31074147884E40E80CC51D6F3C3840146C239EEC884E40807E18213C383840544FE61F7D894E40F81400E31930384014A58460558A4E4040C23060C92B38401072DEFFC78A4E4050E6E61BD1253840942F6821018C4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','2.77944686705e-001','AN010FI00170','0105000020E6100000010000000102000020E61000000B00000050E6E61BD1253840942F6821018C4E4058C7F143A5173840DC0F7860008E4E40585EB9DE360D38401CD5E940D68E4E40D8F4A0A0140D3840904FC8CEDB8E4E407838BA4A770938401429CDE6718F4E4010D55B035B093840EC9C6681768F4E40D8F15F200808384088EAAD81AD8F4E40F0B776A2240038406CA6423C12914E4060F71DC363F937403065E08096924E40D812B9E00CEE3740FCB48AFED0934E403877F4BF5CE137407C849A2155954E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','3.03744556273e-001','AN010FI00171','0105000020E6100000010000000102000020E610000012000000A8ADD85F76313C40387172BF43864E4008789961A3323C408838D6C56D864E400896EA025E343C40A47A6B60AB864E40C0EFDFBC38393C40449E245D33874E40088D60E3FA3F3C401C4D2EC6C0874E40386EF8DD74413C40FCDEA63FFB874E40108C834BC7463C4084D21742CE884E40F0D24D6210483C40EC60C43E01894E40402CD49AE64B3C4078499C1551894E40E84482A966523C401C87FA5DD8894E40B89E211CB3523C406C1805C1E3894E40C801F4FBFE553C40F8A8BF5E618A4E40D80627A25F5D3C40846F9A3E3B8C4E408045B75ED35F3C409C2FF65E7C8C4E40688BA4DDE8653C400427DBC01D8D4E4000D0285DFA6F3C409877D503E68D4E402023A0C211743C4044FB58C16F8E4E4078962023A07C3C4020E4BCFF8F8F4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','6.68169120926e-001','AN010FI00173','0105000020E6100000010000000102000020E61000002400000050EFE2FDB87535405C88D51F61904E40D031E719FB763540E456410C74904E40C016F4DE187E3540C428081EDF904E40D81A118C837F3540745DF8C1F9904E4088CF9D60FF7F354074E272BC02914E40B82231410D89354090DB2F9FAC914E407834D593F98B35402C2FF99FFC914E40986BD102B48D35400C8AE6012C924E4050FBAD9D28913540847EA65EB7924E4028357BA0159A35400CC9C9C4AD934E40E89CD843FBA8354084CFD6C1C1944E4010842BA050AB3540EC8D5A61FA944E40B86DDFA3FEAE35400C45BA9F53954E40E8667FA0DCB0354028ABE97AA2954E401012A27C41B13540A05C5320B3954E40D0122BA391B335403026FDBD14964E40B0FE08C380B735408C1D8D43FD964E40384415FE0CBB3540240516C094974E40903BA583F5BB354044DAC69FA8974E40786682E15CBF354024ED461FF3974E40E0D39CBCC8C8354070766B990C984E4058677C5F5CCA3540281422E010984E40384415FE0CD935404C10751F80984E40E0CAD93BA3DD3540CC8B135FED984E40D8C1887D02E03540DC183BE125994E40C87BD5CA84E735407C7555A0169A4E4008A52F849CEF3540002D5DC1369A4E406809F9A067F93540D4D347E00F9A4E4048F295404AFA3540A8D1E4620C9A4E4078543541D4FF3540F0811DFF059A4E4080FDD7B9690D3640240516C0949A4E40B06CE690D4123640C8DB4AAFCD9A4E4018170E8464153640CC6ABA9EE89A4E4090118942CB163640F4CCCB61F79A4E4068E256410C1A36404C378941609B4E40A8893E1F651E3640941799805F9B4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','1.34242888352e-002','AN010FI00174','0105000020E6100000010000000102000020E610000003000000108D278238D93740B4E386DF4D964E403050526001DA3740804E417E36964E406876DD5B91DC374054EC681CEA954E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','1.92724511902e-002','AN010FI00175','0105000020E6100000010000000102000020E6100000040000006876DD5B91DC374054EC681CEA954E40D067075C57E037403C6EF8DD74954E40C81D6FF25BE0374064355D4F74954E403877F4BF5CE137407C849A2155954E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','3.01182496061e-001','AN010FI00176','0105000020E6100000010000000102000020E61000000E00000078962023A07C3C4020E4BCFF8F8F4E40C0654E97C5803C40F4A5B73F17904E40F099EC9FA7853C40B41CE8A1B6904E4010A5F622DA9A3C4088BA0F406A934E40E87E4E417E9C3C40C44659BF99934E4070E82D1EDEA13C4014CC988235944E4048AD307DAFA93C40D400A5A146954E40E01B0A9FADAD3C400433A6608D964E40E80F069E7BB33C404CECDADE6E974E403083F8C08EB33C40E87B0DC171974E40308639419BB83C4088A2409FC8974E4078EB353D28BC3C40481FF30181984E40A005A1BC8FC13C4088C3D2C08F984E400809185DDEC63C408884EFFD0D994E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','3.29157136582e-002','AN010FI00177','0105000020E6100000010000000102000020E6100000050000000809185DDEC63C408884EFFD0D994E40D04BC5C6BCCA3C40B83F170D19994E40D091955F06CB3C401057CEDE19994E406024B4E55CCE3C4044A2D0B2EE994E40A06516A1D8CE3C4054431B800D9A4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','7.89527388089e-002','AN010FI00178','0105000020E6100000010000000102000020E6100000060000002838BC2022C7374094020B60CA9A4E40209D819197C73740CC0D863AAC9A4E40F0E49A0299CB3740D4E8D500A5994E40805A0C1EA6CD3740E03653211E994E40285305A392D4374028F04E3E3D974E40108D278238D93740B4E386DF4D964E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','1.02644684836e-002','AN010FI00179','0105000020E6100000010000000102000020E6100000020000002814E97E4E4B3640385FECBDF8A04E4080B74082E24D3640608E1EBFB7A04E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','6.09356541178e-001','AN010FI00180','0105000020E6100000010000000102000020E61000003400000080B74082E24D3640608E1EBFB7A04E4030A7CB62624F364064D34A2190A04E403856293DD357364094FC885FB19F4E408878EBFCDB5D36408CB7955E9B9F4E40C058DFC0E45E3640DCD6169E979F4E40D0DC43C2F76036400C51853FC39F4E402093C5FD4762364028081EDFDE9F4E40001E51A1BA653640505260014CA04E40F0A62215C66A3640D8D9907F66A14E40A82215C6166E36409CF9D51C20A24E4090DB2F9FAC7036404879E6E5B0A24E40E877616BB672364060342BDB87A34E40B09B525E2B733640B4E89D0AB8A34E40D8300A82C7733640440DA661F8A34E4080B4FF01D674364024473A0323A44E4000F4346090763640187B2FBE68A44E4028CB10C7BA763640E4F21FD26FA44E40C02EC37FBA793640C84CA25EF0A44E40A0F0129CFA7A3640344A97FE25A54E40B89E211CB37E364070361D01DCA54E4018963FDF16843640E43FA4DFBEA64E40E85DBC1FB785364004249A4011A74E40C087122D79863640F892C6681DA74E4098DBF63DEA8936405C85949F54A74E40483140A2098C364048CB811E6AA74E40D81533C2DB8D36404C3D0B4279A74E4048408523488F3640EC51B81E85A74E40981A683EE7943640546AF6402BA74E4010F0A485CB9A364070E82D1EDEA64E4070F1B73D419C364008336DFFCAA64E40608BDD3EAB9E364088C3D2C08FA64E40B8ECD79DEEA43640348CBB41B4A54E40202444F982A8364064AC36FFAFA54E40D827B9C326B436409853026212A64E4020BAA0BE65B63640B865C0594AA64E40506DA983BCB83640542E54FEB5A64E4050F17F4754BA36402873F38DE8A64E4030E411DC48BB3640EC909BE106A74E4048CE893DB4C33640307A6EA12BA84E40C8707500C4C33640846C59BE2EA84E40D89DEE3CF1C63640D0D38041D2A84E40607138F3ABC73640A058A7CAF7A84E40B06EF59CF4CC3640BCF2599E07AA4E40383B191C25CF3640B8162D40DBAA4E4028F9D85DA0D23640F093A30051AB4E40788A558330D5364000D3A23EC9AB4E40A8E67283A1D63640D400A5A146AC4E40C8CEDBD8ECDA364030293E3E21AD4E40104E0B5EF4DB3640ACCB290131AD4E4048438D4292DD3640C458A65F22AD4E40888DB27E33E136408481E7DEC3AC4E409020956247E33640F0CC04C3B9AC4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','3.32770422130e-001','AN010FI00181','0105000020E6100000010000000102000020E610000012000000F04B361E6CD73540A077634161BA4E408857923CD7D735400009C38025BA4E4058F65D11FCD93540D0C8E7154FB84E40302C7FBE2DDA3540ACC8E88024B84E40706C3D4338DE3540BC344580D3B64E401899805F23DF354028232E008DB64E4070D3669C86E435404C86E3F90CB54E40E82ADD5D67E73540B83A00E2AEB44E402844F98216EA35405840A19E3EB44E4090D8278062FC3540C04692205CB04E40503F6F2A52013640543D997FF4AE4E4070D921FE61013640EC3C2AFEEFAE4E40E00C37E0F30336409CFC169D2CAE4E4088963C9E96073640C876BE9F1AAD4E408811C2A38D0F3640E00F3FFF3DAB4E407884D382171936402805DD5ED2A94E40B819A721AA22364044B6F3FDD4A74E40989EE925C622364098236420CFA74E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','1.67422426073e-001','AN010FI00182','0105000020E6100000010000000102000020E610000004000000989EE925C622364098236420CFA74E408872A25D85303640F4C308E1D1A44E40E803029D493B36401CE1B4E045A34E402814E97E4E4B3640385FECBDF8A04E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','1.86399104685e-001','AN010FI00183','0105000020E6100000010000000102000020E6100000170000005064ADA1D4C63740FCE1E7BF07BF4E40E8284014CCC63740BC61DBA2CCBE4E4070D9E89C9FC637400C2769FE98BD4E40E8573A1F9EC5374040EF8D2100BD4E40909944BDE0C337408CEDB5A0F7BB4E40A023B9FC87C2374060C1FD8007BB4E4048DD0720B5C137401490F63FC0BA4E40E8486760E4BF3740C067244223BA4E40B0A4DC7D8EBF374078573D601EB94E4078909E2287C03740982F2FC03EB84E40F096E4805DC137400C21E7FD7FB74E40888A389D64C13740E8BF07AF5DB74E4008E275FD82C13740E442E55FCBB64E40F88D76DCF0C1374094DBF63DEAB54E4020AB5B3D27C3374024085740A1B34E40B8DD04DF34C337403C8C497F2FB24E40D07C073F71C237404CE658DE55B04E408856276728C2374014A8C5E061AD4E4030EDD45C6EC23740F4B1BB4049AC4E40F8635A9BC6C2374048A643A7E7AA4E409829E620E8C23740F8A8BF5E61AA4E40C83D963E74C337403065E08096A94E4038807EDFBFC337402C357BA015A94E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','2','152','8','1','3','1','1.18117478657e-001','AN010FI00184','0105000020E6100000010000000102000020E61000001200000038807EDFBFC337402C357BA015A94E4060C47762D6C33740E43FA4DFBEA84E40703FE08101C4374088D51F6118A84E4048658A3908C4374090C01F7EFEA74E4028E659492BC4374064CDC82077A74E4018EDF1423AC43740B0A547533DA74E4080751C3F54C43740D4A6EA1ED9A64E40F0E2C4573BC4374024B4E55C8AA64E40F0612F14B0C3374018B49080D1A44E4060B5F97FD5C3374054A0168387A34E40102A38BC20C4374004637D0393A24E40681536035CC6374038894160E5A04E40801EA33CF3C6374084C64CA25EA04E40383B191C25C73740BC16F4DE189E4E4058AF22A303C637401C3C139A249D4E40689126DE01C63740B0E600C11C9D4E40481FBAA0BEC537407C4E7ADFF89B4E402838BC2022C7374094020B60CA9A4E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','6.21394764231e-001','AN010FI00186','0105000020E6100000010000000102000020E610000038000000383811FDDAB03A40A0832EE1D07A4E4028F9D85DA0B23A402C5F97E13F7B4E4028711DE38AB13A4060D6C4025F7C4E4040E0810184B13A4040F50F22197E4E4050F564FED1B33A409C62D520CC7F4E40B8B6F0BC54B43A4044CBBA7F2C804E40E803029D49B93A40C03A8E1F2A824E40001B498270B93A40BC8DCD8E54824E4038B91803EBBA3A40806C921FF1834E40D0FDD5E3BEBB3A402835B401D8844E40C88B852172BC3A40189F02603C864E4058FA0967B7BC3A40ACE0B721C6864E40A859A0DD21BD3A40C44659BF99874E40E057ACE122BD3A4068C70DBF9B874E40588638D6C5BF3A40C437143E5B894E4050D7135D17C23A40C058DFC0E48A4E40305C1D0071C73A407C30293E3E8B4E40485B5CE333C93A402C3E05C0788B4E4080C6850321CD3A40C8737D1F0E8C4E4010AB7823F3D03A403C8908FF228D4E40604F745DF8D13A40DC54DD239B8D4E406058FE7C5BD43A4014C3D501108F4E40B068739CDBD23A40C02B82FFAD904E40A829029CDECF3A405CACA8C134924E408096E7C1DDCF3A40B86455849B924E40E8B46E83DACF3A40C45BE7DF2E944E40408F183DB7CE3A4004E8F7FD9B964E40A07DE5417ACC3A4090ED7C3F35984E40A045EF54C0CB3A4020DD088B8A984E40F83FC05AB5C93A4098A608707A994E40F8BD86E0B8C83A40C89A9141EE994E407878CF81E5C83A4040EE224C519A4E407018CC5F21C93A40D8E55B1FD69A4E4020624A24D1C93A40FC78E8BB5B9C4E40D08BDAFD2ACA3A40F4EA1C03B29E4E40605B3FFD67C93A402C8C2D0439A04E40F0811DFF05CA3A40D0D03FC1C5A04E40B82BF4C132CA3A4068ACFD9DEDA04E4018F0F96184CA3A40E42D573F36A14E401048C2BE9DCE3A4070D921FE61A24E4068EE21E17BD13A4034971B0C75A34E40D0D38041D2D33A40D4B5F63E55A44E40F0A8F8BF23D43A403CC269C18BA44E40301F10E84CD83A40A07422C154A74E4040C2F7FE06DF3A40A877F17EDCA84E40D006600322E63A401490F63FC0AA4E40F051465C00E83A40E851F17F47AC4E4058BE2EC37FE63A40E83F6B7EFCAD4E40982F2FC03EE43A40D4EB1681B1AF4E40F8B7CB7EDDE33A40A80183A44FB14E40A89BC420B0E63A4068AF3E1EFAB24E40C0120F289BE63A4034C7F2AE7AB34E4048404CC285E63A401890BDDEFDB34E40F090291F82E63A40A4B3CC2214B44E40D821FE614BE53A40306B6281AFB44E4070BD6DA642E43A40FCDB65BFEEB44E40');
INSERT INTO "railrdl" ("fcsubtype","gfid","f_code","icc","sn","exs","fco","gaw","loc","rgc","rra","rsu","shape_leng","railid",the_geom) VALUES ('1',NULL,'AN010','FI','3291','28','3','152','8','1','3','1','6.18551111397e-001','AN010FI00187','0105000020E6100000010000000102000020E61000002000000050431B800D603D4080B1BE81C9B54E4010548D5E0D5E3D404C16F71F99B54E40D0EE9062805C3D404C0D349F73B54E4020BA675DA3593D40B0FB8EE1B1B44E40388908FF22563D40D8C1C1DEC4B34E4068F12900C6513D406494675E0EB14E40D891EA3BBF4C3D40CC76853E58AF4E40806FD39FFD423D40D8E55B1FD6AD4E40E01E4B1FBA423D403CA41820D1AD4E40C0FBAA5CA8403D40542B137EA9AD4E40E82494BE10343D40F4BD86E0B8AC4E4090DE37BEF6283D40F8C3CF7F0FAB4E40C873B680D01E3D40DC03745FCEA84E4048749659841A3D400453CDACA5A74E404837C2A222183D40EC60C43E01A74E405073F22213163D40D8DCD1FF72A64E40B8E00CFE7E133D40B0F84D61A5A54E40D04F711C78113D40B0E07EC003A54E4018D2A8C0C9083D4060855B3E92A34E40E8C6BB2363073D401CC3633F8BA34E4048E3175E49023D4044AD69DE71A34E40F09925016AFC3C4038B9DFA128A34E4070E5EC9DD1F03C40DC09F65FE7A14E40B0045262D7EE3C40DCDC989EB0A14E40383E5A9C31E83C40F8083543AAA04E40388DB454DEE23C40D0BEF2203D9F4E40B8287AE063E03C4004637D03939E4E4078280AF489DE3C404CE3175E499E4E40B861DBA2CCDA3C4028DE019EB49D4E40702D5A80B6D33C406CF12900C69B4E4080C0CAA145D03C40F4936A9F8E9A4E40A06516A1D8CE3C4054431B800D9A4E40');