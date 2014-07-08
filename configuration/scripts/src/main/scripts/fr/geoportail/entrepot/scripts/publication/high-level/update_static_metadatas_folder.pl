#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script launch crawl on product metadatas of static referential on catalog in validation,
#	intern and extern on both ISOAP and inspire providers
# ARGS :
# RETURNS :
#   * 0 if success
#	* 1 if one crawl failed
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/publication/update_static_metadatas_folder.pl $
#   $Date: 26/04/12 $
#   $Author: Nicolas Godelu (A184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;

require "harvest_directory.pl";
require "harvest_directory_validation.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $validationurl = $config->param("catalog.url.integration");
my $internurl     = $config->param("catalog.url.intern");
my $externurl     = $config->param("catalog.url.extern");

my $ref_statique             = $config->param("static_ref.static_referentiel");
my $metadata_product_isoap   = $config->param("static_ref.productmtds.isoap");
my $metadata_product_inspire = $config->param("static_ref.productmtds.inspire");
my $metadata_service_isoap   = $config->param("static_ref.servicemtds.isoap");
my $metadata_service_inspire = $config->param("static_ref.servicemtds.inspire");

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "update_static_metadatas_folder.pl", $logger_levels );

sub update_static_metadatas_folder {

    my $return_crawl_isoap;
    my $return_crawl_inspire;

    # validation zone ISOAP - PRODUCT METADATAS
    $return_crawl_isoap = harvest_directory_validation( $validationurl,
        $ref_statique . $metadata_product_isoap, "ISOAP" );
    if ( $return_crawl_isoap != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl ISOAP de la zone validation " );
        return 1;
    }

    # validation zone ISOAP - SERVICE METADATAS
    $return_crawl_isoap = harvest_directory_validation( $validationurl,
        $ref_statique . $metadata_service_isoap, "ISOAP" );
    if ( $return_crawl_isoap != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl ISOAP de la zone validation " );
        return 1;
    }

    # validation zone Inspire - PRODUCT METADATAS
    $return_crawl_inspire = harvest_directory_validation( $validationurl,
        $ref_statique . $metadata_product_inspire, "INSPIRE" );
    if ( $return_crawl_inspire != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl INSPIRE de la zone validation " );
        return 1;
    }

    # validation zone Inspire - SERVICE METADATAS
    $return_crawl_inspire = harvest_directory_validation( $validationurl,
        $ref_statique . $metadata_service_inspire, "INSPIRE" );
    if ( $return_crawl_inspire != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl INSPIRE de la zone validation " );
        return 1;
    }

    # intern zone ISOAP - PRODUCT METADATAS
    $return_crawl_isoap =
      harvest_directory( $internurl, $ref_statique . $metadata_product_isoap,
        "ISOAP" );
    if ( $return_crawl_isoap != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl ISOAP de la zone interne " );
        return 1;
    }

    # intern zone ISOAP - SERVICE METADATAS
    $return_crawl_isoap =
      harvest_directory( $internurl, $ref_statique . $metadata_service_isoap,
        "ISOAP" );
    if ( $return_crawl_isoap != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl ISOAP de la zone interne " );
        return 1;
    }

    # intern zone Inspire - PRODUCT METADATAS
    $return_crawl_inspire =
      harvest_directory( $internurl, $ref_statique . $metadata_product_inspire,
        "INSPIRE" );
    if ( $return_crawl_inspire != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl INSPIRE de la zone interne " );
        return 1;
    }

    # intern zone Inspire - SERVICE METADATAS
    $return_crawl_inspire =
      harvest_directory( $internurl, $ref_statique . $metadata_service_inspire,
        "INSPIRE" );
    if ( $return_crawl_inspire != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl INSPIRE de la zone interne " );
        return 1;
    }

    # extern zone ISOAP - PRODUCT METADATAS
    $return_crawl_isoap =
      harvest_directory( $externurl, $ref_statique . $metadata_product_isoap,
        "ISOAP" );
    if ( $return_crawl_isoap != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl ISOAP de la zone externe " );
        return 1;
    }

    # extern zone ISOAP - SERVICE METADATAS
    $return_crawl_isoap =
      harvest_directory( $externurl, $ref_statique . $metadata_service_isoap,
        "ISOAP" );
    if ( $return_crawl_isoap != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl ISOAP de la zone externe " );
        return 1;
    }

    # extern zone Inspire - PRODUCT METADATAS
    $return_crawl_inspire =
      harvest_directory( $externurl, $ref_statique . $metadata_product_inspire,
        "INSPIRE" );
    if ( $return_crawl_inspire != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl INSPIRE de la zone externe " );
        return 1;
    }

    # extern zone Inspire - SERVICE METADATAS
    $return_crawl_inspire =
      harvest_directory( $externurl, $ref_statique . $metadata_service_inspire,
        "INSPIRE" );
    if ( $return_crawl_inspire != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'appel du crawl INSPIRE de la zone externe " );
        return 1;
    }

    return 0;

}
