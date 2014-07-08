fr.geoportail.entrepot.scripts.verification.test_raster_check
=============================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.verification.test_raster_check
- **Functional test name** Test fonctionnel pour la chaîne de vérification raster
- **Functional test description** Teste le fonctionnement de la chaîne de vérification raster
- **Functional test severity** A



---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_raster_check.testWithoutParameters
- **Name**             Vérification raster sans paramètres
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification des données raster sans lui fournir de paramètres
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre l'identifiant d'une livraison (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------------
testWithCorrectDelivery
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_raster_check.testWithCorrectDelivery
- **Name**             Vérification raster avec une livraison de données correctes
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification des données raster avec un ensemble de georasters corrects
- **Result**           La chaîne doit correctement se terminer (retour 0)
- **Comment**          -
- **Severity**         A
- **Automatic**        Yes



-------------------------
testWithIncorrectDelivery
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_raster_check.testWithIncorrectDelivery
- **Name**             Vérification raster avec une livraison de données incorrectes
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification des données raster avec un ensemble de georasters possédant des erreurs de géoréférencement (absence de fichier de géoréférencement)
- **Result**           La chaîne doit retourner une erreur car au moins un des fichiers testés est erroné (retour 1)
- **Comment**          -
- **Severity**         A
- **Automatic**        Yes
	

