fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement
===================================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement
- **Functional test name** Test fonctionnel pour le conditionnement de données issues de l'extraction
- **Functional test description** Teste le fonctionnement de la chaîne conditionnement de données extraites
- **Functional test severity** A



---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithoutParameters
- **Name**             Conditionnement sans paramètres
- **Prerequisite**     Aucun
- **Description**      Teste le conditionnement de données sans lui fournir de paramètres
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre l'identifiant d'un conditionnement (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



----------------------------
testWithBadConditionnementId
----------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithBadConditionnementId
- **Name**             Conditionnement avec un identifiant de conditionnement inexistant
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement en lui fournissant un identifiant de conditionnement introuvable en BDD
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre un identifiant correct d'un conditionnement (retour 1)
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         C
- **Automatic**        Yes



-------------------------------------
testWithCorrectConditionnementOfType1
-------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithCorrectConditionnementOfType1
- **Name**             Conditionnement correct pour un produit de type BDOrtho
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement  avec une demande de conditionnement correcte pour un produit de type BDOrtho
- **Result**           L' arborescence des dossiers est bien créée, les données extraites sont bien copiées dans le repertoire DONNEES_LIVRAISON
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes




-------------------------------------
testWithCorrectConditionnementOfType2
-------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithCorrectConditionnementOfType2
- **Name**             Conditionnement correct pour un produit de type Vecteur
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement  avec une demande de conditionnement correcte pour un produit de type Vecteur
- **Result**           L' arborescence des dossiers est bien créée, les données extraites sont bien copiées dans le repertoire DONNEES_LIVRAISON
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


-------------------------------------
testWithCorrectConditionnementOfType3
-------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithCorrectConditionnementOfType2
- **Name**             Conditionnement correct pour un produit de type Raster
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement  avec une demande de conditionnement correcte pour un produit de type Raster
- **Result**           L' arborescence des dossiers est bien créée, les données extraites sont bien copiées dans le repertoire DONNEES_LIVRAISON
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes



--------------------------
testWithUnreachableService
--------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUnreachableService
- **Name**             Conditionnement avec service indisponible
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement en simulant l'indisponibilité du serice
- **Result**           La chaine retourne une erreur car le service ne répond pas
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes

-------------------------------
testWithUndefinedInputDirectory
-------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedInputDirectory
- **Name**             Conditionnement avec dossier source des données indéfini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement avec un repertoire de données non défini
- **Result**           La chaine retourne une erreur car le répertoire de données n'est pas défini
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


--------------------------------------
testWithUndefinedTypeOfConditionnement
--------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedTypeOfConditionnement
- **Name**             Conditionnement avec type de conditionnement non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans type de conditionnement défini au préalable
- **Result**           La chaine retourne une erreur car elle s'attend à un type de conditionnement afin de procéder à celui-ci
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


--------------------------------------
testWithUndefinedOutputDirectory_type1
--------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedInputDirectory
- **Name**             Conditionnement pour un produit de type BDOrtho avec dossier de destination des données non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement avec un repertoire de destination des données non défini
- **Result**           La chaine retourne une erreur car le répertoire de destination données n'est pas défini
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


----------------------------------
testWithUndefinedProductName_type1
----------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedProductName_type1
- **Name**             Conditionnement pour un produit de type BDOrtho avec nom de produit non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans nom de produit
- **Result**           La chaine retourne une erreur car le nom du produit est indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


-----------------------------
testWithUndefinedFormat_type1
-----------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedFormat_type1
- **Name**             Conditionnement pour un produit de type BDOrtho avec format du produit non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans format du produit
- **Result**           La chaine retourne une erreur car le format du produit est indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


------------------------------
testWithUndefinedRigCode_type1
------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedRigCode_type1
- **Name**             Conditionnement pour un produit de type BDOrtho avec code Rig non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans code Rig
- **Result**           La chaine retourne une erreur car le code Rig est indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


---------------------------
testWithUndefinedInfo_type1
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedInfo_type1
- **Name**             Conditionnement pour un produit de type BDOrtho sans information complémentaire
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans information complémentaire
- **Result**           La chaine retourne une erreur car la chaine d'information complémentaire  est indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


---------------------------------
testWithUndefinedResolution_type1
---------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedResolution_type1
- **Name**             Conditionnement pour un produit de type BDOrtho sans résolution géométrique
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans résolution géométrique
- **Result**           La chaine retourne une erreur car la résolution géométrique est indispensable à la création de l'arborescence de dossiers pour un produit de type BDOrtho
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes

-----------------------------
testWithUndefinedOption_type1
-----------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedOption_type1
- **Name**             Conditionnement pour un produit de type BDOrtho sans définition de l'option
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement  sans définition de l'option
- **Result**           La chaine retourne une erreur car l'option est indispensable à la création de l'arborescence de dossiers pour un produit de type BDOrtho
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


-----------------------------------
testWithUndefinedDeliveryYear_type1
-----------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedDeliveryYear_type1
- **Name**             Conditionnement pour un produit de type BDOrtho sans définition de l'année de livraison
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement  sans définition de  l'année de livraison
- **Result**           La chaine retourne une erreur car l'année de livraison est indispensable à la création de l'arborescence de dossiers pour un produit de type BDOrtho
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes

------------------------------------
testWithUndefinedDeliveryMonth_type1
------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedDeliveryMonth_type1
- **Name**             Conditionnement pour un produit de type BDOrtho sans définition du mois de livraison
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement  sans définition du mois de livraison
- **Result**           La chaine retourne une erreur car le mois de livraison est indispensable à la création de l'arborescence de dossiers pour un produit de type BDOrtho
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes

-----------------------------------
testWithUndefinedDeliveryCode_type1
-----------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedDeliveryCode_type1
- **Name**             Conditionnement pour un produit de type BDOrtho sans définition du code de livraison
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement  sans définition du code de livraison
- **Result**           La chaine retourne une erreur car le code de livraison est indispensable à la création de l'arborescence de dossiers pour un produit de type BDOrtho
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


--------------------------------------
testWithUndefinedOutputDirectory_type2
--------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedOutputDirectory_type2
- **Name**             Conditionnement pour un produit de type Raster avec dossier de destination des données non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement avec un repertoire de destination des données non défini
- **Result**           La chaine retourne une erreur car le répertoire de destination données n'est pas défini
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


----------------------------------
testWithUndefinedProductName_type2
----------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedProductName_type2
- **Name**             Conditionnement pour un produit de type Raster avec nom de produit non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans nom de produit
- **Result**           La chaine retourne une erreur car le nom du produit est indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


-----------------------------
testWithUndefinedFormat_type2
-----------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedFormat_type2
- **Name**             Conditionnement pour un produit de type Raster avec format du produit non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans format du produit
- **Result**           La chaine retourne une erreur car le format du produit est indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


------------------------------
testWithUndefinedRigCode_type2
------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedRigCode_type2
- **Name**             Conditionnement pour un produit de type Raster avec code Rig non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans format code Rig
- **Result**           La chaine retourne une erreur car le code Rig est indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


----------------------------
testWithUndefinedInfo_type2
----------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedInfo_type2
- **Name**             Conditionnement pour un produit de type Raster avec information complémentaire non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans information complémentaire
- **Result**           La chaine retourne une erreur car l'information complémentaireest indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes

-----------------------------
testWithUndefinedOption_type2
-----------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedOption_type2
- **Name**             Conditionnement pour un produit de type Raster sans définition de l'option
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement  sans définition de l'option
- **Result**           La chaine retourne une erreur car l'option est indispensable à la création de l'arborescence de dossiers pour un produit de type Raster
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


--------------------------------------
testWithUndefinedOutputDirectory_type3
--------------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedOutputDirectory_type3
- **Name**             Conditionnement pour un produit de type Vecteur avec dossier de destination des données non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement avec un repertoire de destination des données non défini
- **Result**           La chaine retourne une erreur car le répertoire de destination données n'est pas défini
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


----------------------------------
testWithUndefinedProductName_type3
----------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedProductName_type3
- **Name**             Conditionnement pour un produit de type Vecteur avec nom de produit non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans nom de produit
- **Result**           La chaine retourne une erreur car le nom du produit est indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


-----------------------------
testWithUndefinedFormat_type3
-----------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedFormat_type3
- **Name**             Conditionnement pour un produit de type Vecteur avec format du produit non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans format du produit
- **Result**           La chaine retourne une erreur car le format du produit est indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes

------------------------------
testWithUndefinedRigCode_type3
------------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedRigCode_type3
- **Name**             Conditionnement pour un produit de type Vecteur avec code Rig non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans format code Rig
- **Result**           La chaine retourne une erreur car le code Rig est indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes


---------------------------
testWithUndefinedInfo_type3
---------------------------

- **ID**               fr.geoportail.entrepot.scripts.conditionnement.test_conditionnement.testWithUndefinedInfo_type3
- **Name**             Conditionnement pour un produit de type Vecteur avec information complémentaire non défini
- **Prerequisite**     Aucun
- **Description**      Teste la chaîne de conditionnement sans information complémentaire
- **Result**           La chaine retourne une erreur car l'information complémentaireest indispensable à la création de l'arborescence de dossiers
- **Comment**          Utilise un mock pour la communication au service REST
- **Severity**         A
- **Automatic**        Yes









