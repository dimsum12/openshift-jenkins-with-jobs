import java.awt.geom.Line2D;

import groovy.sql.Sql

/**
 * @author carto
 *
 */
class CreateAddressLinks {

	static main(args) {go();
	
	}
	
	
	static go() {
		Sql sql = null;
		
		def timeStart = System.currentTimeMillis();
		
		try {
			sql = ConfigurationAddress.getCnx();
			sql.getConnection().setAutoCommit(false);
			sql.getConnection().setReadOnly(true);
			// ouverture du fichier et creation d'un writer avec comme codage caractere CP1252
			String fileName = ConfigurationAddress.getLINKSFILENAME();
			println "Generate file " + fileName;
			
			new File(fileName).withWriter('CP1252'){ writer ->
				// ecriture de l'entete de fichier
				writer << "Parent\tChild\tLinkType\n";
				String query = ConfigurationAddress.getLINKSQUERY();
				// execution requete + parsing resultat
				sql.eachRow(query) { line ->
					// recupere le nom (colonne 1)
					def str = line.getString(1);
					
					//Definition du flux
					String flux = line.Parent + '\t'+ line.Child + '\t'+ "Contains" + '\n'
					
					// ecrit dans le flux (fichier)
					writer << flux;
				}
			}
			def timeEnd = System.currentTimeMillis();
			println('  -> DONE in ' + (timeEnd - timeStart) + ' ms');
		} catch (Exception e) {
			// Gestion des erreurs
			println("ERROR : " + e.getMessage());
		} finally {
			sql.close();
		}
	}
}
