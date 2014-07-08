SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE :schema_final.table1 (
gid serial PRIMARY KEY,
column1 character varying(3) NOT NULL,
column2 character varying(50));

insert into :schema_final.table1 select gid, nln, lnm from :schema_initial.ebm_chr where nln <> 'FIN' ;

COMMIT;

analyze table1 ;