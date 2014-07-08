SELECT 	md5(t."nom") AS id, 
		t."nom"      AS nom, 
		c."code_insee"    AS code_insee, 
		st_x(t.the_geom) AS x,
		st_y(t.the_geom) AS y,
		t."type" || '|' || t."nom" || '|' || c."nom" AS attribute
FROM 	{SCHEMA}.site_geoportail t, {SCHEMA}.commune c
WHERE 	t.the_geom && c.the_geom AND 
		intersects(c.the_geom,st_transform(t.the_geom, st_srid(c.the_geom)))
  AND	c."code_insee" LIKE '{DEPARTEMENT}%'

UNION

SELECT 	md5(t."nom") AS id, 
		t."nom"      AS nom, 
		c."code_insee"    AS code_insee, 
		st_x(t.the_geom) AS x,
		st_y(t.the_geom) AS y,
		t."type" || '|' || t."altitude" || '|' || c."nom" AS attribute
FROM 	{SCHEMA}.rn_geoportail t, {SCHEMA}.commune c
WHERE 	t.the_geom && c.the_geom AND 
		intersects(c.the_geom,st_transform(t.the_geom, st_srid(c.the_geom)))
  AND	c."code_insee" LIKE '{DEPARTEMENT}%'

UNION

SELECT 	md5(t."identifian") AS id, 
		t."identifian"      AS nom, 
		c."code_insee"    AS code_insee, 
		st_x(t.the_geom) AS x,
		st_y(t.the_geom) AS y,
		t."type"  || '|' || c."nom" AS attribute
FROM 	{SCHEMA}.rgp_geoportail t, {SCHEMA}.commune c
WHERE 	t.the_geom && c.the_geom AND 
		intersects(c.the_geom,st_transform(t.the_geom, st_srid(c.the_geom)))
  AND	c."code_insee" LIKE '{DEPARTEMENT}%'
