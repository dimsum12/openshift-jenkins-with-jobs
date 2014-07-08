fr.geoportail.entrepot.scripts.emap.test_clean_catalog
=============================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.emap.test_clean_catalog
- **Functional test name** Test fonctionnel du nettoyage du dossier tmp de l'EMAP.
- **Functional test description** Teste le fonctionnement de  la sauvegarde et du nettoyage (par nombre de fichiers présents pour les deux) du dossier tmp de l'EMAP.
- **Functional test severity** C



---------------------
testWithParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_catalog.testWithParameters
- **Name**             Nettoyage du catalogue avec des paramètres.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du catalogue en lui fournissant un argument.
- **Result**           Le script doit renvoyer un code 1 et ne rien faire, car l'intention de nettoyage avec des arguments est soit une faute de frappe, soit une mauvaise compréhension de l'utilisation du script.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


---------------------
testWithNoBackup
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_catalog.testWithNoBackup
- **Name**             Nettoyage du catalogue avec impossibilité de faire la sauvegarde de la base.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du catalogue dans le cas où la sauvegarde n'est pas effectué.
- **Result**           Le script doit renvoyer un code 2 et n'exécuter aucune autre action.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


---------------------
testWithNoGeneratingTable
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_catalog.testWithNoGeneratingTable
- **Name**             Nettoyage du catalogue avec impossibilité de regénérer les tables de base pour le catalogue.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du catalogue dans le cas où les tables de bases du catalogue ne peuvent être créées.
- **Result**           Le script doit renvoyer un code 4, la sauvegarde est faite, un retour arrière de la BDD sur le nettoyage est fait, et aucune autre action ne sera effectuée.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


---------------------
testNormalCase
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_catalog.testNormalCase
- **Name**             Nettoyage du catalogue dans le cas normal.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du catalogue dans le cas d'utilisation normal.
- **Result**           Le script doit renvoyer un code 0, la sauvegarde est faite, la base du catalogue est réinitalisée.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes