#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will create and populate a bdd schema using an already created schema and some scripts
#       First it tests the given parameters
#       Then it creates the new schema
#       Finally it runs all scripts
# ARGS :
#   The directory containing the scripts to be executed
#   The source schema name
#   The target schema name
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the specified directory doesn't exist
#   * 2 if the specified directory doesn't contain any sql or plpgsql files
#   * 3 if the source schema name is incorrect
#   * 4 if the source schema doesn't exist
#   * 5 if the target schema name is incorrect
#   * 6 if the target schema already exist
#   * 7 if the psql command returns an error
#   * 254 if the schema couldn't be created
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/generate_bdd_from_existing_bdd.pl $
#   $Date: 19/08/11 $
#   $Author: Stefan Tudose (a508763) <stefan.tudose@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;
use DBI;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "generate_bdd_from_existing_bdd.pl", $logger_levels );

my $dbname        = $config->param("db-ent_donnees.dbname");
my $host          = $config->param("db-ent_donnees.host");
my $port          = $config->param("db-ent_donnees.port");
my $username      = $config->param("db-ent_donnees.username");
my $password      = $config->param("db-ent_donnees.password");
my $gdaltransform = $config->param("resources.gdaltransform");

my $sql_pattern      = "*.sql";
my $plpgsql_pattern  = "*.plpgsql";
my $create_pattern   = "-name \"CREATE*\"";
my $populate_pattern = "-name \"POPULATE*\"";
my $other_pattern =
  " -not " . $create_pattern . " -a -not " . $populate_pattern;
my $sql_pattern_regex     = "^.*[/][^/]+[.]sql\$";
my $plpgsql_pattern_regex = "^.*[/][^/]+[.]plpgsql\$";
my $schema_name_pattern   = "^(?!pg_)[A-Za-z][A-Za-z0-9_]*\$";
my $bash_count_lines      = "| wc -l";
my $random_range          = '99999';
my $shape_to_pgsql_cmd    = $config->param("resources.shp2pgsql") . " -I -s ";
my $tmp_dir               = $config->param("resources.tmp.path");

sub generate_bdd_from_existing_bdd {

    # Parameters number validation
    my ( $script_directory, $source_schema_name, $target_schema_name ) = @_;
    if ( !defined $script_directory ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (3)"
        );
        return 255;
    }
    $logger->log( "DEBUG",
        "Paramètre 1 : script_directory = " . $script_directory );

    if ( !defined $source_schema_name ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (3)"
        );
        return 255;
    }
    $logger->log( "DEBUG",
        "Paramètre 2 : source_schema_name = " . $source_schema_name );

    if ( !defined $target_schema_name ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (3)"
        );
        return 255;
    }
    $logger->log( "DEBUG",
        "Paramètre 3 : target_schema_name = " . $target_schema_name );

    # Does the source directory exist ?
    if ( !-d $script_directory ) {
        $logger->log( "ERROR",
                "Le répertoire source des données "
              . $script_directory
              . " n'existe pas" );
        return 1;
    }

    # Is the source directory contain any .sql or .shp ?
    if (
        `find $script_directory/$plpgsql_pattern 2> /dev/null $bash_count_lines`
        == 0 )
    {
        $logger->log( "DEBUG",
            "La livraison ne contient pas de fichier .plpgsql" );

        if (
            `find $script_directory/$sql_pattern 2> /dev/null $bash_count_lines`
            == 0 )
        {
            $logger->log( "ERROR",
                    "Le répertoire source des données "
                  . $script_directory
                  . " ne contient ni SQL, ni Plpgsql" );
            return 2;
        }
    }

    # Source schema name verification using pattern
    if ( $source_schema_name !~ /$schema_name_pattern/ ) {
        $logger->log( "ERROR",
                "Le nom du schéma source spécifié ("
              . $source_schema_name
              . ") est incorrect" );
        return 3;
    }

    # Target schema name verification using pattern
    if ( $target_schema_name !~ /$schema_name_pattern/ ) {
        $logger->log( "ERROR",
                "Le nom du schéma cible spécifié ("
              . $target_schema_name
              . ") est incorrect" );
        return 5;
    }

    # Prepare BDD
    $logger->log( "DEBUG",
            "Connection à la BDD : " 
          . $dbname . " sur " 
          . $host . ":" 
          . $port
          . " avec l'utilisateur "
          . $username );
    my $database =
      Database->connect( $dbname, $host, $port, $username, $password );

    $database->start_transaction();

    # Does the source schema exists?
    my $sql = "SELECT count(*) FROM pg_namespace WHERE nspname = lower('"
      . $source_schema_name . "')";
    ( my $source_schema_exist ) = $database->select_one_row($sql);
    $logger->log( "DEBUG",
        "La requête \"" . $sql . "\" a retourné " . $source_schema_exist );

    if ( $source_schema_exist == 0 ) {
        $logger->log( "ERROR", "Le schéma source n'existe pas" );
        $database->stop_transaction();
        $database->disconnect();
        return 4;
    }

    # Does the target schema already exists?
    $sql = "SELECT count(*) FROM pg_namespace WHERE nspname = lower('"
      . $target_schema_name . "')";
    ( my $target_schema_exist ) = $database->select_one_row($sql);
    $logger->log( "DEBUG",
        "La requête \"" . $sql . "\" a retourné " . $target_schema_exist );

    if ( $target_schema_exist != 0 ) {
        $logger->log( "ERROR", "Le schéma cible existe déjà" );
        $database->stop_transaction();
        $database->disconnect();
        return 6;
    }

    if ( $database->create_schema($target_schema_name) ) {
        $logger->log( "ERROR",
            "Erreur lors de la création du schema " . $target_schema_name );
        $database->stop_transaction();
        $database->disconnect();
        return 240;
    }

    $database->stop_transaction();

