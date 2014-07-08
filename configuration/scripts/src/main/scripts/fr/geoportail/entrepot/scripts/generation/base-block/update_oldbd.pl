#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will get calculate the bradcastdata output size and update it in entrepot
# ARGS :
#   The broadcastdata
# RETURNS :
#   * 0 if ok
# KEYWORDS
#   $Revision 3 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/high-level/rok4_final_update.pl $
#   $Date: 15/03/12 $
#   $Author: Nicolas Godelu (A184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Deliveryconf;
use Database;
use Execute;
use Tools;
use Cwd;
use LWP::UserAgent;
use WebserviceTools;
use HTTP::Request::Common;
use Config::Simple;
use JSON;

require "update_broadcastdata_size.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "update_oldbd.pl", $config->param("logger.levels") );

my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $url_proxy       = $config->param("proxy.url");

my $retry_attempts = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.entrepot.retry.waitingtime");
my $root_storage = $config->param("filer.root.storage");

sub update_oldbd {

    # Extraction des paramètres
    my ( $is_bd, $list_of_bd_elements ) = @_;
    if ( !defined $is_bd || !defined $list_of_bd_elements ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : is_bd = " . $is_bd );
    $logger->log( "DEBUG",
        "Paramètre 1 : list_of_bd_elements = " . $list_of_bd_elements );

    # cut elements
    my @bd_elements = split /;/, $list_of_bd_elements;
    $logger->log( "DEBUG",
        "Taille du tableau des éléments : " . scalar @bd_elements );

    foreach my $bd_element (@bd_elements) {
        my @parts_elements = split /,/, $bd_element;

        my $element_to_scan = $parts_elements[0];
        my $bd_id           = $parts_elements[1];

        $logger->log( "DEBUG", "element_to_scan : " . $element_to_scan );
        $logger->log( "DEBUG", "bd_id : " . $bd_id );

        # MAJ de la taille totale de la donnée de diffusion
        if ( update_broadcastdata_size( $element_to_scan, $bd_id, $is_bd ) ) {
            $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la taille de la donnée de diffusion "
                  . $bd_id );
            return 3;
        }
    }

    return 0;
}

