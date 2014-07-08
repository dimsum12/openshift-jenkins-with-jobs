#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script drop a specific schema name
# ARGS :
#   The schema name to drop
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the schema name is incorrect
#   * 2 if the schema name does not exist in the DB
#   * 240 if the schema dropping has failed
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/rollback_generate_bdd_datas.pl $
#   $Date: 17/08/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "rollback_generate_bdd_datas.pl", $logger_levels );

my $dbname   = $config->param("db-ent_donnees.dbname");
my $host     = $config->param("db-ent_donnees.host");
my $port     = $config->param("db-ent_donnees.port");
my $username = $config->param("db-ent_donnees.username");
my $password = $config->param("db-ent_donnees.password");

my $schema_name_pattern = "^(?!pg_)[A-Za-z][A-Za-z0-9_]*\$";

sub rollback_generate_bdd_datas {

    # Parameters number validation
    my ($schema_name) = @_;
    if ( !defined $schema_name ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : schema_name = " . $schema_name );

    # Schema name verification by using pattern
    if ( $schema_name !~ /$schema_name_pattern/ ) {
        $logger->log( "ERROR",
                "Le nom du schéma spécifié ("
              . $schema_name
              . ") est incorrect" );
        return 1;
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

    # Is the schema exist in the database ?
    my $sql = "SELECT count(*) FROM pg_namespace WHERE nspname = lower('"
      . $schema_name . "')";
    ( my $schema_exist ) = $database->select_one_row($sql);
    $logger->log( "DEBUG",
        "La requête \"" . $sql . "\" a retourné " . $schema_exist );

    if ( $schema_exist == 0 ) {
        $logger->log( "ERROR", "Le schéma à supprimer n'existe pas" );
        $database->rollback_transaction();
        $database->disconnect();
        return 2;
    }

    # Delete schéma
    if ( $database->drop_schema( $schema_name, "true" ) ) {
        $logger->log( "ERROR",
            "Erreur lors de la suppression du schema " . $schema_name );
        $database->rollback_transaction();
        $database->disconnect();
        return 240;
    }

    # Close database
    $database->stop_transaction();
    $database->disconnect();

    return 0;
}

