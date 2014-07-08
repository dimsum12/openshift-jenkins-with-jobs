

def t1 = System.currentTimeMillis();

println("Launch Adresses");
CreateAutoCompAddresses.go();

println("Launch Population");
CreateAutoCompPopulation.go();

println("Launch Toponyme");
CreateAutoCompToponyme.go();

println("Launch ugc");
AutoCompUGC.go();

def t2 = System.currentTimeMillis();

println ">>> Generate intermediate files and UGC table in " + (t2-t1) + " ms";


