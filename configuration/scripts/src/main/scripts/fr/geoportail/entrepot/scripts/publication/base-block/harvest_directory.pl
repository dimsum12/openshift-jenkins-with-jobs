#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script take a directory and launch a crawl depending on the zone and the provider
# ARGS :
#	The url of the catalog
#   The folder to crawl
#   The provider to use
# RETURNS :
#   * 0 if success
#	* 1 if launch crawl failed
#	* 2 if get status failed
#	* 3 if harvest of metadatas failed
#	* 4 if harvest reach timeout
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/publication/harvest_directory.pl $
#   $Date: 30/08/11 $
#   $Author: Nicolas Godelu (A184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;
use DBI;
use HTTP::Request::Common;
use LWP::UserAgent;
use File::Basename;
use XML::XPath;
use XML::XPath::XMLParser;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "harvest_directory.pl", $logger_levels );

my $url_proxy        = $config->param("proxy.url");
my $provider_inspire = $config->param("publication.provider.inspire");
my $provider_isoap   = $config->param("publication.provider.isoap");
my $schema_inspire   = $config->param("publication.schema.inspire");
my $schema_isoap     = $config->param("publication.schema.isoap");
my $schema_pva       = $config->param("publication.schema.pva");
my $gap              = $config->param("publication.gap");
my $timeout          = $config->param("publication.timeout");

sub harvest_directory {

    # Parameters number validation
    my ( $url, $folder, $type ) = @_;
    if ( !defined $url || !defined $folder || !defined $type ) {
        $logger->log( "ERROR",
            "Le nombre de parametres renseignes n'est pas celui attendu (3)" );
        return 255;
    }

    $logger->log( "INFO", "Parametre 1 : url du catalogue = " . $url );
    $logger->log( "INFO", "Parametre 2 : dossier a crawler = " . $folder );
    $logger->log( "INFO", "Parametre 3 : type = " . $type );

    # Init useragent with or without proxy
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
        $logger->log( "DEBUG",
            "Les paramètres du proxy ont été initialisés ($url_proxy)" );
    }

    # Init params for harvesting
    my $schema = 0;
    if ( $type eq "INSPIRE" ) {
        $schema = $schema_inspire;
    }
    if ( $type eq "ISOAP" ) {
        $schema = $schema_isoap;
    }
    if ( $type eq "PVA" ) {
        $schema = $schema_pva;
    }

    my $params =
        "?service=CSW&request=crawl&version=2.0.2&folder=" 
      . $folder
      . "&resourceType="
      . $schema
      . "&asynchronous=true&delay=0&threadnb=4";

    # Harvest metadatas (asynchronous)
    my $response, my $request;
    if ( $type eq "INSPIRE" ) {
        $logger->log( "INFO",
            "Intégration des métadonnées $provider_inspire démarrée" );
        $logger->log( "DEBUG",
            "Crawl on " . $url . $provider_inspire . $params );
        $request = $url . $provider_inspire;
    }
    else {
        $logger->log( "INFO",
            "Intégration des métadonnées $provider_isoap démarrée " );
        $logger->log( "DEBUG", "Crawl on " . $url . $provider_isoap . $params );
        $request = $url . $provider_isoap;
    }

    # Send an harvesting request to the catalog
    $response = $ua->request( GET $request. $params );

    if ( $response->is_success ) {

        # Retrieve id of the harvest operation
        my @harvest_id_tab = split /\n/, $response->content;
        my $harvest_id = join "", @harvest_id_tab;
        $harvest_id =~ s/.*<erdas:id>(.*)<\/erdas:id>.*/$1/;
        $logger->log( "INFO",
            "L'Identifiant de l'opération de moissonnage est " . $harvest_id );

        $params = "?service=CSW&request=crawl&version=2.0.2&id=" . $harvest_id;

        # Retrieve status of harvesting operation
        my $elapsed_time = 0;
        my $crawling     = 1;
        while ($crawling) {

            if ( $elapsed_time < $timeout ) {

                $response = $ua->request( GET $request. $params );
                $logger->log( "DEBUG",
"Récupération du statut de l'opération de moissonnage via : $request$params"
                );

                if ( $response->is_success ) {

                    my $response_content = $response->content;
                    my @response_tab     = split /\n/, $response_content;
                    my $status           = join "", @response_tab;
                    my $failure_count    = join "", @response_tab;
                    my $success_count    = join "", @response_tab;

                    $status =~
                      s/.*<erdas:crawlStatus>(.*)<\/erdas:crawlStatus>.*/$1/;
                    $failure_count =~
                      s/.*<erdas:failure count="(.*)">.*<\/erdas:failure>.*/$1/;
                    $success_count =~
                      s/.*<erdas:success count="(.*)">.*<\/erdas:success>.*/$1/;

                    $logger->log( "DEBUG", "Response is " . $response_content );
                    $logger->log( "DEBUG", "status is " . $status );

                    # Check the end of the harvesting
                    if ( $status eq "finished" ) {
                        $logger->log( "INFO",
"Intégration des métadonnées terminée pour le répertoire"
                              . $folder );
                        if ($success_count) {
                            $logger->log( "INFO",
                                "$success_count métadonnée(s) intégrée(s)"
                            );

                        }
                        if ( $failure_count ne "0" ) {
                            $logger->log( "ERROR",
                                "$failure_count métadonnée(s) en erreur" );
                            return 3;
                        }

                        $crawling = 0;
                    }
                    else {
                        $logger->log( "INFO",
"Intégration des métadonnées en cours. on attend "
                              . $gap
                              . " secondes... Temps deja ecoule (en secondes) = "
                              . $elapsed_time );

                        $elapsed_time += $gap;
                        my $code = system "sleep $gap";
                    }
                }
                else {
                    $logger->log( "ERROR",
"Erreur lors de la récupération du statut de l'opération de moissonnage des métadonnées pour l'id $harvest_id"
                    );
                    return 2;
                }
            }
            else {

                # timeout
                $logger->log( "ERROR",
"Timeout - le crawl a depassee le timeout (en secondes) fixe a  "
                      . $timeout );
                return 4;
            }

        }
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de l'interrogation du catalogue pour une intégration des métadonnées"
        );
        return 1;
    }

    return 0;

}

