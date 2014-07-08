/**
 * @author carto
 *
 */
class AddressUGC {

	static main(args) {
		go();
	}

	static go() {

		String command = ConfigurationAddress.getADDRESSUGCCMDLINE() +
				 ' -create ' + ConfigurationAddress.getADDRESSUGCTABLE() +
				 ' -grammar ' + ConfigurationAddress.getADDRESSUGCGRAMMAR() +
				 ' -projectiondir ' + ConfigurationAddress.getADDRESSUGCPROJ() + 
				 ' -txtstreets ' + ConfigurationAddress.getSTREETSFILENAME() + 
				 ' -txtcities ' + ConfigurationAddress.getCITIESFILENAME() +
				 ' -txtLinks ' + ConfigurationAddress.getLINKSFILENAME() +
 				 ' -txtmetadata ' + ConfigurationAddress.getADDRESSUGCMETADATAS();
				 

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

