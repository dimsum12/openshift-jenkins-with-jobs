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
class Configuration {

	static HOSTNAME = null;
	static PORT = null;
	static DATABASE = null;
	static USER = null;
	static PASSWORD = null;
	static DRIVERCLASS = null;

	static ACADDRESSESSCHEMA = null;
	static ACADDRESSESFILENAME = null;
	static ACADDRESSESQUERY = null;
	static ACADDRESSESLISTDEP = null;

	static ACPOPULATIONSCHEMA = null;
	static ACPOPULATIONFILENAME = null;
	static ACPOPULATIONQUERY = null;
	
	static ACTOPONYMESSCHEMA = null;
	static ACTOPONYMESFILENAME = null;
	static ACTOPONYMESQUERY = null;
	
	static AUTOCOMPUGCCMDLINE = null;
	static ACABREVIATIONREFFILENAME = null;
	static ACABREVIATIONFILENAME = null;
	static ACCONFIGREFFILENAME = null;
	static ACCONFIGFILENAME = null;
	
	static def config;

	static {
		config = new ConfigSlurper().parse(new File('config_autocomp.properties').toURL());
		HOSTNAME = config.db.hostname;
		PORT = config.db.port; 
		DATABASE = config.db.database;
		USER = config.db.user;
		PASSWORD = config.db.password;
		DRIVERCLASS = config.db.driverclass;
		
		ACADDRESSESSCHEMA = config.autocomp.addresses.schema;
		ACADDRESSESFILENAME = config.autocomp.addresses.filename;
		ACADDRESSESQUERY = config.autocomp.addresses.query.replace('{DBSCHEMA}', ACADDRESSESSCHEMA);
		ACADDRESSESLISTDEP = config.autocomp.addresses.listdep.replace('{DBSCHEMA}', ACADDRESSESSCHEMA);

		ACPOPULATIONSCHEMA = config.autocomp.population.schema;
		ACPOPULATIONFILENAME = config.autocomp.population.filename;
		ACPOPULATIONQUERY = config.autocomp.population.query.replace('{DBSCHEMA}', ACPOPULATIONSCHEMA);
	
		ACTOPONYMESSCHEMA = config.autocomp.toponyme.schema;
		ACTOPONYMESFILENAME = config.autocomp.toponyme.filename;
		ACTOPONYMESQUERY = config.autocomp.toponyme.query.replace('{DBSCHEMA}', ACTOPONYMESSCHEMA);	

		AUTOCOMPUGCCMDLINE = config.autocomp.ugccmdline;
		ACABREVIATIONREFFILENAME = config.autocomp.ab.ref.filename;
		ACABREVIATIONFILENAME = config.autocomp.ab.filename;
		ACCONFIGREFFILENAME = config.autocomp.config.ref.filename;
		ACCONFIGFILENAME = config.autocomp.config.filename;
	} 	
	
	
	static getCnx() {
		return Sql.newInstance( "jdbc:postgresql://$HOSTNAME:$PORT/$DATABASE", USER, PASSWORD, DRIVERCLASS );
	}
		
}
