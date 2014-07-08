SELECT 	numero || ' ' ||  rep AS numero,
		nom_voie AS nom_voie, 
		c.canton || '|' || c.depart || '|' || c.region || '|' || a.type_loc || '|' || asewkt(setsrid(st_box2d(a.the_geom), srid(a.the_geom))) AS code_voie, 
		c.canton || '|' || c.depart || '|' || c.region || '|' || a.type_loc || '|' || asewkt(setsrid(st_box2d(a.the_geom), srid(a.the_geom))) AS code_voie, 
		nom AS cityname, 
		c.id AS cityid, 
		a.code_post AS cityattribute, 
		st_x(st_centroid(a.the_geom)) AS x, 
		st_y(st_centroid(a.the_geom)) AS y 
FROM 	{SCHEMA}.adresse a, 
		{SCHEMA}.commune c
WHERE 	c.code_insee = a.code_insee 
  AND 	c.code_insee like '{DEPARTEMENT}%'