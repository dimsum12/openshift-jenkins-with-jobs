fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation
===========================================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation
- **Functional test name** Test fonctionnel pour la chaîne de génération de données prégénérées
- **Functional test description** Teste le fonctionnement de la chaîne génération de données prégénérées
- **Functional test severity** A



---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithoutParameters
- **Name**             Génération données prégénérées sans paramètres
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées sans lui fournir de paramètres
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre l'identifiant d'une génération (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------------
testWithBadGenerationId
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithBadGenerationId
- **Name**             Génération  données prégénérées avec un identifiant de génération inexistant
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées en lui fournissant un identifiant de génération introuvable en BDD
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre un identifiant correct d'une génération (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------------
testWithCorrectGeneration
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithCorrectGeneration
- **Name**             Génération  données prégénérées correcte
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec une demande de génération correcte et des données OK
- **Result**           La chaîne doit correctement se dérouler, avec la récupération des informations de génération, la copie des données du répertoire correspondant à la livraison vers le répertoire correspondant à la donnée de diffusion
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes



--------------------------
testWithUnreachableService
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithUnreachableService
- **Name**             Génération données prégénérées avec impossibilité de joindre le service REST pour récupérer les éléments de la génération
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec un service injoignable
- **Result**           La chaîne doit retourner une erreur car elle ne peut récupérer les informations sur les éléments en entrée et en sortie de la génération à effectuer (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



-------------------------------
testWithMultipleDeliveriesInput
-------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithMultipleDeliveriesInput
- **Name**             Génération  données prégénérées avec plusieurs livraisons en entrée du processus de génération
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec 2 livraisons en entrée au lieu d'une seule attendue
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons unique (retour 2)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



----------------------------
testWithNoLoginDeliveryInput
----------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithNoLoginDeliveryInput
- **Name**             Génération  données prégénérées avec une livraison incorrecte (ne possédant pas de login)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec une livraison en entrée sans login (erreur de structure)
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------------
testWithNoIdDeliveryInput
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithNoIdDeliveryInput
- **Name**             Génération  données prégénérées avec une livraison incorrecte (ne possédant pas d'identifiant)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec une livraison en entrée sans identifiant (erreur de structure)
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



------------------------------
testWithNoDeliveryProductInput
------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithNoDeliveryProductInput
- **Name**             Génération  données prégénérées avec une livraison incorrecte (ne possédant pas de produit de livraison)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec une livraison en entrée sans produit de livraison associé (erreur de structure)
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



----------------------------------
testWithNoNameDeliveryProductInput
----------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithNoNameDeliveryProductInput
- **Name**             Génération  données prégénérées avec une livraison incorrecte (dont le produit de livraison n'a pas de nom)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec un produit de livraison sans nom (erreur de structure)
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


--------------------------
testWithoutInformationFile
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithoutInformationFile
- **Name**             Génération  données prégénérées avec une livraison incorrecte (qui n'a pas de fichier d'information associé)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec une livraison qui n'a pas de fichier d'informations
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les livraisons correctes (retour 7)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes

------------------------------------
testWithMultipleBroadcastDatasOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithMultipleBroadcastDatasOutput
- **Name**             Génération  données prégénérées avec plusieurs données de diffusion en sortie du processus de génération
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec 2 données de génération en sortie au lieu d'une seule attendue
- **Result**           La chaîne doit retourner une erreur car elle ne génère qu'une seule donnée de diffusion (retour 3)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



------------------------------------
testWithNoVersionBroadcastDataOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithNoVersionBroadcastDataOutput
- **Name**             Génération  données prégénérées avec une donnée de diffusion incorrecte (ne possédant pas de version)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec une données de diffusion sans version
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------------------
testWithNoIdBroadcastDataOutput
-------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithNoIdBroadcastDataOutput
- **Name**             Génération  données prégénérées avec une donnée de diffusion incorrecte (ne possédant pas d'identifiant)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec une données de diffusion sans identifiant
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



------------------------------------
testWithNoStorageBroadcastDataOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithNoStorageBroadcastDataOutput
- **Name**             Génération  données prégénérées avec une donnée de diffusion incorrecte (ne possédant pas de stockage)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec une données de diffusion sans stockage
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes


-----------------------------------------------
testWithNoStorageLogicalNameBroadcastDataOutput
-----------------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithNoStorageLogicalNameBroadcastDataOutput
- **Name**             Génération  données prégénérées avec une donnée de diffusion incorrecte (dont le stockage n'a pas de nom logique)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées avec une données de diffusion dont le stockage n'a pas de nom logique
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes


---------------------------
testWithJsonConversionError
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_pregenerated_data_generation.testWithJsonConversionError
- **Name**             Génération  données prégénérées avec un dysfonctionnement lors de la conversion du JSON renvoyé par le service REST en structure PERL
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données prégénérées lorsque la conversion du JSON est impossible
- **Result**           La chaîne doit retourner une erreur car les informations retournée par le service sont inexploitables (retour 254)
- **Comment**          Utilise un mock pour la communication au service REST et pour la conversion JSON
- **Severity**         B
- **Automatic**        Yes