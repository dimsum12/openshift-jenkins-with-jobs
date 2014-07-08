
#########################################################################################################################
#
# USAGE :
#   This script take a directory of sql files and shapefiles, create a schema in the DB and integrate all
#       the datas in this schema
# ARGS :
#   The source directory for SQL and SHP
#   The schema name to create for the datas
#   The SRS of the shapefiles (optionnal, if shapefiles are present in the directory)
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the directory does not exist
#   * 2 if the directory does not contain any SQL or SHP
#   * 3 if the schema name is incorrect
#   * 4 if the directory contain shapefiles and the SRS is unrecognized
#   * 5 if the conversion from shapefile to SQL has failed
#   * 6 if an error occured during integrating the datas in the schema
#   * 7 if the schema name already exist in the DB
#   * 240 if the schema creation has failed
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/generate_bdd_datas.pl $
#   $Date: 17/08/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Execute;
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
my $logger = Logger->new( "generate_bdd_datas.pl", $logger_levels );

my $dbname        = $config->param("db-ent_donnees.dbname");
my $host          = $config->param("db-ent_donnees.host");
my $port          = $config->param("db-ent_donnees.port");
my $username      = $config->param("db-ent_donnees.username");
my $password      = $config->param("db-ent_donnees.password");
my $gdaltransform = $config->param("resources.gdaltransform");

my $sql_pattern      = "-name \"*.sql\"";
my $shp_pattern      = "-name \"*.shp\"";
my $create_pattern   = "-name \"CREATE*\"";
my $populate_pattern = "-name \"POPULATE*\"";
my $other_pattern =
  " -not " . $create_pattern . " -a -not " . $populate_pattern;
my $sql_pattern_regex    = "^.*[/][^/]+[.]sql\$";
my $shp_pattern_regex    = "^.*[/][^/]+[.]shp\$";
my $shp_table_name_regex = "^.*[/]([^/]+)[.]shp\$";
my $schema_name_pattern  = "^(?!pg_)[A-Za-z][A-Za-z0-9_]*\$";
my $gdaltransform_validator_pre =
  "echo '0 0 0' | " . $gdaltransform . " -s_srs '+init=";
my $gdaltransform_validator_post = " +wktext' 1> /dev/null 2>&1";
my $bash_count_lines             = "| wc -l";
my $random_range                 = 99999;
my $shape_to_pgsql_cmd = $config->param("resources.shp2pgsql") . " -I -s ";
my $tmp_dir            = $config->param("resources.tmp.path");

