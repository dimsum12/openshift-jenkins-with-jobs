SELECT	a.id AS id,
		a.numero AS numero,
		a.nom_voie AS nom_voie,
		a.rep AS rep,
		c.code_insee AS code_insee,
		a.code_post AS code_post,
		c.nom AS nom
FROM	{SCHEMA}.adresse a,
		{SCHEMA}.commune c
WHERE	a.code_insee = c.code_insee
AND		a.code_post like '{DEPARTEMENT}%'