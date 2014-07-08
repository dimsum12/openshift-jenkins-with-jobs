--------------------------------------------------------
--------------------------------------------------------
start transaction;

CREATE TABLE :schema_final.routes (
    gid serial NOT NULL,
    id character varying(24) NOT NULL,
    style character varying(10) DEFAULT 'NR'::character varying,
    num_route character varying (10) DEFAULT 'NC'::character varying,
    nom character varying (127) DEFAULT 'NC'::character varying
);
SELECT AddGeometryColumn(':schema_final','routes','the_geom','210642000','MULTILINESTRING',2);

insert into :schema_final.routes(id,style,num_route,nom,the_geom) select id_bdcarto,'BRETEL',num_route,toponyme,transform(the_geom,210642000) from :schema_initial.troncon_route where vocation='Bretelle' and class_adm<>'Autoroute' ;
insert into :schema_final.routes(id,style,num_route,nom,the_geom) select id_bdcarto,'LOCALE',num_route,toponyme,transform(the_geom,210642000) from :schema_initial.troncon_route where vocation='Liaison locale' and class_adm<>'Autoroute' ;
insert into :schema_final.routes(id,style,num_route,nom,the_geom) select id_bdcarto,'AUTO',num_route,toponyme,transform(the_geom,210642000) from :schema_initial.troncon_route where vocation='Type autoroutier' or class_adm='Autoroute' ;
insert into :schema_final.routes(id,style,num_route,nom,the_geom) select id_bdcarto,'PRINCIP',num_route,toponyme,transform(the_geom,210642000) from :schema_initial.troncon_route where vocation='Liaison principale' and class_adm<>'Autoroute' ;
insert into :schema_final.routes(id,style,num_route,nom,the_geom) select id_bdcarto,'REGION',num_route,toponyme,transform(the_geom,210642000) from :schema_initial.troncon_route where vocation='Liaison régionale' and class_adm<>'Autoroute' ;
insert into :schema_final.routes(id,style,num_route,nom,the_geom) select id_bdcarto,'CYCLABLE',num_route,toponyme,transform(the_geom,210642000) from :schema_initial.troncon_route where vocation='Piste cyclable' and class_adm<>'Autoroute' ;
update :schema_final.routes set num_route='NC' where num_route is null;
update :schema_final.routes set nom='NC' where nom is null;

commit ;

ALTER TABLE :schema_final.routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (gid);

CREATE INDEX routes_geoidx ON :schema_final.routes USING gist (the_geom public.gist_geometry_ops);

CREATE INDEX routes_style_idx ON :schema_final.routes USING btree (style);

analyze :schema_final.routes ;

--------------------------------------------------------
--------------------------------------------------------

-- drop table :schema_final.iti if exists;

-- start transaction;

--CREATE TABLE :schema_final.iti (
--    gid serial NOT NULL,
--    nom character varying (127) DEFAULT 'NC'::character varying
--);
--SELECT AddGeometryColumn(':schema_final','iti','the_geom','210642000','MULTILINESTRING',2);
--
--insert into :schema_final.iti select gid,toponyme,transform(the_geom,210642000) from :schema_initial.itineraire ;
--update :schema_final.iti set nom='NC' where nom is null ;
--
--update :schema_final.iti set nom=upper(substring(nom from 1 for 1))||substring(nom from 2);
--
-- commit ;

-- ALTER TABLE :schema_final.iti
--     ADD CONSTRAINT iti_pkey PRIMARY KEY (gid);

-- CREATE INDEX iti_geoidx ON :schema_final.iti USING gist (the_geom public.gist_geometry_ops);

-- analyze :schema_final.iti ;
--------------------------------------------------------
--------------------------------------------------------
start transaction;

CREATE TABLE :schema_final.occsol (
    gid serial NOT NULL,
    style character varying (10) DEFAULT 'NC'::character varying
);
SELECT AddGeometryColumn(':schema_final','occsol','the_geom','210642000','MULTIPOLYGON',2);

insert into :schema_final.occsol (style,the_geom) select 'HABITAT',transform(the_geom,210642000) from :schema_initial.zone_occupation_sol where nature='Bâti';
insert into :schema_final.occsol (style,the_geom) select 'ACTIVITE',transform(the_geom,210642000) from :schema_initial.zone_occupation_sol where nature='Zone d''activités';

commit ;

ALTER TABLE :schema_final.occsol
    ADD CONSTRAINT occsol_pkey PRIMARY KEY (gid);

CREATE INDEX occsol_geoidx ON :schema_final.occsol USING gist (the_geom public.gist_geometry_ops);
CREATE INDEX occsol_style_idx ON :schema_final.occsol USING btree (style);

analyze :schema_final.occsol ;
--------------------------------------------------------
--------------------------------------------------------
start transaction;

CREATE TABLE :schema_final.hydrosurf (
    gid serial NOT NULL,
    style character varying (10) DEFAULT 'NC'::character varying
);
SELECT AddGeometryColumn(':schema_final','hydrosurf','the_geom','210642000','MULTIPOLYGON',2);

insert into :schema_final.hydrosurf (style,the_geom) select 'SURFEAU',transform(the_geom,210642000) from :schema_initial.surface_hydrographique where nature='Eau libre';

commit ;

ALTER TABLE :schema_final.hydrosurf
    ADD CONSTRAINT hydrosurf_pkey PRIMARY KEY (gid);

CREATE INDEX hydrosurf_geoidx ON :schema_final.hydrosurf USING gist (the_geom public.gist_geometry_ops);
CREATE INDEX hydrosurf_style_idx ON :schema_final.hydrosurf USING btree (style);

analyze :schema_final.hydrosurf ;
--------------------------------------------------------
--------------------------------------------------------
start transaction;

CREATE TABLE :schema_final.hydrolin (
    gid serial NOT NULL,
    style character varying (10) DEFAULT 'NC'::character varying
);
SELECT AddGeometryColumn(':schema_final','hydrolin','the_geom','210642000','MULTILINESTRING',2);

insert into :schema_final.hydrolin (style,the_geom) select 'BIGTDEAU',transform(the_geom,210642000) from :schema_initial.troncon_hydrographique where not(pos_sol='-1') and classe='100';
insert into :schema_final.hydrolin (style,the_geom) select 'MOYTDEAU',transform(the_geom,210642000) from :schema_initial.troncon_hydrographique where not(pos_sol='-1') and classe='50';
insert into :schema_final.hydrolin (style,the_geom) select 'MOYTDEAU',transform(the_geom,210642000) from :schema_initial.troncon_hydrographique where not(pos_sol='-1') and classe='25';
insert into :schema_final.hydrolin (style,the_geom) select 'TRONDEAU',transform(the_geom,210642000) from :schema_initial.troncon_hydrographique where not(pos_sol='-1') and classe not in ('25','50','100');
insert into :schema_final.hydrolin (style,the_geom) select 'SOUTERRAIN',transform(the_geom,210642000) from :schema_initial.troncon_hydrographique where pos_sol='-1';

commit ;

ALTER TABLE :schema_final.hydrolin
    ADD CONSTRAINT hydrolin_pkey PRIMARY KEY (gid);

CREATE INDEX hydrolin_geoidx ON :schema_final.hydrolin USING gist (the_geom public.gist_geometry_ops);
CREATE INDEX hydrolin_style_idx ON :schema_final.hydrolin USING btree (style);

analyze :schema_final.hydrolin ;
--------------------------------------------------------
