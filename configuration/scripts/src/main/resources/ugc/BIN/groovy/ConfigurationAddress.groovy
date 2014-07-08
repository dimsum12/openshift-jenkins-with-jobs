import groovy.sql.Sql;
import com.vividsolutions.jts.geom.LineString;
import com.vividsolutions.jts.geom.MultiLineString;
import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.io.WKTReader;
import com.vividsolutions.jts.operation.valid.IsValidOp;

/**
 * @author carto
 *
 */
class ConfigurationAddress {

	static HOSTNAME = null;
	static PORT = null;
	static DATABASE = null;
	static USER = null;
	static PASSWORD = null;
	static DRIVERCLASS = null;

	static CITIESSCHEMA = null;
	static CITIESQUERY = null;
	static CITIESFILENAME = null;

	static LINKSSCHEMA = null;
        static LINKSQUERY = null;
        static LINKSFILENAME = null;

	static STREETSSCHEMA = null;
        static STREETSQUERY = null;
	static STREETSROUTEQUERY = null;
        static STREETSQUERYLISTDEP = null;
        static STREETSFILENAME = null;
        static STREETSFILENAMEBAD = null;

	static ADDRESSUGCCMDLINE = null; 
	static ADDRESSUGCTABLE = null;
	static ADDRESSUGCGRAMMAR = null;
	static ADDRESSUGCPROJ = null;
	static ADDRESSUGCMETADATAS = null;

	static def config;

	static {
		config = new ConfigSlurper().parse(new File('config_address.properties').toURL());
		HOSTNAME = config.db.hostname;
		PORT = config.db.port; 
		DATABASE = config.db.database;
		USER = config.db.user;
		PASSWORD = config.db.password;
		DRIVERCLASS = config.db.driverclass;

		CITIESSCHEMA = config.cities.schema;
		if (config.containsKey("cities.schema")) {
			CITIESQUERY = config.cities.query.replace('{DBSCHEMA}', CITIESSCHEMA);
		} else {
			 CITIESQUERY = config.cities.query;
		}
		CITIESFILENAME = config.cities.filename;

		LINKSSCHEMA = config.links.schema;
		LINKSQUERY = config.links.query.replace('{DBSCHEMA}', LINKSSCHEMA);
		LINKSFILENAME = config.links.filename;

		STREETSSCHEMA = config.streets.schema;
	        	STREETSQUERY = config.streets.query.replace('{DBSCHEMA}', STREETSSCHEMA);
			STREETSROUTEQUERY = config.streets.route.query.replace('{DBSCHEMA}', STREETSSCHEMA);
        		STREETSQUERYLISTDEP = config.streets.listdep.replace('{DBSCHEMA}', STREETSSCHEMA);
        	STREETSFILENAME = config.streets.filename;
        	STREETSFILENAMEBAD = config.streets.filenamebad;
		
		ADDRESSUGCCMDLINE = config.ugc.address.ugccmdline;
                ADDRESSUGCTABLE = config.ugc.address.tableref; 
                ADDRESSUGCGRAMMAR = config.ugc.address.grammar;
                ADDRESSUGCPROJ = config.ugc.address.proj;
                ADDRESSUGCMETADATAS = config.ugc.address.metadatas; 
	} 	
	
	
	static getCnx() {
		return Sql.newInstance( "jdbc:postgresql://$HOSTNAME:$PORT/$DATABASE", USER, PASSWORD, DRIVERCLASS );
	}
	
	
	/**
	 * Check if a street is valid. ie doesn't contains some invalid characters
	 * @param streetName the street name to be checked
	 * @return an empty string ("") if the street name is valid, an error message otherwise
	 */
	static private isValidStreetName(String streetName) {
		String retValue = "";
		def myError = [
			[car:',', nb:0, label:'comma'],
			[car:';', nb:0, label:'dot comma'],
			[car:'/', nb:0, label:'slash'],
			[car:'"', nb:0, label:'quote'],
			[car:'.', nb:0, label:'dot']
		];
		if (streetName != null && streetName.length() > 0) {
			streetName.each { caractere ->
				myError.each { er ->
					if (caractere == er.car) {
						er.nb += 1;
					}
				}
			}
			int nb = 0;
			myError.each { er ->
				if (er.nb > 0) {
					if (nb > 0) {
						retValue += ','
					}
					retValue += ' ' + er.nb + ' ' + er.label;
					nb++;
				}
			}
			if (retValue != "") {
				retValue += '\t';
			}
		}
		return retValue;
	}
	
	
	public static generateGeom(String geom) {
		String retStr = "";
		StringBuffer sb;
		WKTReader wktReader = new WKTReader();
		LineString ls;
		try {
			ls = (LineString)wktReader.read(geom);
			if (ls.getNumPoints() < 2) {
				System.err.println("Error : bad Geometry .... " + ls.getNumPoints() + " points");
			} else {
				int factor = 1;
				def currentX = ls.getPointN(0).getX()*factor;
				def currentY = ls.getPointN(0).getY()*factor;
				sb = new StringBuffer();
				sb.append( ls.getPointN(0).getX()*factor).append('\t');
				sb.append( ls.getPointN(0).getY()*factor).append('\t');
				sb.append( (double)(ls.getPointN(ls.getNumPoints()-1).getX()*factor) ).append('\t');
				sb.append( (double)(ls.getPointN(ls.getNumPoints()-1).getY()*factor) ).append('\t');
				sb.append( (ls.getNumPoints()-1) );
				for (int i = 1 ; i < ls.getNumPoints() ; i++) {
					sb.append('\t');
					sb.append( sprintf("%2.8f",(double)(ls.getPointN(i).getX()*factor) - currentX)).append('\t');
					sb.append( sprintf("%2.8f",(double)(ls.getPointN(i).getY()*factor) - currentY));
					currentX = (double)(ls.getPointN(i).getX()*factor);
					currentY = (double)(ls.getPointN(i).getY()*factor);
				}
				
				retStr = sb.toString();
			}
		} 
		catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return retStr;
	}
	
}