# Work on every file in the source directory, ordered by priority (create, populate and then others)
    my @create_file_list   = `find $script_directory $create_pattern | sort`;
    my @populate_file_list = `find $script_directory $populate_pattern | sort`;
    my @other_file_list    = `find $script_directory $other_pattern | sort`;
    my @ordered_list =
      ( @create_file_list, @populate_file_list, @other_file_list );

    $logger->log( "DEBUG", "Ordered files list : " . @ordered_list );

    # build the hash map of the paramaeters to be used by the script
    my %script_parameters;
    $script_parameters{'schema_initial'} = $source_schema_name;
    $script_parameters{'schema_final'}   = $target_schema_name;

    foreach my $file_in_dir (@ordered_list) {
        chomp $file_in_dir;

        # is the file a sql or plpgsql file?
        if (   $file_in_dir =~ m/$sql_pattern_regex/
            || $file_in_dir =~ m/$plpgsql_pattern_regex/ )
        {

            # create a temp file

            # Finding a non-existant temporary filename
            my $sql_tmp = "";
            while ( $sql_tmp eq "" || -e $sql_tmp ) {
                $sql_tmp = $tmp_dir . "/tmp" . int rand $random_range;
                $logger->log( "DEBUG",
                    "Trying using temporary file " . $sql_tmp );
            }
            `touch $sql_tmp`;
            $logger->log( "DEBUG", "Temporary SQL file is set to " . $sql_tmp );

            # Is the file a SQL ?
            if ( $file_in_dir =~ m/$sql_pattern_regex/ ) {

                $logger->log( "INFO", "Traitement du fichier " . $file_in_dir );

                # replace the schema parameter names in the scrip
`sed 's/:schema_initial/$source_schema_name/g' $file_in_dir | sed 's/:schema_final/$target_schema_name/g' >> $sql_tmp`;
            }
            else {

                # it is a plpgsql file
                $logger->log( "INFO", "Traitement du fichier " . $file_in_dir );

                # transform the file into a sql file
`echo 'CREATE FUNCTION $target_schema_name.tmp_function() RETURNS void AS \$\$' >> $sql_tmp`;
`sed 's/:schema_initial/$source_schema_name/g' $file_in_dir | sed 's/:schema_final/$target_schema_name/g' >> $sql_tmp`;
`echo '\$\$ LANGUAGE plpgsql;  SELECT $target_schema_name.tmp_function(); DROP FUNCTION  $target_schema_name.tmp_function();' >> $sql_tmp`;
            }

            # Play the SQL source file
            my $return_value_sql =
              $database->run_sql_dump( $target_schema_name, $sql_tmp );

            # Delete the tmp file
            `rm $sql_tmp`;

            if ( $return_value_sql != 0 ) {
                $logger->log( "ERROR",
                        "Erreur lors de l'intégration en base du fichier "
                      . $file_in_dir
                      . " avec le nom de schéma "
                      . $target_schema_name );
                $logger->log( "DEBUG", "Code retour = " . $return_value_sql );

                $database->disconnect();
                return 6;
            }
        }
    }

    # Grant only 'Select' permission on all tables from the new schema
    $database->set_permissions_on_tables_from_schema( $target_schema_name,
        $username, 'SELECT' );

    # Revoke the 'Create' permission on the new schema
    $database->revoke_schema_permissions( $target_schema_name, $username,
        'CREATE' );

    $database->disconnect();
    return 0;
}

