#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script creates a countour of a polygon with its points in the gml format
# ARGS :
#   The list of polygons to create into file
#   The list of polygons names
#   The output file name without extension
# 	The output format of the outlines file
# 	The CRS of the geometries to add
# RETURNS :
#   * 0 if the creation is correct
#   * 1 if an error occured during creating the temporary GML format file
#   * 2 if an error occured during conversion
#   * 3 if an error occured while deleting temporary file
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 4 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/conditionnement/create_outlines.pl $
#   $Date: 22/12/11 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Execute;
use Config::Simple;
use File::Basename;

require "transform_file.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "create_outlines.pl", $config->param("logger.levels") );

# Configuration
my $gdalsrsinfo          = $config->param("resources.gdalsrsinfo");
my $conditionnement_path = $config->param("resources.conditionnement_paths");
my $static_referentiel   = $config->param("static_ref.static_referentiel");

my $config_conditionnement = Config::Simple->new($conditionnement_path);
my $legendes_wfs_path =
  $config_conditionnement->param("resources.legendes.wfs");
my $prj_path = $config_conditionnement->param("resources.prj");

# Clés statiques
my $begin_gml =
"<?xml version='1.0' encoding='UTF-8'?><gml:FeatureCollection xmlns:gml='http://www.opengis.net/gml' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>";
my $begin_gml_gml32 = "<?xml version='1.0' encoding='UTF-8'?><gml:FeatureCollection xmlns:gml='http://www.opengis.net/gml/3.2' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>";
my $begin_gml_member_1 = "<gml:featureMember><gml:feature fid='";
my $begin_gml_member_2 = "'><gml:name>";
my $begin_gml_member_3 = "</gml:name><gml:the_geom><gml:Polygon srsName='";
my $begin_gml_member_3_gml32 = "</gml:name><gml:the_geom><gml:Polygon srsName='urn:x-ogc:def:crs:";
my $begin_gml_member_4 =
  "'><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates>";
my $end_gml_member =
"</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:the_geom></gml:feature></gml:featureMember>";
my $end_gml       = "</gml:FeatureCollection>";
my $gml_extension = ".gml";
my $wkt_option    = " -o wkt";
my $prj_extension = ".prj";

sub create_outlines {

    # Extraction des paramètres
    my ( $polygons, $polygons_names, $output_file_name, $output_format,
        $output_crs )
      = @_;
    if (   !defined $polygons
        || !defined $polygons_names
        || !defined $output_file_name
        || !defined $output_format
        || !defined $output_crs )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (5)"
        );
        return 255;
    }

    $logger->log( "DEBUG",
        "Paramètre 1 : polygons = " . scalar @{$polygons} . " éléments" );
    $logger->log( "DEBUG",
            "Paramètre 2 : polygons_names = "
          . scalar @{$polygons_names}
          . " éléments" );
    $logger->log( "DEBUG",
        "Paramètre 3 : output_file_name = " . $output_file_name );
    $logger->log( "DEBUG", "Paramètre 4 : output_format = " . $output_format );
    $logger->log( "DEBUG", "Paramètre 5 : output_crs = " . $output_crs );

    if ( scalar @{$polygons} != scalar @{$polygons_names} ) {
        $logger->log( "ERROR",
                "Le nombre de polygones ("
              . scalar @{$polygons}
              . ") n'est pas le même que le nombre de noms ("
              . scalar @{$polygons_names}
              . ")" );
        return 255;
    }

