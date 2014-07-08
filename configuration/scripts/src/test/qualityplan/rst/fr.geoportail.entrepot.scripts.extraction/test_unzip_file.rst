fr.geoportail.entrepot.scripts.extraction.test_unzip_file
=========================================================

- **Functional test ID** fr.geoportail.entrepot.scripts.extraction.test_unzip_file
- **Functional test name** Test fonctionnel pour l'extraction de fichiers compressés dans une archive
- **Functional test description** Teste le fonctionnement de l'extraction de fichiers depuis une archive
- **Functional test severity** A



---------------------
testWithoutParameters
---------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_unzip_file.testWithoutParameters
- **Name**             Test de décompression d'archive sans fichier en entrée et sans répertoire de sortie
- **Prerequisite**     Aucun
- **Description**      Test de décompression d'archive sans fichier en entrée et sans répertoire de sortie
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre le chemin vers le fichier à décompresser et le chemin vers le dossier de destination (retour 255)
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-------------------------
testWithInexistingZipFile
-------------------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_unzip_file.testWithInexistingZipFile
- **Name**             Test de décompression d'archive sans fichier en entrée
- **Prerequisite**     Aucun
- **Description**      Test de décompression d'archive avec un fichier inconnu en entrée et avec un répertoire de destination existant
- **Result**           La chaîne doit retourner une erreur car elle attend en paramètre un fichier compressé valide en format zip et un répertoire de destination 
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



-----------------
testWithEmptyFile
-----------------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_unzip_file.testWithEmptyFile
- **Name**             Test avec un fichier à décompresser vide
- **Prerequisite**     Aucun
- **Description**      Test avec un fichier à décompresser vide
- **Result**           La chaine retourne une erreur car elle attend en entrée un fichier non vide
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes







----------
testOkCase
----------

- **ID**               fr.geoportail.entrepot.scripts.extraction.test_unzip_file.testOkCase
- **Name**             Test du cas nominal de la decompression de fichier
- **Prerequisite**     Aucun
- **Description**      Teste la décompression du fichier avec les bons paramètres (ficher en entrée existant et répertoire de destination existant)
- **Result**           La chaîne retourne 0
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes



------------------------------
testWithNoWriteAccessDirectory
------------------------------

- **ID**               fr.geoportail.entrepot.scripts.onditionnement.test_unzip_file.testWithNoWriteAccessDirectory
- **Name**             Test avec un répertoire de destination inaccessible en écriture
- **Prerequisite**     Aucun
- **Description**      Test avec un répertoire de destination inaccessible en écriture
- **Result**           La chaîne doit retourner une erreur car le répertoire est inaccessible en écriture
- **Comment**          -
- **Severity**         C
- **Automatic**        Yes


