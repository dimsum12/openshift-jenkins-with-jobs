SELECT 	nom AS nom, 
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) as code_insee,
		c.id AS id, 
		translate((c.depart), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' ||  
		CASE WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
			THEN  substring(c.code_insee, 0 ,3) 
			ELSE   
				CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
				THEN  substring(c.code_insee, 0 ,3) 
				ELSE substring(c.code_insee, 0, 4)  
				END
		END || '|' ||
		translate((c.region), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		c.prec_plani || '|' || 
		asewkt(setsrid(st_box2d(c.the_geom), srid(c.the_geom))) AS attribute,
		st_x(st_centroid(c.the_geom)) AS x, 
		st_y(st_centroid(c.the_geom)) AS y  
FROM 	{SCHEMA}.commune c