#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script call the entrepot webservice to get the epsg projection for an ignf one
# ARGS :
#	The ignf projection
# RETURNS :
#   * epsgProjection or the same projection if not found
#   * 1 if an error occured during calling entrepot webservice
#   * 254 if the json response cannot be decoded
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/get_epsg_for_ignf_projection.pl $
#   $Date: 21/12/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use WebserviceTools;
use Cwd;
use Config::Simple;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "get_epsg_for_ignf_projection.pl",
    $config->param("logger.levels") );

# Configuration
my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $url_proxy       = $config->param("proxy.url");
my $retry_attempts  = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.entrepot.retry.waitingtime");

sub get_epsg_for_ignf_projection {

    # Extraction des paramètres
    my ($ignf_projection) = @_;
    if ( !defined $ignf_projection ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG",
        "Paramètre 1 : ignf_projection = " . $ignf_projection );

    # Appel au web service pour récupérer l'extraction à effectuer
    my $ws = WebserviceTools->new(
        'GET',
        $url_ws_entrepot
          . "/extraction/getEpsgFromIgnfProjection?ignfProjection="
          . $ignf_projection,
        $url_proxy
    );

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/extraction/getEpsgFromIgnfProjection?ignfProjection="
          . $ignf_projection );

    my $result = $ws->run( $retry_attempts, $retry_waitingtime );

    if ( !$result ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la récupération de la projection EPSG pour la projection IGNF suivante : "
              . $ignf_projection );
        $logger->log( "ERROR", "l'erreur est : " . $ws->get_content() );
        return 1;
    }

    my $epsgProjection = $ws->get_content();
    $logger->log( "DEBUG", "Projection récupérée = " . $epsgProjection );

    return $epsgProjection;
}
1;
