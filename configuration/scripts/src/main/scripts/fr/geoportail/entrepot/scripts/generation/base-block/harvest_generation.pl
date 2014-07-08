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
#   * 1 if there are errors during the harvesting operation for ISO AP metadatas
#   * 2 if there are errors during the harvesting operation for INSPIRE metadatas
#   * 3 if there are errors during the harvesting operation for PVA metadatas
#   * 4 if there are errors during the metadatas update operation for a broadcast data
#   * 5 if there are gateway timetour retry during the metadatas update operation for a broadcast data
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/harvest_generation.pl $
#   $Date: 26/09/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
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
use Deliveryconf;
use Execute;
use JSON;
use XML::XPath;
use XML::XPath::XMLParser;
use HTTP::Status qw(:constants :is status_message);

require "harvest_metadatas.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

our $deliveryconf;

my $logger_levels        = $config->param("logger.levels");
my $url_ws_entrepot      = $config->param("resources.ws.url.entrepot");
my $url_proxy            = $config->param("proxy.url");
my $xpath_geometry_gml   = $config->param("metadata.xpath.geometry.gml");
my $updating_limit       = $config->param("harvesting.updating.limit");
my $check_status_timeout = $config->param("harvesting.timeout");
my $updating_retry       = $config->param("harvesting.updating.retry");

my $logger = Logger->new( "harvest_generation.pl", $logger_levels );

sub harvest_generation {
    my ( $delivery_dir, $bd_id ) = @_;

    if (   !defined $delivery_dir
        || !defined $bd_id )
    {
        $logger->log( "ERROR",
            "Le nombre de paramèes renseignén'est pas celui attendu (2)" );
        return 255;
    }

    # Récupération des informations du fichier d'informations complémentaires
    if ( not( defined $deliveryconf ) ) {
        $deliveryconf = Deliveryconf->new( $delivery_dir, $logger, $config );
    }

    # Configuration de l'agent pour effectuer des requêtes
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
    }

    my ( $mtd_src_dir, %hash_metadatas );

    my $metadatas_finded = "false";

    $mtd_src_dir = $delivery_dir . "/";

    # Mise à jour des métadonnées ISO
    $mtd_src_dir = $deliveryconf->{values}{"DIR.METADATA.ISO"};
    if ( defined $mtd_src_dir ) {
        if ( "" ne $mtd_src_dir ) {
            $mtd_src_dir = $delivery_dir . "/" . $mtd_src_dir;
            my $result = launch_harvesting( $mtd_src_dir, "ISOAP", $bd_id,
                \%hash_metadatas );
            if ($result) {
                return 1;
            }
            $metadatas_finded = "true";
        }
    }

    # Mise à jour des métadonnées INSPIRE
    $mtd_src_dir = $deliveryconf->{values}{"DIR.METADATA.INSPIRE"};
    if ( defined $mtd_src_dir ) {
        if ( "" ne $mtd_src_dir ) {
            $mtd_src_dir = $delivery_dir . "/" . $mtd_src_dir;
            my $result = launch_harvesting( $mtd_src_dir, "INSPIRE", $bd_id,
                \%hash_metadatas );
            if ($result) {
                return 2;
            }
            $metadatas_finded = "true";
        }
    }

    # Mise à jour des métadonnées PVA
    $mtd_src_dir = $deliveryconf->{values}{"DIR.METADATA.PVA"};
    if ( defined $mtd_src_dir ) {
        if ( "" ne $mtd_src_dir ) {
            $mtd_src_dir = $delivery_dir . "/" . $mtd_src_dir;
            my $result = launch_harvesting( $mtd_src_dir, "PVA", $bd_id,
                \%hash_metadatas );
            if ($result) {
                return 3;
            }
            $metadatas_finded = "true";
        }
    }

    my %hash_metadatas_split;
    my $cpt     = 1;
    my $cpt_lot = 1;
    foreach my $i ( keys %hash_metadatas ) {
        $hash_metadatas_split{$i} = $hash_metadatas{$i};
        if ( $updating_limit > $cpt ) {
            $cpt = $cpt + 1;
        }
        elsif ( $updating_limit == $cpt ) {
            my $result = update_broadcastdata( $ua, $bd_id, $metadatas_finded,
                \%hash_metadatas_split, \%hash_metadatas, $cpt_lot, 0 );
            %hash_metadatas_split = ();
            if ( 0 != $result ) {
                return $result;
            }
            $cpt_lot = $cpt_lot + 1;
            $cpt     = 1;
        }
    }

# Mise à jour de la donnée de diffusion avec le dernier lot de métadonnées associées
    my $result = update_broadcastdata( $ua, $bd_id, $metadatas_finded,
        \%hash_metadatas_split, \%hash_metadatas, $cpt_lot, 0 );
    %hash_metadatas_split = ();
    if ( 0 != $result ) {
        return $result;
    }

    return 0;
}

