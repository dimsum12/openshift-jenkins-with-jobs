#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script extract a complete WMS dataset
# ARGS :
#	Output folder for the extracted tiles
#	Output format of the extracted tiles
#	List of the bounding boxes to use to extract WMS tiles
#	Tile width
#	Tile height
#	Type d'extraction (WMS Raster or WMS Vector)
#	Key for requesting the WMS services
#	Layer name to extract
#	Output projection of the extracted datas
#	Style used for WMS request
#	Context : used to build service url
# RETURNS :
#   * 0 if the extraction is correct
#   * 1 if an error occured during creating ouptut directory
#   * 2 if a bbox in parameter is incorrect
#   * 3 if an error occured during extracting a WMS tile
#   * 4 if the output format value is of an unknown type
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/extraction_wms.pl $
#   $Date: 21/12/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;

require "extract_wms_tile.pl";
require "convert_points.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "extraction_wms.pl", $config->param("logger.levels") );
  
my $retry_attempts =
  $config->param("resources.ws.extraction.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.extraction.entrepot.retry.waitingtime");

my $gxt_extension = ".gxt";
my $grf_extension = ".grf";
my $tab_extension = ".tab";

sub extraction_wms {

    # Extraction des paramètres
    my (
        $output_folder, $output_format,   $bboxes,     $image_width,
        $image_height,  $type_extraction, $manager_id, $layer_name,
        $output_crs,    $style,           $context
    ) = @_;
    if (   !defined $output_folder
        || !defined $output_format
        || !defined $bboxes
        || !defined $image_width
        || !defined $image_height
        || !defined $type_extraction
        || !defined $manager_id
        || !defined $layer_name
        || !defined $output_crs
        || !defined $style
        || !defined $context )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (11)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : output_folder = " . $output_folder );
    $logger->log( "DEBUG", "Paramètre 2 : output_format = " . $output_format );
    $logger->log( "DEBUG",
        "Paramètre 3 : bboxes = " . scalar @{$bboxes} . " élément(s)" );
    $logger->log( "DEBUG", "Paramètre 4 : image_width = " . $image_width );
    $logger->log( "DEBUG", "Paramètre 5 : image_height = " . $image_height );
    $logger->log( "DEBUG",
        "Paramètre 6 : type_extraction = " . $type_extraction );
    $logger->log( "DEBUG", "Paramètre 7 : manager_id = " . $manager_id );
    $logger->log( "DEBUG", "Paramètre 8 : layer_name = " . $layer_name );
    $logger->log( "DEBUG", "Paramètre 9 : output_crs = " . $output_crs );
    $logger->log( "DEBUG", "Paramètre 10 : style = " . $style );
    $logger->log( "DEBUG", "Paramètre 11 : context = " . $context );

    # Création du répertoire des images
    $logger->log( "DEBUG",
        "Création du répertoire des images : " . $output_folder );
    if ( !-d $output_folder ) {
        my $create_folder_cmd = "mkdir -p " . $output_folder;
        my $create_folder_return = Execute->run( $create_folder_cmd, "true" );
        if ( $create_folder_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Impossible de créer le répertoire des images : "
                  . $output_folder );
            $create_folder_return->log_all( $logger, "DEBUG" );
            return 1;
        }
    }

	
    # Définition de l'extension de l'image et du fichier de géoréférencement
    my $image_extension;
    my $georef_extension;
    if ( $output_format =~ /png/i ) {
        $image_extension  = ".png";
        $georef_extension = ".wld";
        $output_format    = "image/png";
    }
    elsif ( $output_format =~ /jpeg/i ) {
        $image_extension  = ".jpg";
        $georef_extension = ".wld";
        $output_format    = "image/jpeg";
    }
	elsif ( $output_format =~ /lzw/i ) {
        $image_extension  = ".tif";
        $georef_extension = ".tfw";
        $output_format    = "image/tiff&FORMAT_OPTIONS=compression:lzw";
    }
    elsif ( $output_format =~ /tif/i ) {
        $image_extension  = ".tif";
        $georef_extension = ".tfw";
        $output_format    = "image/tiff&FORMAT_OPTIONS=compression:raw";
    }
    else {
        $logger->log( "ERROR",
                "Le format "
              . $output_format
              . " n'est pas reconnu par l'extraction" );
        return 4;
    }
    $logger->log( "DEBUG",
        "Extension utilisée pour les images : " . $image_extension );
    $logger->log( "DEBUG",
        "Extension utilisée pour les fichiers de géoréférencement : "
          . $georef_extension );

    # Traitement de chaque BBOX de l'extraction WMS
    for ( 0 .. scalar( @{$bboxes} ) - 1 ) {
        my $bbox_name   = $bboxes->[$_]->{'name'};
        my $bbox_id     = $bboxes->[$_]->{'id'};
        my $bbox_points = $bboxes->[$_]->{'points'};

        # Split et contrôle de la BBOX fournie
        my @bbox_points_splitted = split /,/, $bbox_points;
        if ( 4 != scalar @bbox_points_splitted ) {
            $logger->log( "ERROR",
                "La géométrie fournie ne contient pas 4 coordonnées" );
            return 2;
        }
        my ( $min_longitude, $min_latitude, $max_longitude, $max_latitude ) =
          @bbox_points_splitted;

        # Génération des noms de fichiers
        my $image_simple_file_name = $bbox_name . $image_extension;
        my $image_file_name        = $output_folder . $image_simple_file_name;
        my $tfw_file_name = $output_folder . $bbox_name . $georef_extension;
        my $gxt_file_name = $output_folder . $bbox_name . $gxt_extension;
        my $grf_file_name = $output_folder . $bbox_name . $grf_extension;
        my $tab_file_name = $output_folder . $bbox_name . $tab_extension;

        my $return_extract_wms_tile = extract_wms_tile(
            $image_file_name, $min_longitude,   $min_latitude,
            $max_longitude,   $max_latitude,    $image_width,
            $image_height,    $type_extraction, $manager_id,
            $layer_name,      $output_format,   $output_crs,
            $style,           $context,  $retry_attempts, 
		$retry_waitingtime
        );
        if ( 0 != $return_extract_wms_tile ) {
            $logger->log( "ERROR",
                    "Impossible d'extraire le fichier "
                  . $image_file_name
                  . " en WMS" );
            $logger->log( "ERROR",
                "Code retour de la fonction extract_wms_tile : "
                  . $return_extract_wms_tile );
            return 3;
        }

        # Génération du fichier de géoréférencement TFW
        my $return_create_georef = create_georef(
            $tfw_file_name, "TFW",         $image_simple_file_name,
            $min_longitude, $min_latitude, $max_longitude,
            $max_latitude,  $image_width,  $image_height,
            $output_crs
        );
        if ( 0 != $return_create_georef ) {
            $logger->log( "ERROR",
                "Impossible de créer le fichier de géoréférencement TFW "
                  . $tfw_file_name );
            $logger->log( "ERROR",
                "Code retour de la fonction create_georef : "
                  . $return_create_georef );
            return 3;
        }

        # Génération du fichier de géoréférencement GXT
        $return_create_georef = create_georef(
            $gxt_file_name, "GXT",         $image_simple_file_name,
            $min_longitude, $min_latitude, $max_longitude,
            $max_latitude,  $image_width,  $image_height,
            $output_crs
        );
        if ( 0 != $return_create_georef ) {
            $logger->log( "ERROR",
                "Impossible de créer le fichier de géoréférencement GXT "
                  . $gxt_file_name );
            $logger->log( "ERROR",
                "Code retour de la fonction create_georef : "
                  . $return_create_georef );
            return 3;
        }

        # Génération du fichier de géoréférencement GRF
        $return_create_georef = create_georef(
            $grf_file_name, "GRF",         $image_simple_file_name,
            $min_longitude, $min_latitude, $max_longitude,
            $max_latitude,  $image_width,  $image_height,
            $output_crs
        );
        if ( 0 != $return_create_georef ) {
            $logger->log( "ERROR",
                "Impossible de créer le fichier de géoréférencement GXT "
                  . $grf_file_name );
            $logger->log( "ERROR",
                "Code retour de la fonction create_georef : "
                  . $return_create_georef );
            return 3;
        }

        # Génération du fichier de géoréférencement TAB
        $return_create_georef = create_georef(
            $tab_file_name, "TAB",         $image_simple_file_name,
            $min_longitude, $min_latitude, $max_longitude,
            $max_latitude,  $image_width,  $image_height,
            $output_crs
        );
        if ( 0 != $return_create_georef ) {
            $logger->log( "ERROR",
                "Impossible de créer le fichier de géoréférencement TAB "
                  . $tab_file_name );
            $logger->log( "ERROR",
                "Code retour de la fonction create_georef : "
                  . $return_create_georef );
            return 3;
        }
    }

    return 0;
}
