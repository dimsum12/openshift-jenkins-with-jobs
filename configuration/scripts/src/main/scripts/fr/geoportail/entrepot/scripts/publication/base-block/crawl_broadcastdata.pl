#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script take a list of BD ids to crawl and launch two crawl on each one : ISOAP & INSPIRE
# ARGS :
#	The url of catalog
#   The list of broadcastdata IDs separated by a coma
#   The zone to crawl : INTERNAL or EXTERNAL (optionnal, default = INTERNAL)
# RETURNS :
#   * 0 if success
#	* 1 if crawl failed
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/publication/crawl_broadcastdata.pl $
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

require "harvest_directory.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $root_catalog_folder = $config->param("filer.catalog.repository");
my $root_catalog_folder_extern =
  $config->param("filer.catalog.extern.repository");
my $isoap_folder_name   = $config->param("filer.folder.isoap");
my $inspire_folder_name = $config->param("filer.folder.inspire");
my $pva_folder_name     = $config->param("filer.folder.pva");
my $logger_levels       = $config->param("logger.levels");
my $logger = Logger->new( "crawl_broadcastdata .pl", $logger_levels );

sub crawl_broadcastdata {

    # Parameters number validation
    my ( $url, $broadcast_datas_id_to_crawl, $zone ) = @_;
    if ( !defined $url || !defined $broadcast_datas_id_to_crawl ) {
        $logger->log( "ERROR",
"Le nombre de parametres renseignes n'est pas celui attendu (2 ou 3)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Parametre 1 : url = " . $url );
    $logger->log( "DEBUG",
        "Parametre 2 : list des id de broadcastdata a crawler = "
          . $broadcast_datas_id_to_crawl );
    if ( defined $zone ) {
        $logger->log( "DEBUG", "Parametre 3 : zone = " . $zone );
    }

    # get the list of BD ID
    my @broadcast_datas_id_to_crawl_list = split /,/,
      $broadcast_datas_id_to_crawl;
    $logger->log( "INFO",
        "Nombre de broadcastData à crawler  = "
          . scalar @broadcast_datas_id_to_crawl_list );

    # iterate over the ID
    foreach my $broadcast_data_id (@broadcast_datas_id_to_crawl_list) {

        # Calculate Folders to crawl
        my $isoap_folder;
        my $pva_folder;
        my $inspire_folder;

        if ( defined $zone && $zone eq "EXTERNAL" ) {
            $isoap_folder =
                $root_catalog_folder_extern
              . $isoap_folder_name
              . $broadcast_data_id . "/";
            $pva_folder =
                $root_catalog_folder_extern
              . $pva_folder_name
              . $broadcast_data_id . "/";
            $inspire_folder =
                $root_catalog_folder_extern
              . $inspire_folder_name
              . $broadcast_data_id . "/";
        }
        else {
            $isoap_folder =
                $root_catalog_folder
              . $isoap_folder_name
              . $broadcast_data_id . "/";
            $pva_folder =
                $root_catalog_folder
              . $pva_folder_name
              . $broadcast_data_id . "/";
            $inspire_folder =
                $root_catalog_folder
              . $inspire_folder_name
              . $broadcast_data_id . "/";
        }

        # check if folder exists and not empty
        my @inspire_metadata_files =
          `find $inspire_folder -type f -name "*.xml"`;
        my $inspire_metadata_files_count = scalar @inspire_metadata_files;
        $logger->log( "DEBUG",
            " $inspire_metadata_files_count métadonnée(s) INSPIRE trouvée(s)"
        );

        my @isoap_metadata_files = `find $isoap_folder -type f -name "*.xml"`;
        my $isoap_metadata_files_count = scalar @isoap_metadata_files;
        $logger->log( "DEBUG",
            " $isoap_metadata_files_count métadonnée(s) ISOAP trouvée(s)" );

        my @pva_metadata_files       = `find $pva_folder -type f -name "*.xml"`;
        my $pva_metadata_files_count = scalar @pva_metadata_files;
        $logger->log( "DEBUG",
            " $pva_metadata_files_count métadonnée(s) PVA trouvée(s)" );

        # Harvest ISOAP metadatas
        if ( $isoap_metadata_files_count != 0 ) {
            my $return_crawl_isoap =
              harvest_directory( $url, $isoap_folder, "ISOAP" );
            if ( $return_crawl_isoap != 0 ) {
                $logger->log( "ERROR",
"Erreur lors de l'appel du crawl ISOAP de la BroadcastDATA : "
                      . $broadcast_data_id );
                $logger->log( "DEBUG", "Code retour = " . $return_crawl_isoap );
                return 1;
            }
        }

        # Harvest INSPIRE metadatas
        if ( $inspire_metadata_files_count != 0 ) {
            my $return_crawl_inspire =
              harvest_directory( $url, $inspire_folder, "INSPIRE" );
            if ( $return_crawl_inspire != 0 ) {
                $logger->log( "ERROR",
"Erreur lors de l'appel du crawl INSPIRE de la BroadcastDATA : "
                      . $broadcast_data_id );
                $logger->log( "DEBUG",
                    "Code retour = " . $return_crawl_inspire );
                return 1;
            }
        }

        # Harvest PVA metadatas
        if ( $pva_metadata_files_count != 0 ) {
            my $return_crawl_pva =
              harvest_directory( $url, $pva_folder, "PVA" );
            if ( $return_crawl_pva != 0 ) {
                $logger->log( "ERROR",
                    "Erreur lors de l'appel du crawl PVA de la BroadcastDATA : "
                      . $broadcast_data_id );
                $logger->log( "DEBUG", "Code retour = " . $return_crawl_pva );
                return 1;
            }
        }

    }

    return 0;

}