# Retrieve the geometry in metadata
sub retrieve_geometry {
    my $param = shift;

    my $xp = XML::XPath->new( filename => $param );

    my $result = $xp->find($xpath_geometry_gml);

    my $gml;
    foreach my $node ( $result->get_nodelist ) {
        $gml = $gml . XML::XPath::XMLParser::as_string($node);
    }

    return $gml;
}

sub launch_harvesting {
    my ( $mtd_src_dir, $type, $bd_id, $hash_metadatas ) = @_;

    my $catalog_repository = $config->param("filer.catalog.repository");

    my $mtd_dir_dest = $catalog_repository . "/" . $type . "/" . $bd_id;

    $logger->log( "INFO",
        "Lancement du processus d'intégration des métadonnées $type" );
    $logger->log( "DEBUG",
        "call -> harvest_metadatas( $mtd_src_dir, $mtd_dir_dest, $type )" );
    my $return_harvest_metadatas =
      harvest_metadatas( $mtd_src_dir, $mtd_dir_dest, $type );
    $logger->log( "DEBUG",
        " --> Valeur de retour : " . $return_harvest_metadatas );

    if ( $return_harvest_metadatas != 0 ) {
        $logger->log( "ERROR",
"Une erreur est survenue lors de l'intégration des métadonnées $type"
        );
        return 2;
    }

    my $cmd = "find $mtd_dir_dest -type f -name \"*.xml\"";
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
    my $result = Execute->run( $cmd, "true" );

    my @results = $result->get_log();

 # Suppresion des caractère de fin de ligne et récupération de la géométrie
    foreach my $file_identifier (@results) {
        chomp $file_identifier;
        my $geometry = retrieve_geometry($file_identifier);
        if ( !defined $geometry ) {
            $logger->log( "ERROR",
"La géométrie de la métadonnée, $file_identifier, n'a pas pu être récupérée."
            );
            return 5;
        }
        $file_identifier = basename($file_identifier);
        $logger->log( "DEBUG", "$file_identifier" );
        $$hash_metadatas{$file_identifier} = {
            type        => $type,
            geometry    => $geometry,
            broadcastId => $bd_id
        };
    }

    return 0;
}

sub update_broadcastdata {
    my ( $ua, $bd_id, $metadatas_finded, $hash_metadatas_split_ref,
        $hash_metadatas_ref, $cpt_lot, $retry )
      = @_;
    my %hash_metadatas_split = %$hash_metadatas_split_ref;
    my %hash_metadatas       = %$hash_metadatas_ref;

    # Mise à jour de la donnée de diffusion avec les métadonnées associées
    if ( "true" eq $metadatas_finded && 0 != keys(%hash_metadatas_split) ) {
        $logger->log( "INFO",
            "Mise à jour de la donnée de diffusion : " . $bd_id );
        $logger->log( "DEBUG",
                "Appel au service REST : "
              . $url_ws_entrepot
              . "/generation/updateMetadatas pour la donnée de diffusion "
              . $bd_id );
        JSON->new->encode( \%hash_metadatas_split );
        $logger->log( "DEBUG",
            JSON->new->encode( \%hash_metadatas_split ) . " : " .
              keys(%hash_metadatas_split) );
        my $response = $ua->request(
            POST $url_ws_entrepot
              . "/generation/updateMetadatas?broadcastDataId="
              . $bd_id,
            Content_Type => 'application/json',
            Content      => JSON->new->encode( \%hash_metadatas_split )
        );

        if ( $response->is_success ) {
            $logger->log( "INFO",
                    "Mise à jour de la donnée de diffusion " 
                  . $bd_id
                  . " effectuée pour le lot $cpt_lot ("
                  . $cpt_lot * $updating_limit . "/"
                  . keys(%hash_metadatas)
                  . ")" );
            $cpt_lot = $cpt_lot + 1;
        }
        elsif ( $response->code == HTTP_GATEWAY_TIMEOUT ) {
            $logger->log( "WARN",
"Gateway Timeout lors de la mise à jour de la donnée de diffusion "
                  . $bd_id );
            if ( $updating_retry > $retry ) {
                Execute->run( "sleep $check_status_timeout", "false" );
                $logger->log( "INFO",
". Relance du processus de mise à jour de la donnée de diffusion..."
                );
                update_broadcastdata( $ua, $bd_id, $metadatas_finded,
                    $hash_metadatas_split_ref, $hash_metadatas_ref, $cpt_lot,
                    $retry );
                $retry = $retry + 1;
            }
            else {
                return 5;
            }

        }
        else {
            $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la donnée de diffusion "
                  . $bd_id );
            return 4;
        }
    }
    else {
        $logger->log( "INFO",
            "Aucune métadonnée à intégrer pour cette donnée de diffusion "
              . $bd_id );
    }

    return 0;
}
