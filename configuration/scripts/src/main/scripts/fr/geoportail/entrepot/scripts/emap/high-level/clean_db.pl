#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   clean_db() will backup current EMAP's PGSQL database and clean it. By cleaning, we mean removing all schemas
#   which are "user-defined" (not pg-system's schemas as "pg_*", nor "public" nor "information_schema") and their
#   contents. It'll also clean contents of PostGIS catalog into "public" schema. All errors will be printed into
#   standard output.
# ARGS :
#   none
# RETURNS :
#   * 0 if all processes are well done.
#   * 1 if backup could not be done, no more actions will be done.
#   * 2 if we can't find any "user-defined" schemas. Backup will be done, but no more actions because nothing to do more.
#   * 3 if one (or more) schemas couldn't be deleted.
#   * 4 if arguments are provided.
#   * 255 if another error occured.
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
my $logger = Logger->new( "clean_db.pl", $logger_levels );
our $VERSION = "2.0";
## End loading

## Custom loading
require "get_backup_name.pl";
## End custom loadingg

## Main function
sub clean_db {
    ## Gathering provided params
    my @provided_arguments      = @_;
    my $expected_number_of_args = 0;
    if ( scalar @provided_arguments != $expected_number_of_args ) {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 4;
    }

    ## Gathering params from config and DAOs
    my $dbname      = $config->param("db-emap.dbname");
    my $host        = $config->param("db-emap.host");
    my $port        = $config->param("db-emap.port");
    my $username    = $config->param("db-emap.username");
    my $password    = $config->param("db-emap.password");
    my $backup_path = $config->param("emap.backuppath");

    ## Do PG DUMP to backup DB
    my $pg_dumpfile = $backup_path . "/" . get_backup_name("bdd") . ".backup";
    $logger->log( "DEBUG", "Le fichier de dump sera : " . $pg_dumpfile );

    my $database =
      Database->connect( $dbname, $host, $port, $username, $password );
    my $result_dump = $database->exec_pg_dump($pg_dumpfile);

    if ( $result_dump != 0 ) {
        $logger->log( "ERROR",
"La sauvegarde n'a pu être effectuée, arrêt du processus de nettoyage."
        );
        $database->disconnect();
        return 1;
    }
    $logger->log( "DEBUG",
        "La sauvegarde a bien été effectuée dans le fichier de dump "
          . $pg_dumpfile );

    ## Getting list of non system schemas of database.
    my $liste_schemas     = $database->get_user_defined_schemas();
    my $nbr_found_schemas = scalar @{$liste_schemas};

    if ( $nbr_found_schemas == 0 ) {
        $logger->log( "INFO",
"Aucun schéma n'a été trouvé sur la base. Le backup a été fait, arrêt du nettoyage."
        );
        $database->disconnect();
        return 2;
    }
    $logger->log( "DEBUG",
        "J'ai trouvé " . $nbr_found_schemas . " schémas à supprimer." );

    ## Deleting found schemas.
    $database->start_transaction();
    foreach my $schema ( @{$liste_schemas} ) {
        my ($schema_name) = @{$schema};

        my $return = $database->drop_schema( $schema_name, "true" );
        if ( $return != 0 ) {
            $database->rollback_transaction();
            $logger->log( "ERROR",
                    "Impossible de supprimer le schéma "
                  . $schema_name
                  . ". Un rollback va être effectué." );
            $database->disconnect();
            return 3;
        }
        $logger->log( "DEBUG",
            "Suppression du schema " . $schema_name . "réussie." );
    }

    ## Ending all.
    $database->stop_transaction();
    $database->disconnect();
    $logger->log( "DEBUG", "Nettoyage terminé." );

    $logger->log( "INFO",
"Le base de donnée de l\' EMAP a bien été sauvegardée et réinitalisé."
    );

    return 0;
}

## End Main Function
