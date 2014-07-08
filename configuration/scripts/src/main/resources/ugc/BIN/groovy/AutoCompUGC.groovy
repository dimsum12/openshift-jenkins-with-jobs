/**
 * @author carto
 *
 */
class AutoCompUGC {

	static main(args) {
		go();
	}

	static go() {

		String abRefFileName = Configuration.getACABREVIATIONREFFILENAME();
		String abFileName = Configuration.getACABREVIATIONFILENAME();
		String confRefFileName = Configuration.getACCONFIGREFFILENAME();
		String confFileName = Configuration.getACCONFIGFILENAME();
		
		// copy abreviations ref file
		new File(abFileName).withWriter { file ->
			new File(abRefFileName).eachLine { line ->
				file.writeLine(line);
			}
		}
	
		// copy config ref file
		new File(confFileName).withWriter { file ->
			new File(confRefFileName).eachLine { line ->
				file.writeLine(line);
			}
		}

		String command = 	Configuration.getAUTOCOMPUGCCMDLINE() + 
							' -createAutocomplete ' + 
							confFileName;
				 

		println "Calling ugc Command Line : \n" + command; 

		def t1 = System.currentTimeMillis();		
		def proc = command.execute()                 // Call *execute* on the string
		proc.waitFor()                               // Wait for the command to finish

		// Obtain status and output
		println "return code: ${ proc.exitValue()}"
		println "stderr: ${proc.err.text}"
		println "stdout: ${proc.in.text}" // *out* from the external program is *in* for groovy

		def t2 = System.currentTimeMillis();
		println "Create UGC table in " + (t2 - t1) + " ms";
	}
}

