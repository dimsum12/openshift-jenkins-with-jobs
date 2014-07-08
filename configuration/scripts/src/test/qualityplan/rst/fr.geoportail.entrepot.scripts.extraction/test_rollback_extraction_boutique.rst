fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique
===========================================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique
- **Functional test name** Test fonctionnel pour la chaine de rollback de haut niveau de l'extraction
- **Functional test description** Teste le fonctionnement de la chaîne de rollback de l'extraction
- **Functional test severity** A

---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithoutParameters
- **Name**             Rollback d'extraction boutique sans paramètres
- **Prerequisite**     Aucun
- **Description**      Teste le rollback de la chaîne d'extraction boutique sans lui fournir de paramètres
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre l'identifiant d'une extraction (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes

-----------------------
testWithBadExtractionId
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithBadExtractionId
- **Name**             Rollback d'extraction boutique avec un identifiant d'extraction inexistant
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique en lui fournissant un identifiant d'extraction introuvable en BDD
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car elle attend en paramètre un identifiant d'extraction correct (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes

--------------------------
testWithUnreachableService
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithUnreachableService
- **Name**             Rollback d'extraction boutique avec impossibilité de joindre le service REST pour récupérer les éléments de l'extraction
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec un service injoignable
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car elle ne peut récupérer les informations sur les éléments en sortie de l'extraction à rollbacker (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

-----------------------
testWithNoBroadcastData
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithNoBroadcastData
- **Name**             Rollback d'extraction boutique avec une extraction sans donnée de diffusion
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec une extraction qui n'a pas de donnée de diffusion
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car une extraction doit avoir une donnée de diffusion pour pouvoir être rollbackée (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

-----------------
testWithNoStorage
-----------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithNoStorage
- **Name**             Rollback d'extraction boutique avec une extraction avec une donnée de diffusion liée à aucun stockage
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec une extraction qui a une donnée de diffusion liée à aucun stockage
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car une extraction doit avoir une donnée de diffusion liée à un stockage pour pouvoir être rollbackée (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

---------------------
testWithNoStoragePath
---------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithNoStoragePath
- **Name**             Rollback d'extraction boutique avec une extraction avec une donnée de diffusion liée à un stockage sans logicalName
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec une extraction qui a une donnée de diffusion liée à un stockage sans logicalName
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car une extraction doit avoir une donnée de diffusion liée à un stockage avec un logicalName pour pouvoir être rollbackée (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

-------------------
testWithNoComponent
-------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithNoComponent
- **Name**             Rollback d'extraction boutique avec une extraction associée à aucune ressource (liste de composants null)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec une extraction associée à aucune ressource (pas de composant)
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car une extraction doit avoir une ressource pour pouvoir être rollbackée (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

-----------------------
testWithEmptyComponents
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithEmptyComponents
- **Name**             Rollback d'extraction boutique avec une extraction associée à aucune ressource (liste de composants vide)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec une extraction associée à aucune ressource (liste de composants vide)
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car une extraction doit avoir une ressource pour pouvoir être rollbackée (retour 2)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

-------------------
testWith2Components
-------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWith2Components
- **Name**             Rollback d'extraction boutique avec une extraction associée à 2 ressources
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec une extraction associée 2 ressources 
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car une extraction doit avoir une seule ressource pour pouvoir être rollbackée (retour 2)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

----------------------------
testWith1ComponentNoResource
----------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWith1ComponentNoResource
- **Name**             Rollback d'extraction boutique avec une extraction associée à aucune resource (composant sans resource)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec une extraction associée à aucune resource. La donnée de diffusion a bien un composant associée mais ce composant n'a pas de ressource.
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car une extraction doit avoir une ressource pour pouvoir être rollbackée (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

-------------------------------
testWith1Component1ResourceNoId
-------------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWith1Component1ResourceNoId
- **Name**             Rollback d'extraction boutique avec une extraction associée à une resource sans id
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec une extraction associée à une ressource sans id.
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car une extraction doit avoir une ressource avec un id pour pouvoir être rollbackée (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

-----------------------------------------
testWithNoExistingDirectoryUpdateStatusOk
-----------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithNoExistingDirectoryUpdateStatusOk
- **Name**             Rollback d'extraction boutique avec répertoire à supprimer inexistant (statut de l'extraction mis à jour)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec un répertoire à supprimer inexistant et une mise à jour du statut de l'extraction qui fonctionne. 
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car la suppression des données n'a pas fonctionnée, le répertoir étant incorrect. Le statut de l'extraction a cependant bien été mis à jour avec "ROLLBACK_NOK" (retour 3)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

------------------------------------------
testWithNoExistingDirectoryUpdateStatusNok
------------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithNoExistingDirectoryUpdateStatusNok
- **Name**             Rollback d'extraction boutique avec répertoire à supprimer inexistant (statut de l'extraction non mis à jour)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec un répertoire à supprimer inexistant et une mise à jour du statut de l'extraction qui ne fonctionne pas. 
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car la suppression des données n'a pas fonctionnée, le répertoir étant incorrect. Le statut de l'extraction n'a pas été mis à jour avec "ROLLBACK_NOK" (retour 4)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes

---------------------------------------
testWithExistingDirectoryUpdateStatusOk
---------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithExistingDirectoryUpdateStatusOk
- **Name**             Rollback d'extraction boutique avec répertoire existant (statut de l'extraction mis à jour)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec un répertoire à supprimer existant et une mise à jour du statut de l'extraction qui fonctionne. 
- **Result**           Le rollback de la chaine extraction boutique doit retourner auncune erreur car le répertoire a bien été supprimé et le statut de l'extraction a bien été mis à jour avec "ROLLBACK_OK" (retour 0)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes

----------------------------------------
testWithExistingDirectoryUpdateStatusNok
----------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithExistingDirectoryUpdateStatusNok
- **Name**             Rollback d'extraction boutique avec répertoire existant (statut de l'extraction non mis à jour)
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique avec un répertoire à supprimer existant et une mise à jour du statut de l'extraction qui ne fonctionne pas. 
- **Result**           Le rollback de la chaine extraction boutique doit retourner une erreur car le répertoire a bien été supprimé et mais le statut de l'extraction n'a pas été mis à jour avec "ROLLBACK_OK" (retour 5)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes

---------------------------
testWithJsonConversionError
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_rollback_extraction_boutique.testWithJsonConversionError
- **Name**             Rollback d'extraction boutique BDD avec un dysfonctionnement lors de la conversion du JSON renvoyé par le service REST en structure PERL
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de rollback d'extraction boutique lorsque la conversion du JSON est impossible
- **Result**           La chaîne doit retourner une erreur car les informations retournée par le service sont inexploitables (retour 254)
- **Comment**          Utilise un mock pour la communication au service REST et pour la conversion JSON
- **Severity**         B
- **Automatic**        Yes






