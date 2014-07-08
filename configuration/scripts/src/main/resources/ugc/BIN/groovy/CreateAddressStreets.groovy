import java.sql.ResultSet;

import javax.sql.RowSet;


import groovy.sql.Sql

class CreateAddressStreets {

	static go() {

		// ouverture connexion BDD
		Sql sql = null;
		FileWriter badFile = null;

		String queryListDep = ConfigurationAddress.getSTREETSQUERYLISTDEP();
		String query = ConfigurationAddress.getSTREETSQUERY();
		String fileName = ConfigurationAddress.getSTREETSFILENAME();
		String fileNameBAD = ConfigurationAddress.getSTREETSFILENAMEBAD();
		String queryRoute = ConfigurationAddress.getSTREETSROUTEQUERY();

		
		try {
			sql = ConfigurationAddress.getCnx();
			sql.getConnection().setAutoCommit(false);
			sql.getConnection().setReadOnly(true);
			sql.setResultSetType(ResultSet.FETCH_FORWARD);
			sql.setResultSetConcurrency(ResultSet.CONCUR_READ_ONLY);
			
			def nberror = 0;

			def i = 1;
			def timeStart = System.currentTimeMillis();
			println "Generate file " + fileName + " ( and " + fileNameBAD + " for wrong lines)"; 
			try {
				// ouverture du fichier BAD
				badFile = new FileWriter(fileNameBAD);
				badFile << "Cause\tstreetName\tstreetAttribute\tendNumberL\tstartNumberL\tendNumberR\tstartNumberR\tcityName\tcityAttribute\tcityUniqueId\tX1\tY1\tX1\tY1\tGEOM\n";
				// ouverture du fichier et creation d'un writer avec comme codage caractere CP1252
				new File(fileName).withWriter('CP1252'){ writer ->
					// ecriture de l'entete de fichier
					writer << "streetName\tstreetAttribute\tendNumberL\tstartNumberL\tendNumberR\tstartNumberR\tcityName\tcityAttribute\tcityUniqueId\tX1\tY1\tX2\tY2\tGEOM\n";
					
					// execution requete + parsing resultat
					def timeStart2 = System.currentTimeMillis();
					def timeEnd2 = timeStart2;
					def error = "";
					println "Starting .... ";
					//String queryListDep = "select distinct code_dep as id from bdadresse.commune_dep order by code_dep";
					sql.eachRow(queryListDep) { dep ->
						String code_dep = dep.id;
						println '  Generate dep ' + code_dep;		
								
						String q = query.replace('{DEPARTEMENT}', code_dep);
								
						def t1 = System.currentTimeMillis();
						int nb = 0;
						sql.eachRow(q) { line ->
							def flux = new StringBuffer();
							flux << line.nom_voie << '\t' <<
									line.code_voie << '\t' <<
									line.numero << '\t' <<
									'\t' <<
									'\t' <<
									'\t' <<
									line.cityname << '\t' <<
									line.cityattribute << '\t' <<
									line.cityid << '\t' <<
									line.x << '\t' <<
									line.y << '\n';
							error = Configuration.isValidStreetName(line.nom_voie);
							if (error != "") {
								badFile << error << ' ' << flux;
								nberror++;
							} else {
								writer << flux;
							}
							nb++;
						}
						def t2 = System.currentTimeMillis();
						println '    -> DONE ' + nb + ' lines (PA) in ' + (t2 - t1) + ' ms';
						nb = 0;
						sql.eachRow( queryRoute.replace('{DEPARTEMENT}', code_dep)) { line ->
								
							// si rue_g = null
							if (line.nom_rue_g == null || line.nom_rue_g == "" ) {
								if (line.nom_rue_d == null || line.nom_rue_d == "" ) {
									// rue_d == null
									// nothing
								} else {
									// rue_d != null
									String flux = line.nom_rue_d + '\t' +
												  line.codevoie_d + '\t' +
												  "" + '\t' +
												  "" + '\t' +
												  line.bornefin_d + '\t' +
												  line.bornedeb_d + '\t' +
												  line.nom_d + '\t' +
												  line.cinsee_d + '\t' +
												  line.id_d + '\t' +
												  Configuration.generateGeom(line.geom) + '\n';
												  
									error = Configuration.isValidStreetName(line.nom_rue_d);
									if (error != "") {
										 badFile << error << ' ' << flux;
										 nberror++;
									} else {
										writer << flux;
									}
								}
							} else {
								// rue_g != null
								if (line.nom_rue_d == null || line.nom_rue_d == "" ) {
								// rue_d == null
									String flux = line.nom_rue_g + '\t' +
													line.codevoie_g + '\t' +
													line.bornefin_g + '\t' +
													line.bornedeb_g + '\t' +
													"" + '\t' +
													"" + '\t' +
													line.nom_g + '\t' +
													line.cinsee_g + '\t' +
													line.id_g + '\t' +
													Configuration.generateGeom(line.geom) + '\n';
									error = Configuration.isValidStreetName(line.nom_rue_g);
									if (error != "") {
										 badFile << error << ' ' << flux;
										 nberror++;
									} else {
									   writer << flux;
									}
								} else {
									if (line.nom_rue_g != line.nom_rue_d) {
										 //rue_g != rue_d
										String flux_g = line.nom_rue_g + '\t' +
														 line.codevoie_g + '\t' +
														 line.bornefin_g + '\t' +
														 line.bornedeb_g + '\t' +
														 "" + '\t' +
														 "" + '\t' +
														 line.nom_g + '\t' +
														 line.cinsee_g + '\t' +
														 line.id_g + '\t' +
														 Configuration.generateGeom(line.geom)+ '\n';
										 String flux_d = line.nom_rue_d + '\t' +
														 line.codevoie_d + '\t' +
														"" + '\t' +
														"" + '\t' +
														line.bornefin_d + '\t' +
														line.bornedeb_d + '\t' +
														line.nom_d + '\t' +
														line.cinsee_d + '\t' +
														line.id_d + '\t' +
														Configuration.generateGeom(line.geom)+ '\n';
														
										error = Configuration.isValidStreetName(line.nom_rue_g);
										if (error != "") {
											badFile << error << ' ' << flux_g;
											nberror++;
										} else {
										   writer << flux_g;
										}
										error = Configuration.isValidStreetName(line.nom_rue_d);
										if (error != "") {
											badFile << error << ' ' << flux_d;
											nberror++;
										} else {
											writer << flux_d;
										}
									} else {
										// rue_g == rue_d
										if (line.id_g == line.id_d) {
											 String flux = line.nom_rue_g + '\t' +
											 line.codevoie_g + '\t' +
											 line.bornefin_g + '\t' +
											 line.bornedeb_g + '\t' +
											 line.bornefin_d + '\t' +
											 line.bornedeb_d + '\t' +
											 line.nom_g + '\t' +
											 line.cinsee_g + '\t' +
											 line.id_g + '\t' +
											 Configuration.generateGeom(line.geom)+ '\n';
											 error = Configuration.isValidStreetName(line.nom_rue_g);
											 if (error != "") {
												 badFile << error << ' ' << flux;
												 nberror++;
											 } else {
												writer << flux;
											 }
										} else {
											 // ville_g != ville_d
											 String flux_g = line.nom_rue_g + '\t' +
															 line.codevoie_g + '\t' +
															 line.bornefin_g + '\t' +
															 line.bornedeb_g + '\t' +
															 "" + '\t' +
															 "" + '\t' +
															 line.nom_g + '\t' +
															 line.cinsee_g + '\t' +
															 line.id_g + '\t' +
															 Configuration.generateGeom(line.geom) + '\n';
											String flux_d = line.nom_rue_d + '\t' +
															 line.codevoie_d + '\t' +
															"" + '\t' +
															"" + '\t' +
															line.bornefin_d + '\t' +
															line.bornedeb_d + '\t' +
															line.nom_d + '\t' +
															line.cinsee_d + '\t' +
															line.id_d + '\t' +
															Configuration.generateGeom(line.geom) + '\n';
											error = Configuration.isValidStreetName(line.nom_rue_g);
											if (error != "") {
												badFile << error << ' ' << flux_g;
												nberror++;
											} else {
												writer << flux_g;
											}
											error = Configuration.isValidStreetName(line.nom_rue_d);
											if (error != "") {
												badFile << error << ' ' << flux_d;
												nberror++;
											} else {
												writer << flux_d;
											}
										}
									}
								}
							}
							nb++;
						}
						def t3 = System.currentTimeMillis();
						println '    -> DONE ' + nb + ' lines (RA) in ' + (t3 - t2) + ' ms';
					}					
					
				} 

			} catch (Exception e) {
				// Gestion des erreurs
				println("ERROR : " + e.getMessage());
			}
			def timeEnd = System.currentTimeMillis();
			println '  -> DONE in ' + (timeEnd - timeStart) + ' ms with ' + nberror + ' error(s)';
		} finally {
			if (sql != null) {
				sql.close();
			}
			if (badFile != null) {
				badFile.close();	
			}
		}

	}

	static main(args) {
		go();
	}

}

