fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation
====================================================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation
- **Functional test name** Test fonctionnel du rollback de la chaîne de génération de données prégénérées
- **Functional test description** Teste le fonctionnement du rollback de la chaîne génération de données prégénérées
- **Functional test severity** A



---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation.testWithoutParameters
- **Name**             Rollback de génération de données prégénérées sans paramètres
- **Prerequisite**     Aucun
- **Description**      Teste le rollback de la chaîne de génération de données prégénérées sans lui fournir de paramètres
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre l'identifiant d'une génération (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------------
testWithBadGenerationId
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation.testWithBadGenerationId
- **Name**             Rollback de génération de données prégénérées avec un identifiant de génération inexistant
- **Prerequisite**     Aucun
- **Description**      Teste le rollback de la chaîne de génération de données prégénérées en lui fournissant un identifiant de génération introuvable en BDD
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre un identifiant correct d'une génération (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------------
testWithCorrectGeneration
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation.testWithCorrectGeneration
- **Name**             Rollback de génération de données prégénérées correct
- **Prerequisite**     Aucun
- **Description**      Teste le rollback de la chaîne de génération de données prégénérées avec une demande correcte
- **Result**           Le rollback doit correctement se dérouler, avec la suppression des fichiers qui se trouvent dans le dossier de destination
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes



--------------------------
testWithUnreachableService
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation.testWithUnreachableService
- **Name**             Rollback de génération de données prégénérées avec impossibilité de joindre le service REST pour récupérer les éléments de la génération
- **Prerequisite**     Aucun
- **Description**      Teste le rollback de la chaîne de génération de données prégénérées avec un service injoignable
- **Result**           La chaîne doit retourner une erreur car elle ne peut récupérer les informations sur les éléments en sortie de la génération à rollbacker (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



------------------------------------
testWithMultipleBroadcastDatasOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation.testWithMultipleBroadcastDatasOutput
- **Name**             Rollback de génération de données prégénérées avec plusieurs données de diffusion en sortie du processus de génération
- **Prerequisite**     Aucun
- **Description**      Teste le rollback de la chaîne de génération de données prégénérées avec 2 données de génération en sortie au lieu d'une seule attendue
- **Result**           La chaîne doit retourner une erreur car elle ne rollback qu'une seule donnée de diffusion (retour 2)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



-------------------------------
testWithNoIdBroadcastDataOutput
-------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation.testWithNoIdBroadcastDataOutput
- **Name**             Rollback de génération de données prégénérées avec une donnée de diffusion incorrecte (ne possédant pas d'identifiant)
- **Prerequisite**     Aucun
- **Description**      Teste le rollback de la chaîne de génération de données prégénérées avec une données de diffusion sans identifiant
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


------------------------------------
testWithNoStorageBroadcastDataOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation.testWithNoStorageBroadcastDataOutput
- **Name**             Rollback de génération de données prégénérées avec une donnée de diffusion incorrecte (ne possédant pas de stockage)
- **Prerequisite**     Aucun
- **Description**      Teste le rollback de la chaîne de génération de données prégénérées avec une données de diffusion sans stockage associé
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


-----------------------------------------------
testWithNoStorageLogicalNameBroadcastDataOutput
-----------------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation.testWithNoStorageLogicalNameBroadcastDataOutput
- **Name**             Rollback de génération de données prégénérées avec une donnée de diffusion incorrecte (dont le stockage associé ne possède pas de nom logique)
- **Prerequisite**     Aucun
- **Description**      Teste le rollback de la chaîne de génération de données prégénérées avec une données de diffusion dont le stockage associé ne possède pas de nom logique
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


---------------------------
testWithJsonConversionError
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_rollback_pregenerated_data_generation.testWithJsonConversionError
- **Name**             Rollback de génération de données prégénérées avec un dysfonctionnement lors de la conversion du JSON renvoyé par le service REST en structure PERL
- **Prerequisite**     Aucun
- **Description**      Teste le rollback de la chaîne de génération de données prégénérées lorsque la conversion du JSON est impossible
- **Result**           La chaîne doit retourner une erreur car les informations retournée par le service sont inexploitables (retour 254)
- **Comment**          Utilise un mock pour la communication au service REST et pour la conversion JSON
- **Severity**         B
- **Automatic**        Yes