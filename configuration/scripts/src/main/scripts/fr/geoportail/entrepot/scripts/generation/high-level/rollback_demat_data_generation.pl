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
#   * 2 if the generation is linked to many deliveries
#   * 3 if the REST service for updating the broadcast data send an error
#   * 4 if an error occured while rollbacking metadatas
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/demat_data_generation.pl $
#   $Date: 20/10/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Deliveryconf;
use WebserviceTools;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use JSON;
use Execute;

require "rollback_harvest_generation.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

our $deliveryconf;

my $logger = Logger->new( "rollback_demat_data_generation.pl",
    $config->param("logger.levels") );

my $deliveries_path      = $config->param("filer.delivery-ftp");
my $auto_detect_filename = $config->param("auto-detect.filename");
my $url_ws_entrepot      = $config->param("resources.ws.url.entrepot");
my $url_proxy            = $config->param("proxy.url");
my $retry_attempts = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.entrepot.retry.waitingtime");
my $rmv_write_permission = $config->param("resources.rmv.write.permission");

sub rollback_demat_data_generation {
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
            "La donnée en sortie du processus ne possède pas d'identifiant" );
        return 253;
    }
    $logger->log( "DEBUG", "Identifiant de la donnée de sortie : " . $bd_id );

    # Rollback de la données de diffusion
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
    }
    my $response =
      $ua->request( POST $url_ws_entrepot. "/generation/updateDematBD",
        [ broadcastDataId => $bd_id ] );

    if ( $response->is_success ) {
        $logger->log( "INFO",
                "Mise à jour de la donnée de diffusion " 
              . $bd_id
              . " effectuée" );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la donnée de diffusion "
              . $bd_id );
        return 3;
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

        return 4;
    }
}
