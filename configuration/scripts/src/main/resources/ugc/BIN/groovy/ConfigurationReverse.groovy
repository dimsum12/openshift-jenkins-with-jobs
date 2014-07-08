import groovy.sql.Sql;

/**
 * @author carto
 *
 */
class ConfigurationReverse {

	static HOSTNAME = null;
	static PORT = null;
	static DATABASE = null;
	static USER = null;
	static PASSWORD = null;
	static DRIVERCLASS = null;

	static REVERSESCHEMA = null;
    static REVERSEPAQUERY = null;
    static REVERSEQUERYLISTDEP = null;
    static REVERSEPAFILENAME = null;
	
	static REVERSERAQUERY = null;
    static REVERSERAFILENAME = null;
	
	static def config;

	static {
		config = new ConfigSlurper().parse(new File('config_reverse.properties').toURL());
		HOSTNAME = config.db.hostname;
		PORT = config.db.port; 
		DATABASE = config.db.database;
		USER = config.db.user;
		PASSWORD = config.db.password;
		DRIVERCLASS = config.db.driverclass;

		REVERSESCHEMA = config.reverse.schema;
		REVERSEQUERYLISTDEP = config.reverse.listdep.replace('{DBSCHEMA}', REVERSESCHEMA);
		REVERSEPAQUERY = config.reverse.pa.query.replace('{DBSCHEMA}', REVERSESCHEMA);
		REVERSEPAFILENAME = config.reverse.pa.filename;
		REVERSERAQUERY = config.reverse.ra.query.replace('{DBSCHEMA}', REVERSESCHEMA);
		REVERSERAFILENAME = config.reverse.ra.filename;
	} 	
	
	
	static getCnx() {
		return Sql.newInstance( "jdbc:postgresql://$HOSTNAME:$PORT/$DATABASE", USER, PASSWORD, DRIVERCLASS );
	}
		
}
