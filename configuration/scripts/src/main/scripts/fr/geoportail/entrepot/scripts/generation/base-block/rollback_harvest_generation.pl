#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#
# ARGS :
#   The source directory of the metadatas
#   The destination directory of the metadatas
#   The type of the metadatas (ISO or INSPIRE)
# RETURNS :
#   * 0 if the process is correct
#   * 1 if there are errors during the rollback operation for ISO AP metadatas
#   * 2 if there are errors during the rollback operation for INSPIRE metadatas
#   * 3 if there are errors during the rollback update operation for a broadcast data
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/rollback_harvest_generation.pl $
#   $Date: 17/10/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use HTTP::Request::Common;
use LWP::UserAgent;
use File::Basename;

require "rollback_harvest_metadatas.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels   = $config->param("logger.levels");
my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $url_proxy       = $config->param("proxy.url");

my $logger = Logger->new( "rollback_harvest_generation.pl", $logger_levels );

sub rollback_harvest_generation {

    my $bd_id = shift;

    # Test paramters
    if ( !defined $bd_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseigné n'est pas celui attendu (1)" );
        return 255;
    }

    # Configuration de l'agent pour effectuer des requêtes
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
    }

    my $catalog_repository = $config->param("filer.catalog.repository");
    my $provider_isoap     = $config->param("harvesting.provider.isoap");
    my $provider_inspire   = $config->param("harvesting.provider.inspire");
    my $mtd_dir_pva_dest   = $catalog_repository . "/PVA/" . $bd_id;
    my $mtd_dir_isoap_dest =
      $catalog_repository . "/" . $provider_isoap . "/" . $bd_id;
    my $mtd_dir_inspire_dest =
      $catalog_repository . "/" . $provider_inspire . "/" . $bd_id;

    $logger->log( "DEBUG",
        "Rollback des métadonnées présentes dans le répertoire  "
          . $mtd_dir_pva_dest );
    if ( -e $mtd_dir_pva_dest ) {
        $logger->log( "INFO",
            "Lancement du processus de rollback des métadonnées PVA" );
        $logger->log( "DEBUG",
            "call -> rollback_harvest_metadatas( $mtd_dir_pva_dest, 0 )" );
        my $return_rollback_harvest_metadatas =
          rollback_harvest_metadatas( $mtd_dir_pva_dest, 0 );
        $logger->log( "DEBUG",
            " --> Valeur de retour : " . $return_rollback_harvest_metadatas );

        if ( $return_rollback_harvest_metadatas != 0 ) {
            $logger->log( "ERROR",
                "Une erreur est survenue lors du rollback des métadonnées PVA"
            );
            return 1;
        }
    }

    $logger->log( "DEBUG", "mtd_dir_isoap_dest " . $mtd_dir_isoap_dest );
    if ( -e $mtd_dir_isoap_dest ) {
        $logger->log( "INFO",
            "Lancement du processus de rollback des métadonnées ISOAP" );
        $logger->log( "DEBUG",
            "call -> rollback_harvest_metadatas( $mtd_dir_isoap_dest, 0 )" );
        my $return_rollback_harvest_metadatas =
          rollback_harvest_metadatas( $mtd_dir_isoap_dest, 0 );
        $logger->log( "DEBUG",
            " --> Valeur de retour : " . $return_rollback_harvest_metadatas );

        if ( $return_rollback_harvest_metadatas != 0 ) {
            $logger->log( "ERROR",
"Une erreur est survenue lors du rollback des métadonnées ISOAP"
            );
            return 1;
        }
    }

    $logger->log( "DEBUG", "mtd_dir_inspire_dest " . $mtd_dir_inspire_dest );
    if ( -e $mtd_dir_inspire_dest ) {
        $logger->log( "INFO",
            "Lancement du processus de rollback des métadonnées INSPIRE" );
        $logger->log( "DEBUG",
            "call -> rollback_harvest_metadatas( $mtd_dir_inspire_dest, 1 )" );
        my $return_rollback_harvest_metadatas =
          rollback_harvest_metadatas( $mtd_dir_inspire_dest, 1 );
        $logger->log( "DEBUG",
            " --> Valeur de retour : " . $return_rollback_harvest_metadatas );

        if ( $return_rollback_harvest_metadatas != 0 ) {
            $logger->log( "ERROR",
"Une erreur est survenue lors du rollback des métadonnées INSPIRE"
            );
            return 2;
        }
    }

    # Mise à jour de la donnée de diffusion avec les métadonnées associées
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/rollbackMetadatas" );
    my $response =
      $ua->request( POST $url_ws_entrepot. "/generation/rollbackMetadatas",
        [ broadcastDataId => $bd_id ] );

    if ( $response->is_success ) {
        $logger->log( "INFO",
            "Rollback de la donnée de diffusion " . $bd_id . " effectuée" );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors du rollback de la donnée de diffusion "
              . $bd_id );
        return 3;
    }

    return 0;
}
