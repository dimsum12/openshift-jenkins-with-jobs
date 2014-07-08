#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script extract a list of ISOAP and INSPIRE metadatas
# ARGS :
#	The ISOAP metadatas identifier list
#	The INSPIRE metadatas identifier list
#	The folder to extract the metadatas to
# RETURNS :
#   * 0 if the extraction is correct
#   * 1 if the an error occured with ISOAP metadatas
#   * 1 if the an error occured with INSPIRE metadatas
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/extraction_mtds.pl $
#   $Date: 22/12/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;

require "extract_mtd_file.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "extraction_mtds.pl", $config->param("logger.levels") );

# Clés statiques
my $provider_name_isoap   = "ISOAP";
my $provider_name_inspire = "INSPIRE";

sub extraction_mtds {

    # Extraction des paramètres
    my ( $isoap_array, $inspire_array, $output_folder ) = @_;
    if ( !defined $output_folder ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (3)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 3 : output_folder = " . $output_folder );

    # Création du répertoire des métadonnées
    $logger->log( "DEBUG",
        "Création du répertoire des métadonnées : " . $output_folder );
    if ( !-d $output_folder ) {
        my $create_folder_cmd = "mkdir -p " . $output_folder;
        my $create_folder_return = Execute->run( $create_folder_cmd, "true" );
        if ( $create_folder_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Impossible de créer le répertoire des métadonnées : "
                  . $output_folder );
            $create_folder_return->log_all( $logger, "DEBUG" );
            return 1;
        }
    }

    # Traitements de la liste des métadonnées ISOAP
    if ( defined $isoap_array ) {
        $logger->log( "DEBUG",
"Nombre de métadonnées ISOAP associées à cette extraction WMS : "
              . scalar @{$isoap_array} );
        foreach my $mtd_id ( @{$isoap_array} ) {
            my $file_name = $output_folder . $mtd_id;

            my $return_extract_mtd_file =
              extract_mtd_file( $file_name, $provider_name_isoap, "", $mtd_id );
            if ( 0 != $return_extract_mtd_file ) {
                $logger->log( "ERROR",
                        "Impossible d'extraire la métadonnée " 
                      . $mtd_id
                      . " en CSW ISOAP" );
                $logger->log( "ERROR",
                    "Code retour de la fonction extract_mtd_file : "
                      . $return_extract_mtd_file );
                return 1;
            }
        }
    }

    # Traitements de la liste des métadonnées INSPIRE
    if ( defined $inspire_array ) {
        $logger->log( "DEBUG",
"Nombre de métadonnées INSPIRE associées à cette extraction WMS : "
              . scalar @{$inspire_array} );
        foreach my $mtd_id ( @{$inspire_array} ) {
            my $file_name = $output_folder . $mtd_id;

            my $return_extract_mtd_file =
              extract_mtd_file( $file_name, $provider_name_inspire, "",
                $mtd_id );
            if ( 0 != $return_extract_mtd_file ) {
                $logger->log( "ERROR",
                        "Impossible d'extraire la métadonnée " 
                      . $mtd_id
                      . " en CSW INSPIRE" );
                $logger->log( "ERROR",
                    "Code retour de la fonction extract_mtd_file : "
                      . $return_extract_mtd_file );
                return 2;
            }
        }
    }

    return 0;
}
