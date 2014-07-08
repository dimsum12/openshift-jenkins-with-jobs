fr.geoportail.entrepot.scripts.emap.test_clean_db
=============================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.emap.test_clean_db
- **Functional test name** Test fonctionnel du nettoyage du dossier tmp de l'EMAP.
- **Functional test description** Teste le fonctionnement de  la sauvegarde et du nettoyage (par nombre de fichiers présents pour les deux) du dossier tmp de l'EMAP.
- **Functional test severity** A



---------------------
testWithParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_db.testWithParameters
- **Name**             Nettoyage de la BDD EMAP avec un argument.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage de la BDD EMAP en fournissant un argument.
- **Result**           Le script doit renvoyer un code 4 et n'exécuter aucune action, car l'intention de nettoyage avec des arguments est soit une faute de frappe, soit une mauvaise compréhension de l'utilisation du script.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


---------------------
testWithNoBackup
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_db.testWithNoBackup
- **Name**             Nettoyage de la BDD EMAP lorsque la destination de sauvegardes n'est pas accessible.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage de la BDD EMAP lorsque le répertoire des sauvegardes n'est pas accessible.
- **Result**           Le script doit renvoyer un code 1 et n'exécuter aucune autre action.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


---------------------
testWithNoPgsqlSchema
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_db.testWithNoPgsqlSchema
- **Name**             Nettoyage de la BDD EMAP lorsque cette dernière ne possède aucun autre schéma que "public".
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage de la BDD EMAP lorsqu'aucun.
- **Result**           Le script doit faire une sauvegarde de la table puis renvoyer un code 2 sans aucune autre action.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



---------------------
testCouldNotDeleteSchema
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_db.testCouldNotDeleteSchema
- **Name**             Nettoyage de la BDD EMAP lorsque un schéma n'a pu être supprimé.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage de la BDD EMAP lorsqu'un schéma n'a pu être supprimé.
- **Result**           Le script doit faire une sauvegarde de la table et exécuter un rollback sur la suppression, puis renvoyer un code 3.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


---------------------
testNormalCase
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_db.testNormalCase
- **Name**             Nettoyage de la BDD EMAP dans un cas normal.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage de la BDD EMAP dans un cas normal.
- **Result**           Le script doit faire une sauvegarde de la table, supprimer tous les schémas de la table et les références POSTGIS de ces schémas, et renvoyer un code 0.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes
