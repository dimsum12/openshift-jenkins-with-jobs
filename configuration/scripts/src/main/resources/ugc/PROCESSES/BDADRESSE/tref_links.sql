SELECT  c.id as parent,  
		a.id as child 
FROM 	{SCHEMA}.arrondissement as a, 
		{SCHEMA}.commune as c 
WHERE 	a.code_insee like '75%' 
  AND 	c.nom = 'Paris' 
  
UNION ALL 

SELECT 	c.id as parent, 
		a.id as child 
FROM 	{SCHEMA}.arrondissement as a, 
		{SCHEMA}.commune as c 
WHERE 	a.code_insee like '69%' 
  AND 	c.nom = 'Lyon' 
  
UNION ALL 

SELECT 	c.id as parent, 
		a.id as child 
FROM 	{SCHEMA}.arrondissement as a, 
		{SCHEMA}.commune as c 
WHERE 	a.code_insee like '13%' 
  AND 	c.nom = 'Marseille'