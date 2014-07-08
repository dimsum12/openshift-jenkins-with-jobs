set client_encoding='latin1' ;

start transaction;

CREATE TABLE :schema_final.table0 (
    gid serial NOT NULL,
    column1 character varying(3) NOT NULL,
    column2 character varying(50)
);

insert into :schema_final.table0 select gid, nln, lnm from :schema_initial.ebm_chr where nln <> 'FIN' ;

commit ;

ALTER TABLE ONLY :schema_final.table0
    ADD CONSTRAINT pkey PRIMARY KEY (gid);


analyze :schema_final.table0 ;
