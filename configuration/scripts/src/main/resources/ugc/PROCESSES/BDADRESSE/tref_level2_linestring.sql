SELECT 	r.nom_voie_g AS nom_rue_g,
		r.nom_voie_d AS nom_rue_d,
		c1.canton || '|' || c1.depart || '|' || c1.region || '|' || r.prec_plani || '|' || asewkt(setsrid(st_box2d(r.the_geom), srid(r.the_geom))) AS codevoie_g,
		c1.canton || '|' || c1.depart || '|' || c1.region || '|' || r.prec_plani || '|' || asewkt(setsrid(st_box2d(r.the_geom), srid(r.the_geom))) AS codevoie_d,
		r.bornefin_g,
		r.bornedeb_g,
		r.bornefin_d,
		r.bornedeb_d,
		c1.nom AS nom_g,
		c2.nom AS nom_d,
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c1.code_insee) as cinsee_g,
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c2.code_insee) as cinsee_d,
		c1.id AS id_g,
		c2.id AS id_d,
		AStext(st_geometryn(r.the_geom, 1)) AS geom 
FROM    {SCHEMA}.commune AS c1,
		{SCHEMA}.commune AS c2,
		{SCHEMA}.route_adresse_nommee r
WHERE 	r.inseecom_g = c1.code_insee
  AND 	r.inseecom_d = c2.code_insee
  AND 	c1.code_insee like '{DEPARTEMENT}%'
