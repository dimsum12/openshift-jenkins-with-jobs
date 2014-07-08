#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will rollback a Database generation by dropping the schema created and updating consequently
#       the braodcast data concerned
# ARGS :
#   The generation ID
# RETURNS :
#   * 0 if rollback is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the genereaiton is linked to many broadcast datas
#   * 3 if the schema cannot be dropped
#   * 4 if the REST service for updating the braodcast data send an error
#   * 5 if an error occured while rollbacking metadatas
#   * 6 if an error occured during deleting static directory
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/rollback_bdd_generation.pl $
#   $Date: 16/08/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use WebserviceTools;
use Logger;
use Deliveryconf;
use Database;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use JSON;

require "rollback_generate_bdd_datas.pl";
require "rollback_harvest_generation.pl";
require "delete_data.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "rollback_bdd_generation.pl", $config->param("logger.levels") );

my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $retry_attempts  = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.entrepot.retry.waitingtime");
my $url_proxy = $config->param("proxy.url");
my $static_data_dir		 = $config->param("filer.static.storage");

sub rollback_bdd_generation {
    my ($generation_id) = @_;
    if ( !defined $generation_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );

    my $ws = WebserviceTools->new(
        'GET',
        $url_ws_entrepot
          . "/generation/getGeneration?generationId="
          . $generation_id,
        $url_proxy
    );

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/getGeneration?generationId="
          . $generation_id );

    my $result = $ws->run( $retry_attempts, $retry_waitingtime );

    if ( !$result ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la récupération de la génération d'identifiant :"
              . $generation_id );
        $logger->log( "ERROR", "l'erreur est : " . $ws->get_content() );
        return 1;
    }

    my $hash_response = $ws->get_json();
    if ( !$hash_response ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la conversion de la réponse JSON"
        );
        return 254;
    }

    $logger->log( "DEBUG",
"Récupération des informations depuis la données de diffusion liée à la génération"
    );

    my $broadcast_datas = $hash_response->{'broadcastDatas'};
    if ( scalar( @{$broadcast_datas} ) != 1 ) {
        $logger->log( "ERROR",
                "La génération demandée est lié à "
              . scalar( @{$broadcast_datas} )
              . " données en sortie alors que ce type de traitement n'en attend que 1"
        );
        return 2;
    }
    $logger->log( "DEBUG",
        scalar( @{$broadcast_datas} )
          . " donnée(s) de diffusion en sortie de la génération" );

    my $bd_id = $broadcast_datas->[0]->{'id'};
    if ( !$bd_id ) {
        $logger->log( "ERROR",
            "La données en sortie du processus ne possède pas d'identifiant"
        );
        return 253;
    }
    $logger->log( "DEBUG", "Identifiant de la donnée de sortie : " . $bd_id );

    my $schema_name = $broadcast_datas->[0]->{'schemaName'};
    if ( !defined $schema_name ) {
        $logger->log( "ERROR",
"La données en sortie du processus ne possède pas de nom de schema"
        );
        return 253;
    }
    if ( !$schema_name ) {
        $logger->log( "INFO",
"La données en sortie du processus n'a pas été générée. Fin du rollback"
        );
        return 0;
    }
    $logger->log( "DEBUG",
        "Nom de schema de la donnée de sortie : " . $schema_name );

    # Suppression du schema
	$logger->log( "INFO",
"Lancement du processus de rollback de génération de données de diffusion BDD"
    );
    my $return_rollback_bdd_datas = rollback_generate_bdd_datas($schema_name);
    $logger->log( "DEBUG",
        " --> Valeur de retour : " . $return_rollback_bdd_datas );

    if ( $return_rollback_bdd_datas != 0 ) {
        $logger->log( "ERROR",
"Une erreur est survenue lors du rollback de la génération de données de diffusion BDD"
        );
        return 3;
    }

	my $static_dir =
      $static_data_dir . "/" . $bd_id;
    $logger->log( "INFO", "Répertoire statique : " . $static_dir );

    # Suppression du répertoire
    $logger->log( "DEBUG",
        "Appel à  : delete_data(" . $static_dir . ")" );
    my $return_delete_data = delete_data($static_dir);
    $logger->log( "DEBUG", " --> Valeur de retour : " . $return_delete_data );

    if ( $return_delete_data != 0 && $return_delete_data != 1 ) {
        $logger->log( "ERROR",
"Une erreur est survenue lors du rollback de la génération Rok4 ou UGC"
        );

        return 6;
    }
	
    # Rollback du harvest des métadonnées
    $logger->log( "INFO", "Moissonage des métadonnées" );
    my $return_rollback_harvest_generation =
      rollback_harvest_generation($bd_id);
    if ( $return_rollback_harvest_generation != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors du rollback du moissonnage des métadonnées." );
        $logger->log( "DEBUG",
            "Code retour : " . $return_rollback_harvest_generation );

        return 5;
    }

    return 0;
}

