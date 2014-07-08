import java.sql.ResultSet;
import groovy.sql.Sql

class CreateReversePA {

	static main(args) {
		go();
	}

	static go() {
		Sql sql = null;
		
		String queryListDep = ConfigurationReverse.getREVERSEQUERYLISTDEP();
		String query = ConfigurationReverse.getREVERSEPAQUERY();
		String fileName = ConfigurationReverse.getREVERSEPAFILENAME();
		
		try {
			sql = ConfigurationReverse.getCnx();
			sql.getConnection().setAutoCommit(false);
			sql.getConnection().setReadOnly(true);
			sql.setResultSetType(ResultSet.FETCH_FORWARD);
			sql.setResultSetConcurrency(ResultSet.CONCUR_READ_ONLY);			
			
			def timeStart = System.currentTimeMillis();
			println 'Generate file ' + fileName; 
			try {
				// ouverture du fichier et creation d'un writer avec comme codage caractere CP1252
				new File(fileName).withWriter('CP1252'){ writer ->
					// ecriture de l'entete de fichier
					writer << 'number\trep\tstreet_name\tgovt_code\tpostal_code\tcity\tquality\tnature\tthe_geom\n';
					writer << 'integer\tcharacter\tcharacter\tcharacter\tcharacter\tcharacter\tlist\tcharacter\tgeometry\n'
					sql.eachRow(queryListDep) { dep ->
						String code_dep = dep.id;
						println '  Generate dep ' + code_dep;		
								
						String q = query.replace('{DEPARTEMENT}', code_dep);
								
						def t1 = System.currentTimeMillis();
						int nb = 0;
						sql.eachRow(q) { line ->
							
							writer << line.number << '\t' <<
									line.rep << '\t' <<
									line.street_name << '\t' <<
									line.govt_code << '\t' <<
									line.postal_code << '\t' <<
									line.nom << '\t' <<
									line.quality << '\t' <<
									line.nature << '\t' <<
									line.the_geom << '\n';
							nb++;
						}
						def t2 = System.currentTimeMillis();
						println '    -> DONE ' + nb + ' lines in ' + (t2 - t1) + ' ms';
					}					
				}  
			} catch (Exception e) {
				// Gestion des erreurs
				println 'ERROR : ' + e.getMessage();
			}
			def timeEnd = System.currentTimeMillis();
			println '  -> DONE in ' + (timeEnd - timeStart) + ' ms';
		} finally {
			if (sql != null) {
				sql.close();
			}
		}

	}

}

