#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will rollback a Rok4 or UGC generation by deleting the datas in the storage and the temporary directory
# ARGS :
#   The generation ID
# RETURNS :
#   * 0 if rollback is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to many broadcast datas
#   * 3 if the deleting operation failed
#   * 4 if an error occured during rollbacking metadatas
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 3 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/rollback_rok4_ugc_generation.pl $
#   $Date: 24/10/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Deliveryconf;
use WebserviceTools;
use Database;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use JSON;

require "delete_data.pl";
require "rollback_harvest_generation.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "rollback_rok4_ugc_generation.pl",
    $config->param("logger.levels") );

my $root_storage    = $config->param("filer.root.storage");
my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $url_proxy       = $config->param("proxy.url");
my $tmp_path        = $config->param("resources.tmp.path");
my $retry_attempts  = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.entrepot.retry.waitingtime");
my $tmp_generation = $config->param("resources.tmp.generations");

sub rollback_rok4_ugc_generation {
    my ($generation_id) = @_;
    if ( !defined $generation_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );

    # Appel au web service pour récupérer la génération à rollbacker
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

    # Lecture des données en sortie
    my $broadcast_datas = $hash_response->{'broadcastDatas'};
    if ( defined @{$broadcast_datas} ) {
        if ( scalar( @{$broadcast_datas} ) != 1 ) {
            $logger->log( "ERROR",
                    "La génération demandée est lié à "
                  . scalar( @{$broadcast_datas} )
                  . " données en sortie alors que ce type de traitement n'en attend que 1"
            );
            return 2;
        }
    }
    else {
        $logger->log( "ERROR",
"La génération demandée n'est lié à aucune donnée en sortie alors que ce type de traitement en attend 1"
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

    my $storage = $broadcast_datas->[0]->{'storage'};
    if ( !$storage ) {
        $logger->log( "ERROR",
"La données en sortie du processus n'est pas associé à un stockage "
        );
        return 253;
    }

    my $storage_path = $storage->{'logicalName'};
    if ( !$storage_path ) {
        $logger->log( "ERROR",
"Le stockage associé à la donnée de diffusion ne contient pas de chemin "
        );
        return 253;
    }
    $logger->log( "DEBUG",
        "Chemin de stockage de la donnée de sortie : " . $storage_path );

    # Rollback du harvest des métadonnées
    $logger->log( "INFO", "Moissonage des métadonnées" );
    my $return_rollback_harvest_generation =
      rollback_harvest_generation($bd_id);
    if ( $return_rollback_harvest_generation != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors du rollback du moissonnage des métadonnées." );
        $logger->log( "DEBUG",
            "Code retour : " . $return_rollback_harvest_generation );

        return 4;
    }

    # Mise en forme des informations
    my $destination_dir = $root_storage . '/' . $storage_path . '/' . $bd_id;
    $logger->log( "INFO",
        "Répertoire de la donnée de diffusion : " . $destination_dir );

    # Suppression du répertoire
    $logger->log( "DEBUG",
        "Appel à  : delete_data(" . $destination_dir . ")" );
    my $return_delete_data = delete_data($destination_dir);
    $logger->log( "DEBUG", " --> Valeur de retour : " . $return_delete_data );

    if ( $return_delete_data != 0 && $return_delete_data != 1 ) {
        $logger->log( "ERROR",
"Une erreur est survenue lors du rollback de la génération Rok4 ou UGC"
        );

        return 3;
    }

    my $tmp_generation_dir =
      $tmp_path . $tmp_generation . '/' . $generation_id . '/';
    $logger->log( "INFO", "Répertoire temporaire : " . $tmp_generation_dir );

    # Suppression du répertoire
    $logger->log( "DEBUG",
        "Appel à  : delete_data(" . $tmp_generation_dir . ")" );
    $return_delete_data = delete_data($tmp_generation_dir);
    $logger->log( "DEBUG", " --> Valeur de retour : " . $return_delete_data );

    if ( $return_delete_data != 0 && $return_delete_data != 1 ) {
        $logger->log( "ERROR",
"Une erreur est survenue lors du rollback de la génération Rok4 ou UGC"
        );

        return 3;
    }

    return 0;
}

