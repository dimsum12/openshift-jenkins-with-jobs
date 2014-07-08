
def t1 = System.currentTimeMillis();

println("Launch City");
CreateNymeCities.go();

println("Launch ugc");
NymeUGC.go();

def t2 = System.currentTimeMillis();

println ">>> Generate UGC table in " + (t2-t1) + " ms";


