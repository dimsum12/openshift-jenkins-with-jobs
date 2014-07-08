import java.sql.ResultSet;
import groovy.sql.Sql

class CreateReverseRA {

	static main(args) {
		go();
	}

	static go() {
		Sql sql = null;
		
		String queryListDep = ConfigurationReverse.getREVERSEQUERYLISTDEP();
		String query = ConfigurationReverse.getREVERSERAQUERY();
		String fileName = ConfigurationReverse.getREVERSERAFILENAME();
		
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
					writer << 'number_end_left\tnumber_end_right\tnumber_begin_left\tnumber_begin_right\tstreet_name\tgovt_code\tpostal_code\tcity\tnature\tthe_geom\n';
					writer << 'character\tcharacter\tcharacter\tcharacter\tcharacter\tcharacter\tcharacter\tcharacter\tcharacter\tgeometry\n'
					sql.eachRow(queryListDep) { dep ->
						String code_dep = dep.id;
						println '  Generate dep ' + code_dep;		
								
						String q = query.replace('{DEPARTEMENT}', code_dep);
								
						def t1 = System.currentTimeMillis();
						int nb = 0;
						sql.eachRow(q) { line ->
							
							if ( (line.govt_code_left != line.govt_code_right) ||
								 (line.street_name_left != line.street_name_right) ) {
								writeL(writer, line);
								writeR(writer, line);
							} else {
								writeLR(writer, line);
							}
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
	
	private static writeL(writer, line) {
		writer << line.number_end_left << '\t' <<
			   '' << '\t' <<
			   line.number_begin_left << '\t' <<
			   '' << '\t' <<
			   line.street_name_left << '\t' <<
			   line.govt_code_left << '\t' <<
			   line.postal_code_left << '\t' <<
			   line.city_left << '\t' <<
			   line.nature << '\t' <<
			   line.the_geom << '\n';
	}
	
	private static writeR(writer, line) {
		writer << '' << '\t' <<
			   line.number_end_right << '\t' <<
			   '' << '\t' <<
			   line.number_begin_right << '\t' <<
			   line.street_name_right << '\t' <<
			   line.govt_code_right << '\t' <<
			   line.postal_code_right << '\t' <<
			   line.city_right << '\t' <<
			   line.nature << '\t' <<
			   line.the_geom << '\n';
	}
	
	private static writeLR(writer, line) {
		writer << line.number_end_left << '\t' <<
			   line.number_end_right << '\t' <<
			   line.number_begin_left << '\t' <<
			   line.number_begin_right << '\t' <<
			   line.street_name_left << '\t' <<
			   line.govt_code_left << '\t' <<
			   line.postal_code_left << '\t' <<
			   line.city_left << '\t' <<
			   line.nature << '\t' <<
			   line.the_geom << '\n';
	}

}

