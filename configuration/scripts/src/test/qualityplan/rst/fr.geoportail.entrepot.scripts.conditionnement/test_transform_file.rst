fr.geoportail.entrepot.scripts.conditionnement.test_transform_file
==================================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.conditionnement.test_transform_file
- **Functional test name** Test fonctionnel pour la transformation de format de fichiers raster et vecteurs
- **Functional test description** Teste le fonctionnement de la transformation de format
- **Functional test severity** A



---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_transform_file.testWithoutParameters
- **Name**             Test sans paramètres
- **Prerequisite**     Aucun
- **Description**      Test de transformation de format sans paramètres en entrée
- **Result**           La chaîne doit retourner une erreur car elle attend 4 paramètres en entrée (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-------------------
testWithUnknownFile
-------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_transform_file.testWithUnknownFile
- **Name**             Test de décompression d'archive sans fichier en entrée
- **Prerequisite**     Aucun
- **Description**      Test de transformation de fichier avec en entrée un fichier inexistant
- **Result**           La chaîne doit retourner une erreur car le chemin vers le fichier indiqué n'existe pas(retour 1) 
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------
testWithEmptyFile
-----------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_transform_file.testWithEmptyFile
- **Name**             Test avec un fichier à transformer vide
- **Prerequisite**     Aucun
- **Description**      Test avec un fichier à transformer vide
- **Result**           La chaîne doit retourner une erreur (retour 2) 
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes




------------------------
testWithCorrectInputFile
------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_transform_file.testWithCorrectInputFile
- **Name**             Test du cas nominal de la transformation de fichier du format gml vers shp
- **Prerequisite**     Aucun
- **Description**      Teste la transformation de fichier du format gml au format shp
- **Result**           La chaîne retourne 0
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



---------------
testOkVectorise
---------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_transform_file.testOkVectorise
- **Name**             Test du cas nominal de la génération de contour vecteur à partir d'une image géoréférencée
- **Prerequisite**     Aucun
- **Description**      Test de la génération de contour vecteur
- **Result**           La chaîne retourne 0
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


