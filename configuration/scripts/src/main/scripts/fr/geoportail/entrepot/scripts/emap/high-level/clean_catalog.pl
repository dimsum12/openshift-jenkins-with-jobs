#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#
# ARGS :
#
# RETURNS :
#   *
# KEYWORDS :
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/emap/clean_db.pl $
#   $Date: 23/08/2011 $
#   $Author: Damien DUPORTAL (a503140) <damien.duportal@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "clean_catalog.pl", $logger_levels );
our $VERSION = "2.0";
## End loading

## Custom Loading
require "get_backup_name.pl";
## End custom loading

sub clean_catalog {
    ## Gathering provided params
    my @provided_arguments      = @_;
    my $expected_number_of_args = 0;
    if ( scalar @provided_arguments != $expected_number_of_args ) {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 1;
    }

    ## Initializing env params
    my $host        = $config->param("db-emap_catalog.host");
    my $port        = $config->param("db-emap_catalog.port");
    my $username    = $config->param("db-emap_catalog.username");
    my $password    = $config->param("db-emap_catalog.password");
    my $dbname      = $config->param("db-emap_catalog.dbname");
    my $backup_path = $config->param("emap.backuppath");
    my $catalog_sql_scripts_pattern =
      $config->param("emap.catalog_scripts_path") . "/*.sql";
    my $database =
      Database->connect( $dbname, $host, $port, $username, $password );

    ## Do PG DUMP to backup DB
    my $pg_dumpfile =
      $backup_path . "/" . get_backup_name("catalog") . ".backup";
    $logger->log( "DEBUG", "Le fichier de dump sera : " . $pg_dumpfile );

    my $result_dump = $database->exec_pg_dump($pg_dumpfile);
    $database->disconnect();

    if ( $result_dump != 0 ) {
        $logger->log( "ERROR",
"La sauvegarde n'a pu être effectuée, arrêt du processus de nettoyage."
        );
        return 2;

    }
    $logger->log( "DEBUG",
        "La sauvegarde a bien été effectuée dans le fichier de dump "
          . $pg_dumpfile );

    ## Getting all tables of schema "public" except the two "postgis" tables (geometry_columns and spatial_ref_sys)
    $database =
      Database->connect( $dbname, $host, $port, $username, $password );
    $database->start_transaction();
    foreach my $sql_dump_file (`ls $catalog_sql_scripts_pattern`) {
        chomp $sql_dump_file;
        $logger->log( "DEBUG",
            "Exécution du script : " . $sql_dump_file . "." );
        my $return = $database->run_sql_dump( 'public', $sql_dump_file );
        if ( $return != 0 ) {
            $logger->log( "ERROR",
"La restauration de la base de données du catalogue n'a pu être effectuée, arrêt du processus de nettoyage."
            );
            $database->rollback_transaction();
            $database->disconnect();

            return 3;
        }
    }
    $database->stop_transaction();

    ## Ending all.
    $database->disconnect();

    $logger->log( "INFO",
        "Le catalogue de métadonnée de l\'EMAP a bien été réinitialisé."
    );

    return 0;
}
