/**
 * @author carto
 *
 */
import groovy.sql.Sql


class CreateAutoCompPopulation {

	static main(args) {
		go();
	}


	static go() {
 		Sql sql = null;
		def timeStart = System.currentTimeMillis();
		try {
			sql = ConfigurationAutoComp.getCnx();
			sql.getConnection().setAutoCommit(false);
			sql.getConnection().setReadOnly(true);
			// ouverture du fichier et creation d'un writer avec comme codage caractere CP1252
			String fileName = ConfigurationAutoComp.getACPOPULATIONFILENAME();
			String query = ConfigurationAutoComp.getACPOPULATIONQUERY();

			println "Generate file " + fileName;
			new File(fileName).withWriter('CP1252'){ writer ->
				// ecriture de l'entete de fichier
				//writer << 'id	origin_nom	nom	importance	nature	code_insee	nom_com';
				// execution requete + parsing resultat
				sql.eachRow(query) { line ->
						// flux = id	origin_nom	nom	importance	nature	code_insee	nom_com
					writer << line.code_insee << '\t' <<
									line.popul << '\n';
				}
			}
		} catch (Exception e) {
			// Gestion des erreurs
			println("ERROR : " + e.getMessage());
		}
		def timeEnd = System.currentTimeMillis();
		println('  -> DONE in ' + (timeEnd - timeStart) + ' ms');
		sql.close();
	}
	
}
