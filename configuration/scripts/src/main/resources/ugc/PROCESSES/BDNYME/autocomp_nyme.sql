SELECT	t.id AS id,
		t.origin_nom AS origin_nom,
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom,
		t.importance AS importance,
		t.nature AS nature,
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee,
		translate((c.nom) , 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom_com
FROM	{SCHEMA}.commune c, {SCHEMA}.chef_lieu t 
WHERE	t.id_com=c.id

UNION

SELECT	t.id AS id,
		t.origin_nom AS origin_nom,
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom,
		t.importance AS importance,
		t.nature AS nature,
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee,
		translate((c.nom) , 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom_com
FROM	{SCHEMA}.commune c, {SCHEMA}.hydronyme t 
WHERE	t.the_geom && c.the_geom
AND		intersects(c.the_geom,t.the_geom)

UNION 

SELECT	t.id AS id,
		t.origin_nom AS origin_nom,
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom,
		t.importance AS importance,
		t.nature AS nature,
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee,
		translate((c.nom) , 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom_com
FROM	{SCHEMA}.commune c, {SCHEMA}.lieu_dit_habite t 
WHERE	t.the_geom && c.the_geom
AND		intersects(c.the_geom,t.the_geom)

UNION

SELECT	t.id AS id,
		t.origin_nom AS origin_nom,
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom,
		t.importance AS importance,
		t.nature AS nature,
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee,
		translate((c.nom) , 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom_com
FROM	{SCHEMA}.commune c, {SCHEMA}.lieu_dit_non_habite t 
WHERE	t.the_geom && c.the_geom
AND		intersects(c.the_geom,t.the_geom)

UNION

SELECT	t.id AS id,
		t.origin_nom AS origin_nom,
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom,
		t.importance AS importance,
		t.nature AS nature,
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee,
		translate((c.nom) , 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom_com
FROM	{SCHEMA}.commune c, {SCHEMA}.oronyme t 
WHERE	t.the_geom && c.the_geom
AND		intersects(c.the_geom,t.the_geom)

UNION

SELECT	t.id AS id,
		t.origin_nom AS origin_nom,
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom,
		t.importance AS importance,
		t.nature AS nature,
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee,
		translate((c.nom) , 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom_com
FROM	{SCHEMA}.commune c, {SCHEMA}.toponyme_communication t 
WHERE	t.the_geom && c.the_geom
AND		intersects(c.the_geom,t.the_geom)

UNION

SELECT	t.id AS id,
		t.origin_nom AS origin_nom,
		translate((t.nom), 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom,
		t.importance AS importance,
		t.nature AS nature,
		(SELECT icu.code_post FROM public.insee_codpost_uniq icu WHERE icu.code_insee = c.code_insee) AS code_insee,
		translate((c.nom) , 'אגהחטיךכלמןפצשûüÿ', 'aaaceeeeiiioouuuy') AS nom_com
FROM	{SCHEMA}.commune c, {SCHEMA}.toponyme_divers t 
WHERE	t.the_geom && c.the_geom
AND		intersects(c.the_geom,t.the_geom)