if ( $output_format =~ /gml/i ) {
        $logger->log( "DEBUG", "On tulise les balises gml 3.2" );
        $begin_gml = $begin_gml_gml32;
		$begin_gml_member_3 = $begin_gml_member_3_gml32;
    }
    # Génération du GML
    my $gml = $begin_gml;
    for ( 0 .. scalar( @{$polygons} ) - 1 ) {
        $gml =
            $gml
          . $begin_gml_member_1
          . $polygons_names->[$_]
          . $begin_gml_member_2
          . $polygons_names->[$_]
          . $begin_gml_member_3
          . $output_crs
          . $begin_gml_member_4
          . $polygons->[$_]
          . $end_gml_member;
    }
    $gml = $gml . $end_gml;
    $logger->log( "DEBUG", "GML généré : " . $gml );

    # Création au besoin du répertoire d'écriture
    my @split_file_name = split /\//, $output_file_name;
    my $output_folder = join "/",
      @split_file_name[ 0 .. scalar @split_file_name - 2 ];
    $logger->log( "DEBUG",
        "Création du répertoire de contour : " . $output_folder );
    if ( !-d $output_folder ) {
        my $create_folder_cmd = "mkdir -p " . $output_folder;
        my $create_folder_return = Execute->run( $create_folder_cmd, "true" );
        if ( $create_folder_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Impossible de créer le répertoire de contour : "
                  . $output_folder );
            $create_folder_return->log_all( $logger, "DEBUG" );
            return 1;
        }
    }

    # Ecriture du fichier GML de sortie
    my $hdl_gml_file;
    if ( !open $hdl_gml_file, ">", $output_file_name . $gml_extension ) {
        $logger->log( "ERROR",
                "Impossible de créer le fichier GML "
              . $output_file_name
              . $gml_extension );
        return 1;
    }

    print {$hdl_gml_file} $gml;

    if ( !close $hdl_gml_file ) {
        $logger->log( "ERROR",
                "Impossible de fermer le fichier GML "
              . $output_file_name
              . $gml_extension );
        return 1;
    }

    # Définition du format
    if ( $output_format =~ /shp/i || $output_format =~ /shape-zip/i ) {
        $output_format = "shp";
        $logger->log( "DEBUG",
            "Le contour doit être généré dans le format Shapefile" );

        # Copie du fichier PRJ
        my $prj_dir = $output_crs;
        $prj_dir =~ s/:/\//;
        my $src_prj_file =
            $static_referentiel . "/"
          . $prj_path . "/"
          . $prj_dir
          . $prj_extension;

        my $copy_prj_cmd =
          "cp -f " . $src_prj_file . " " . $output_file_name . $prj_extension;
        $logger->log( "DEBUG", "La commande appelée est : " . $copy_prj_cmd );
        my $copy_prj_cmd_return = Execute->run( $copy_prj_cmd, "true" );
        if ( $copy_prj_cmd_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                    "Impossible de copier le fichier de projection de "
                  . $output_crs
                  . " depuis "
                  . $src_prj_file );
            $copy_prj_cmd_return->log_all( $logger, "DEBUG" );
            return 4;
        }
    }
    elsif ( $output_format =~ /tab/i ) {
        $output_format = "tab";
        $logger->log( "DEBUG",
            "Le contour doit être généré dans le format MapInfo TAB" );
    }
    elsif ( $output_format =~ /mifmid/i ) {
        $output_format = "mif";
        $logger->log( "DEBUG",
            "Le contour doit être généré dans le format MapInfo MIF/MID" );
    }
    elsif ( $output_format =~ /gml/i ) {
        $logger->log( "DEBUG", "Pas de conversion nécessaire" );
        return 0;
    }
    elsif ( $output_format =~ /kml/i ) {
        $output_format = "kml";
        $logger->log( "DEBUG",
            "Le contour doit être généré dans le format KML" );
    }

    # Conversion du fichier
    my $retour_transform =
      transform_file( $output_file_name, 'gml', $output_format );
    if ( $retour_transform != 0 ) {
        $logger->log( "ERROR",
            "La transformation en format $output_format a échoué !" );
        return 2;
    }

    # Suppression du fichier précédent
    my $delete_cmd = "rm -f " . $output_file_name . $gml_extension;
    $logger->log( "DEBUG",
        "La commande de suppression appelée est : " . $delete_cmd );
    my $delete_cmd_return = Execute->run( $delete_cmd, "true" );
    if ( $delete_cmd_return->get_return() != 0 ) {
        $logger->log( "ERROR",
                "Impossible de supprimer le fichier "
              . $output_file_name
              . $gml_extension );
        $delete_cmd_return->log_all( $logger, "DEBUG" );
        return 3;
    }

    return 0;
}
