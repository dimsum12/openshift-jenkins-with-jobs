SELECT		code_insee AS code_insee,
			SUM(popul) AS popul
FROM 		{SCHEMA}.commune c
GROUP BY	code_insee