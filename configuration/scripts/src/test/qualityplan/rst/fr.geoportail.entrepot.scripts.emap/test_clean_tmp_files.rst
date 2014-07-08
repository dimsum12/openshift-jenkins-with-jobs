fr.geoportail.entrepot.scripts.emap.test_clean_tmp_files
=============================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.emap.test_clean_tmp_files
- **Functional test name** Test fonctionnel du nettoyage du dossier tmp de l'EMAP.
- **Functional test description** Teste le fonctionnement de  la sauvegarde et du nettoyage (par nombre de fichiers présents pour les deux) du dossier tmp de l'EMAP.
- **Functional test severity** A



---------------------
testWithParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_tmp_files.testWithParameters
- **Name**             Nettoyage du dossier tmp avec des paramètres
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du dossier tmp en lui fournissant un argument.
- **Result**           Le script doit renvoyer une erreur 253 et ne rien faire, car l'intention de nettoyage avec des arguments est soit une faute de frappe, soit une mauvaise compréhension de l'utilisation du script.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


---------------------
testBackupInNormalCase
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_tmp_files.testBackupInNormalCase
- **Name**             Nettoyage du dossier tmp dans un cas normal, vérification de la sauvegarde.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du dossier tmp et vérifie la sauvegarde générée.
- **Result**           Le fichier de sauvegarde ".tar.gz" doit contenir le même nombre d'éléments que le dossier tmp avant exécution. L'exécution ne doit pas retourner d'erreurs.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes

---------------------
testCleaningInNormalCase
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_tmp_files.testCleaningInNormalCase
- **Name**             Nettoyage du dossier tmp dans un cas normal, vérification du nettoyage effectif.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du dossier tmp et vérifie le nettoyage effectif du dossier tmp.
- **Result**           Le dossier tmp doit être complètement vide, hors les fichiers "." et "..".
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes

---------------------
testWithNoAccessToTmp
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_tmp_files.testWithNoAccessToTmp
- **Name**             Nettoyage du dossier tmp lorsque ce dernier est inaccessible.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du dossier tmp alors que tmp n'est pas accessible (ni lecture, ni écriture).
- **Result**           Le backup n'ayant pu être fait, une erreur 255 doit être retournée.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes

---------------------
testWithNoWriteInTmp
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_tmp_files.testWithNoWriteInTmp
- **Name**             Nettoyage du dossier tmp lorsque ce dernier est accessible en lecture uniquement.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du dossier tmp alors que tmp accessible qu'en lecture.
- **Result**           Le backup a été fait, pas le nettoyage. Une erreur 254 doit être retournée.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes

