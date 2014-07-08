#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will realize an extraction from different parameters
# ARGS :
#   The extraction id
# RETURNS :
#   * 0 if the extraction is Ok
#   * 1 if the packaging identifier is not yet implemented
#   * 2 if an error occured during WMS extraction
#   * 3 if an error occured during WFS extraction
#   * 4 if an error occured during metadatas extraction
#   * 5 if an error occured creating outlines for an extraction
#   * 6 if an error occured during copying datas from static ref to the extracted package
#   * 7 if an error occured during aggregating or post-processing metadatas
#   * 8 if an error occured during packaging
#   * 254 if the extractions structure is incorrect
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/extraction/base-block/extraction.pl $
#   $Date: 28/12/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configuration

use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use JSON;
use Execute;
use Tools;
use POSIX qw(strftime);
use IO::File;
use List::Util qw(max);
use List::Util qw(min);
use XML::XPath;
use XML::XPath::XMLParser;

require "copy_data.pl";
require "packaging.pl";
require "extraction_wms.pl";
require "extraction_wfs.pl";
require "extraction_mtds.pl";
require "create_outlines.pl";
require "agregate_metadata.pl";
require "apply_xsd.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger = Logger->new( "extraction.pl", $config->param("logger.levels") );

# Configuration
my $conditionnement_path = $config->param("resources.conditionnement_paths");
my $static_referentiel   = $config->param("static_ref.static_referentiel");
my $xsl_file             = $config->param("resources.xsl_file");
my $gdaltransform        = $config->param("resources.gdaltransform");

my $config_conditionnement = Config::Simple->new($conditionnement_path);
my $descriptions_folder_path =
  $config_conditionnement->param("resources.descriptions");
my $metadatas_folder_path =
  $config_conditionnement->param("resources.metadatas");
my $additional_folder_path =
  $config_conditionnement->param("resources.additional");
my $fxx_specific_additional_folder_path =
  $config_conditionnement->param("resources.additional.fxx");
my $packaging_directorie_1 = $config_conditionnement->param("directories.1");
my $packaging_directorie_2 = $config_conditionnement->param("directories.2");
my $packaging_directorie_3 = $config_conditionnement->param("directories.3");
my $packaging_directorie_4 = $config_conditionnement->param("directories.4");
my $packaging_directorie_5 = $config_conditionnement->param("directories.5");
my $packaging_directorie_add =
  $config_conditionnement->param("directories.additionnals");
my $readme_file =
  $config->param("metadata_extraction.readme.txt");
my $fxx_longlat_longitude_min =
  $config_conditionnement->param("boundingbox.fxx.x1");
my $fxx_longlat_longitude_max =
  $config_conditionnement->param("boundingbox.fxx.x2");
my $fxx_longlat_latitude_min =
  $config_conditionnement->param("boundingbox.fxx.y1");
my $fxx_longlat_latitude_max =
  $config_conditionnement->param("boundingbox.fxx.y2");

my $gdaltransform_validator_pre =
  " | " . $gdaltransform . " -s_srs '+init=IGNF:WGS84G +wktext' -t_srs '+init=";
my $gdaltransform_validator_post = " +wktext'";
my @inverted_lonlat_srs_list     = split /\|/,
  $config->param("resources.srs_liste_inverted_lonlat");

#################
## Method Main ##
#################

