fr.geoportail.entrepot.scripts.emap.test_clean_chains
=============================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.emap.test_clean_chains
- **Functional test name** Test fonctionnel du nettoyage du dossier des chaînes de traitement de l'EMAP.
- **Functional test description** Teste le fonctionnement de  la sauvegarde, du nettoyage et de la récuépration du dépôt Mercurial des chaînes de traitement dans l'EMAP.
- **Functional test severity** C



---------------------
testWithParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_chains.testWithParameters
- **Name**             Nettoyage du dossier des chaînes avec des paramètres
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du dossier des chaînes en lui fournissant un argument.
- **Result**           Le script doit renvoyer une erreur 254 et ne rien faire, car l'intention de nettoyage avec des arguments est soit une faute de frappe, soit une mauvaise compréhension de l'utilisation du script.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


---------------------
TestWithNoBackupDone
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_chains.TestWithNoBackupDone
- **Name**             Nettoyage du dossier des chaînes avec un répertoire de sauvegarde non accessible en écriture.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du des chaînes quand le répertoire des sauvegardes n'est pas atteignable.
- **Result**           L'exécution renvoie un code 251. La sauvegarde n'ayant pas pu être faite, aucune autre action ne sera exécutée.
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


---------------------
TestWithNoCleaning
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_chains.TestWithNoCleaning
- **Name**             Nettoyage du dossier des chaînes lorsque ce dernier n'a pu être purgé.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du des chaînes quand ce dernier ne peut être purgé (fichier bloqué, pas d'écriture possible, etc.)
- **Result**           L'exécution renvoie un code 252. La sauvegarde a bien été exécutée, mais pas le nettoyage. Aucune autre action ne sera exécutée (récuépration du dépôt).
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


---------------------
TestNormalCase
---------------------

- **ID**               fr.geoportail.entrepot.scripts.emap.test_clean_chains.TestNormalCase
- **Name**             Nettoyage du dossier des chaînes en cas normal.
- **Prerequisite**     Aucun
- **Description**      Teste l'appel au nettoyage du des chaînes dans un cas normal.
- **Result**           L'exécution renvoie un code 0. La sauvegarde du dossier des chaînes est effectuée, sa purge également, ainsi que la récupération du dépôt mercurial spécifié dans la configuration (adresse et branche).
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes