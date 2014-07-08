/**
 * @author carto
 *
 */
class NymeUGC {

	static main(args) {
		go();
	}

	static go() {

		String command = ConfigurationNyme.getNYMEUGCCMDLINE() +
				 ' -create ' + ConfigurationNyme.getNYMEUGCTABLE() +
				 ' -grammar ' + ConfigurationNyme.getNYMEUGCGRAMMAR() +
				 ' -projectiondir ' + ConfigurationNyme.getNYMEUGCPROJ() + 
				 ' -txtcities ' + ConfigurationNyme.getNYMEFILENAME() +
				 ' -txtstreets ' + ConfigurationNyme.getNYMESTREETSFILENAME() +
 				 ' -txtmetadata ' + ConfigurationNyme.getNYMEUGCMETADATAS();
				 

		//A string can be executed in the standard java way:

		println "Calling ugc Command Line : \n" + command; 

		def proc = command.execute()                 // Call *execute* on the string
		proc.waitFor()                               // Wait for the command to finish

		// Obtain status and output
		println "return code: ${ proc.exitValue()}"
		println "stderr: ${proc.err.text}"
		println "stdout: ${proc.in.text}" // *out* from the external program is *in* for groovy
	}
}