sub generate_bdd_datas {

    # Parameters number validation
    my ( $source_dir, $schema_name, $shp_srs ) = @_;
    if ( !defined $source_dir || !defined $schema_name ) {
        $logger->log( "ERROR",
"Le nombre de paramètres renseignés n'est pas celui attendu (2 ou 3)"
        );
        return 255;
    }
    if ( !defined $shp_srs ) {
        $shp_srs = "";
    }

    $logger->log( "DEBUG", "Paramètre 1 : source_dir = " . $source_dir );
    $logger->log( "DEBUG", "Paramètre 2 : schema_name = " . $schema_name );
    $logger->log( "DEBUG", "Paramètre 3 : shp_srs = " . $shp_srs );

    # Is the source directory exist ?
    if ( !-d $source_dir ) {
        $logger->log( "ERROR",
                "Le répertoire source des données "
              . $source_dir
              . " n'existe pas" );
        return 1;
    }

    my $contain_shp = "false";

    # Is the source directory contain any .sql or .shp ?
    if ( `find $source_dir $shp_pattern 2> /dev/null $bash_count_lines` == 0 ) {
        $logger->log( "DEBUG", "La livraison ne contient pas de fichier .shp" );

        if ( `find $source_dir $sql_pattern 2> /dev/null $bash_count_lines` ==
            0 )
        {
            $logger->log( "ERROR",
                    "Le répertoire source des données "
                  . $source_dir
                  . " ne contient ni SQL, ni Shapefile" );
            return 2;
        }
    }
    else {
        $logger->log( "DEBUG", "La livraison contient des fichiers .shp" );
        $contain_shp = "true";
    }

    # Schema name verification by using pattern
    if ( $schema_name !~ /$schema_name_pattern/ ) {
        $logger->log( "ERROR",
                "Le nom du schéma spécifié ("
              . $schema_name
              . ") est incorrect" );
        return 3;
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

    # Projection verification using gdaltransform
    my $srid = -1;
    if ( "" ne $shp_srs ) {
        if ( ( lc $shp_srs ) =~ /epsg.*/ ) {
            $shp_srs = lc $shp_srs;
            my @splitted = split /:/, $shp_srs;
            $srid = $splitted[1];
        }
        else {
            my $sql_srid =
              "SELECT srid FROM spatial_ref_sys WHERE proj4text LIKE '%"
              . $shp_srs . "%'";
            ($srid) = $database->select_one_row($sql_srid);
            $logger->log( "DEBUG",
                "La requête \"" . $sql_srid . "\" a retourné " . $srid );

            if ( !defined $srid ) {
                $logger->log( "ERROR",
                    "Le srs " . $shp_srs . " ne correspond à aucun srid" );
                $database->disconnect();
                return 4;
            }
        }

        my $cmd_validation =
            $gdaltransform_validator_pre 
          . $shp_srs
          . $gdaltransform_validator_post;
        $logger->log( "DEBUG", "Execution de : " . $cmd_validation );
        my $validation_return = Execute->run($cmd_validation);
        if ( $contain_shp eq "true" && $validation_return->get_return() != 0 ) {
            $logger->log( "ERROR",
"Le répertoire source des données contient des Shapefiles, et la projection \""
                  . $shp_srs
                  . "\" n'est pas reconnue par gdaltransform" );
            return 4;
        }
    }
    elsif ( "true" eq $contain_shp ) {
        $logger->log( "ERROR",
"Des shapefiles ont été trouvés, mais aucun srs n'a été spécifié"
        );
        return 4;
    }

    # Create schema
    $database->start_transaction();

    my $sql = "SELECT count(*) FROM pg_namespace WHERE nspname = lower('"
      . $schema_name . "')";
    ( my $schema_exist ) = $database->select_one_row($sql);
    $logger->log( "DEBUG",
        "La requête \"" . $sql . "\" a retourné " . $schema_exist );

    if ( $schema_exist != 0 ) {
        $logger->log( "ERROR",
            "Le schéma à créer existe déjà : $schema_name" );
        $database->stop_transaction();
        $database->disconnect();
        return 7;
    }
    else {
        if ( $database->create_schema($schema_name) ) {
            $logger->log( "ERROR",
                "Erreur lors de la création du schema " . $schema_name );
            $database->stop_transaction();
            $database->disconnect();
            return 240;
        }
    }

    $database->stop_transaction();

# Work on every file in the source directory, ordered by priority (create, populate and then others)
    my @create_file_list   = `find $source_dir $create_pattern | sort`;
    my @populate_file_list = `find $source_dir $populate_pattern | sort`;
    my @other_file_list    = `find $source_dir $other_pattern | sort`;
    my @ordered_list =
      ( @create_file_list, @populate_file_list, @other_file_list );

    $logger->log( "DEBUG", "Ordered files list : " . @ordered_list );
    foreach my $file_in_dir (@ordered_list) {
        chomp $file_in_dir;
        $logger->log( "INFO", "Traitement du fichier " . $file_in_dir );

        # Is the file a SQL ?
        $logger->log( "DEBUG",
            "Comparing " . $file_in_dir . " with regex " . $sql_pattern_regex );
        if ( $file_in_dir =~ m/$sql_pattern_regex/ ) {
            $logger->log( "DEBUG", "File " . $file_in_dir . " is a SQL" );

            # Playing SQL source file
            my $return_value_sql =
              $database->run_sql_dump( $schema_name, $file_in_dir );

            if ( $return_value_sql != 0 ) {
                $logger->log( "ERROR",
                        "Erreur lors de l'intégration en base du fichier "
                      . $file_in_dir
                      . " avec le nom de schéma "
                      . $schema_name );
                $logger->log( "DEBUG", "Code retour = " . $return_value_sql );

                $database->disconnect();
                return 6;
            }
        }
        else {

            # Is the file a SHP ?
            $logger->log( "DEBUG",
                    "Comparing "
                  . $file_in_dir
                  . " with regex "
                  . $shp_pattern_regex );
            if ( $file_in_dir =~ m/$shp_pattern_regex/ ) {
                $logger->log( "DEBUG",
                    "File " . $file_in_dir . " is a Shapefile" );

                # Finding a non-existant temporary filename
                my $sql_tmp = "";
                while ( $sql_tmp eq "" || -e $sql_tmp ) {
                    $sql_tmp = $tmp_dir . "/tmp" . int rand $random_range;
                    $logger->log( "DEBUG",
                        "Trying using temporary file " . $sql_tmp );
                }
                `touch $sql_tmp`;
                $logger->log( "DEBUG",
                    "Temporary SQL file is set to " . $sql_tmp );

                # Extracting SQL tablename
                my $table_name = $file_in_dir;
                $table_name =~ s/$shp_table_name_regex/$1/;

                # Conversion SHP --> SQL
                $logger->log( "INFO", "Converting Shapefile to SQL" );
                my $convert_command =
                    $shape_to_pgsql_cmd 
                  . $srid . " "
                  . $file_in_dir . " "
                  . $table_name . " 1> "
                  . $sql_tmp
                  . " 2> /dev/null";
                $logger->log( "DEBUG",
                    "Execution de la commande de conversion : "
                      . $convert_command );
                my $return_value_convert = system $convert_command;

                if ( $return_value_convert != 0 ) {
                    $logger->log( "ERROR",
                            "Erreur lors de la conversion du shapefile "
                          . $file_in_dir
                          . " avec le SRS "
                          . $srid
                          . " et le nom de table calculé "
                          . $table_name );
                    $logger->log( "DEBUG",
                        "Code retour = " . $return_value_convert );
                    `rm $sql_tmp`;

                    $database->disconnect();
                    return 5;
                }

                # Playing SQL source file
                my $return_value_sql =
                  $database->run_sql_dump( $schema_name, $sql_tmp );
                `rm $sql_tmp`;

                if ( $return_value_sql != 0 ) {
                    $logger->log( "ERROR",
"Erreur lors de l'intégration en base du fichier temporaire "
                          . $sql_tmp
                          . " avec le nom de schéma "
                          . $schema_name );
                    $logger->log( "DEBUG",
                        "Code retour = " . $return_value_sql );

                    $database->disconnect();
                    return 6;
                }
            }

            # The file is not a SQL or a Shapefile
            else {
                $logger->log( "DEBUG", "File " . $file_in_dir . " is skipped" );
            }
        }
    }

    # Grant only 'Select' permission on all tables from the new schema
    $database->set_permissions_on_tables_from_schema( $schema_name, $username,
        'SELECT' );

    # Revoke the 'Create' permission on the new schema
    $database->revoke_schema_permissions( $schema_name, $username, 'CREATE' );

    $database->disconnect();

    return 0;
}

