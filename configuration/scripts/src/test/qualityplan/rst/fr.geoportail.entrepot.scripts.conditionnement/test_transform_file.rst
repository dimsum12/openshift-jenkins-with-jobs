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
- **Name**             Test sans param�tres
- **Prerequisite**     Aucun
- **Description**      Test de transformation de format sans param�tres en entr�e
- **Result**           La cha�ne doit retourner une erreur car elle attend 4 param�tres en entr�e (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-------------------
testWithUnknownFile
-------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_transform_file.testWithUnknownFile
- **Name**             Test de d�compression d'archive sans fichier en entr�e
- **Prerequisite**     Aucun
- **Description**      Test de transformation de fichier avec en entr�e un fichier inexistant
- **Result**           La cha�ne doit retourner une erreur car le chemin vers le fichier indiqu� n'existe pas(retour 1) 
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------
testWithEmptyFile
-----------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_transform_file.testWithEmptyFile
- **Name**             Test avec un fichier � transformer vide
- **Prerequisite**     Aucun
- **Description**      Test avec un fichier � transformer vide
- **Result**           La cha�ne doit retourner une erreur (retour 2) 
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
- **Result**           La cha�ne retourne 0
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



---------------
testOkVectorise
---------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_transform_file.testOkVectorise
- **Name**             Test du cas nominal de la g�n�ration de contour vecteur � partir d'une image g�or�f�renc�e
- **Prerequisite**     Aucun
- **Description**      Test de la g�n�ration de contour vecteur
- **Result**           La cha�ne retourne 0
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


