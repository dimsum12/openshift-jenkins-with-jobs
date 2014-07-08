SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "ebm_p" (gid serial PRIMARY KEY,
"icc" varchar(2),
"shn" varchar(14));
SELECT AddGeometryColumn('','ebm_p','the_geom','210642000','POINT',2);
COMMIT;