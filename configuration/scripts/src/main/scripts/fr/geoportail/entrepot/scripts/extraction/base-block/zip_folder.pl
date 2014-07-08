#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will zip a folder
# ARGS :
#   The folder to compress
#   The size of the division of an archive
#   The compression quality, used with -mx 7za option : from 0 (none) to 9 (ultra)
#   The archive name
#   The output directory where the compressed files will be stored
# RETURNS :
#   * 0 if the extraction is Ok
#   * 255 if the function is called with an incorrect number of arguments
#   * 254 if the folder to compress is empty
#   * 253 if the folder to compress doesn't exists
#   * 252 if the zip size is equal to 0
#   * 250 if the output folder of the archive doesn't exist
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/conditionnement/zip_folder.pl $
#   $Date: 12/09/11 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configurationuse strict;
use strict;
use warnings;
use Logger;
use Execute;
use Cwd;
use Config::Simple;

our $VERSION = "1.0";
our $config;

if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $resources_path = $config->param("resources.path");
my $logger = Logger->new( "zip_folder.pl", $config->param("logger.levels") );

my $bash_count_lines = "| wc -l";

sub zip_folder {

    # Extraction des paramètres
    my ( $folder, $size, $compression_quality, $output_folder, $archive_name ) =
      @_;
    if (   !defined $folder
        || !defined $size
        || !defined $compression_quality
        || !defined $output_folder
        || !defined $archive_name )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (4)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : folder = " . $folder );
    $logger->log( "DEBUG", "Paramètre 2 : size = " . $size );
    $logger->log( "DEBUG",
        "Paramètre 3 : compression_quality = " . $compression_quality );
    $logger->log( "DEBUG", "Paramètre 4 : output_folder = " . $output_folder );
    $logger->log( "DEBUG", "Paramètre 5 : archive_name = " . $archive_name );

    # Contrôle des paramètres
    if ( !-d $folder ) {
        $logger->log( "ERROR",
            "Le dossier source passée en paramètre n'éxiste pas" );
        return 253;
    }

    if ( $size == 0 ) {
        $logger->log( "ERROR",
            "La taille de découpage de l'archive est nulle" );
        return 252;
    }

    # Création du répertoire des images
    $logger->log( "DEBUG",
        "Création du répertoire de destination : " . $output_folder );
    if ( !-d $output_folder ) {
        my $create_folder_cmd = "mkdir -p " . $output_folder;
        my $create_folder_return = Execute->run( $create_folder_cmd, "true" );
        if ( $create_folder_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Impossible de créer le répertoire de destination : "
                  . $output_folder );
            $create_folder_return->log_all( $logger, "DEBUG" );
            return 1;
        }
    }

    # Commande de compression
    my $cmd_7zip =
        "7za a -mx="
      . $compression_quality . " -v"
      . $size . "m "
      . $output_folder . "/"
      . $archive_name . " "
      . $folder;
    $logger->log( "DEBUG",
        "Appel à la commande compression 7zip : " . $cmd_7zip );

    my $return_7zip = Execute->run( $cmd_7zip, "true" );
    if ( $return_7zip->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Impossible de compresser le dossier : " . $folder );
        $return_7zip->log_all( $logger, "ERROR" );
        return 3;
    }

    $logger->log( "INFO",
            "Le dossier " 
          . $folder
          . " a été compressé vers "
          . $output_folder . "/"
          . $archive_name );

    return 0;
}
