SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "ebm_isn" (gid serial PRIMARY KEY,
"icc" varchar(2),
"isn" int2,
"desn" varchar(80),
"desa" varchar(80),
"nln" varchar(11),
"iss" int2,
"shi" int2);
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('FI','4901','Tasavalta#Republik','Tasavalta#Republik','FIN#SWE','4902','6');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('FI','4902','Lääni#Län','Laani#Lan','FIN#SWE','4903','5');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('FI','4903','Maakunta#Landskap','Maakunta#Landskap','FIN#SWE','4904','3');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('FI','4904','Kunta#Kommun','Kunta#Kommun','FIN#SWE','998','0');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('SE','3001','Kungarike','Kungarike','SWE','3002','4');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('SE','3002','Län','Lan','SWE','3003','2');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('SE','3003','Kommun','Kommun','SWE','998','0');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('NO','3301','Kongerike','Kongerike','NOR','3302','4');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('NO','3302','Fylke','Fylke','NOR','3303','2');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('NO','3303','Kommune','Kommune','NOR','998','0');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('DK','4701','Kongeriget','Kongeriget','DAN','4702','7');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('DK','4701','Kongeriget','Kongeriget','DAN','4704','7');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('DK','4701','Kongeriget','Kongeriget','DAN','4705','7');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('DK','4702','Region','Region','DAN','4703','3');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('DK','4703','Kommune','Kommune','DAN','998','0');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('DK','4704','Umatrikuleret Søer','Umatrikuleret Soer','DAN','998','3');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('FO','6001','Self-governing territory','Self-governing territory','ENG','6002','4');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('FO','6002','Sysler','Sysler','DAN','6003','2');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('FO','6003','Kommuner','Kommuner','DAN','998','0');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('GL','6101','Self-governing territory','Self-governing territory','ENG','6102','4');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('GL','6102','Kommuner','Kommuner','KAL','998','0');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('DK','4705','Under Forsvarsministeriet','Under Forsvarsministeriet','DAN','998','0');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('IS','3201','Lýðveldi','Lydveldi','ICE','3202','6');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('IS','3202','Umdæmi','Umdaemi','ICE','3203','4');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('IS','3203','Sveitarfélag','Sveitarfelag','ICE','998','0');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('ND','1201','United Kingdom','United Kingdom','ENG','1222','8');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('ND','1222','Province','Province','ENG','1223','7');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('ND','1223','Local government district','Local government district','ENG','1224','2');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('ND','1224','Ward','Ward','ENG','998','0');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('IE','1601','Re,'Re,'ENG','1602','10');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('IE','1602','Euregion','Euregion','ENG','1603','9');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('IE','1603','Regional Authority','Regional Authority','ENG','1604','8');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('IE','1604','County','County','ENG','1605','6');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('IE','1605','Electoral Division','Electoral Division','ENG','998','0');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('EE','4801','Vabariik','Vabariik','EST','4802','6');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('EE','4801','Vabariik','Vabariik','EST','4805','6');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('EE','4802','Maakond','Maakond','EST','4803','4');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('EE','4802','Maakond','Maakond','EST','4804','4');
INSERT INTO "ebm_isn" ("icc","isn","desn","desa","nln","iss","shi") VALUES ('EE','4802','Maakond','Maakond','EST','4805','4');
