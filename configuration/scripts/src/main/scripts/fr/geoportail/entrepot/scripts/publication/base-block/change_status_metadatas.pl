#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script take a list of metadatas ids and change its status
# ARGS :
#	The url of the catalog
#   The list of broadcastdata IDs separated by a coma
#	the status to set
#	the boolean saying if it is inspire provider
# RETURNS :
#   * 0 if success
#	* 1 if change status failed
#	* 2 if some mtd are not updated
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/publication/change_status_metadatas.pl $
#   $Date: 30/08/11 $
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
use XML::XPath;
use XML::XPath::XMLParser;

require "harvest_directory.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $max_number_of_mtds_by_request =
  $config->param("publication.max.number.of.mtds.per.perquest");
my $url_proxy        = $config->param("proxy.url");
my $provider_inspire = $config->param("publication.provider.inspire");
my $provider_isoap   = $config->param("publication.provider.isoap");

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "change_status_metadatas .pl", $logger_levels );

sub change_status_metadatas {

    # Parameters number validation
    my ( $url, $metadatas_id_to_activate, $status, $is_inspire ) = @_;
    if (   !defined $url
        || !defined $metadatas_id_to_activate
        || !defined $status
        || !defined $is_inspire )
    {
        $logger->log( "ERROR",
            "Le nombre de parametres renseignes n'est pas celui attendu (4)" );
        return 255;
    }

    $logger->log( "DEBUG", "Parametre 1 : url = " . $url );
    $logger->log( "DEBUG",
        "Parametre 3 : list des id de broadcastdata a changer le statut = "
          . $metadatas_id_to_activate );
    $logger->log( "INFO",
        "Nombre maximum de metadaonnées par requête "
          . $max_number_of_mtds_by_request );

    # get the list of metadatas ID
    my @metadatas_id_to_activate_list = split /,/, $metadatas_id_to_activate;
    my $nb_mtds = scalar @metadatas_id_to_activate_list;
    $logger->log( "INFO", "Nombre de metadonnées à activer   = " . $nb_mtds );

    # Init useragent with or without proxy
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
        $logger->log( "DEBUG",
            "Les paramètres du proxy ont été initialisés ($url_proxy)" );
    }

    my $nb_mtds_activated = 0;
    my $iterator          = 0;
    my $still_mtds        = 1;
    my $lastrequest       = 0;
    my $send_metadatas    = 0;
    while ( !$lastrequest ) {

        # Build the request
        my $body_request = "";
        while ( $still_mtds
            && ( $send_metadatas != $max_number_of_mtds_by_request ) )
        {

            my $id_to_add = $metadatas_id_to_activate_list[$iterator];
            $logger->log( "DEBUG", "ID to add =  " . $id_to_add );
            $body_request =
              $body_request . "<ogc:Literal>$id_to_add</ogc:Literal>";

            if ( $iterator == ( $nb_mtds - 1 ) ) {
                $logger->log( "DEBUG", "dernière mtd atteinte " );
                $still_mtds  = 0;
                $lastrequest = 1;
            }
            $iterator       += 1;
            $send_metadatas += 1;
        }

        my $begin_request =
"<?xml version='1.0' encoding='UTF-8'?><csw:SetStatus service='CSW' version='2.0.2' status='$status' xmlns:csw='http://www.opengis.net/cat/csw/2.0.2' xmlns:dc='http://www.purl.org/dc/elements/1.1/' xmlns:ogc='http://www.opengis.net/ogc'><csw:Query><csw:Constraint version='2.0.2'><ogc:Filter><ogc:PropertyIsIn><ogc:PropertyName>dc:identifier</ogc:PropertyName>";
        my $end_resquest =
"</ogc:PropertyIsIn></ogc:Filter></csw:Constraint></csw:Query></csw:SetStatus>";
        my $set_status_request = $begin_request . $body_request . $end_resquest;
        $logger->log( "INFO",
            "Status request ready to be sent : " . $set_status_request );

        # send request
        my $response;
        if ($is_inspire) {
            $response = $ua->request(
                POST $url. $provider_inspire,
                Content_Type => 'text/xml',
                Content      => $set_status_request
            );
            $logger->log( "DEBUG",
                "set_status_request on $url$provider_inspire" );
        }
        else {
            $response = $ua->request(
                POST $url. $provider_isoap,
                Content_Type => 'text/xml',
                Content      => $set_status_request
            );
            $logger->log( "DEBUG",
                "set_status_request on $url$provider_isoap" );
        }

        # check result
        my $content = $response->content;
        $logger->log( "DEBUG", "reponse : " . $content );

        my @content_tab = split /\n/, $response->content;
        if ( $response->is_success ) {

            my $count = join "", @content_tab;
            $count =~ s/.*<csw:totalUpdated>(.*)<\/csw:totalUpdated>.*/$1/;

            #test if everything was updated
            if ( $count eq $send_metadatas ) {
                $logger->log( "INFO",
"requête est passée en succès avec $count métadonnées mis à jour"
                );
            }
            else {
                $logger->log( "ERROR",
"Seulement $count métadonnées ont été mis à jour sur les $send_metadatas de la requête"
                );
                return 2;
            }

        }
        else {
            $logger->log( "ERROR",
"Erreur lors de la récupération du statut de l'opération de set_status_request"
            );
            return 1;
        }

        # reinitialize
        $nb_mtds_activated += $send_metadatas;
        $send_metadatas = 0;
    }

    $logger->log( "INFO", "Toutes les métadonénes ont été mis à jour" );
    return 0;

}
