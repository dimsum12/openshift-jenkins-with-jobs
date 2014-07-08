#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#
# ARGS :
#   The point to convert
#   The projection of the point
#   The destination projection for the point
# RETURNS :
#   * a point
#   * 1 if there are errors during the conversion operation
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/convert_points.pl $
#   $Date: 10/02/12 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use Execute;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "convert_points.pl", $logger_levels );

sub convert_points {

    # Parameters number validation
    my ( $points, $proj_src, $proj_dest ) = @_;

    if (   !defined $points
        || !defined $proj_src
        || !defined $proj_dest )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (3)" );
        return 255;
    }

    my @proj = split /:/, $proj_src;
    my $is_longlat_proj_src = $config->param( uc $proj[0] . "." . $proj[1] );
    @proj = split /:/, $proj_dest;
    my $is_longlat_proj_dest = $config->param( uc $proj[0] . "." . $proj[1] );

    my $cmd;
    my @coords = split / /, $points;

    if ( !defined $is_longlat_proj_src ) {
        $is_longlat_proj_src = "true";
    }
    if ( !defined $is_longlat_proj_dest ) {
        $is_longlat_proj_dest = "true";
    }
    if ( "true" eq $is_longlat_proj_src && "true" eq $is_longlat_proj_dest ) {
        $cmd =
            "cs2cs -f \"\%.2f\" +init="
          . lc($proj_src)
          . " +to +init="
          . lc($proj_dest)
          . " << EOF\n$coords[0] $coords[1]\nEOF";
    }
    elsif ( "true" eq $is_longlat_proj_src && "false" eq $is_longlat_proj_dest )
    {
        $cmd =
            "cs2cs -f \"\%.6f\" -s +init="
          . lc($proj_src)
          . " +to +init="
          . lc($proj_dest)
          . " << EOF\n$coords[0] $coords[1]\nEOF";
    }
    elsif ( "false" eq $is_longlat_proj_src && "true" eq $is_longlat_proj_dest )
    {
        $cmd =
            "cs2cs -f \"\%.2f\" -r +init="
          . lc($proj_src)
          . " +to +init="
          . lc($proj_dest)
          . " << EOF\n$coords[0] $coords[1]\nEOF";
    }
    elsif ("false" eq $is_longlat_proj_src
        && "false" eq $is_longlat_proj_dest )
    {
        $cmd =
            "cs2cs -f \"\%.6f\" +init="
          . lc($proj_src)
          . " +to +init="
          . lc($proj_dest)
          . " << EOF\n$coords[0] $coords[1]\nEOF";
    }
    else {
        $cmd =
            "cs2cs -f \"\%.6f\" +init="
          . lc($proj_src)
          . " +to +init="
          . lc($proj_dest)
          . " << EOF\n$coords[0] $coords[1]\nEOF";
    }

    $logger->log( "DEBUG", $cmd );
    my $result = Execute->run( $cmd, "true" );
    if ( $result->get_return() != 0 ) {
        $logger->log( "ERROR",
                "Impossible de convertir le point ("
              . $coords[0] . ", "
              . $coords[1] . "-> "
              . $proj_src
              . ") vers la projection "
              . $proj_dest
              . "" );

        # $result->log_all( $logger, "DEBUG" );
        return 1;
    }
    my @results          = $result->get_log();
    my $points_converted = $results[0];
    chomp $points_converted;

    my @coords_converted = split / /, $points_converted;
    @coords_converted = split /\t/, $coords_converted[0];
    $logger->log( "DEBUG",
            "Conversion effectuée du point ("
          . $coords[0] . ", "
          . $coords[1] . " -> "
          . $proj_src
          . ") vers le point ("
          . $coords_converted[0] . ", "
          . $coords_converted[1] . " -> "
          . $proj_dest
          . ")" );

    return ( $coords_converted[0] . "," . $coords_converted[1] );
}
