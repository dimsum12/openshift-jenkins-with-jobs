fr.geoportail.entrepot.scripts.extraction.test_create_arbo
===============================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.extraction.test_create_arbo
- **Functional test name** Test fonctionnel pour la génération d'une arborescence de fichiers correcte
- **Functional test description** Teste la création d'une arborescence de fichiers
- **Functional test severity** B


---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_create_arbo.testWithoutParameters
- **Name**             Création arborescence sans paramètres 
- **Prerequisite**     Aucun
- **Description**      Teste la création d'arborescence de fichiers sans paramètres d'entrée
- **Result**           La chaîne doit retourner une erreur car elle attend en entrée 6 paramètres obligatoires
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes

---------------------
testWithOneParameters
---------------------
- **ID**               fr.geoportail.entrepot.scripts.extraction.test_create_arbo.testWithOneParameters
- **Name**             Création arborescence avec 1 seul paramètre
- **Prerequisite**     Aucun
- **Description**      Teste la création d'arborescence de fichiers avec 1 seul paramètre en entrée
- **Result**           La chaîne doit retourner une erreur car elle attend en entrée 6 paramètres obligatoires
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes

-----------------
testOkArboBDOrtho
-----------------
- **ID**               fr.geoportail.entrepot.scripts.extraction.test_create_arbo.testOkArboBDOrtho
- **Name**             Création arborescence correcte, pour produit BDOrtho
- **Prerequisite**     Aucun
- **Description**      Teste la création d'arborescence correspondant à un produit de la BDOrtho
- **Result**           La création de l'arborescence de dossiers doit bien se dérouler (retourne 0)
- **Comment**          -
- **Severity**         B
- **Automatic**        Yes

------------------------
testOkArboProduitVecteur
------------------------
- **ID**               fr.geoportail.entrepot.scripts.extraction.test_create_arbo.testOkArboProduitVecteur
- **Name**             Création arborescence correcte, pour produit Vecteur
- **Prerequisite**     Aucun
- **Description**      Teste la création d'arborescence correspondant à un produit de type Vecteur
- **Result**           La création de l'arborescence de dossiers doit bien se dérouler (retourne 0)
- **Comment**          -
- **Severity**         B
- **Automatic**        Yes

-----------------------
testOkArboProduitRaster
-----------------------
- **ID**               fr.geoportail.entrepot.scripts.extraction.test_create_arbo.testOkArboProduitRaster
- **Name**             Création arborescence correcte, pour produit raster
- **Prerequisite**     Aucun
- **Description**      Teste la création d'arborescence correspondant à un produit de type Rater
- **Result**           La création de l'arborescence de dossiers doit bien se dérouler (retourne 0)
- **Comment**          -
- **Severity**         B
- **Automatic**        Yes

-------------------
testForbiddenAccess
-------------------
- **ID**               fr.geoportail.entrepot.scripts.extraction.test_create_arbo.testForbiddenAccess
- **Name**             Création arborescence dans un répertoire parent interdit d'acces (/root)
- **Prerequisite**     Aucun
- **Description**      Teste la création d'arborescence dans un répertoire inaccessible
- **Result**           La chaîne doit retourner une erreur l'accès à ce répertoire d'écriture est impossible(retour 254)
- **Comment**          -
- **Severity**         B
- **Automatic**        Yes




