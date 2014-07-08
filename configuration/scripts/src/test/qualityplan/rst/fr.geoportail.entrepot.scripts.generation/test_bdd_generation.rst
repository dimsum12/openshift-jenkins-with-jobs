fr.geoportail.entrepot.scripts.generation.test_bdd_generation
=============================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.generation.test_bdd_generation
- **Functional test name** Test fonctionnel pour la chaîne de génération de données de diffusion Pgsql
- **Functional test description** Teste le fonctionnement de la chaîne génération de données de diffusion Pgsql
- **Functional test severity** A



---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithoutParameters
- **Name**             Génération BDD sans paramètres
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql sans lui fournir de paramètres
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre l'identifiant d'une génération (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------------
testWithBadGenerationId
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithBadGenerationId
- **Name**             Génération BDD avec un identifiant de génération inexistant
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql en lui fournissant un identifiant de génération introuvable en BDD
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre un identifiant correct d'une génération (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------------
testWithCorrectGeneration
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithCorrectGeneration
- **Name**             Génération BDD correcte
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec une demande de génération correcte et des données OK
- **Result**           La chaîne doit correctement se dérouler, avec la récupération des informations de génération, la création et le remplissage de la base de données adéquate et la mise à jour de la donnée de diffusion en fin de traitement
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes



--------------------------
testWithUnreachableService
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithUnreachableService
- **Name**             Génération BDD avec impossibilité de joindre le service REST pour récupérer les éléments de la génération
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec un service injoignable
- **Result**           La chaîne doit retourner une erreur car elle ne peut récupérer les informations sur les éléments en entrée et en sortie de la génération à effectuer (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



-------------------------------
testWithMultipleDeliveriesInput
-------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithMultipleDeliveriesInput
- **Name**             Génération BDD avec plusieurs livraisons en entrée du processus de génération
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec 2 livraisons en entrée au lieu d'une seule attendue
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons unique (retour 2)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



----------------------------
testWithNoLoginDeliveryInput
----------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithNoLoginDeliveryInput
- **Name**             Génération BDD avec plusieurs une livraison incorrecte (ne possédant pas de login)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec une livraison en entrée sans login (erreur de structure)
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------------
testWithNoIdDeliveryInput
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithNoIdDeliveryInput
- **Name**             Génération BDD avec plusieurs une livraison incorrecte (ne possédant pas d'identifiant)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec une livraison en entrée sans identifiant (erreur de structure)
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



------------------------------
testWithNoDeliveryProductInput
------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithNoDeliveryProductInput
- **Name**             Génération BDD avec plusieurs une livraison incorrecte (ne possédant pas de produit de livraison)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec une livraison en entrée sans produit de livraison associé (erreur de structure)
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



----------------------------------
testWithNoNameDeliveryProductInput
----------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithNoNameDeliveryProductInput
- **Name**             Génération BDD avec plusieurs une livraison incorrecte (dont le produit de livraison n'a pas de nom)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec un produit de livraison sans nom (erreur de structure)
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



------------------------------------
testWithMultipleBroadcastDatasOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithMultipleBroadcastDatasOutput
- **Name**             Génération BDD avec plusieurs données de diffusion en sortie du processus de génération
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec 2 données de génération en sortie au lieu d'une seule attendue
- **Result**           La chaîne doit retourner une erreur car elle ne génère qu'une seule donnée de diffusion (retour 3)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



------------------------------------
testWithNoVersionBroadcastDataOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithNoVersionBroadcastDataOutput
- **Name**             Génération BDD avec une donnée de diffusion incorrecte (ne possédant pas de version)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec une données de diffusion sans version
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------------------
testWithNoIdBroadcastDataOutput
-------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithNoIdBroadcastDataOutput
- **Name**             Génération BDD avec une donnée de diffusion incorrecte (ne possédant pas d'identifiant)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec une données de diffusion sans identifiant
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



--------------------------
testWithoutInformationFile
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithoutInformationFile
- **Name**             Génération BDD avec une livraison sans fichier d'information complémentaire
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec une livraison ne possédant pas de fichier d'information complémentaire
- **Result**           La chaîne doit retourner une erreur car elle ne peut extraire les information du fichier d'information complémentaire de la livraison à traiter (retour 4)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



---------------------------
testWithIncorrectGeneration
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithIncorrectGeneration
- **Name**             Génération BDD avec une livraison générant des erreurs lors de l'intégration SQL
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql avec une livraison de données SQL incorrecte
- **Result**           La chaîne doit retourner une erreur car l'intégration en base n'est pas correctement effectuée (retour 5)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes



--------------------------------
testWithUpdateBroadcastDataError
--------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithUpdateBroadcastDataError
- **Name**             Génération BDD avec un dysfonctionnement lors de la mise à jour de la donnée de diffusion
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql lorsque la mise à jour de la donnée de diffusion en sortie ne fonctionne pas
- **Result**           La chaîne doit retourner une erreur car la mise à jour de la donnée de diffusion ne peut être réalisée (retour 6)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



---------------------------
testWithJsonConversionError
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_bdd_generation.testWithJsonConversionError
- **Name**             Génération BDD avec un dysfonctionnement lors de la conversion du JSON renvoyé par le service REST en structure PERL
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql lorsque la conversion du JSON est impossible
- **Result**           La chaîne doit retourner une erreur car les informations retournée par le service sont inexploitables (retour 254)
- **Comment**          Utilise un mock pour la communication au service REST et pour la conversion JSON
- **Severity**         B
- **Automatic**        Yes