fr.geoportail.entrepot.scripts.extraction.test_extraction
=========================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.extraction.test_extraction
- **Functional test name** Test fonctionnel pour la chaine de haut niveau de l'extraction
- **Functional test description** Teste le fonctionnement de la chaîne de l'extraction
- **Functional test severity** A



---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_extraction.testWithoutParameters
- **Name**             Extraction sans paramètres
- **Prerequisite**     Aucun
- **Description**      Teste l'extraction de données sans paramètres
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre l'identifiant d'une extraction (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


-----------------------
testWithBadExtractionId
-----------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_extraction.testWithBadExtractionId
- **Name**             Extraction avec un identifiant d'extraction inexistant
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne d'extraction en lui fournissant un identifiant d'extraction introuvable en BDD
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre un identifiant d'extraction correct (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


--------------------------
testWithUnreachableService
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_extraction.testWithUnreachableService
- **Name**             Extraction avec service indisponible
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne d'extraction en simulant l'indisponibilité du service
- **Result**           La chaine retourne une erreur car le service ne répond pas
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


--------------------------
testWithUnreachableService
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_extraction.testWithUnreachableService
- **Name**             Extraction avec service indisponible
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne d'extraction en simulant l'indisponibilité du service
- **Result**           La chaine retourne une erreur car le service ne répond pas
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes

------------------------------------------
testWithCorrectExtractionOfWMSTypeWithBBOX
------------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_extraction.testWithCorrectExtractionOfWMSTypeWithBBOX
- **Name**             Extraction de type WMS
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne d'extraction d'un service WMS avec une BoundingBox 
- **Result**           L'extraction des données est bien lancée, et les données sont stockées dans le dossier de sortie passé en paramètre
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes

------------------------------
testWithCorrectExtractionOfWFS
------------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_extraction.testWithCorrectExtractionOfWFS
- **Name**             Extraction de type WFS
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne d'extraction d'un service WFS 
- **Result**           L'extraction des données est bien lancée, et les données sont stockées dans le dossier de sortie passé en paramètre
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes



