SELECT 	t.code_dep || t.code_com || t.com_abs || t.code_arr || t.feuille || t.section || t.numero AS id,
		t.code_dep || t.code_com || t.com_abs || t.code_arr || t.feuille || t.section || t.numero AS nom,
		t.code_dep || t.code_com AS code_insee,
		ST_X(t.the_geom) AS x, 
		ST_Y(t.the_geom) AS y, 
		t.nom_com AS attribute
FROM 	{SCHEMA}.localisant AS t
WHERE 	t.code_dep LIKE '{DEPARTEMENT}%'
