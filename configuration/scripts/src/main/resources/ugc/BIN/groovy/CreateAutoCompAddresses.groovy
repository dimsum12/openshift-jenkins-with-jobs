/**
 * @author carto
 *
 */
import groovy.sql.Sql


class CreateAutoCompAddresses {

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
			String fileName = ConfigurationAutoComp.getACADDRESSESFILENAME();
			String queryListDep = ConfigurationAutoComp.getACADDRESSESLISTDEP();

			println "Generate file " + fileName;
			new File(fileName).withWriter('CP1252'){ writer ->
				// ecriture de l'entete de fichier
				writer << "id@numero@nom_voie@rep@code_insee@code_post@nom\n";
				// execution requete + parsing resultat
				sql.eachRow(queryListDep) { dep ->
					println '  Generate dep ' + dep.id;
					def t1 = System.currentTimeMillis();
					int nb = 0;
					String rq = ConfigurationAutoComp.getACADDRESSESQUERY();
					sql.eachRow(rq.replace('{DEPARTEMENT}', dep.id)) { line ->
						// flux = id@numero@nom_voie@rep@code_insee@code_post@nom	
						writer << line.id << '@' << 
								line.numero << '@' << 
								line.nom_voie << '@' << 
								line.rep << '@' <<
								line.code_insee << '@' <<
								line.code_post << '@' <<
								line.nom << '\n';
						nb++;
					}
					def t2 = System.currentTimeMillis();
					println '    -> DONE ' + nb + ' lines in ' + (t2-t1) + ' ms'; 
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
