#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will rollback the "pregenerated_datat_generation" script by deleting all copied files
# ARGS :
#   The generation ID
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to many broadcast datas
#   * 3 if the rollback copy script returns an error
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/rollback_pregenerated_data_generation.pl $
#   $Date: 17/08/11 $
#   $Author: Stefan Tudose (a508763) <stefan.tudose@atos.net> $
#########################################################################################################################

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

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "rollback_pregenerated_data_generation.pl",
    $config->param("logger.levels") );

my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $retry_attempts  = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.entrepot.retry.waitingtime");
my $url_proxy = $config->param("proxy.url");

sub rollback_pregenerated_data_generation {
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

    my $destination_dir = $storage_path . '/' . $bd_id;
    $logger->log( "INFO", "Répertoire de destination : " . $destination_dir );

    $logger->log( "INFO",
"Lancement du processus de rollback de génération de données prégénérés "
    );

    #delete the destination directory content
    my $return_rollback_copy_data = delete_data($destination_dir);
    $logger->log( "DEBUG",
        " --> Valeur de retour : " . $return_rollback_copy_data );

    if ( $return_rollback_copy_data != 0 && $return_rollback_copy_data != 1) {
        $logger->log( "ERROR",
            "Une erreur est survenue lors du rollback de la copie des données"
        );
        return 3;
    }

    return 0;
}

