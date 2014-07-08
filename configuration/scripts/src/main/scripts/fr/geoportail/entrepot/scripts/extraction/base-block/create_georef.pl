#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script create a georef file from informations input
# ARGS :
#	The absolute file name used for writing the georef
#	The georeference type to create
#	X1 value for the BBOX to extract
#	Y1 value for the BBOX to extract
#	X2 value for the BBOX to extract
#	Y2 value for the BBOX to extract
#	Image out width in pixels
#	Image out height in pixels
#	Projection of the output georef
# RETURNS :
#   * 0 if the georef file creation is correct
#   * 1 if the georef type is unknown
#   * 2 if an error occured during writing file
#   * 3 if an error occured calculating Coordsys Mapinfo value using gdalsrsinfo
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/create_georef.pl $
#   $Date: 18/01/12 $
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
my $logger = Logger->new( "create_georef.pl", $config->param("logger.levels") );

# Configuration
my $gdalsrsinfo = $config->param("resources.gdalsrsinfo");

# Clés statiques
my $georef_type_tfw   = "TFW";
my $georef_type_gxt   = "GXT";
my $georef_type_grf   = "GRF";
my $georef_type_tab   = "TAB";
my $carriage_return   = "\n";
my $tabulation        = "\t";
my $arobas            = "\@";
my $dpi               = "72";
my $gxt_format_raster = "Raster";
my $gxt_multiplicator = 2834.645669291;
my $mapinfo_option    = " -o mapinfo";

