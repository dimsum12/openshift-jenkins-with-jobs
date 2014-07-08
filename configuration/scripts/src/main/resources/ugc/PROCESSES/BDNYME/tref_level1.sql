SELECT 	t.id AS id, 
		translate((c.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom, 
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee, 
		st_x(st_geometryn(t.the_geom,1)) AS x, 
		st_y(st_geometryn(t.the_geom,1)) AS y,
		translate((c.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		c.code_insee || '|' || 
		translate((c.depart), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		CASE WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
			THEN  substring(c.code_insee, 0 ,3) 
			ELSE   
				CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
				THEN  substring(c.code_insee, 0 ,3) 
				ELSE substring(c.code_insee, 0, 4)  
				END
		END || '|' || 
		translate((c.region), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		(	SELECT  ter.trigramme
			FROM public.departement_territoire dt, territoire ter  
			WHERE dt.territoire = ter.id AND dt.departement = CASE 
										WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
										THEN  substring(c.code_insee, 0 ,3) 
										ELSE   
											CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE substring(c.code_insee, 0, 4)  
											END
									END
		) || '|' || 
		translate(
			(
				SELECT  ter.name
				FROM public.departement_territoire dt, territoire ter  
				WHERE dt.territoire = ter.id AND dt.departement = CASE 
											WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE   
												CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
												THEN  substring(c.code_insee, 0 ,3) 
												ELSE substring(c.code_insee, 0, 4)  
												END
										END
		
			)
		, 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		t.nature || '|' || 
		t.importance || '|' || 
		asewkt(setsrid(st_box2d(t.the_geom), srid(t.the_geom))) AS attribute  
FROM 	{SCHEMA}.commune c, {SCHEMA}.chef_lieu t 
WHERE 	t.id_com=c.id
AND 	c.code_insee like '{DEPARTEMENT}%'

UNION

SELECT 	t.id AS id, 
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom, 
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee, 
		st_x(st_geometryn(t.the_geom,1)) AS x, 
		st_y(st_geometryn(t.the_geom,1)) AS y, 
		translate((c.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		c.code_insee || '|' || 
		translate((c.depart), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		CASE WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
			THEN  substring(c.code_insee, 0 ,3) 
			ELSE   
				CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
				THEN  substring(c.code_insee, 0 ,3) 
				ELSE substring(c.code_insee, 0, 4)  
				END
		END || '|' || 
		translate((c.region), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		(	SELECT  ter.trigramme
			FROM public.departement_territoire dt, territoire ter  
			WHERE dt.territoire = ter.id AND dt.departement = CASE 
										WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
										THEN  substring(c.code_insee, 0 ,3) 
										ELSE   
											CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE substring(c.code_insee, 0, 4)  
											END
									END
		) || '|' || 
		translate(
			(
				SELECT  ter.name
				FROM public.departement_territoire dt, territoire ter  
				WHERE dt.territoire = ter.id AND dt.departement = CASE 
											WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE   
												CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
												THEN  substring(c.code_insee, 0 ,3) 
												ELSE substring(c.code_insee, 0, 4)  
												END
										END
		
			)
		, 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		t.nature || '|' || 
		t.importance || '|' || 
		asewkt(setsrid(st_box2d(t.the_geom), srid(t.the_geom))) AS attribute
FROM 	{SCHEMA}.commune c, {SCHEMA}.hydronyme t 
WHERE 	t.the_geom && c.the_geom
AND 	intersects(c.the_geom,t.the_geom)
AND 	c.code_insee like '{DEPARTEMENT}%'
	  
UNION 

SELECT 	t.id AS id, 
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom, 
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee, 
		st_x(st_geometryn(t.the_geom,1)) AS x, 
		st_y(st_geometryn(t.the_geom,1)) AS y, 
		translate((c.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		c.code_insee || '|' || 
		translate((c.depart), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		CASE WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
			THEN  substring(c.code_insee, 0 ,3) 
			ELSE   
				CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
				THEN  substring(c.code_insee, 0 ,3) 
				ELSE substring(c.code_insee, 0, 4)  
				END
		END || '|' || 
		translate((c.region), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		(	SELECT  ter.trigramme
			FROM public.departement_territoire dt, territoire ter  
			WHERE dt.territoire = ter.id AND dt.departement = CASE 
										WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
										THEN  substring(c.code_insee, 0 ,3) 
										ELSE   
											CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE substring(c.code_insee, 0, 4)  
											END
									END
		) || '|' || 
		translate(
			(
				SELECT  ter.name
				FROM public.departement_territoire dt, territoire ter  
				WHERE dt.territoire = ter.id AND dt.departement = CASE 
											WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE   
												CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
												THEN  substring(c.code_insee, 0 ,3) 
												ELSE substring(c.code_insee, 0, 4)  
												END
										END
		
			)
		, 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		t.nature || '|' || 
		t.importance || '|' || 
		asewkt(setsrid(st_box2d(t.the_geom), srid(t.the_geom))) AS attribute
FROM 	{SCHEMA}.commune c, {SCHEMA}.lieu_dit_habite t 
WHERE 	t.the_geom && c.the_geom
AND 	intersects(c.the_geom,t.the_geom)
AND 	c.code_insee like '{DEPARTEMENT}%'

UNION

SELECT 	t.id AS id, 
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom, 
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee, 
		st_x(st_geometryn(t.the_geom,1)) AS x, 
		st_y(st_geometryn(t.the_geom,1)) AS y, 
		translate((c.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		c.code_insee || '|' || 
		translate((c.depart), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		CASE WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
			THEN  substring(c.code_insee, 0 ,3) 
			ELSE   
				CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
				THEN  substring(c.code_insee, 0 ,3) 
				ELSE substring(c.code_insee, 0, 4)  
				END
		END || '|' || 
		translate((c.region), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		(	SELECT  ter.trigramme
			FROM public.departement_territoire dt, territoire ter  
			WHERE dt.territoire = ter.id AND dt.departement = CASE 
										WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
										THEN  substring(c.code_insee, 0 ,3) 
										ELSE   
											CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE substring(c.code_insee, 0, 4)  
											END
									END
		) || '|' || 
		translate(
			(
				SELECT  ter.name
				FROM public.departement_territoire dt, territoire ter  
				WHERE dt.territoire = ter.id AND dt.departement = CASE 
											WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE   
												CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
												THEN  substring(c.code_insee, 0 ,3) 
												ELSE substring(c.code_insee, 0, 4)  
												END
										END
		
			)
		, 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		t.nature || '|' || 
		t.importance || '|' || 
		asewkt(setsrid(st_box2d(t.the_geom), srid(t.the_geom))) AS attribute 
FROM 	{SCHEMA}.commune c, {SCHEMA}.lieu_dit_non_habite t 
WHERE 	t.the_geom && c.the_geom
AND 	intersects(c.the_geom,t.the_geom)
AND 	c.code_insee like '{DEPARTEMENT}%'

UNION

SELECT 	t.id AS id, 
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom, 
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee, 
		st_x(st_geometryn(t.the_geom,1)) AS x, 
		st_y(st_geometryn(t.the_geom,1)) AS y, 
		translate((c.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		c.code_insee || '|' || 
		translate((c.depart), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		CASE WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
			THEN  substring(c.code_insee, 0 ,3) 
			ELSE   
				CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
				THEN  substring(c.code_insee, 0 ,3) 
				ELSE substring(c.code_insee, 0, 4)  
				END
		END || '|' || 
		translate((c.region), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		(	SELECT  ter.trigramme
			FROM public.departement_territoire dt, territoire ter  
			WHERE dt.territoire = ter.id AND dt.departement = CASE 
										WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
										THEN  substring(c.code_insee, 0 ,3) 
										ELSE   
											CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE substring(c.code_insee, 0, 4)  
											END
									END
		) || '|' || 
		translate(
			(
				SELECT  ter.name
				FROM public.departement_territoire dt, territoire ter  
				WHERE dt.territoire = ter.id AND dt.departement = CASE 
											WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE   
												CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
												THEN  substring(c.code_insee, 0 ,3) 
												ELSE substring(c.code_insee, 0, 4)  
												END
										END
		
			)
		, 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		t.nature || '|' || 
		t.importance || '|' || 
		asewkt(setsrid(st_box2d(t.the_geom), srid(t.the_geom))) AS attribute 
FROM 	{SCHEMA}.commune c, {SCHEMA}.oronyme t 
WHERE 	t.the_geom && c.the_geom
AND 	intersects(c.the_geom,t.the_geom)
AND 	c.code_insee like '{DEPARTEMENT}%'

UNION

SELECT 	t.id AS id, 
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom, 
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee, 
		st_x(st_geometryn(t.the_geom,1)) AS x, 
		st_y(st_geometryn(t.the_geom,1)) AS y, 
		translate((c.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		c.code_insee || '|' || 
		translate((c.depart), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		CASE WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
			THEN  substring(c.code_insee, 0 ,3) 
			ELSE   
				CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
				THEN  substring(c.code_insee, 0 ,3) 
				ELSE substring(c.code_insee, 0, 4)  
				END
		END || '|' || 
		translate((c.region), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		(	SELECT  ter.trigramme
			FROM public.departement_territoire dt, territoire ter  
			WHERE dt.territoire = ter.id AND dt.departement = CASE 
										WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
										THEN  substring(c.code_insee, 0 ,3) 
										ELSE   
											CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE substring(c.code_insee, 0, 4)  
											END
									END
		) || '|' || 
		translate(
			(
				SELECT  ter.name
				FROM public.departement_territoire dt, territoire ter  
				WHERE dt.territoire = ter.id AND dt.departement = CASE 
											WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE   
												CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
												THEN  substring(c.code_insee, 0 ,3) 
												ELSE substring(c.code_insee, 0, 4)  
												END
										END
		
			)
		, 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		t.nature || '|' || 
		t.importance || '|' || 
		asewkt(setsrid(st_box2d(t.the_geom), srid(t.the_geom))) AS attribute 
FROM 	{SCHEMA}.commune c, {SCHEMA}.toponyme_communication t 
WHERE  	t.the_geom && c.the_geom
AND 	intersects(c.the_geom,t.the_geom)
AND 	c.code_insee like '{DEPARTEMENT}%'

UNION

SELECT 	t.id AS id, 
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom, 
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee, 
		st_x(st_geometryn(t.the_geom,1)) AS x, 
		st_y(st_geometryn(t.the_geom,1)) AS y, 
		translate((c.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		c.code_insee || '|' || 
		translate((c.depart), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') || '|' || 
		CASE WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
			THEN  substring(c.code_insee, 0 ,3) 
			ELSE   
				CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
				THEN  substring(c.code_insee, 0 ,3) 
				ELSE substring(c.code_insee, 0, 4)  
				END
		END || '|' || 
		translate((c.region), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		(	SELECT  ter.trigramme
			FROM public.departement_territoire dt, territoire ter  
			WHERE dt.territoire = ter.id AND dt.departement = CASE 
										WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
										THEN  substring(c.code_insee, 0 ,3) 
										ELSE   
											CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE substring(c.code_insee, 0, 4)  
											END
									END
		) || '|' || 
		translate(
			(
				SELECT  ter.name
				FROM public.departement_territoire dt, territoire ter  
				WHERE dt.territoire = ter.id AND dt.departement = CASE 
											WHEN upper(substring(c.code_insee, 1 ,3)) SIMILAR TO '(A|B)' 
											THEN  substring(c.code_insee, 0 ,3) 
											ELSE   
												CASE WHEN to_number(substring(c.code_insee, 0 ,3), 'S99999999999999D999999') <96 
												THEN  substring(c.code_insee, 0 ,3) 
												ELSE substring(c.code_insee, 0, 4)  
												END
										END
		
			)
		, 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy')  || '|' || 
		t.nature || '|' || 
		t.importance || '|' || 
		asewkt(setsrid(st_box2d(t.the_geom), srid(t.the_geom))) AS attribute 
FROM 	{SCHEMA}.commune c, {SCHEMA}.toponyme_divers t 
WHERE 	t.the_geom && c.the_geom
AND 	intersects(c.the_geom,t.the_geom)
AND 	c.code_insee like '{DEPARTEMENT}%'