sub extraction {

    # Extraction des paramètres
    my (
        $packaging_id,         $product_id,
        $purchase_id,          $manager_id,
        $zip_name,             $zip_max_size,
        $wfs_extraction_array, $wms_extraction_array,
        $tmp_output_storage,   $extraction_output_storage,
        $extraction_id
    ) = @_;

    if (   !defined $packaging_id
        || !defined $product_id
        || !defined $purchase_id
        || !defined $manager_id
        || !defined $zip_name
        || !defined $zip_max_size
        || ( !defined $wfs_extraction_array && !defined $wms_extraction_array )
        || !defined $tmp_output_storage
        || !defined $extraction_output_storage
        || !defined $extraction_id )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (10)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : packaging_id = " . $packaging_id );
    $logger->log( "DEBUG", "Paramètre 2 : product_id = " . $product_id );
    $logger->log( "DEBUG", "Paramètre 3 : purchase_id = " . $purchase_id );
    $logger->log( "DEBUG", "Paramètre 4 : manager_id = " . $manager_id );
    $logger->log( "DEBUG", "Paramètre 5 : zip_name = " . $zip_name );
    $logger->log( "DEBUG", "Paramètre 6 : zip_max_size = " . $zip_max_size );
    if ( defined @{$wfs_extraction_array} ) {
        $logger->log( "DEBUG",
                "Paramètre 7 : wfs_extraction_array = "
              . scalar @{$wfs_extraction_array}
              . " élément(s)" );
    }
    if ( defined @{$wms_extraction_array} ) {
        $logger->log( "DEBUG",
                "Paramètre 8 : wms_extraction_array = "
              . scalar @{$wms_extraction_array}
              . " élément(s)" );
    }
    $logger->log( "DEBUG",
        "Paramètre 9 : tmp_output_storage = " . $tmp_output_storage );
    $logger->log( "DEBUG",
        "Paramètre 10 : extraction_output_storage = "
          . $extraction_output_storage );
    $logger->log( "DEBUG", "Paramètre 11 : extraction_id" );

## Validation de l'identifiant de conditionnement

    my $general_output_folder;
    my $general_output_folder_files;
    my $description_product_target;
    my $description_metadata_target;
    my $general_output_folder_metadatas;
    my $general_output_folder_additionnals;
    my $general_output_folder_general_additionnals;

## Definition du conditionnement extraction boutique ... en dur ;)

    if ( "CONDITIONNEMENT_EXTRACTION_BOUTIQUE" eq $packaging_id ) {
        $general_output_folder = $tmp_output_storage . "/" . $product_id . "/";

        $general_output_folder_files =
            $general_output_folder
          . $packaging_directorie_1 . "_"
          . $purchase_id . "/";

        $description_product_target =
          $general_output_folder . $packaging_directorie_2;

        $description_metadata_target =
          $general_output_folder . $packaging_directorie_3;

        $general_output_folder_metadatas =
            $general_output_folder
          . $packaging_directorie_4 . "_"
          . $purchase_id . "/";

        $general_output_folder_additionnals =
            $general_output_folder
          . $packaging_directorie_5 . "_"
          . $purchase_id . "/";

        $general_output_folder_general_additionnals =
          $tmp_output_storage . "/" . $packaging_directorie_add;
    }
    else {
        $logger->log( "ERROR",
                "L'identifiant de packaging "
              . $packaging_id
              . " n'est pas reconnu par le processus" );
        return 1;
    }

## Initialisation du hash des répertoires de métadonnées et du vérificateur drise FXX

    my %all_mtds_folder = ();
    my $is_on_fxx       = "false";
    my $data_folder;

## Traitement des extractions WFS  ##
#-----------------#-----------------#

    if ( defined @{$wfs_extraction_array} ) {
        for ( 0 .. scalar( @{$wfs_extraction_array} ) - 1 ) {
            my $extraction_polygon =
              $wfs_extraction_array->[$_]->{'extractionPolygon'};
            if ( !defined $extraction_polygon ) {
                $logger->log( "ERROR",
                    "L'extraction WFS ne possède pas de polygone d'extraction"
                );
                return 254;
            }
            $logger->log( "DEBUG",
                "Polygone d'extraction WFS : " . $extraction_polygon );

            my $layer_name = $wfs_extraction_array->[$_]->{'layerName'};
            if ( !defined $layer_name ) {
                $logger->log( "ERROR",
                    "L'extraction WFS ne possède pas de nom de couche" );
                return 254;
            }
            $logger->log( "DEBUG",
                "Nom de couche à extraire : " . $layer_name );

            $data_folder = $wfs_extraction_array->[$_]->{'dataFolder'};
            if ( !defined $data_folder ) {
                $logger->log( "ERROR",
"L'extraction WFS ne possède pas de nom de dossier de données"
                );
                return 254;
            }
            $logger->log( "DEBUG",
                "Nom du dossier de données à utiliser : " . $data_folder );

            my $theme_folder = $wfs_extraction_array->[$_]->{'themeFolder'};
            if ( !defined $theme_folder ) {
                $logger->log( "INFO",
"L'extraction WFS ne possède pas de nom de dossier de thème"
                );
                $theme_folder = "";
            }
            $logger->log( "DEBUG",
                "Nom de dossier de thème : " . $theme_folder );

            my $output_crs = $wfs_extraction_array->[$_]->{'outputCrs'};
            if ( !defined $output_crs ) {
                $logger->log( "ERROR",
                    "L'extraction WFS ne possède pas de projection cible" );
                return 254;
            }
            $logger->log( "DEBUG", "Projection cible : " . $output_crs );

            my $output_format = $wfs_extraction_array->[$_]->{'outputFormat'};
            if ( !defined $output_format ) {
                $logger->log( "ERROR",
                    "L'extraction WFS ne possède pas format de sortie" );
                return 254;
            }
            $logger->log( "DEBUG", "Format de sortie : " . $output_format );

            my $context = $wfs_extraction_array->[$_]->{'context'};
            if ( !defined $context ) {
                $logger->log( "ERROR",
                    "L'extraction WFS ne possède pas de contexte" );
                return 254;
            }
            $logger->log( "DEBUG", "Contexte : " . $context );

            my $isoap_array =
              $wfs_extraction_array->[$_]->{'idsMetadatasIsoApToRequest'};
            my $inspire_array =
              $wfs_extraction_array->[$_]->{'idsMetadatasInspireToRequest'};

## Conversion de la bounding box FXX en projection cible

            my $convert_cmd =
                "echo '"
              . $fxx_longlat_longitude_min . " "
              . $fxx_longlat_latitude_min . " 0'"
              . $gdaltransform_validator_pre
              . $output_crs
              . $gdaltransform_validator_post
              . "; echo '"
              . $fxx_longlat_longitude_max . " "
              . $fxx_longlat_latitude_max . " 0'"
              . $gdaltransform_validator_pre
              . $output_crs
              . $gdaltransform_validator_post;

            $logger->log( "DEBUG",
                "La commande appelée est : " . $convert_cmd );
            my $convert_cmd_return = Execute->run( $convert_cmd, "true" );
            if ( $convert_cmd_return->get_return() != 0 ) {
                $logger->log( "ERROR",
                    "La commande à renvoyé "
                      . $convert_cmd_return->get_return() );
                $logger->log( "DEBUG", "Sortie complète du processus :" );
                $convert_cmd_return->log_all( $logger, "DEBUG" );

                return 9;
            }

            my @results           = $convert_cmd_return->get_log();
            my @fxx_point1        = split / /, $results[0];
            my @fxx_point2        = split / /, $results[1];
            my $fxx_longitude_min = $fxx_point1[0];
            my $fxx_longitude_max = $fxx_point2[0];
            my $fxx_latitude_min  = $fxx_point1[1];
            my $fxx_latitude_max  = $fxx_point2[1];

            # Définition des répertoire d'écriture
            my $output_folder_files =
                $general_output_folder_files
              . $data_folder . "/"
              . $theme_folder . "/";

            my $output_folder_metadatas =
              $general_output_folder_metadatas . $data_folder . "/";

            my $output_folder_additionnals =
              $general_output_folder_additionnals . $data_folder . "/";

            # Extraction WFS
            my $return_extraction_wfs = extraction_wfs(
                $output_folder_files,
                $extraction_polygon->{'points'},
                $extraction_polygon->{'name'},
                $manager_id,
                $layer_name,
                $product_id,
                $output_format,
                $output_crs,
                $context
            );
            if ( 0 != $return_extraction_wfs ) {
                $logger->log( "ERROR",
                    "Impossible d'effectuer l'extraction WFS" );
                $logger->log( "ERROR",
                    "Code retour de la fonction extraction_wfs : "
                      . $return_extraction_wfs );
                return 2;
            }

            # Extraction Métadonnées
            my $return_extraction_mtds =
              extraction_mtds( $isoap_array, $inspire_array,
                $output_folder_metadatas );
            if ( 0 != $return_extraction_mtds ) {
                $logger->log( "ERROR",
                    "Impossible d'effectuer l'extraction des métadonnées" );
                $logger->log( "ERROR",
                    "Code retour de la fonction extraction_mtds : "
                      . $return_extraction_mtds );
                return 4;
            }

            # Préparation de l'aggrégation
            my $longitude_min;
            my $longitude_max;
            my $latitude_min;
            my $latitude_max;
            my $srs_dimension = $extraction_polygon->{'points'};

            # sécurité pour enlever les sauts de ligne
            $srs_dimension =~ s/>\n.*</></g;

            $srs_dimension =~
s/^.*<gml:posList srsDimension="([0-9]+)">.*<\/gml:posList>.*$/$1/;
            $logger->log( "DEBUG", "srs dimension is : " . $srs_dimension );

            my $extraction_points = $extraction_polygon->{'points'};

            # sécurité pour enlever les sauts de ligne
            $extraction_points =~ s/>\n.*</></g;
            $extraction_points =~
s/^.*<gml:posList srsDimension="[0-9]+">(.*)<\/gml:posList>.*$/$1/;

            my $points_as_list = "";
            my $tmp_points     = "";
            my $count          = 0;

            # create list of points
            foreach my $point_cutted ( split / /, $extraction_points ) {
			$logger->log( "DEBUG", "point_cutted is: " . $point_cutted );
			
                if ( $count < $srs_dimension ) {
								
                    $count += 1;
                    $tmp_points .= $point_cutted . ",";
                    $logger->log( "DEBUG", "tmp_points is : " . $tmp_points );
                }
                else {
					# remove last coma
					chop($tmp_points);
                    $points_as_list .= $tmp_points . " ";
                    $logger->log( "DEBUG",
                        "points_as_list is : " . $points_as_list );
                    $count      = 1;
                    $tmp_points = $point_cutted . ",";
                }
            }

            foreach my $point_extraction_polygon ( split / /, $points_as_list )
            {
                $logger->log( "DEBUG",
                    "Point de polygone a traiter : "
                      . $point_extraction_polygon );
                my @split_point_extraction_polygon = split /,/,
                  $point_extraction_polygon;

# Si on a un CRS qui inverse les longitudes latitudes, on inverse la bounding box en conséquent
# Ex: EPSG 4326
                if ( grep {$_ eq $output_crs} @inverted_lonlat_srs_list ) {
                    my @temp_split_point_extraction_polygon =
                      @split_point_extraction_polygon;
                    @split_point_extraction_polygon = ();
                    $split_point_extraction_polygon[0] =
                      $temp_split_point_extraction_polygon[1];
                    $split_point_extraction_polygon[1] =
                      $temp_split_point_extraction_polygon[0];
                    $split_point_extraction_polygon[2] =
                      $temp_split_point_extraction_polygon[3];
                    $split_point_extraction_polygon[3] =
                      $temp_split_point_extraction_polygon[2];
                    @temp_split_point_extraction_polygon = ();
                }

                if (   defined $split_point_extraction_polygon[0]
                    && defined $split_point_extraction_polygon[1] )
                {
                    if ( !defined $longitude_min
                        || $longitude_min > $split_point_extraction_polygon[0] )
                    {
                        $longitude_min = $split_point_extraction_polygon[0];
                    }
                    if ( !defined $longitude_max
                        || $longitude_max < $split_point_extraction_polygon[0] )
                    {
                        $longitude_max = $split_point_extraction_polygon[0];
                    }
                    if ( !defined $latitude_min
                        || $latitude_min > $split_point_extraction_polygon[1] )
                    {
                        $latitude_min = $split_point_extraction_polygon[1];
                    }
                    if ( !defined $latitude_max
                        || $latitude_max < $split_point_extraction_polygon[1] )
                    {
                        $latitude_max = $split_point_extraction_polygon[1];
                    }
                }
                else {
                    $logger->log( "ERROR",
                        "Mauvaise construction des coordonnées du polygon WMS "
                          . $extraction_polygon->{'name'} . " : "
                          . $point_extraction_polygon );
                    return 254;
                }
            }

            # Vérification des emprises par rapport à la France
            if (   $longitude_min <= $fxx_longitude_max
                && $longitude_max >= $fxx_longitude_min
                && $latitude_min <= $fxx_latitude_max
                && $latitude_max >= $fxx_latitude_min )
            {
                $logger->log( "DEBUG",
                    "L'extraction en cours se situe sur le territoire FXX" );
                $is_on_fxx = "true";
            }

            if ( !defined $all_mtds_folder{$output_folder_metadatas} ) {
                $logger->log( "DEBUG",
"C'est la première extraction pour le répertoire de métadonnées "
                      . $output_folder_metadatas );
                my %new_hash = ();
                $all_mtds_folder{$output_folder_metadatas} = \%new_hash;
            }
            my %current_hash = %{ $all_mtds_folder{$output_folder_metadatas} };

            if ( !defined $current_hash{'format'} ) {
                my @tab_format = ($output_format);
                $current_hash{'format'} = \@tab_format;
                $logger->log( "DEBUG",
                        "Le format "
                      . $output_format
                      . " est lié à "
                      . $output_folder_metadatas );
            }
            elsif (
                scalar(
                    grep { /$output_format/ } @{ $current_hash{'format'} }
                ) == 0
              )
            {
                $logger->log( "DEBUG",
                        "Le format "
                      . $output_format
                      . " n'existe pas encore pour "
                      . $output_folder_metadatas );
                push @{ $current_hash{'format'} }, $output_format;
            }

            if ( !defined $current_hash{'projection'} ) {
                my @tab_projection = ($output_crs);
                $current_hash{'projection'} = \@tab_projection;
                $logger->log( "DEBUG",
                        "La projection "
                      . $output_crs
                      . " est lié à "
                      . $output_folder_metadatas );
            }
            elsif (
                scalar(
                    grep { /$output_crs/ } @{ $current_hash{'projection'} }
                ) == 0
              )
            {
                $logger->log( "DEBUG",
                        "La projection "
                      . $output_crs
                      . " n'existe pas encore pour "
                      . $output_folder_metadatas );
                push @{ $current_hash{'projection'} }, $output_crs;
            }

            if ( !defined $current_hash{'longitude_min'}
                || $current_hash{'longitude_min'} >= $longitude_min )
            {
                $logger->log( "DEBUG",
                        "La longitude minimum "
                      . $longitude_min
                      . " est la nouvelle valeur pour  "
                      . $output_folder_metadatas );
                $current_hash{'longitude_min'} = $longitude_min;
            }

            if ( !defined $current_hash{'longitude_max'}
                || $current_hash{'longitude_max'} <= $longitude_max )
            {
                $logger->log( "DEBUG",
                        "La longitude maximum "
                      . $longitude_max
                      . " est la nouvelle valeur pour  "
                      . $output_folder_metadatas );
                $current_hash{'longitude_max'} = $longitude_max;
            }

            if ( !defined $current_hash{'latitude_min'}
                || $current_hash{'latitude_min'} > $latitude_min )
            {
                $logger->log( "DEBUG",
                        "La latitude minimum "
                      . $latitude_min
                      . " est la nouvelle valeur pour  "
                      . $output_folder_metadatas );
                $current_hash{'latitude_min'} = $latitude_min;
            }

            if ( !defined $current_hash{'latitude_max'}
                || $current_hash{'latitude_max'} < $latitude_max )
            {
                $logger->log( "DEBUG",
                        "La latitude maximum "
                      . $latitude_max
                      . " est la nouvelle valeur pour  "
                      . $output_folder_metadatas );
                $current_hash{'latitude_max'} = $latitude_max;
            }

            $all_mtds_folder{$output_folder_metadatas} = \%current_hash;

            # Creation des contours à partir du polygone d'extraction
            my $emprise_extension;
			my $points_for_outlines;
            if ( $output_format =~ /gml/i ) {
                $emprise_extension = "gml";
				$points_for_outlines = $extraction_points;
            }
            elsif ( $output_format =~ /shp/i ) {
                $emprise_extension = "shp";
				$points_for_outlines = $points_as_list;
            }

            if (
                !-e (
                        $output_folder_additionnals
                      . "EMPRISE" . "/"
                      . "EMPRISE."
                      . $emprise_extension
                )
              )
            {
                my @polygons       = ($points_for_outlines);
                my @polygons_names = ( $extraction_polygon->{'name'} );
                my $return_create_outlines_shp = create_outlines(
                    \@polygons,
                    \@polygons_names,
                    $output_folder_additionnals . "EMPRISE" . "/" . "EMPRISE",
                    $emprise_extension,
                    $output_crs,
                    "true"
                );

                if ( 0 != $return_create_outlines_shp ) {
                    $logger->log( "ERROR",
"Impossible de créer le fichier de contour de l'extraction"
                    );
                    $logger->log( "ERROR",
                        "Code retour des fonctions create_outlines : "
                          . $return_create_outlines_shp );
                    return 5;
                }
            }
        }
    }

    # Traitement des extractions WMS
    if ( defined @{$wms_extraction_array} ) {
        for ( 0 .. scalar( @{$wms_extraction_array} ) - 1 ) {

            # Vérification des paramètres de l'extraction WMS
            my $layer_name = $wms_extraction_array->[$_]->{'layerName'};
            if ( !defined $layer_name ) {
                $logger->log( "ERROR",
                    "L'extraction WMS ne possède pas de nom de couche" );
                return 254;
            }
            $logger->log( "DEBUG",
                "Nom de la couche à extraire : " . $layer_name );

            $data_folder = $wms_extraction_array->[$_]->{'dataFolder'};
            if ( !defined $data_folder ) {
                $logger->log( "ERROR",
"L'extraction WMS ne possède pas de nom de dossier de données"
                );
                return 254;
            }
            $logger->log( "DEBUG",
                "Nom du dossier de données à utiliser : " . $data_folder );

            my $theme_folder = $wms_extraction_array->[$_]->{'themeFolder'};
            if ( !defined $theme_folder ) {
                $logger->log( "INFO",
"L'extraction WMS ne possède pas de nom de dossier de thème"
                );
                $theme_folder = "";
            }
            $logger->log( "DEBUG",
                "Nom de dossier de thème : " . $theme_folder );

            my $output_crs = $wms_extraction_array->[$_]->{'outputCrs'};
            if ( !defined $output_crs ) {
                $logger->log( "ERROR",
                    "L'extraction WMS ne possède pas de projection cible" );
                return 254;
            }
            $logger->log( "DEBUG", "Projection cible : " . $output_crs );

            my $output_format = $wms_extraction_array->[$_]->{'outputFormat'};
            if ( !defined $output_format ) {
                $logger->log( "ERROR",
                    "L'extraction WMS ne possède pas format de sortie" );
                return 254;
            }
            $logger->log( "DEBUG", "Format de sortie : " . $output_format );

            my $image_width = $wms_extraction_array->[$_]->{'imageWidth'};
            if ( !defined $image_width ) {
                $logger->log( "ERROR",
                    "L'extraction WMS ne possède pas de largeur d'image" );
                return 254;
            }
            $logger->log( "DEBUG",
                "Largeur des images de sortie : " . $image_width );

            my $image_height = $wms_extraction_array->[$_]->{'imageHeight'};
            if ( !defined $image_height ) {
                $logger->log( "ERROR",
                    "L'extraction WMS ne possède pas de hauteur d'image" );
                return 254;
            }
            $logger->log( "DEBUG",
                "Hauteur des images de sortie : " . $image_height );

            my $style = $wms_extraction_array->[$_]->{'style'};
            if ( !defined $style ) {
                $logger->log( "ERROR",
                    "L'extraction WMS ne possède pas de style WMS" );
                return 254;
            }
            $logger->log( "DEBUG", "Style WMS : " . $style );

            my $bboxes = $wms_extraction_array->[$_]->{'bboxes'};
            if ( !defined $bboxes ) {
                $logger->log( "ERROR",
                    "L'extraction WMS ne possède pas de style WMS" );
                return 254;
            }
            $logger->log( "DEBUG",
                "Bounding boxes à générer : " . scalar @{$bboxes} );

            my $type_extraction = $wms_extraction_array->[$_]->{'type'};
            if ( !defined $type_extraction ) {
                $logger->log( "ERROR",
                    "L'extraction WMS ne possède pas de type d'extraction" );
                return 254;
            }
            $logger->log( "DEBUG", "Type d'extraction : " . $type_extraction );

            my $context = $wms_extraction_array->[$_]->{'context'};
            if ( !defined $context ) {
                $logger->log( "ERROR",
                    "L'extraction WMS ne possède pas de contexte" );
                return 254;
            }
            $logger->log( "DEBUG", "Contexte : " . $context );

            my $isoap_array =
              $wms_extraction_array->[$_]->{'idsMetadatasIsoApToRequest'};
            my $inspire_array =
              $wms_extraction_array->[$_]->{'idsMetadatasInspireToRequest'};

            # Conversion de la bounding box FXX en projection cible
            my $convert_cmd =
                "echo '"
              . $fxx_longlat_longitude_min . " "
              . $fxx_longlat_latitude_min . " 0'"
              . $gdaltransform_validator_pre
              . $output_crs
              . $gdaltransform_validator_post
              . "; echo '"
              . $fxx_longlat_longitude_max . " "
              . $fxx_longlat_latitude_max . " 0'"
              . $gdaltransform_validator_pre
              . $output_crs
              . $gdaltransform_validator_post;
            $logger->log( "DEBUG",
                "La commande appelée est : " . $convert_cmd );
            my $convert_cmd_return = Execute->run( $convert_cmd, "true" );
            if ( $convert_cmd_return->get_return() != 0 ) {
                $logger->log( "ERROR",
                    "La commande à renvoyé "
                      . $convert_cmd_return->get_return() );
                $logger->log( "DEBUG", "Sortie complète du processus :" );
                $convert_cmd_return->log_all( $logger, "DEBUG" );

                return 9;
            }
            my @results           = $convert_cmd_return->get_log();
            my @fxx_point1        = split / /, $results[0];
            my @fxx_point2        = split / /, $results[1];
            my $fxx_longitude_min = $fxx_point1[0];
            my $fxx_longitude_max = $fxx_point2[0];
            my $fxx_latitude_min  = $fxx_point1[1];
            my $fxx_latitude_max  = $fxx_point2[1];

            # Définition des répertoire d'écriture
            my $output_folder_images =
                $general_output_folder_files
              . $data_folder . "/"
              . $theme_folder . "/";

            my $output_folder_metadatas =
              $general_output_folder_metadatas . $data_folder . "/";

            my $output_folder_additionnals =
              $general_output_folder_additionnals . $data_folder . "/";

            # Extraction WMS
            my $return_extraction_wms = extraction_wms(
                $output_folder_images, $output_format,
                $bboxes,               $image_width,
                $image_height,         $type_extraction,
                $manager_id,           $layer_name,
                $output_crs,           $style,
                $context
            );
            if ( 0 != $return_extraction_wms ) {
                $logger->log( "ERROR",
                    "Impossible d'effectuer l'extraction WMS" );
                $logger->log( "ERROR",
                    "Code retour de la fonction extraction_wms : "
                      . $return_extraction_wms );
                return 3;
            }

            # Extraction Métadonnées
            my $return_extraction_mtds =
              extraction_mtds( $isoap_array, $inspire_array,
                $output_folder_metadatas );
            if ( 0 != $return_extraction_mtds ) {
                $logger->log( "ERROR",
                    "Impossible d'effectuer l'extraction des métadonnées" );
                $logger->log( "ERROR",
                    "Code retour de la fonction extraction_mtds : "
                      . $return_extraction_mtds );
                return 4;
            }

            # Préparation de l'aggrégation
            my $longitude_min;
            my $longitude_max;
            my $latitude_min;
            my $latitude_max;
            for ( 0 .. scalar( @{$bboxes} ) - 1 ) {
                my $bbox_points = $bboxes->[$_]->{'points'};
                $logger->log( "DEBUG",
                    "Bounding box a traiter : " . $bbox_points );
                my @split_point_bbox = split /,/, $bbox_points;

# Si on a un CRS qui inverse les longitudes latitudes, on inverse la bounding box en conséquent
# Ex: EPSG 4326
                if ( grep {$_ eq $output_crs} @inverted_lonlat_srs_list ) {
                    my @temp_split_point_bbox = @split_point_bbox;
                    @split_point_bbox      = ();
                    $split_point_bbox[0]   = $temp_split_point_bbox[1];
                    $split_point_bbox[1]   = $temp_split_point_bbox[0];
                    $split_point_bbox[2]   = $temp_split_point_bbox[3];
                    $split_point_bbox[3]   = $temp_split_point_bbox[2];
                    @temp_split_point_bbox = ();
                }

                if (   defined $split_point_bbox[0]
                    && defined $split_point_bbox[1]
                    && defined $split_point_bbox[2]
                    && defined $split_point_bbox[3] )
                {
                    if ( !defined $longitude_min
                        || $longitude_min > $split_point_bbox[0] )
                    {
                        $longitude_min = $split_point_bbox[0];
                    }
                    if ( !defined $longitude_max
                        || $longitude_max < $split_point_bbox[2] )
                    {
                        $longitude_max = $split_point_bbox[2];
                    }
                    if ( !defined $latitude_min
                        || $latitude_min > $split_point_bbox[1] )
                    {
                        $latitude_min = $split_point_bbox[1];
                    }
                    if ( !defined $latitude_max
                        || $latitude_max < $split_point_bbox[3] )
                    {
                        $latitude_max = $split_point_bbox[3];
                    }
                }
                else {
                    $logger->log( "ERROR",
"Mauvaise construction des coordonnées de la bounding box WMS "
                          . $bboxes->[$_]->{'name'} . " : "
                          . $bbox_points );
                    return 254;
                }
            }

            # Vérification des emprises par rapport à la France
            if (   $longitude_min <= $fxx_longitude_max
                && $longitude_max >= $fxx_longitude_min
                && $latitude_min <= $fxx_latitude_max
                && $latitude_max >= $fxx_latitude_min )
            {
                $logger->log( "DEBUG",
                    "L'extraction en cours se situe sur le territoire FXX" );
                $is_on_fxx = "true";
            }

            if ( !defined $all_mtds_folder{$output_folder_metadatas} ) {
                $logger->log( "DEBUG",
"C'est la première extraction pour le répertoire de métadonnées "
                      . $output_folder_metadatas );
                my %new_hash = ();
                $all_mtds_folder{$output_folder_metadatas} = \%new_hash;
            }
            my %current_hash = %{ $all_mtds_folder{$output_folder_metadatas} };

            if ( !defined $current_hash{'format'} ) {
                my @tab_format = ($output_format);
                $current_hash{'format'} = \@tab_format;
                $logger->log( "DEBUG",
                        "Le format "
                      . $output_format
                      . " est lié à "
                      . $output_folder_metadatas );
            }
            elsif (
                scalar(
                    grep { /$output_format/ } @{ $current_hash{'format'} }
                ) == 0
              )
            {
                $logger->log( "DEBUG",
                        "Le format "
                      . $output_format
                      . " n'existe pas encore pour "
                      . $output_folder_metadatas );
                push @{ $current_hash{'format'} }, $output_format;
            }

            if ( !defined $current_hash{'projection'} ) {
                my @tab_projection = ($output_crs);
                $current_hash{'projection'} = \@tab_projection;
                $logger->log( "DEBUG",
                        "La projection "
                      . $output_crs
                      . " est lié à "
                      . $output_folder_metadatas );
            }
            elsif (
                scalar(
                    grep { /$output_crs/ } @{ $current_hash{'projection'} }
                ) == 0
              )
            {
                $logger->log( "DEBUG",
                        "La projection "
                      . $output_crs
                      . " n'existe pas encore pour "
                      . $output_folder_metadatas );
                push @{ $current_hash{'projection'} }, $output_crs;
            }

            if ( !defined $current_hash{'longitude_min'}
                || $current_hash{'longitude_min'} >= $longitude_min )
            {
                $logger->log( "DEBUG",
                        "La longitude minimum "
                      . $longitude_min
                      . " est la nouvelle valeur pour  "
                      . $output_folder_metadatas );
                $current_hash{'longitude_min'} = $longitude_min;
            }

            if ( !defined $current_hash{'longitude_max'}
                || $current_hash{'longitude_max'} <= $longitude_max )
            {
                $logger->log( "DEBUG",
                        "La longitude maximum "
                      . $longitude_max
                      . " est la nouvelle valeur pour  "
                      . $output_folder_metadatas );
                $current_hash{'longitude_max'} = $longitude_max;
            }

            if ( !defined $current_hash{'latitude_min'}
                || $current_hash{'latitude_min'} > $latitude_min )
            {
                $logger->log( "DEBUG",
                        "La latitude minimum "
                      . $latitude_min
                      . " est la nouvelle valeur pour  "
                      . $output_folder_metadatas );
                $current_hash{'latitude_min'} = $latitude_min;
            }

            if ( !defined $current_hash{'latitude_max'}
                || $current_hash{'latitude_max'} < $latitude_max )
            {
                $logger->log( "DEBUG",
                        "La latitude maximum "
                      . $latitude_max
                      . " est la nouvelle valeur pour  "
                      . $output_folder_metadatas );
                $current_hash{'latitude_max'} = $latitude_max;
            }

            $all_mtds_folder{$output_folder_metadatas} = \%current_hash;

            # Creation des contours à partir du polygone d'extraction
            if ( !-e ( $output_folder_additionnals . "dalles.shp" ) ) {
                my @polygons       = ();
                my @polygons_names = ();
                for ( 0 .. scalar( @{$bboxes} ) - 1 ) {
                    push @polygons_names, $bboxes->[$_]->{'name'};
                    my @bbox_points_splitted = split /,/,
                      $bboxes->[$_]->{'points'};
                    if ( 4 != scalar @bbox_points_splitted ) {
                        $logger->log( "ERROR",
"La géométrie fournie ne contient pas 4 coordonnées"
                        );
                        return 254;
                    }
                    my (
                        $min_longitude, $min_latitude,
                        $max_longitude, $max_latitude
                    ) = @bbox_points_splitted;

                    push @polygons,
                        $min_longitude . ","
                      . $min_latitude . ",0 "
                      . $min_longitude . ","
                      . $max_latitude . ",0 "
                      . $max_longitude . ","
                      . $max_latitude . ",0 "
                      . $max_longitude . ","
                      . $min_latitude . ",0 "
                      . $min_longitude . ","
                      . $min_latitude . ",0";
                }

                my $return_create_outlines_shp =
                  create_outlines( \@polygons, \@polygons_names,
                    $output_folder_additionnals . "dalles",
                    "shp", $output_crs );
                my $retour_transform =
                  transform_file( $output_folder_additionnals . "dalles",
                    'shp', 'mif' );
                if (   0 != $return_create_outlines_shp
                    || 0 != $retour_transform )
                {
                    $logger->log( "ERROR",
"Impossible de créer le fichier de contour de l'extraction"
                    );
                    $logger->log( "ERROR",
                            "Code retour des fonctions create_outlines : "
                          . $return_create_outlines_shp
                          . " puis transform : "
                          . $retour_transform );
                    return 5;
                }
            }
        }
    }

    # Copie des informations statiques depuis le référentiel
    $logger->log( "INFO", "Copie ressources supplémentaires génériques" );
    $logger->log( "INFO",
        "Copie des descriptifs et métadonnées du produit " . $product_id );

    # Sources
    my $description_product_source =
      $static_referentiel . "/" . $descriptions_folder_path . "/" . $product_id;
    my $description_metadata_source =
      $static_referentiel . "/" . $metadatas_folder_path . "/" . $product_id;
    my $additional_source = $static_referentiel . "/" . $additional_folder_path;
    my $fxx_specific_additional_source =
      $static_referentiel . "/" . $fxx_specific_additional_folder_path;

    # Copies effectives
    my $return_copy_data_description_product =
      copy_data( $description_product_source, $description_product_target );
    if ( 0 != $return_copy_data_description_product ) {
        $logger->log( "ERROR",
                "Erreur de copie de "
              . $description_product_source
              . " vers "
              . $description_product_target );
        $logger->log( "ERROR",
            "Code retour de la fonction copy_data : "
              . $return_copy_data_description_product );
        return 6;
    }

    my $return_copy_data_description_metadata =
      copy_data( $description_metadata_source, $description_metadata_target );
    if ( 0 != $return_copy_data_description_product ) {
        $logger->log( "ERROR",
                "Erreur de copie de "
              . $description_metadata_source
              . " vers "
              . $description_metadata_target );
        $logger->log( "ERROR",
            "Code retour de la fonction copy_data : "
              . $return_copy_data_description_product );
        return 6;
    }

    my $return_copy_data_additional = copy_data( $additional_source,
        $general_output_folder_general_additionnals );
    if ( 0 != $return_copy_data_description_product ) {
        $logger->log( "ERROR",
                "Erreur de copie de "
              . $additional_source
              . " vers "
              . $general_output_folder_general_additionnals );
        $logger->log( "ERROR",
            "Code retour de la fonction copy_data : "
              . $return_copy_data_description_product );
        return 6;
    }

    if ( "true" eq $is_on_fxx ) {
        $logger->log( "INFO",
            "L'extraction concerne au moins une zone sur la métropole" );

        my $return_copy_data_fxx_specific_additional =
          copy_data( $fxx_specific_additional_source,
            $general_output_folder_general_additionnals );
        if ( 0 != $return_copy_data_fxx_specific_additional ) {
            $logger->log( "ERROR",
                    "Erreur de copie de "
                  . $fxx_specific_additional_source
                  . " vers "
                  . $general_output_folder_general_additionnals );
            $logger->log( "ERROR",
                "Code retour de la fonction copy_data : "
                  . $return_copy_data_fxx_specific_additional );
            return 6;
        }
    }

# Aggrégation des métadonnées ou ajout des fichiers README en l'absence de métadonnées
    while ( my $current_mtds_folder = each %all_mtds_folder ) {
        my %current_hash = %{ $all_mtds_folder{$current_mtds_folder} };
        $logger->log( "DEBUG",
            "Vérification de la présence de métadonnées dans : "
              . $current_mtds_folder );

        my $cmd_count_xml =
          "ls -1 " . $current_mtds_folder . " | grep \".xml\" | wc -l";
        $logger->log( "DEBUG",
            "Commande de comptage des fichiers XML dans le dossier :"
              . $cmd_count_xml );
        my $return_count_xml = Execute->run( $cmd_count_xml, "false" );
        my @xml_number_lines = $return_count_xml->get_log();
		my $xml_number = $xml_number_lines[0];
		chomp $xml_number;

        $logger->log( "DEBUG",
            "Nombre d'éléments XML dans le dossier : " . $xml_number );
        if ( 0 == $xml_number ) {
            $logger->log( "DEBUG",
"Le dossier de métadonnées ne contient aucune métadonnée suite à l'extraction"
            );
            $logger->log( "INFO",
                    "Copie du fichier "
                  . $readme_file
                  . " dans le dossier "
                  . $current_mtds_folder );

            my $cmd_cp_readme =
              "cp -f " . $readme_file . " " . $current_mtds_folder;
            Execute->run( $cmd_cp_readme, "true" );
        }
        else {
            $logger->log( "DEBUG",
                    "Le dossier de métadonnées contient "
                  . $xml_number
                  . " métadonnée(s) suite à l'extraction" );
            $logger->log( "INFO",
                "Aggrégation des métadonnées de " . $current_mtds_folder );

            ## Détermination du nom de la métadonnée agrégée : nom du data_folder + FORMAT_RIG_INFO
# Le FORMAT_RIG_INFO est déduit du data_folder en parsant sur '_' et en supprimant la première occurence
            $logger->log( "DEBUG", "data_folder : " . $data_folder );
            my @splitted_data_folder = split( "_", $data_folder );
            my $format_rig_info =
                $splitted_data_folder[-3] . "_"
              . $splitted_data_folder[-2] . "_"
              . $splitted_data_folder[-1];
            $logger->log( "DEBUG",
                "Le FORMAT_RIG_INFO déterminé est : " . $format_rig_info );

# Le nom de la metadonne est issue du dossier 3_xxx issue du référentiel statique
# my $return_list_product_metadata = Execute->run( "ls " . $description_metadata_target . "/*.xml", "false" );
            my @product_metadatas = `ls $description_metadata_target/*.xml`;
            $logger->log( "DEBUG",
                    "Nombre de métadonnées de produit trouvées : "
                  . scalar @product_metadatas
                  . " dans le dossier "
                  . $description_metadata_target );
            if ( scalar @product_metadatas < 1 ) {
                $logger->log( "ERROR",
                    "Aucune métadonnee de produit n'a pu être trouvée." );
                return 7;
            }

# On a récupéré le contenu du dossier : on parse le nom de l'unique fichier afin d'enlever l'extension .xml.
            (
                my $product_metadata_name,
                my $product_metadata_content_dir,
                my $product_metadata_extension
            ) = fileparse( $product_metadatas[0], qr/\.[^.]*/ );
            $logger->log( "DEBUG",
                "Le nom de la méta donnée de produiselectionnée est : "
                  . $product_metadata_name );

            my @product_metadata_parsed = split( '_', $product_metadata_name );
            my $agregated_filename =
                $product_metadata_parsed[0] . "_"
              . $product_metadata_parsed[1] . "_"
              . $product_metadata_parsed[2] . "_"
              . $format_rig_info
              . "_extraction_"
              . $extraction_id;
            $logger->log( "DEBUG",
"Le nom du fichier de destination de l'agrégation des métadonnée sera : "
                  . $agregated_filename );

            my $return_agregate_metadata = agregate_metadata(
                $current_mtds_folder,
                ( join ";", @{ $current_hash{'format'} } ),
                ( join ";", @{ $current_hash{'projection'} } ),
                $current_hash{'longitude_min'},
                $current_hash{'longitude_max'},
                $current_hash{'latitude_min'},
                $current_hash{'latitude_max'},
                ( strftime "%Y-%m-%d", localtime ),
                $agregated_filename, $purchase_id, $product_id
            );
            if ( Tools->is_numeric($return_agregate_metadata)
                && 0 != $return_agregate_metadata )
            {
                $logger->log( "ERROR",
                    "Impossible d'effectuer l'aggrégation des métadonnées" );
                $logger->log( "ERROR",
                    "Code retour de la fonction agregate_metadata : "
                      . $return_agregate_metadata );
                return 7;
            }

            if ( !Tools->is_numeric($return_agregate_metadata) ) {
                my $return_apply_xsd =
                  apply_xsd( $return_agregate_metadata, $xsl_file,
                    $current_mtds_folder );
                if ( 0 != $return_apply_xsd ) {
                    $logger->log( "ERROR",
                        "Erreur lors de l'application du XSD" );
                    $logger->log( "ERROR",
                        "Code retour de la fonction apply_xsd : "
                          . $return_apply_xsd );
                    return 7;
                }
            }
        }
    }

    # Appel au conditionnement (md5 et compression)
    my $return_packaging =
      packaging( $tmp_output_storage, $extraction_output_storage, $zip_name,
        $zip_max_size );
    if ( 0 != $return_packaging ) {
        $logger->log( "ERROR",
            "Impossible de conditionner l'extraction générée" );
        $logger->log( "ERROR",
            "Code retour de la fonction packaging : " . $return_packaging );
        return 8;
    }

    return 0;
}
1;
