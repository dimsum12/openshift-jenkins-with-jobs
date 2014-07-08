fr.geoportail.entrepot.scripts.verification.test_vector_check
=============================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.verification.test_vector_check
- **Functional test name** Test fonctionnel pour la chaîne de vérification vecteur
- **Functional test description** Teste le fonctionnement de la chaîne de vérification vecteur
- **Functional test severity** A



---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_vector_check.testWithoutParameters
- **Name**             Vérification vecteur sans paramètres
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification des données vecteur sans lui fournir de paramètres
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre l'identifiant d'une livraison (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------------
testWithCorrectDelivery
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_vector_check.testWithCorrectDelivery
- **Name**             Vérification vecteur avec une livraison de données correctes
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification des données vecteur avec un ensemble de SQL corrects
- **Result**           La chaîne doit correctement se terminer (retour 0)
- **Comment**          -
- **Severity**         A
- **Automatic**        Yes



-------------------------
testWithIncorrectDelivery
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_vector_check.testWithIncorrectDelivery
- **Name**             Vérification vecteur avec une livraison de données incorrectes
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification des données vecteur avec un ensemble de SQL possédant des erreurs de syntaxe par rapport aux régles définies d'acceptation (syntaxe, absence des schéma spécifiques dans les commandes SQL, etc...)
- **Result**           La chaîne doit retourner une erreur car au moins un des fichiers testés est erroné (retour 1)
- **Comment**          -
- **Severity**         A
- **Automatic**        Yes
	


---------------------
testWithNoSQLDelivery
---------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_vector_check.testWithNoSQLDelivery
- **Name**             Vérification vecteur avec une livraison de données ne contenant aucun fichier SQL
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification des données vecteur avec un repertoire de données ne contenant pas de SQL.
- **Result**           La chaîne doit correctement se terminer (retour 0) car l'on considère que la livraison peut être d'un autre type (Shapefile par exemple)
- **Comment**          -
- **Severity**         B
- **Automatic**        Yes
	


	

