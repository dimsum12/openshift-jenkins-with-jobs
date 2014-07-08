fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation
================================================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation
- **Functional test name** Test fonctionnel pour la chaîne de génération d'une donnée de diffusion Pgsql à partir d'une autre donnée Pgsql existante.
- **Functional test description** Teste le fonctionnement de la chaîne génération d'une donnée de diffusion Pgsql à partir d'une autre donnée Pgsql existante.
- **Functional test severity** A


---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithoutParameters
- **Name**             Génération BDD retravaillée sans paramètres
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées sans lui fournir de paramètres
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre l'identifiant d'une génération et le nom du dossier contenant les traitements sql à appliquer. (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


--------------------------
testWithoutScriptDirectory
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithoutScriptDirectory
- **Name**             Génération BDD retravaillée sans le nom du répertoire contenant les traitements
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées sans lui fournir le nom du répertoire contenant les traitements
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre le nom du dossier contenant les traitements sql à appliquer. (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------------
testWithBadGenerationId
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithBadGenerationId
- **Name**             Génération BDD retravaillée avec un identifiant de génération inexistant
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées en lui fournissant un identifiant de génération introuvable en BDD
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre un identifiant correct d'une génération (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------
testWithCorrectData
-------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithCorrectData
- **Name**             Génération BDD retravaillée correcte
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées avec une demande de génération correcte et des données OK
- **Result**           La chaîne doit correctement se dérouler, avec la récupération des informations de génération, la création et le remplissage de la nouvelle base de données à partir de la base initiale et la mise à jour de la donnée de diffusion en fin de traitement
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes



--------------------------
testWithUnreachableService
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithUnreachableService
- **Name**             Génération BDD retravaillée avec impossibilité de joindre le service REST pour récupérer les éléments de la génération
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées avec un service injoignable
- **Result**           La chaîne doit retourner une erreur car elle ne peut récupérer les informations sur les éléments en entrée et en sortie de la génération à effectuer (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



------------------------------------
testWithMultipleBroadcastDatasOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithMultipleBroadcastDatasOutput
- **Name**             Génération BDD retravaillée avec plusieurs données de diffusion en sortie du processus de génération
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées avec 2 données de génération en sortie au lieu d'une seule attendue
- **Result**           La chaîne doit retourner une erreur car elle ne génère qu'une seule donnée de diffusion (retour 3)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



-------------------------
testWithMultipleInputData
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithMultipleInputData
- **Name**             Génération BDD retravaillée avec plusieurs données en entrée du processus de génération
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées avec 2 données Pgsql en entrée au lieu d'une seule attendue
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter qu'une seule donnée en entrée (retour 2)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



-----------------------------
testWithNoSchemaNameInputData
-----------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithNoSchemaNameInputData
- **Name**             Génération BDD retravaillée avec une donnée en entrée incorrecte (ne possédant pas de nom de schéma)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées avec une donnée en entrée sans nom de schéma (erreur de structure)
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données en entrée correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------------------
testWithNoIdBroadcastDataOutput
-------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithNoIdBroadcastDataOutput
- **Name**             Génération BDD retravaillée avec une donnée de diffusion incorrecte (ne possédant pas d'identifiant)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées avec une données de diffusion sans identifiant
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


---------------------
testWithNoIdInputData
---------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithNoIdInputData
- **Name**             Génération BDD retravaillée avec une donnée en entrée incorrecte (ne possédant pas d'identifiant)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées avec une donnée en entrée sans identifiant (erreur de structure)
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données en entrée correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


------------------------------------
testWithNoVersionBroadcastDataOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithNoVersionBroadcastDataOutput
- **Name**             Génération BDD retravaillée avec une donnée de diffusion incorrecte (ne possédant pas de version)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées avec une données de diffusion sans version
- **Result**           La chaîne doit retourner une erreur car elle ne peut traiter que les données de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


---------------------------
testWithDataGenerationError
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithDataGenerationError
- **Name**             Génération BDD retravaillée avec une livraison générant des erreurs lors de l'intégration SQL
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées avec des informations qui génèrent une erreur lors de l'intégration SQL (le nom du schéma initial n'existe pas en base) 
- **Result**           La chaîne doit retourner une erreur car l'intégration en base n'est pas correctement effectuée (retour 5)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


--------------------------------
testWithUpdateBroadcastDataError
--------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithUpdateBroadcastDataError
- **Name**             Génération BDD retravaillée avec un dysfonctionnement lors de la mise à jour de la donnée de diffusion
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées lorsque la mise à jour de la donnée de diffusion en sortie ne fonctionne pas
- **Result**           La chaîne doit retourner une erreur car la mise à jour de la donnée de diffusion ne peut être réalisée (retour 6)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


---------------------------
testWithJsonConversionError
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithJsonConversionError
- **Name**             Génération BDD retravaillée avec un dysfonctionnement lors de la conversion du JSON renvoyé par le service REST en structure PERL
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de génération de données de diffusion Pgsql retravaillées lorsque la conversion du JSON est impossible
- **Result**           La chaîne doit retourner une erreur car les informations retournée par le service sont inexploitables (retour 254)
- **Comment**          Utilise un mock pour la communication au service REST et pour la conversion JSON
- **Severity**         B
- **Automatic**        Yes