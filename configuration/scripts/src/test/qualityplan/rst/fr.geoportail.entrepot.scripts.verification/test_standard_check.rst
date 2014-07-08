fr.geoportail.entrepot.scripts.verification.test_standard_check
=============================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.verification.test_standard_check
- **Functional test name** Test fonctionnel pour la chaîne de vérification standard
- **Functional test description** Teste le fonctionnement de la chaîne de vérification standard
- **Functional test severity** A



---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_standard_check.testWithoutParameters
- **Name**             Vérification standard sans paramètres
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification standard sans lui fournir de paramètres
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre l'identifiant d'une livraison (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------------
testWithCorrectDelivery
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_standard_check.testWithCorrectDelivery
- **Name**             Vérification standard avec une livraison de données correctes
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification standard avec une livraison correcte
- **Result**           La chaîne doit correctement se terminer (retour 0)
- **Comment**          -
- **Severity**         A
- **Automatic**        Yes



-------------------------
testWithIncorrectDelivery
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_standard_check.testWithIncorrectDelivery
- **Name**             Vérification standard avec une livraison de données incorrectes
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification standard avec une livraison possédant une erreur dans la construction du package
- **Result**           La chaîne doit retourner une erreur car la vérification a detecté une erreur (retour 1)
- **Comment**          -
- **Severity**         A
- **Automatic**        Yes
	

	
-----------------------
testWithWarningDelivery
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.verification.test_standard_check.testWithWarningDelivery
- **Name**             Vérification standard avec une livraison de données correcte mais en avertissement
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de vérification standard avec une livraison possédant une vérification md5 incomplète
- **Result**           La chaîne doit se terminer correctement car la vérification a detecté un avertissement, l'a remonté dans les logs, mais ne bloque pas le processus (retour 0)
- **Comment**          -
- **Severity**         A
- **Automatic**        Yes
