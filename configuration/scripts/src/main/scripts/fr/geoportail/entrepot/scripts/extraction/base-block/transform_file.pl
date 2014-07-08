#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script will transform files from a format to another using ogr2ogr utility
# ARGS :
#   The file to transform
#   The format of the file to transform
#   The output format
# RETURNS :
#   * 0 if the transformation is correct
#   * 1 if the given file to transform doesn't exists
#   * 2 if the extension of the file is unknown
#   * 3 if an error occured during conversion
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/conditionnement/transform_file.pl $
#   $Date: 22/12/11 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
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
my $logger =
  Logger->new( "transform_file.pl", $config->param("logger.levels") );

# Configuration
my $ogr2ogr = $config->param("resources.ogr2ogr");

sub transform_file {
    my ( $file_to_transform, $extension, $output_format ) = @_;
    if (   !defined $file_to_transform
        || !defined $extension
        || !defined $output_format )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (3)"
        );
        return 255;
    }

    $logger->log( "DEBUG",
        "Paramètre 1 : file_to_transform = " . $file_to_transform );
    $logger->log( "DEBUG", "Paramètre 2 : extension = " . $extension );
    $logger->log( "DEBUG", "Paramètre 3 : output_format = " . $output_format );

    # Détermine l'existence du fichier
    my $file_input_name  = $file_to_transform . "." . $extension;
    my $file_output_name = $file_to_transform . "." . $output_format;

    if ( !-e $file_input_name ) {
        $logger->log( "ERROR", "Le fichier à transformer n'existe pas" );
        return 1;
    }

    # Test du format demandé
    my $complete_vector_output_format = "";
    if ( "shp" eq $output_format ) {
        $complete_vector_output_format = "\"ESRI Shapefile\"";
    }
    elsif ( "gml" eq $output_format ) {
        $complete_vector_output_format = "\"GML\"";
    }
    elsif ( "tab" eq $output_format ) {
        $complete_vector_output_format = "\"MapInfo File\"";
    }
    elsif ( "mif" eq $output_format ) {
        $complete_vector_output_format =
          "\"MapInfo File\" -dsco \"FORMAT=MIF\"";
    }
    elsif ( "kml" eq $output_format ) {
        $complete_vector_output_format = "\"KML\"";
    }
    else {
        $logger->log( "ERROR",
            "Le format " . $output_format . " n'est pas connu" );
        return 2;
    }

    # Transformation vecteur => vecteur
    my $ogr2ogr_cmd =
        $ogr2ogr . " -f "
      . $complete_vector_output_format . " "
      . $file_output_name . " "
      . $file_input_name;
    $logger->log( "DEBUG", "La commande OGR appelée est : " . $ogr2ogr_cmd );
    my $ogr2ogr_cmd_return = Execute->run( $ogr2ogr_cmd, "true" );
    if ( $ogr2ogr_cmd_return->get_return() != 0 ) {
        $logger->log( "ERROR",
                "Impossible de convertir le fichier "
              . $file_input_name . " en "
              . $file_output_name );
        $ogr2ogr_cmd_return->log_all( $logger, "DEBUG" );
        return 3;
    }

    return 0;
}

