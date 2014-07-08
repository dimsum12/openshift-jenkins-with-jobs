fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation
================================================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation
- **Functional test name** Test fonctionnel pour la cha�ne de g�n�ration d'une donn�e de diffusion Pgsql � partir d'une autre donn�e Pgsql existante.
- **Functional test description** Teste le fonctionnement de la cha�ne g�n�ration d'une donn�e de diffusion Pgsql � partir d'une autre donn�e Pgsql existante.
- **Functional test severity** A


---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithoutParameters
- **Name**             G�n�ration BDD retravaill�e sans param�tres
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es sans lui fournir de param�tres
- **Result**           La cha�ne doit retourner une erreur car elle attend en param�tre l'identifiant d'une g�n�ration et le nom du dossier contenant les traitements sql � appliquer. (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


--------------------------
testWithoutScriptDirectory
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithoutScriptDirectory
- **Name**             G�n�ration BDD retravaill�e sans le nom du r�pertoire contenant les traitements
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es sans lui fournir le nom du r�pertoire contenant les traitements
- **Result**           La cha�ne doit retourner une erreur car elle attend en param�tre le nom du dossier contenant les traitements sql � appliquer. (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------------
testWithBadGenerationId
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithBadGenerationId
- **Name**             G�n�ration BDD retravaill�e avec un identifiant de g�n�ration inexistant
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es en lui fournissant un identifiant de g�n�ration introuvable en BDD
- **Result**           La cha�ne doit retourner une erreur car elle attend en param�tre un identifiant correct d'une g�n�ration (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------
testWithCorrectData
-------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithCorrectData
- **Name**             G�n�ration BDD retravaill�e correcte
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es avec une demande de g�n�ration correcte et des donn�es OK
- **Result**           La cha�ne doit correctement se d�rouler, avec la r�cup�ration des informations de g�n�ration, la cr�ation et le remplissage de la nouvelle base de donn�es � partir de la base initiale et la mise � jour de la donn�e de diffusion en fin de traitement
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes



--------------------------
testWithUnreachableService
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithUnreachableService
- **Name**             G�n�ration BDD retravaill�e avec impossibilit� de joindre le service REST pour r�cup�rer les �l�ments de la g�n�ration
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es avec un service injoignable
- **Result**           La cha�ne doit retourner une erreur car elle ne peut r�cup�rer les informations sur les �l�ments en entr�e et en sortie de la g�n�ration � effectuer (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



------------------------------------
testWithMultipleBroadcastDatasOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithMultipleBroadcastDatasOutput
- **Name**             G�n�ration BDD retravaill�e avec plusieurs donn�es de diffusion en sortie du processus de g�n�ration
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es avec 2 donn�es de g�n�ration en sortie au lieu d'une seule attendue
- **Result**           La cha�ne doit retourner une erreur car elle ne g�n�re qu'une seule donn�e de diffusion (retour 3)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



-------------------------
testWithMultipleInputData
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithMultipleInputData
- **Name**             G�n�ration BDD retravaill�e avec plusieurs donn�es en entr�e du processus de g�n�ration
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es avec 2 donn�es Pgsql en entr�e au lieu d'une seule attendue
- **Result**           La cha�ne doit retourner une erreur car elle ne peut traiter qu'une seule donn�e en entr�e (retour 2)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         B
- **Automatic**        Yes



-----------------------------
testWithNoSchemaNameInputData
-----------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithNoSchemaNameInputData
- **Name**             G�n�ration BDD retravaill�e avec une donn�e en entr�e incorrecte (ne poss�dant pas de nom de sch�ma)
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es avec une donn�e en entr�e sans nom de sch�ma (erreur de structure)
- **Result**           La cha�ne doit retourner une erreur car elle ne peut traiter que les donn�es en entr�e correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------------------
testWithNoIdBroadcastDataOutput
-------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithNoIdBroadcastDataOutput
- **Name**             G�n�ration BDD retravaill�e avec une donn�e de diffusion incorrecte (ne poss�dant pas d'identifiant)
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es avec une donn�es de diffusion sans identifiant
- **Result**           La cha�ne doit retourner une erreur car elle ne peut traiter que les donn�es de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


---------------------
testWithNoIdInputData
---------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithNoIdInputData
- **Name**             G�n�ration BDD retravaill�e avec une donn�e en entr�e incorrecte (ne poss�dant pas d'identifiant)
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es avec une donn�e en entr�e sans identifiant (erreur de structure)
- **Result**           La cha�ne doit retourner une erreur car elle ne peut traiter que les donn�es en entr�e correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


------------------------------------
testWithNoVersionBroadcastDataOutput
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithNoVersionBroadcastDataOutput
- **Name**             G�n�ration BDD retravaill�e avec une donn�e de diffusion incorrecte (ne poss�dant pas de version)
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es avec une donn�es de diffusion sans version
- **Result**           La cha�ne doit retourner une erreur car elle ne peut traiter que les donn�es de diffusion correctes (retour 253)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


---------------------------
testWithDataGenerationError
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithDataGenerationError
- **Name**             G�n�ration BDD retravaill�e avec une livraison g�n�rant des erreurs lors de l'int�gration SQL
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es avec des informations qui g�n�rent une erreur lors de l'int�gration SQL (le nom du sch�ma initial n'existe pas en base) 
- **Result**           La cha�ne doit retourner une erreur car l'int�gration en base n'est pas correctement effectu�e (retour 5)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


--------------------------------
testWithUpdateBroadcastDataError
--------------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithUpdateBroadcastDataError
- **Name**             G�n�ration BDD retravaill�e avec un dysfonctionnement lors de la mise � jour de la donn�e de diffusion
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es lorsque la mise � jour de la donn�e de diffusion en sortie ne fonctionne pas
- **Result**           La cha�ne doit retourner une erreur car la mise � jour de la donn�e de diffusion ne peut �tre r�alis�e (retour 6)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes


---------------------------
testWithJsonConversionError
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.generation.test_reprocess_existing_bdd_generation.testWithJsonConversionError
- **Name**             G�n�ration BDD retravaill�e avec un dysfonctionnement lors de la conversion du JSON renvoy� par le service REST en structure PERL
- **Prerequisite**     Aucun
- **Description**      Teste la cha�ne de g�n�ration de donn�es de diffusion Pgsql retravaill�es lorsque la conversion du JSON est impossible
- **Result**           La cha�ne doit retourner une erreur car les informations retourn�e par le service sont inexploitables (retour 254)
- **Comment**          Utilise un mock pour la communication au service REST et pour la conversion JSON
- **Severity**         B
- **Automatic**        Yes