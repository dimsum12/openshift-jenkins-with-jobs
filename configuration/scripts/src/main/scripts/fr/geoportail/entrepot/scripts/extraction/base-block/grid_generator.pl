#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script generates a bboxes grid to do harvesting on WMS
# ARGS :
#	The polygon in which grid must be construct, in WKT representation, in the projection the grid must be
#	The step between two element in the grid, in the projection coordinate unit
# RETURNS :
#   * @{$bboxes} if the grid generation is correct
#   * 1 if the an error occured when transforming polygon to bbox2d
#   * 2 if the an error occured when retrieving 4 cordinates from bbox
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/grid_generator.pl $
#   $Date: 21/02/12 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use Database;
use Tools;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "grid_generator.pl", $config->param("logger.levels") );

my $dbname   = $config->param("db-ent_donnees.dbname");
my $host     = $config->param("db-ent_donnees.host");
my $port     = $config->param("db-ent_donnees.port");
my $username = $config->param("db-ent_donnees.username");
my $password = $config->param("db-ent_donnees.password");

sub grid_generator {

    # Parameters number validation
    my ( $polygon_wkt, $step_x, $step_y ) = @_;
    if ( !defined $polygon_wkt || !defined $step_x || !defined $step_y ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (3)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : polygon_wkt = " . $polygon_wkt );
    $logger->log( "DEBUG", "Paramètre 2 : step_x = " . $step_x );
    $logger->log( "DEBUG", "Paramètre 3 : step_y = " . $step_y );

    #Get SRID from projection
    my $srid = ( split /;/, $polygon_wkt )[0];

    #Polygon conversion in Bbox2D
    my $database =
      Database->connect( $dbname, $host, $port, $username, $password );
    my $sql = "SELECT box2d(st_geomfromewkt('" . $polygon_wkt . "'))";
    $logger->log( "DEBUG", $sql );
    ( my $bbox ) = $database->select_one_row($sql);
    if ( defined $bbox && '' ne $bbox ) {
        $logger->log( "INFO", "La BBox est " . $bbox );
    }
    else {
        $logger->log( "ERROR", "Pas de BBox retournée" );
        $database->disconnect();
        return 1;
    }

    # Format BBox
    $bbox =~ s/BOX\((.*)\)/$1/;
    $bbox =~ s/ /,/g;
    my @bbox_points_splitted = split /,/, $bbox;
    if ( 4 != scalar @bbox_points_splitted ) {
        $logger->log( "ERROR",
            "La géométrie fournie ne contient pas 4 coordonnées" );
        $database->disconnect();
        return 2;
    }
    my ( $min_longitude, $min_latitude, $max_longitude, $max_latitude ) =
      @bbox_points_splitted;

    my $width  = $max_longitude - $min_longitude;
    my $height = $max_latitude - $min_latitude;

    $logger->log( "INFO",
            "Nombre de dalles couvertes par le polygon "
          . $polygon_wkt . " : "
          . int( ( $width / $step_x ) + 1 ) * int( ( $height / $step_y ) + 1 )
    );

    # Build the array bboxes
    my $bboxes;
    my $cpt = 1;
    my ( $x1, $x2, $y1, $y2 ) = 0;
    $x1 = $min_longitude;
    $y1 = $min_latitude;
    $y2 = $y1;
    for ( my $y = 0 ; $y < $height ; $y += $step_y ) {
        $x1 = $x2 = $min_longitude;
        $y2 += $step_y;
        for ( my $x = 0 ; $x < $width ; $x += $step_x ) {
            $x1 = $x2;
            $x2 = $x1 + $step_x;

            # Check if Bbox intersects polygon and add to array
            $sql =
                "SELECT st_intersects('" 
              . $srid
              . ";POLYGON(("
              . $x1 . " "
              . $y1 . ","
              . $x2 . " "
              . $y1 . ","
              . $x2 . " "
              . $y2 . ","
              . $x1 . " "
              . $y2 . ","
              . $x1 . " "
              . $y1
              . "))'::geometry, '"
              . $polygon_wkt
              . "'::geometry)";

            ( my $bbox ) = $database->select_one_row($sql);
            if ($bbox) {
                push
                  @{$bboxes},
                  {
                    "name" => $x1 . "/" . $y1,
                    "x1"   => $x1,
                    "x2"   => $x2,
                    "y1"   => $y1,
                    "y2"   => $y2
                  };
                $cpt++;
            }
        }
        $y1 += $step_y;
    }
    $logger->log( "INFO",
"Fin de construction de la grille de dalles à requêter. La grille contient "
          . scalar( @{$bboxes} )
          . " dalles." );

    $database->disconnect();
    return $bboxes;
}
