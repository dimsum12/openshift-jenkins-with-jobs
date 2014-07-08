

def t1 = System.currentTimeMillis();

println("Launch City");
CreateAddressCities.go();

println("Launch Links");
CreateAddressLinks.go();

println("Launch Street");
CreateAddressStreets.go();

println("Launch ugc");
AddressUGC.go();

def t2 = System.currentTimeMillis();

println ">>> Generate intermediate files and UGC table in " + (t2-t1) + " ms";