sub create_georef {

    # Extraction des paramètres
    my (
        $georef_file_name, $georef_type, $image_file_name, $bbox_x1,
        $bbox_y1,          $bbox_x2,     $bbox_y2,         $image_width,
        $image_height,     $projection
    ) = @_;
    if (   !defined $georef_file_name
        || !defined $georef_type
        || !defined $image_file_name
        || !defined $bbox_x1
        || !defined $bbox_y1
        || !defined $bbox_x2
        || !defined $bbox_y2
        || !defined $image_width
        || !defined $image_height
        || !defined $projection )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (9)"
        );
        return 255;
    }

    $logger->log( "DEBUG",
        "Paramètre 1 : georef_file_name = " . $georef_file_name );
    $logger->log( "DEBUG", "Paramètre 2 : georef_type = " . $georef_type );
    $logger->log( "DEBUG", "Paramètre 3 : georef_type = " . $image_file_name );
    $logger->log( "DEBUG", "Paramètre 4 : bbox_x1 = " . $bbox_x1 );
    $logger->log( "DEBUG", "Paramètre 5 : bbox_y1 = " . $bbox_y1 );
    $logger->log( "DEBUG", "Paramètre 6 : bbox_x2 = " . $bbox_x2 );
    $logger->log( "DEBUG", "Paramètre 7 : bbox_y2 = " . $bbox_y2 );
    $logger->log( "DEBUG", "Paramètre 8 : image_width = " . $image_width );
    $logger->log( "DEBUG", "Paramètre 9 : image_height = " . $image_height );
    $logger->log( "DEBUG", "Paramètre 10 : projection = " . $projection );

    $logger->log( "INFO",
            "Génération du fichier de géoréférencement : "
          . $georef_file_name . " en "
          . $georef_type );

    # Calcul des résolutions
    my $res_x = ( $bbox_x2 - $bbox_x1 ) / $image_width;
    my $res_y = ( $bbox_y2 - $bbox_y1 ) / $image_height;
    $logger->log( "DEBUG", "Résolution en X : " . $res_x );
    $logger->log( "DEBUG", "Résolution en Y : " . $res_y );

    # Ecriture de la chaine de géoréférencement
    my $georef_file_name_content;
    if ( $georef_type_tfw eq $georef_type ) {

        # Cas des TFW
        my $x = $bbox_x1 + $res_x / 2;
        my $y = $bbox_y2 - $res_y / 2;
        $logger->log( "DEBUG", "Start en  X : " . $x );
        $logger->log( "DEBUG", "Start en  Y : " . $y );

        $georef_file_name_content =
            $res_x
          . $carriage_return . "0"
          . $carriage_return . "0"
          . $carriage_return
          . -$res_y
          . $carriage_return
          . $x
          . $carriage_return
          . $y
          . $carriage_return;
    }
    elsif ( $georef_type_gxt eq $georef_type ) {

        # Cas des GXT
        $georef_file_name_content = "1"
          . $tabulation
          . $gxt_format_raster
          . $tabulation
          . $gxt_format_raster
          . $tabulation
          . $image_file_name
          . $arobas
          . $gxt_multiplicator * $res_x
          . $arobas
          . $gxt_multiplicator * $res_y
          . $arobas
          . $dpi
          . $arobas
          . $dpi
          . $tabulation
          . "0"
          . $tabulation
          . $bbox_x1
          . $tabulation
          . $bbox_y1
          . $carriage_return;
    }
    elsif ( $georef_type_grf eq $georef_type ) {

        # Cas des GRF
        my $center_x = ( $bbox_x2 + $bbox_x1 ) / 2;
        my $center_y = ( $bbox_y2 + $bbox_y1 ) / 2;
        $logger->log( "DEBUG", "Centre en X : " . $center_x );
        $logger->log( "DEBUG", "Centre en Y : " . $center_y );

        $georef_file_name_content =
            "Nom de l'image : "
          . $image_file_name
          . $carriage_return
          . "X minimum : "
          . $bbox_x1
          . $carriage_return
          . "X maximum : "
          . $bbox_x2
          . $carriage_return
          . "Y minimum : "
          . $bbox_y1
          . $carriage_return
          . "Y maximum : "
          . $bbox_y2
          . $carriage_return
          . "X Centre : "
          . $center_x
          . $carriage_return
          . "Y Centre : "
          . $center_y
          . $carriage_return
          . "Taille du pixel sur le terrain (en m) : "
          . $res_x
          . $carriage_return
          . "Nombre de lignes : "
          . $image_height
          . $carriage_return
          . "Nombre de colonnes : "
          . $image_width
          . $carriage_return;
    }
    elsif ( $georef_type_tab eq $georef_type ) {

        # Cas des TAB
        my $cmd_coordsys = $gdalsrsinfo . $mapinfo_option . " " . $projection;
        my $coordsys_return = Execute->run( $cmd_coordsys, "false" );
        if ( $coordsys_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                    "Impossible de calculer l'information CoordSys Mapinfo de "
                  . $projection
                  . " par la commande : "
                  . $cmd_coordsys );
            $coordsys_return->log_all( $logger, "ERROR" );
            return 3;
        }
        my @coordsys_log = $coordsys_return->get_log();
        my $coordsys     = $coordsys_log[0];
        chomp $coordsys;
        $coordsys =~ s/\'//g;

        $georef_file_name_content =
            "!table"
          . $carriage_return
          . "!version 300"
          . $carriage_return
          . "!charset WindowsLatin1"
          . $carriage_return
          . $carriage_return
          . "Definition Table"
          . $carriage_return
          . "File \""
          . $image_file_name . "\""
          . $carriage_return
          . "Type \"RASTER\""
          . $carriage_return . "("
          . $bbox_x1 . ","
          . $bbox_y1
          . ") (0,0) Label \"Pt 1\","
          . $carriage_return . "("
          . $bbox_x2 . ","
          . $bbox_y1 . ") ("
          . $image_width
          . ",0) Label \"Pt 2\","
          . $carriage_return . "("
          . $bbox_x2 . ","
          . $bbox_y2 . ") ("
          . $image_width . ","
          . $image_height
          . ") Label \"Pt 3\","
          . $carriage_return . "("
          . $bbox_x1 . ","
          . $bbox_y2 . ") (0,"
          . $image_height
          . ") Label \"Pt 4\""
          . $carriage_return
          . "CoordSys "
          . $coordsys
          . $carriage_return
          . "Units \"m\""
          . $carriage_return;
    }
    else {

        # Cas inconnu
        return 1;
    }

    # Ecriture dans le fichier sur disque
    $logger->log( "DEBUG",
        "Ouverture en écriture du fichier " . $georef_file_name );

    my $hdl_georef_file;
    if ( !open $hdl_georef_file, ">", $georef_file_name ) {
        $logger->log( "ERROR",
            "Impossible de créer le fichier de géoréférencement "
              . $georef_file_name );
        return 2;
    }

    $logger->log( "DEBUG",
        "Ecriture du contenu : " . $georef_file_name_content );
    print {$hdl_georef_file} $georef_file_name_content;

    if ( !close $hdl_georef_file ) {
        $logger->log( "ERROR",
            "Impossible de fermer le fichier de georeferencement "
              . $georef_file_name );
        return 2;
    }

    return 0;
}
