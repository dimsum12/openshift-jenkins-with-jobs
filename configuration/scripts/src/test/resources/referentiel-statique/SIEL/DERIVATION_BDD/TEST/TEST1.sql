set client_encoding='latin1' ;

start transaction;

CREATE TABLE :schema_final.route (
    gid int2,
    name varchar(14)
);
SELECT AddGeometryColumn(':schema_final','route','the_geom','210642000','MULTIPOLYGON',2);

insert into :schema_final.route select taa, shn, the_geom from :schema_initial.ebm_a;

commit ;

analyze :schema_final.route;
