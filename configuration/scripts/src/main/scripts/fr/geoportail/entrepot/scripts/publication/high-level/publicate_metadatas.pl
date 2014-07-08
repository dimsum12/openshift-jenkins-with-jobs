#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script integrate metadatas in a catlog in a specified zone. There si a list of ID folders to crawl
#	and a list of metadatas to activate.
# ARGS :
#   id of the publication
# RETURNS :
#   * 0 if success
#	* 1 zone is incorrect
#	* 2 if crawl failed
#	* 3 if change status failed for isoap mtds
#	* 4 if change status failed for inspire mtds
#	* 5 if problem occured when gettint the mtds to publich from webservice
#	* 6 if impossible to copy metadatas to extern storage
#	* 7 if change status failed for pva mtds
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/publication/publicate_metadatas.pl $
#   $Date: 07/09/11 $
#   $Author: Nicolas Godelu (A184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use DBI;
use LWP::UserAgent;
use HTTP::Request::Common;
use WebserviceTools;

require "crawl_broadcastdata.pl";
require "change_status_metadatas.pl";
require "synchronize_metadatas_on_extern_zone.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $status    = $config->param("publication.status.activated");
my $internurl = $config->param("catalog.url.intern");
my $externurl = $config->param("catalog.url.extern");

my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $url_proxy       = $config->param("proxy.url");

my $retry_attempts = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.entrepot.retry.waitingtime");

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "publicate_metadatas.pl", $logger_levels );

sub publicate_metadatas {

    # Extraction des paramètres
    my ($publication_id) = @_;
    if ( !defined $publication_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG",
        "Paramètre 1 : publication_id = " . $publication_id );

    # Appel au web service pour récupérer la publication à effectuer
    my $ws = WebserviceTools->new(
        'GET',
        $url_ws_entrepot
          . "/bus/getMtdsToPublish?publicationId="
          . $publication_id,
        $url_proxy
    );

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/bus/getMtdsToPublish?publicationId="
          . $publication_id );

    my $result = $ws->run( $retry_attempts, $retry_waitingtime );

    if ( !$result ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la récupération de la publication "
              . $publication_id );
        $logger->log( "ERROR", "l'erreur est : " . $ws->get_content() );
        return 5;
    }

    # Conversion de la réponse JSON en structure PERL
    my $hash_response = $ws->get_json();
    if ( !$hash_response ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la conversion de la réponse JSON"
        );
        return 5;
    }

    my $isoap_metadatas_id_to_activate   = $hash_response->[0];
    my $inspire_metadatas_id_to_activate = $hash_response->[1];
    my $pva_metadatas_id_to_activate     = $hash_response->[2];
    my $broadcast_datas_id_to_crawl      = $hash_response->[3];
    my $zone                             = $hash_response->[4];

    $logger->log( "INFO", "zone = " . $zone );
    $logger->log( "INFO",
        "Liste des id de metadatas isoap à activer = "
          . $isoap_metadatas_id_to_activate );
    $logger->log( "INFO",
        "Liste des id de metadatas inspire à activer = "
          . $inspire_metadatas_id_to_activate );
    $logger->log( "INFO",
        "Liste des id de metadatas pva à activer = "
          . $pva_metadatas_id_to_activate );
    $logger->log( "INFO",
        "Liste des id de broadcastdata a crawler = "
          . $broadcast_datas_id_to_crawl );

    my @broadcast_datas_id_to_crawl_list = split /,/,
      $broadcast_datas_id_to_crawl;
    my @isoap_metadatas_id_to_activate_list = split /,/,
      $isoap_metadatas_id_to_activate;
    my @inspire_metadatas_id_to_activate_list = split /,/,
      $inspire_metadatas_id_to_activate;
    my @pva_metadatas_id_to_activate_list = split /,/,
      $pva_metadatas_id_to_activate;

    my $broadcast_datas_id_to_crawl_list_length =
      scalar @broadcast_datas_id_to_crawl_list;
    my $isoap_metadatas_id_to_activate_list_length =
      scalar @isoap_metadatas_id_to_activate_list;
    my $inspire_metadatas_id_to_activate_list_length =
      scalar @inspire_metadatas_id_to_activate_list;
    my $pva_metadatas_id_to_activate_list_length =
      scalar @pva_metadatas_id_to_activate_list;

    $logger->log( "INFO",
        "Nombre de broadcastData à crawler  = "
          . $broadcast_datas_id_to_crawl_list_length );
    $logger->log( "INFO",
        "Nombre de metadonnées isoap à activer   = "
          . $isoap_metadatas_id_to_activate_list_length );
    $logger->log( "INFO",
        "Nombre de metadonnées inspire à activer   = "
          . $inspire_metadatas_id_to_activate_list_length );
    $logger->log( "INFO",
        "Nombre de metadonnées pva à activer   = "
          . $pva_metadatas_id_to_activate_list_length );

    #Get the url of the catalog
    my $url = "0";
    if ( $zone eq "INTERNAL" ) {
        $url = $internurl;
    }
    if ( $zone eq "EXTERNAL" ) {
        $url = $externurl;
    }
    if ( $url eq "0" ) {
        $logger->log( "ERROR",
            "la zone est incorrecte. Sa valeur est " . $zone );
        return 1;
    }
    $logger->log( "INFO", "Url du catalogue = " . $url );

# if need to crawl the broadcastdata on extern zone, first we need to copy them on extern zone
    if (   ( $zone eq "EXTERNAL" )
        && ( $broadcast_datas_id_to_crawl_list_length != 0 ) )
    {
        my $return_sync =
          synchronize_metadatas_on_extern_zone($broadcast_datas_id_to_crawl);
        if ( $return_sync != 0 ) {
            $logger->log( "ERROR",
"Erreur durant la copie des métadonnées à crawler en zone externe "
            );
            return 6;
        }
    }

    # crawl the broadcastdata
    if ( $broadcast_datas_id_to_crawl_list_length != 0 ) {
        my $return_crawl =
          crawl_broadcastdata( $url, $broadcast_datas_id_to_crawl, $zone );
        if ( $return_crawl != 0 ) {
            $logger->log( "ERROR",
                "Erreur durant le crawl des métadonnées " );
            return 2;
        }
    }

    # activate isoap metadatas (change metadatas status from a list of ID)
    if ( $isoap_metadatas_id_to_activate_list_length != 0 ) {
        my $return_change_isoap =
          change_status_metadatas( $url, $isoap_metadatas_id_to_activate,
            $status, 0 );
        if ( $return_change_isoap != 0 ) {
            $logger->log( "ERROR",
                "Erreur durant l'activation des métadonnées ISOAP" );
            return 3;
        }
    }

    # activate inspire metadatas (change metadatas status from a list of ID)
    if ( $inspire_metadatas_id_to_activate_list_length != 0 ) {
        my $return_change_inspire =
          change_status_metadatas( $url, $inspire_metadatas_id_to_activate,
            $status, 1 );
        if ( $return_change_inspire != 0 ) {
            $logger->log( "ERROR",
                "Erreur durant l'activation des métadonnées INSPIRE " );
            return 4;
        }
    }

    # activate pva metadatas (change metadatas status from a list of ID)
    if ( $pva_metadatas_id_to_activate_list_length != 0 ) {
        my $return_change_pva =
          change_status_metadatas( $url, $pva_metadatas_id_to_activate, $status,
            0 );
        if ( $return_change_pva != 0 ) {
            $logger->log( "ERROR",
                "Erreur durant l'activation des métadonnées PVA " );
            return 7;
        }
    }

    return 0;

}
