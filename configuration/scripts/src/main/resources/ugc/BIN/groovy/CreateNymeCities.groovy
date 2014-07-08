import groovy.sql.Sql
/**
 *
 */

/**
 * @author carto
 *
 */
class CreateNymeCities {

        static main(args) {go();
                                }


        static go(String fileName) {

                // ouverture connexion BDD

                //def sql = Sql.newInstance( "jdbc:postgresql://$HOSTNAME:$PORT/$DATABASE", USER, PASSWORD, DRIVERCLASS )

		String queryListDep = ConfigurationNyme.getNYMEQUERYLISTDEP();
                String query = ConfigurationNyme.getNYMEQUERY();
		int nblines = 0;

				
                Sql sql = null;
                def timeStart = System.currentTimeMillis();
                try {
                        sql = ConfigurationNyme.getCnx();
                        sql.getConnection().setAutoCommit(false);
                        sql.getConnection().setReadOnly(true);
                        // ouverture du fichier et creation d'un writer avec comme codage caractere UTF-8
                        new File(ConfigurationNyme.getNYMEFILENAME()).withWriter('CP1252'){ writer ->
                                // ecriture de l'entete de fichier
                                writer << "NOM\tCODE_INSEE\tCITY_KEY\tCITY_ATTRIBUTE\tX\tY\n";
                                sql.eachRow(queryListDep) { lineDep ->
					int nbLinesIntermediate = 0;
					println ' Generate dep ' + lineDep.id;
					def time1 = System.currentTimeMillis();
					sql.eachRow(query.replace('{DEPARTEMENT}', lineDep.id)) { line ->
                                       		// flux = nom   code_insee      id      canton;arrondissement;depart;region     X       Y
 	                               		String flux = line.nom + '\t' + line.code_insee + '\t' + line.id + '\t' + line.attribute + '\t' + line.x + '\t' +line.y + '\n';
        	                                // ecrit dans le flux (fichier)
                	                        writer << flux;
						nblines ++;
						nbLinesIntermediate ++;
                                    	}
					def time2 = System.currentTimeMillis();
					println ('    -> DONE ' + nbLinesIntermediate + ' lines in ' + (time2 - time1) + ' ms');
				}
			}
                } catch (Exception e) {
                        // Gestion des erreurs
                        println("ERROR : " + e.getMessage());
                }
                def timeEnd = System.currentTimeMillis();
                println('  -> DONE ' + nblines + ' lines in ' + (timeEnd - timeStart) + ' ms');
                sql.close();
        }


}


