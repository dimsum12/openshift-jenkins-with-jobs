/**
 * @author carto
 *
 */
import groovy.sql.Sql


class CreateAddressCities {

	static main(args) {
		go();
	}


	static go() {
 		Sql sql = null;
		def timeStart = System.currentTimeMillis();
		try {
			sql = ConfigurationAddress.getCnx();
			sql.getConnection().setAutoCommit(false);
			sql.getConnection().setReadOnly(true);
			// ouverture du fichier et creation d'un writer avec comme codage caractere CP1252
			String fileName = ConfigurationAddress.getCITIESFILENAME();
			println "Generate file " + fileName;
			new File(fileName).withWriter('CP1252'){ writer ->
				// ecriture de l'entete de fichier
				writer << "NOM\tCODE_INSEE\tCITY_KEY\tCITY_ATTRIBUTE\tX\tY\n";
				// execution requete + parsing resultat
				String rq = ConfigurationAddress.getCITIESQUERY();
				sql.eachRow(rq) { line ->
					// recupere le nom (colonne 1)
					def str = line.getString(1);
					// concatene avec code_insee
					str = str + "\t" + line.code_insee + "\n";
					
					// flux = nom	code_insee	id	canton;arrondissement;depart;region	X	Y
					String flux = line.nom + '\t' + line.code_insee + '\t' + line.id + '\t' + line.attribute + '\t' + line.x + '\t' +line.y + '\n';
					
					// ecrit dans le flux (fichier)
					writer << flux;
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
